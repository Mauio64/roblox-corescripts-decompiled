local parent = script.Parent
local CreateButtonsTime = require(parent.CreateButtonsTime)
return {
	createHelpText = function(self)
		self.HelpRevealer = Instance.new("TextLabel")
		self.HelpRevealer.Name = "HelpRevealer"
		self.HelpRevealer.Font = Enum.Font.SourceSans
		self.HelpRevealer.TextXAlignment = Enum.TextXAlignment.Center
		self.HelpRevealer.TextYAlignment = Enum.TextYAlignment.Center
		self.HelpRevealer.Size = UDim2.new(0.5, 0, 1.3, 0)
		self.HelpRevealer.SizeConstraint = Enum.SizeConstraint.RelativeXY
		self.HelpRevealer.AnchorPoint = Vector2.new(0.5, 0.5)
		self.HelpRevealer.Position = UDim2.new(0.5, 0, 0.5, 0)
		self.HelpRevealer.BackgroundTransparency = 1
		self.HelpRevealer.Text = "?"
		self.HelpRevealer.TextColor3 = CreateButtonsTime.regularColor
		self.HelpRevealer.TextScaled = true
		self.HelpRevealer.Parent = self.HelpBar

		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingBottom = UDim.new(0.05, 0)
		uiPadding.Parent = self.HelpRevealer

		self.HelpDescription = Instance.new("TextLabel")
		self.HelpDescription.Name = "HelpDescription"
		self.HelpDescription.Font = Enum.Font.SourceSans
		self.HelpDescription.TextXAlignment = Enum.TextXAlignment.Left
		self.HelpDescription.TextYAlignment = Enum.TextYAlignment.Top
		self.HelpDescription.AnchorPoint = Vector2.new(1, 1)
		self.HelpDescription.Position = UDim2.new(1, 0, 0, 0)
		self.HelpDescription.Size = UDim2.new(5.3, 0, 2.5, 0)
		self.HelpDescription.SizeConstraint = Enum.SizeConstraint.RelativeXY
		self.HelpDescription.BorderSizePixel = 0
		self.HelpDescription.BackgroundColor3 = self.defaultBackgroundColor3
		self.HelpDescription.BackgroundTransparency = self.defaultBackgroundTransparency
		self.HelpDescription.RichText = true
		self.HelpDescription.Text = [[
<b>Shortcuts</b>
<u>space</u> - play/pause
<u>r</u> - rewind
<u>s</u> - stop]]

		self.HelpDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
		self.HelpDescription.TextScaled = Enum.AutomaticSize.XY
		self.HelpDescription.Parent = self.HelpBar
		self.HelpDescription.Visible = false

		local uiPadding2 = Instance.new("UIPadding")
		uiPadding2.PaddingLeft = UDim.new(0.02, 0)
		uiPadding2.PaddingBottom = UDim.new(0.02, 0)
		uiPadding2.Parent = self.HelpDescription

		self.HelpRevealer.MouseEnter:Connect(function()
			self.HelpRevealer.TextColor3 = CreateButtonsTime.hoverColor
			self.HelpDescription.Visible = true
		end)

		self.HelpRevealer.MouseLeave:Connect(function()
			self.HelpRevealer.TextColor3 = CreateButtonsTime.regularColor
			self.HelpDescription.Visible = false
		end)
	end
}
