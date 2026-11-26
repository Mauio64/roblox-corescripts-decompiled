local CoreGui = game:GetService("CoreGui")

local highlights = Instance.new("Folder")
highlights.Name = "Highlights"
highlights.Parent = CoreGui

return {
	setUpHighlight = function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Parent = highlights
		screenGui.DisplayOrder = 9999999

		local highlight = Instance.new("Frame")
		highlight.Name = "Highlight"
		highlight.BackgroundTransparency = 1
		highlight.BorderSizePixel = 0
		highlight.Size = UDim2.new()
		highlight.Position = UDim2.new()
		highlight.Interactable = false
		highlight.Parent = screenGui

		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.fromRGB(51, 95, 255)
		uiStroke.Thickness = 2
		uiStroke.Parent = highlight

		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = highlight
		return highlight
	end,
	cleanUpHighlight = function()
		highlights:ClearAllChildren()
	end,
	highlight = function(p2, p3)
		if not p3 then
			p2.Visible = false
			return
		end

		p2.Size = UDim2.fromOffset(p3.AbsoluteSize.X, p3.AbsoluteSize.Y)
		p2.Position = UDim2.fromOffset(p3.AbsolutePosition.X, p3.AbsolutePosition.Y)
		p2.Visible = true
	end
}
