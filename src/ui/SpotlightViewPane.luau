local Stylesheet = require(script.Parent.Parent.config.Stylesheet)

return function()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.3, 0, 0, 60)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1

	local textBox = Instance.new("TextLabel")
	textBox.Size = UDim2.new(1, 0, 1, 0)
	textBox.Position = UDim2.fromScale(0.5, 0.5)
	textBox.AnchorPoint = Vector2.new(0.5, 0.5)
	textBox.TextColor3 = Color3.fromRGB(100, 100, 100)
	textBox.BackgroundColor3 = Stylesheet.Surface1Color
	textBox.Text = ""
	textBox.TextSize = 11
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.BackgroundTransparency = 0.5
	textBox.Parent = frame
	textBox.Name = "Placeholder"

	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, 0, 1, 0)
	inputBox.Position = UDim2.fromScale(0.5, 0.5)
	inputBox.AnchorPoint = Vector2.new(0.5, 0.5)
	inputBox.PlaceholderText = "Search or enter command..."
	inputBox.BackgroundColor3 = Stylesheet.Surface1Color
	inputBox.TextColor3 = Stylesheet.PrimaryTextColor
	inputBox.Text = ""
	inputBox.TextSize = 11
	inputBox.TextXAlignment = Enum.TextXAlignment.Left
	inputBox.BackgroundTransparency = 1
	inputBox.Parent = frame
    inputBox.ClearTextOnFocus = false
	inputBox.Name = "Input"

	local shadow = Instance.new("ImageLabel")
	shadow.Image = "rbxassetid://6150493168"
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.5
	shadow.Parent = frame
	shadow.ImageColor3 = Stylesheet.ShadowColor
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(100, 100, 100, 100)
	shadow.SliceScale = 0.4
	shadow.ZIndex = -100

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = textBox

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 1
	uiStroke.Color = Stylesheet.Surface2Color
	uiStroke.Parent = textBox
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Transparency = 0.5

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 12)
	uiPadding.Parent = textBox
	uiPadding.PaddingRight = UDim.new(0, 12)

    local placeHolderPadding = Instance.new("UIPadding")
	placeHolderPadding.PaddingLeft = UDim.new(0, 12)
	placeHolderPadding.Parent = inputBox
	placeHolderPadding.PaddingRight = UDim.new(0, 12)

	return frame
end
