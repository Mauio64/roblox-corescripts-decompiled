local t1 = {}
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local ChannelsTab = require(scriptParent:WaitForChild("ChannelsTab"))
local MessageSender = require(scriptParent:WaitForChild("MessageSender"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(scriptParent:WaitForChild("CurveUtil"))
local t2 = {}

t2.__index = t2

function t2.CreateGuiObjects(p1, p2) -- line: 24
	-- upvalues: ChatSettings (copy), MessageSender (copy)
	local Frame = Instance.new("Frame")

	Frame.Selectable = false
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = p2

	local Frame2 = Instance.new("Frame")

	Frame2.Selectable = false
	Frame2.Name = "ScrollingBase"
	Frame2.BackgroundTransparency = 1
	Frame2.ClipsDescendants = true
	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.Position = UDim2.new(0, 0, 0, 0)
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.Selectable = false
	Frame3.Name = "ScrollerSizer"
	Frame3.BackgroundTransparency = 1
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Selectable = false
	Frame4.Name = "ScrollerFrame"
	Frame4.BackgroundTransparency = 1
	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.Position = UDim2.new(0, 0, 0, 0)
	Frame4.Parent = Frame3

	local Frame5 = Instance.new("Frame")

	Frame5.Selectable = false
	Frame5.Size = UDim2.new(1, 0, 1, 0)
	Frame5.Position = UDim2.new(0, 0, 0, 0)
	Frame5.ClipsDescendants = true
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = Frame

	local Frame6 = Instance.new("Frame")

	Frame6.Selectable = false
	Frame6.Name = "LeaveConfirmationFrame"
	Frame6.Size = UDim2.new(1, 0, 1, 0)
	Frame6.Position = UDim2.new(0, 0, 1, 0)
	Frame6.BackgroundTransparency = 0.6
	Frame6.BorderSizePixel = 0
	Frame6.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame6.Parent = Frame5

	local TextButton = Instance.new("TextButton")

	TextButton.Selectable = false
	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = ""
	TextButton.Parent = Frame6

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Selectable = false
	TextButton2.Size = UDim2.new(0.25, 0, 1, 0)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Font = ChatSettings.DefaultFont
	TextButton2.TextSize = 18
	TextButton2.TextStrokeTransparency = 0.75
	TextButton2.Position = UDim2.new(0, 0, 0, 0)
	TextButton2.TextColor3 = Color3.new(0, 1, 0)
	TextButton2.Text = "Confirm"
	TextButton2.Parent = Frame6

	local clone = TextButton2:Clone()

	clone.Parent = Frame6
	clone.Position = UDim2.new(0.75, 0, 0, 0)
	clone.TextColor3 = Color3.new(1, 0, 0)
	clone.Text = "Cancel"

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Selectable = false
	TextLabel.Size = UDim2.new(0.5, 0, 1, 0)
	TextLabel.Position = UDim2.new(0.25, 0, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0.75
	TextLabel.Text = "Leave channel <XX>?"
	TextLabel.Font = ChatSettings.DefaultFont
	TextLabel.TextSize = 18
	TextLabel.Parent = Frame6

	local StringValue = Instance.new("StringValue")

	StringValue.Name = "LeaveTarget"
	StringValue.Parent = Frame6

	local Frame6Position = Frame6.Position

	TextButton2.MouseButton1Click:connect(function() -- line: 116
		-- upvalues: MessageSender (copy), StringValue (copy), Frame6 (copy), Frame6Position (copy)
		MessageSender:SendMessage(string.format("/leave %s", StringValue.Value), nil)
		Frame6:TweenPosition(Frame6Position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)
	clone.MouseButton1Click:connect(function() -- line: 120
		-- upvalues: Frame6 (copy), Frame6Position (copy)
		Frame6:TweenPosition(Frame6Position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)

	local ImageButton = Instance.new("ImageButton", Frame)

	ImageButton.Selectable = ChatSettings.GamepadNavigationEnabled
	ImageButton.Name = "PageLeftButton"
	ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ImageButton.Size = UDim2.new(0.7, 0, 0.7, 0)
	ImageButton.BackgroundTransparency = 1
	ImageButton.Position = UDim2.new(0, 4, 0.15000000000000002, 0)
	ImageButton.Visible = false
	ImageButton.Image = "rbxassetid://471630199"

	local ImageLabel = Instance.new("ImageLabel", ImageButton)

	ImageLabel.Name = "ArrowLabel"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
	ImageLabel.Image = "rbxassetid://471630112"

	local Frame7 = Instance.new("Frame", Frame)

	Frame7.Selectable = false
	Frame7.BackgroundTransparency = 1
	Frame7.Name = "PositionalHelper"
	Frame7.Size = ImageButton.Size
	Frame7.SizeConstraint = ImageButton.SizeConstraint
	Frame7.Position = UDim2.new(1, 0, 0.15000000000000002, 0)

	local clone2 = ImageButton:Clone()

	clone2.Parent = Frame7
	clone2.Name = "PageRightButton"
	clone2.Size = UDim2.new(1, 0, 1, 0)
	clone2.SizeConstraint = Enum.SizeConstraint.RelativeXY
	clone2.Position = UDim2.new(-1, -4, 0, 0)

	local uDim2 = UDim2.new(0.05, 0, 0, 0)

	clone2.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) + uDim2
	ImageButton.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) - uDim2
	ImageButton.ArrowLabel.Rotation = 180
	p1.GuiObject = Frame
	p1.GuiObjects.BaseFrame = Frame
	p1.GuiObjects.ScrollerSizer = Frame3
	p1.GuiObjects.ScrollerFrame = Frame4
	p1.GuiObjects.PageLeftButton = ImageButton
	p1.GuiObjects.PageRightButton = clone2
	p1.GuiObjects.LeaveConfirmationFrame = Frame6
	p1.GuiObjects.LeaveConfirmationNotice = TextLabel
	p1.GuiObjects.PageLeftButtonArrow = ImageButton.ArrowLabel
	p1.GuiObjects.PageRightButtonArrow = clone2.ArrowLabel
	p1:AnimGuiObjects()
	ImageButton.MouseButton1Click:connect(function() -- line: 188
		-- upvalues: p1 (copy)
		p1:ScrollChannelsFrame(-1)
	end)
	clone2.MouseButton1Click:connect(function() -- line: 189
		-- upvalues: p1 (copy)
		p1:ScrollChannelsFrame(1)
	end)
	p1:ScrollChannelsFrame(0)
end
function t2.UpdateMessagePostedInChannel(p3, p4) -- line: 195
	local ChannelTab = p3:GetChannelTab(p4)

	if ChannelTab then
		ChannelTab:UpdateMessagePostedInChannel()

		return
	end

	warn("ChannelsTab '" .. p4 .. "' does not exist!")
end
function t2.AddChannelTab(p5, p6) -- line: 204
	-- upvalues: ChannelsTab (copy), ChatSettings (copy)
	if p5:GetChannelTab(p6) then
		error("Channel tab '" .. p6 .. "'already exists!")
	end

	local v33 = ChannelsTab.new(p6)

	v33.GuiObject.Parent = p5.GuiObjects.ScrollerFrame
	p5.ChannelTabs[p6:lower()] = v33
	p5.NumTabs = p5.NumTabs + 1
	p5:OrganizeChannelTabs()

	if ChatSettings.RightClickToLeaveChannelEnabled then
		v33.NameTag.MouseButton2Click:connect(function() -- line: 217
			-- upvalues: p5 (copy), v33 (copy)
			p5.LeaveConfirmationNotice.Text = string.format("Leave channel %s?", v33.ChannelName)
			p5.LeaveConfirmationFrame.LeaveTarget.Value = v33.ChannelName
			p5.LeaveConfirmationFrame:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
		end)
	end

	return v33
end
function t2.RemoveChannelTab(p7, p8) -- line: 227
	if not p7:GetChannelTab(p8) then
		error("Channel tab '" .. p8 .. "'does not exist!")
	end

	local v36 = p8:lower()

	p7.ChannelTabs[v36]:Destroy()
	p7.ChannelTabs[v36] = nil
	p7.NumTabs = p7.NumTabs - 1
	p7:OrganizeChannelTabs()
end
function t2.GetChannelTab(p9, p10) -- line: 240
	return p9.ChannelTabs[p10:lower()]
end
function t2.OrganizeChannelTabs(p11) -- line: 244
	-- upvalues: ChatSettings (copy)
	local t3 = {}

	table.insert(t3, p11:GetChannelTab(ChatSettings.GeneralChannelName))
	table.insert(t3, p11:GetChannelTab("System"))

	for _, v in pairs(p11.ChannelTabs) do
		if v.ChannelName ~= ChatSettings.GeneralChannelName and v.ChannelName ~= "System" then
			table.insert(t3, v)
		end
	end

	for k, v in pairs(t3) do
		v.GuiObject.Position = UDim2.new(k - 1, 0, 0, 0)
	end

	p11.GuiObjects.ScrollerSizer.Size = UDim2.new(1 / math.max(1, (math.min(ChatSettings.ChannelsBarFullTabSize, p11.NumTabs))), 0, 1, 0)
	p11:ScrollChannelsFrame(0)
end
function t2.ResizeChannelTabText(p12, p13) -- line: 266
	for _, v in pairs(p12.ChannelTabs) do
		v:SetTextSize(p13)
	end
end
function t2.ScrollChannelsFrame(p14, p15) -- line: 272
	-- upvalues: ChatSettings (copy)
	if p14.ScrollChannelsFrameLock then
		return
	end

	p14.ScrollChannelsFrameLock = true

	local ChannelsBarFullTabSize = ChatSettings.ChannelsBarFullTabSize
	local v52 = p14.CurPageNum + p15

	if v52 < 0 then
		v52 = 0
	elseif v52 > 0 and v52 + ChannelsBarFullTabSize > p14.NumTabs then
		v52 = p14.NumTabs - ChannelsBarFullTabSize
	end

	p14.CurPageNum = v52

	local uDim2 = UDim2.new(-p14.CurPageNum, 0, 0, 0)

	p14.GuiObjects.PageLeftButton.Visible = p14.CurPageNum > 0
	p14.GuiObjects.PageRightButton.Visible = p14.CurPageNum + ChannelsBarFullTabSize < p14.NumTabs

	if p15 == 0 then
		p14.ScrollChannelsFrameLock = false

		return
	end

	local function UnlockFunc() -- line: 298
		-- upvalues: p14 (copy)
		p14.ScrollChannelsFrameLock = false
	end

	p14:WaitUntilParentedCorrectly()
	p14.GuiObjects.ScrollerFrame:TweenPosition(uDim2, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15, true, UnlockFunc)
end
function t2.FadeOutBackground(p16, p17) -- line: 307
	-- upvalues: CurveUtil (copy)
	for _, v in pairs(p16.ChannelTabs) do
		v:FadeOutBackground(p17)
	end

	p16.AnimParams.Background_TargetTransparency = 1
	p16.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p17)
end
function t2.FadeInBackground(p18, p19) -- line: 316
	-- upvalues: CurveUtil (copy)
	for _, v in pairs(p18.ChannelTabs) do
		v:FadeInBackground(p19)
	end

	p18.AnimParams.Background_TargetTransparency = 0.6
	p18.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p19)
end
function t2.FadeOutText(p20, p21) -- line: 325
	for _, v in pairs(p20.ChannelTabs) do
		v:FadeOutText(p21)
	end
end
function t2.FadeInText(p22, p23) -- line: 331
	for _, v in pairs(p22.ChannelTabs) do
		v:FadeInText(p23)
	end
end
function t2.AnimGuiObjects(p24) -- line: 337
	p24.GuiObjects.PageLeftButton.ImageTransparency = p24.AnimParams.Background_CurrentTransparency
	p24.GuiObjects.PageRightButton.ImageTransparency = p24.AnimParams.Background_CurrentTransparency
	p24.GuiObjects.PageLeftButtonArrow.ImageTransparency = p24.AnimParams.Background_CurrentTransparency
	p24.GuiObjects.PageRightButtonArrow.ImageTransparency = p24.AnimParams.Background_CurrentTransparency
end
function t2.InitializeAnimParams(p25) -- line: 344
	-- upvalues: CurveUtil (copy)
	p25.AnimParams.Background_TargetTransparency = 0.6
	p25.AnimParams.Background_CurrentTransparency = 0.6
	p25.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end
function t2.Update(p26, p27) -- line: 350
	-- upvalues: CurveUtil (copy)
	for _, v in pairs(p26.ChannelTabs) do
		v:Update(p27)
	end

	p26.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(p26.AnimParams.Background_CurrentTransparency, p26.AnimParams.Background_TargetTransparency, p26.AnimParams.Background_NormalizedExptValue, p27)
	p26:AnimGuiObjects()
end
function t2.WaitUntilParentedCorrectly(p28) -- line: 366
	while not p28.GuiObject:IsDescendantOf(game:GetService("Players").LocalPlayer) do
		p28.GuiObject.AncestryChanged:wait()
	end
end
function t1.new() -- line: 375
	-- upvalues: t2 (copy), ChatSettings (copy)
	local self = setmetatable({}, t2)

	self.GuiObject = nil
	self.GuiObjects = {}
	self.ChannelTabs = {}
	self.NumTabs = 0
	self.CurPageNum = 0
	self.ScrollChannelsFrameLock = false
	self.AnimParams = {}
	self:InitializeAnimParams()
	ChatSettings.SettingsChanged:connect(function(p29, p30) -- line: 391
		-- upvalues: self (copy)
		if p29 == "ChatChannelsTabTextSize" then
			self:ResizeChannelTabText(p30)
		end
	end)

	return self
end

return t1
