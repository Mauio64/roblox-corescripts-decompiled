local CoreGui = game:GetService("CoreGui")
local Folder = Instance.new("Folder")

Folder.Name = "Highlights"
Folder.Parent = CoreGui

return {
	setUpHighlight = function() -- line: 9
		-- upvalues: Folder (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Parent = Folder
		ScreenGui.DisplayOrder = 9999999

		local Frame = Instance.new("Frame")

		Frame.Name = "Highlight"
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new()
		Frame.Position = UDim2.new()
		Frame.Interactable = false
		Frame.Parent = ScreenGui

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = Color3.fromRGB(51, 95, 255)
		UIStroke.Thickness = 2
		UIStroke.Parent = Frame

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = Frame

		return Frame
	end,
	cleanUpHighlight = function() -- line: 34
		-- upvalues: Folder (copy)
		Folder:ClearAllChildren()
	end,
	highlight = function(p1, p2) -- line: 39
		if not p2 then
			p1.Visible = false

			return
		end

		p1.Size = UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y)
		p1.Position = UDim2.fromOffset(p2.AbsolutePosition.X, p2.AbsolutePosition.Y)
		p1.Visible = true
	end
}
