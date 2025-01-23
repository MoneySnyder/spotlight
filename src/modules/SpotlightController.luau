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

local Fzy = require(script.Parent.Parent.packages.Fzy)
local SpotlightModel = require(script.Parent.SpotlightModel)
local Maid = require(script.Parent.Parent.packages.Maid)

--=> Plugins

local InternalPluginFolder = script.Parent.Parent.plugins
local ExternalPluginFolder = ServerScriptService:FindFirstChild("SpotlightPlugins")
	or Instance.new("Folder", ServerScriptService)
ExternalPluginFolder.Name = "SpotlightPlugins"

--=> Variables

local FzyConfig = Fzy.createConfig({
	caseSensitive = false,
})

--=> Public Functions

function SpotlightController:ToggleSettings() end

function SpotlightController:LoadPlugins(context: Instance)
	for _, queriedPlugin in ipairs(context:GetChildren()) do
		if queriedPlugin:IsA("ModuleScript") then
			local pluginModule = require(queriedPlugin)
			if pluginModule then
				local aliases = pluginModule.Aliases or { plugin.Name }
				for _, alias in ipairs(aliases) do
					self.LoadedPlugins[alias] = pluginModule
				end
			end
		end
	end
end

function SpotlightController:ExecutePlugin(pluginName: string, ...)
	local queriedPlugin = self.LoadedPlugins[pluginName]
	if queriedPlugin then
		local success, err = pcall(queriedPlugin.Execute, ...)
		if not success then
			warn("Error executing plugin", pluginName, err)
		end
	end
end

function SpotlightController:QueryPlugins(query: string)
	local temp = {}

	for pluginName, _ in pairs(self.LoadedPlugins) do
		table.insert(temp, {
			pluginName = pluginName,
			score = Fzy.score(FzyConfig, query, pluginName),
		})
	end

	table.sort(temp, function(a, b)
		return a.score > b.score
	end)

	return temp
end

--=> Initializers

function SpotlightController:Init()
	self._maid = Maid.new()

	self:LoadPlugins(InternalPluginFolder)
	self:LoadPlugins(ExternalPluginFolder)

	SpotlightModel:Hydrate()

	self._maid:GiveTask(SpotlightModel.RequestQuery:Connect(function(query: string)
		if string.find(query, " ") or string.find(query, "	") then
			self._pluginEntered = true
			SpotlightModel:SetPlaceholderText("")
			return
		end

		self._pluginEntered = false

		if query == "" then
			SpotlightModel:SetPlaceholderText("")
			return
		end

		local results = self:QueryPlugins(query)

		if not results then
			self._topResult = nil
			self._currentArgTable = nil
			self._currentAlias = nil
		end

		self._currentAlias = results[1].pluginName
		self._topResult = self.LoadedPlugins[results[1].pluginName]
		self._currentArgTable = self._topResult.Args
		SpotlightModel:SetPlaceholderText(results[1].pluginName)
	end))

	self._maid:GiveTask(SpotlightModel.AutoCompleteRequested:Connect(function(currentText: string)
		if not self._pluginEntered then
			self._pluginEntered = true
			task.defer(function()
				SpotlightModel:SetInputText(self._currentAlias.. " ")
			end)
		end
	end))
end

function SpotlightController:Unload()
	SpotlightModel:Dehydrate()
	self._maid:DoCleaning()
end

return SpotlightController
