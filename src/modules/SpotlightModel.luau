--[[
	File: SpotlightModel.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

--=> Classes & Dependencies

local SpotlightView = require(script.Parent.SpotlightView)
local Maid = require(script.Parent.Parent.packages.Maid)
local Signal = require(script.Parent.Parent.packages.Signal)

--=> Class Declaration

local SpotlightModel = {
	RequestQuery = Signal.new(),
	AutoCompleteRequested = Signal.new(),
}

--=> Roblox Services

local CoreGui = game:GetService("CoreGui")

--=> Constructor

function SpotlightModel:Hydrate()
	local spotlightGui = CoreGui:FindFirstChild("SpotlightGui") or Instance.new("ScreenGui")
	spotlightGui.Name = "SpotlightGui"
	spotlightGui.Parent = CoreGui

	self._maid = Maid.new()
	self._spotlightView = SpotlightView.new({ Parent = spotlightGui })
	self._maid:GiveTask(self._spotlightView)
	self._maid:GiveTask(self.RequestQuery)

	self._maid:GiveTask(self._spotlightView.TextChanged:Connect(function(text: string)
		self.RequestQuery:Fire(text)
	end))

	self._maid:GiveTask(self._spotlightView.TabRequested:Connect(function(text: string)
		self.AutoCompleteRequested:Fire(text)
	end))
end

function SpotlightModel:Dehydrate()
	self._maid:DoCleaning()
end

function SpotlightModel:SetPlaceholderText(text: string)
	self._spotlightView:SetPlaceholderText(text)
end

function SpotlightModel:SetInputText(text: string)
	self._spotlightView:SetInputText(text)
end

return SpotlightModel
