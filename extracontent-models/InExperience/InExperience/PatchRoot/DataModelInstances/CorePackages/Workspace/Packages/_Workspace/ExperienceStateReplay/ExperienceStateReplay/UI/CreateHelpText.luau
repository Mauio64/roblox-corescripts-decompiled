local t1 = {}
local scriptParent = script.Parent
local CreateButtonsTime = require(scriptParent.CreateButtonsTime)

function t1.createHelpText(p1) -- line: 7
	-- upvalues: CreateButtonsTime (copy)
	p1.HelpRevealer = Instance.new("TextLabel")
	p1.HelpRevealer.Name = "HelpRevealer"
	p1.HelpRevealer.Font = Enum.Font.SourceSans
	p1.HelpRevealer.TextXAlignment = Enum.TextXAlignment.Center
	p1.HelpRevealer.TextYAlignment = Enum.TextYAlignment.Center
	p1.HelpRevealer.Size = UDim2.new(0.5, 0, 1.3, 0)
	p1.HelpRevealer.SizeConstraint = Enum.SizeConstraint.RelativeXY
	p1.HelpRevealer.AnchorPoint = Vector2.new(0.5, 0.5)
	p1.HelpRevealer.Position = UDim2.new(0.5, 0, 0.5, 0)
	p1.HelpRevealer.BackgroundTransparency = 1
	p1.HelpRevealer.Text = "?"
	p1.HelpRevealer.TextColor3 = CreateButtonsTime.regularColor
	p1.HelpRevealer.TextScaled = true
	p1.HelpRevealer.Parent = p1.HelpBar

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingBottom = UDim.new(0.05, 0)
	UIPadding.Parent = p1.HelpRevealer
	p1.HelpDescription = Instance.new("TextLabel")
	p1.HelpDescription.Name = "HelpDescription"
	p1.HelpDescription.Font = Enum.Font.SourceSans
	p1.HelpDescription.TextXAlignment = Enum.TextXAlignment.Left
	p1.HelpDescription.TextYAlignment = Enum.TextYAlignment.Top
	p1.HelpDescription.AnchorPoint = Vector2.new(1, 1)
	p1.HelpDescription.Position = UDim2.new(1, 0, 0, 0)
	p1.HelpDescription.Size = UDim2.new(5.3, 0, 2.5, 0)
	p1.HelpDescription.SizeConstraint = Enum.SizeConstraint.RelativeXY
	p1.HelpDescription.BorderSizePixel = 0
	p1.HelpDescription.BackgroundColor3 = p1.defaultBackgroundColor3
	p1.HelpDescription.BackgroundTransparency = p1.defaultBackgroundTransparency
	p1.HelpDescription.RichText = true
	p1.HelpDescription.Text = "<b>Shortcuts</b>\n<u>space</u> - play/pause\n<u>r</u> - rewind\n<u>s</u> - stop"
	p1.HelpDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
	p1.HelpDescription.TextScaled = Enum.AutomaticSize.XY
	p1.HelpDescription.Parent = p1.HelpBar
	p1.HelpDescription.Visible = false

	local UIPadding2 = Instance.new("UIPadding")

	UIPadding2.PaddingLeft = UDim.new(0.02, 0)
	UIPadding2.PaddingBottom = UDim.new(0.02, 0)
	UIPadding2.Parent = p1.HelpDescription
	p1.HelpRevealer.MouseEnter:Connect(function() -- line: 55
		-- upvalues: p1 (copy), CreateButtonsTime (copy)
		p1.HelpRevealer.TextColor3 = CreateButtonsTime.hoverColor
		p1.HelpDescription.Visible = true
	end)
	p1.HelpRevealer.MouseLeave:Connect(function() -- line: 60
		-- upvalues: p1 (copy), CreateButtonsTime (copy)
		p1.HelpRevealer.TextColor3 = CreateButtonsTime.regularColor
		p1.HelpDescription.Visible = false
	end)
end

return t1
