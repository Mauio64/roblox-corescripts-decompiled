local parent = script.Parent
local ButtonAssets = require(parent.ButtonAssets)
local SecondsToTimeStr = require(parent.SecondsToTimeStr)

local CreateButtonsTime = {
	["regularColor"] = Color3.fromRGB(255, 255, 255),
	hoverColor = Color3.fromRGB(200, 200, 200),
	clickColor = Color3.fromRGB(150, 150, 150)
}

function CreateButtonsTime:createButtonsTime()
	function self.createControlBarButton(image: string, flag: boolean)
		local controlBarButton = Instance.new("ImageButton")
		controlBarButton.Name = "ControlBarButton"
		controlBarButton.Parent = self.ButtonsTimeControlBar
		controlBarButton.BackgroundTransparency = 1
		controlBarButton.Image = image
		controlBarButton.ImageColor3 = CreateButtonsTime.regularColor
		controlBarButton.AnchorPoint = Vector2.new(0, 0.5)
		controlBarButton.Size = UDim2.new(0.1, 0, 0.9, 0)
		controlBarButton.SizeConstraint = Enum.SizeConstraint.RelativeXY

		controlBarButton:SetAttribute("useHoverColor", true)
		controlBarButton.MouseEnter:Connect(function()
			if controlBarButton:GetAttribute("useHoverColor") then
				controlBarButton.ImageColor3 = CreateButtonsTime.hoverColor
			end
		end)
		controlBarButton.MouseLeave:Connect(function()
			if controlBarButton:GetAttribute("useHoverColor") then
				controlBarButton.ImageColor3 = CreateButtonsTime.regularColor
			end
		end)
		controlBarButton.MouseButton1Down:Connect(function()
			controlBarButton.ImageColor3 = CreateButtonsTime.clickColor
		end)

		if flag then
			controlBarButton.MouseButton1Up:Connect(function()
				controlBarButton.ImageColor3 = CreateButtonsTime.hoverColor
			end)
		end

		local uiSizeConstraint = Instance.new("UISizeConstraint")
		uiSizeConstraint.MaxSize = Vector2.new(self.maxControlBarHeight * 0.9, self.maxControlBarHeight * 0.9)

		uiSizeConstraint.Parent = controlBarButton

		return controlBarButton
	end

	self.PlayButton = self.createControlBarButton(ButtonAssets.PlayButton, true)
	self.PlayButton.LayoutOrder = 2

	self.StopButton = self.createControlBarButton(ButtonAssets.StopButton, false)
	self.StopButton.LayoutOrder = 3

	self.ReverseButton = self.createControlBarButton(ButtonAssets.ReverseButton, false)
	self.ReverseButton.LayoutOrder = 4

	self.CurrentTimeLabel = Instance.new("TextLabel")
	self.CurrentTimeLabel.Name = "CurrentTimeLabel"
	self.CurrentTimeLabel.Font = Enum.Font.SourceSans
	self.CurrentTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.CurrentTimeLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.CurrentTimeLabel.AnchorPoint = Vector2.new(0, 0.5)
	self.CurrentTimeLabel.Size = UDim2.new(0.4, 0, 1.3, 0)
	self.CurrentTimeLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
	self.CurrentTimeLabel.BackgroundTransparency = 1
	self.CurrentTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(0)
	self.CurrentTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.CurrentTimeLabel.TextScaled = true
	self.CurrentTimeLabel.LayoutOrder = 5
	self.CurrentTimeLabel.Parent = self.ButtonsTimeControlBar

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingBottom = UDim.new(0.05, 0)
	uiPadding.Parent = self.CurrentTimeLabel
end

return CreateButtonsTime
