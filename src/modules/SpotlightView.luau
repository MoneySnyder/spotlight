--[[
	File: SpotlightView.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

local SpotlightView = setmetatable({}, {})
SpotlightView.__index = SpotlightView
SpotlightView.ClassName = "SpotlightView"

--=> Dependencies

local Maid = require(script.Parent.Parent.packages.Maid)

--=> Constructor

function SpotlightView.new(props)
	local self = setmetatable({}, SpotlightView)
	local template = require(script.Parent.Parent.ui.SpotlightViewPane)

	self._gui = template()
	self._maid = Maid.new()

	if props.Parent then
		self._gui.Parent = props.Parent
	end

	self._maid:GiveTask(self._gui)

	return self
end

function SpotlightView:Destroy()
	self._gui:Destroy()
    self._maid:DoCleaning()
end

return SpotlightView
