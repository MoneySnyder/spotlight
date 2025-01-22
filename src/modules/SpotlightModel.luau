--[[
	File: SpotlightModel.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

local SpotlightModel = {}

--=> Roblox Services

local CoreGui = game:GetService("CoreGui")

--=> Classes & Dependencies

local SpotlightView = require(script.Parent.SpotlightView)

function SpotlightModel:Hydrate()
	local spotlightGui = CoreGui:FindFirstChild("SpotlightGui") or Instance.new("ScreenGui")
	spotlightGui.Name = "SpotlightGui"
	spotlightGui.Parent = CoreGui

	self._spotlightView = SpotlightView.new({ Parent = spotlightGui })
end

function SpotlightModel:Dehydrate()
	if self._spotlightView then
		self._spotlightView:Destroy()
		self._spotlightView = nil
	end
end

return SpotlightModel
