local scriptParent = script.Parent
local ButtonAssets = require(scriptParent.ButtonAssets)
local SecondsToTimeStr = require(scriptParent.SecondsToTimeStr)
local t1 = {
	regularColor = Color3.fromRGB(255, 255, 255),
	hoverColor = Color3.fromRGB(200, 200, 200),
	clickColor = Color3.fromRGB(150, 150, 150)
}

function t1.createButtonsTime(p1) -- line: 12
	-- upvalues: t1 (copy), ButtonAssets (copy), SecondsToTimeStr (copy)
	function p1.createControlBarButton(s1: string, b1: boolean) -- line: 14
		-- upvalues: p1 (copy), t1 (copy)
		local ImageButton = Instance.new("ImageButton")

		ImageButton.Name = "ControlBarButton"
		ImageButton.Parent = p1.ButtonsTimeControlBar
		ImageButton.BackgroundTransparency = 1
		ImageButton.Image = s1
		ImageButton.ImageColor3 = t1.regularColor
		ImageButton.AnchorPoint = Vector2.new(0, 0.5)
		ImageButton.Size = UDim2.new(0.1, 0, 0.9, 0)
		ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
		ImageButton:SetAttribute("useHoverColor", true)
		ImageButton.MouseEnter:Connect(function() -- line: 26
			-- upvalues: ImageButton (copy), t1 (copy)
			if ImageButton:GetAttribute("useHoverColor") then
				ImageButton.ImageColor3 = t1.hoverColor
			end
		end)
		ImageButton.MouseLeave:Connect(function() -- line: 31
			-- upvalues: ImageButton (copy), t1 (copy)
			if ImageButton:GetAttribute("useHoverColor") then
				ImageButton.ImageColor3 = t1.regularColor
			end
		end)
		ImageButton.MouseButton1Down:Connect(function() -- line: 36
			-- upvalues: ImageButton (copy), t1 (copy)
			ImageButton.ImageColor3 = t1.clickColor
		end)

		if b1 then
			ImageButton.MouseButton1Up:Connect(function() -- line: 40
				-- upvalues: ImageButton (copy), t1 (copy)
				ImageButton.ImageColor3 = t1.hoverColor
			end)
		end

		local UISizeConstraint = Instance.new("UISizeConstraint")

		UISizeConstraint.MaxSize = Vector2.new(p1.maxControlBarHeight * 0.9, p1.maxControlBarHeight * 0.9)
		UISizeConstraint.Parent = ImageButton

		return ImageButton
	end

	p1.PlayButton = p1.createControlBarButton(ButtonAssets.PlayButton, true)
	p1.PlayButton.LayoutOrder = 2
	p1.StopButton = p1.createControlBarButton(ButtonAssets.StopButton, false)
	p1.StopButton.LayoutOrder = 3
	p1.ReverseButton = p1.createControlBarButton(ButtonAssets.ReverseButton, false)
	p1.ReverseButton.LayoutOrder = 4
	p1.CurrentTimeLabel = Instance.new("TextLabel")
	p1.CurrentTimeLabel.Name = "CurrentTimeLabel"
	p1.CurrentTimeLabel.Font = Enum.Font.SourceSans
	p1.CurrentTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
	p1.CurrentTimeLabel.TextYAlignment = Enum.TextYAlignment.Center
	p1.CurrentTimeLabel.AnchorPoint = Vector2.new(0, 0.5)
	p1.CurrentTimeLabel.Size = UDim2.new(0.4, 0, 1.3, 0)
	p1.CurrentTimeLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
	p1.CurrentTimeLabel.BackgroundTransparency = 1
	p1.CurrentTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(0)
	p1.CurrentTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	p1.CurrentTimeLabel.TextScaled = true
	p1.CurrentTimeLabel.LayoutOrder = 5
	p1.CurrentTimeLabel.Parent = p1.ButtonsTimeControlBar

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingBottom = UDim.new(0.05, 0)
	UIPadding.Parent = p1.CurrentTimeLabel
end

return t1
