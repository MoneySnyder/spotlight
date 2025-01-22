--[[
	File: SpotlightController.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

local SpotlightController = {
    LoadedPlugins = {},
}

--=> Roblox Services

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ServerScriptService = game:GetService("ServerScriptService")
local Selection = game:GetService("Selection")

--=> Dependencies

local SpotlightModel = require(script.Parent.SpotlightModel)

--=> Plugins

local InternalPluginFolder = script.Parent.Parent.plugins
local ExternalPluginFolder = ServerScriptService:FindFirstChild("SpotlightPlugins") or Instance.new("Folder", ServerScriptService)
ExternalPluginFolder.Name = "SpotlightPlugins"

--=> Public Functions 

function SpotlightController:ToggleSettings()
end

function SpotlightController:LoadPlugins(context: Instance)
	for _, queriedPlugin in ipairs(context:GetChildren()) do
		if queriedPlugin:IsA("ModuleScript") then
			local pluginModule = require(queriedPlugin)
			if pluginModule then
				self.LoadedPlugins[queriedPlugin.Name] = pluginModule
			end
		end
	end
end

function SpotlightController:ExecutePlugin(pluginName: string, ...)
	local queriedPlugin = self.LoadedPlugins[pluginName]
	if queriedPlugin then
		local success, err = pcall(queriedPlugin, ...)
		if not success then
			warn("Error executing plugin", pluginName, err)
		end
	end
end

--=> Initializers

function SpotlightController:Init()
    self:LoadPlugins(InternalPluginFolder)
	self:LoadPlugins(ExternalPluginFolder)

	SpotlightModel:Hydrate()
end

function SpotlightController:Unload()
	SpotlightModel:Dehydrate()
end

return SpotlightController