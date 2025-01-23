--[[
	File: SpotlightView.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

--=> Roblox Services

local UserInputService = game:GetService("UserInputService")

--=> Class Root

local SpotlightView = setmetatable({}, {})
SpotlightView.__index = SpotlightView
SpotlightView.ClassName = "SpotlightView"

--=> Dependencies

local Maid = require(script.Parent.Parent.packages.Maid)
local Signal = require(script.Parent.Parent.packages.Signal)

--=> Constructor

function SpotlightView.new(props)
	local self = setmetatable({}, SpotlightView)
	local template = require(script.Parent.Parent.ui.SpotlightViewPane)

	self._gui = template()
	self._maid = Maid.new()
	self._input = self._gui.Input
	self._placeholder = self._gui.Placeholder
	self._focused = false
	self._validPlugin = false

	self.TextChanged = Signal.new()
	self.TabRequested = Signal.new()

	if props.Parent then
		self._gui.Parent = props.Parent
	end

	self._maid:GiveTask(self._gui)
	self._maid:GiveTask(self.TextChanged)

	self:_listenToInput()

	return self
end

--=> Public Functions

function SpotlightView:SetPlaceholderText(text: string)
	self._placeholder.Text = text
end

function SpotlightView:SetInputText(text: string)
	self._input.Text = text
end

function SpotlightView:Destroy()
	self._gui:Destroy()
    self._maid:DoCleaning()
end

--=> Private Functions

function SpotlightView:_listenToInput()
	self._maid:GiveTask(self._input:GetPropertyChangedSignal("Text"):Connect(function()
		self.TextChanged:Fire(self._input.Text)
	end))
	
	self._maid:GiveTask(self._input.Focused:Connect(function()
		self._focused = true
	end))
	
	self._maid:GiveTask(self._input.FocusLost:Connect(function()
		self._focused = false
	end))

	self._maid:GiveTask(UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Tab and self._focused then
			self._input:ReleaseFocus()
			self.TabRequested:Fire(self._input.Text)
			task.delay(0.1, function()
				self._input:CaptureFocus()
			end)
		end
	end))
end

--=> Return Class

return SpotlightView
