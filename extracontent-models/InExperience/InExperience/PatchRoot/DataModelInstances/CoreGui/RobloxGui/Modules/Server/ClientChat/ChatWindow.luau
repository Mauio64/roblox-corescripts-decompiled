local t1 = {}
local Players = game:GetService("Players")

game:GetService("Chat")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local ChatChannel = require(scriptParent:WaitForChild("ChatChannel"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(scriptParent:WaitForChild("CurveUtil"))
local t2 = {}

t2.__index = t2

function getClassicChatEnabled() -- line: 34
	-- upvalues: ChatSettings (copy), Players (copy)
	if ChatSettings.ClassicChatEnabled ~= nil then
		return ChatSettings.ClassicChatEnabled
	end

	return Players.ClassicChat
end
function getBubbleChatEnabled() -- line: 41
	-- upvalues: ChatSettings (copy), Players (copy)
	if ChatSettings.BubbleChatEnabled ~= nil then
		return ChatSettings.BubbleChatEnabled
	end

	return Players.BubbleChat
end
function bubbleChatOnly() -- line: 48
	return not getClassicChatEnabled() and getBubbleChatEnabled()
end
function mergeProps(p1, p2) -- line: 53
	if not p1 or not p2 then
		return
	end

	for k, v in pairs(p1) do
		if p2[k] ~= nil then
			p2[k] = v
		end
	end
end
function t2.CreateGuiObjects(p3, p4) -- line: 62
	-- upvalues: Chat (copy), ChatSettings (copy), PlayerGui (copy)
	local u17 = nil

	pcall(function() -- line: 64
		-- upvalues: u17 (ref), Chat (copy)
		u17 = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, nil)
	end)
	mergeProps(u17, ChatSettings)

	local Frame = Instance.new("Frame")

	Frame.BackgroundTransparency = 1
	Frame.Active = ChatSettings.WindowDraggable
	Frame.Parent = p4
	Frame.AutoLocalize = false

	local Frame2 = Instance.new("Frame")

	Frame2.Selectable = false
	Frame2.Name = "ChatBarParentFrame"
	Frame2.BackgroundTransparency = 1
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.Selectable = false
	Frame3.Name = "ChannelsBarParentFrame"
	Frame3.BackgroundTransparency = 1
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.Parent = Frame

	local Frame4 = Instance.new("Frame")

	Frame4.Selectable = false
	Frame4.Name = "ChatChannelParentFrame"
	Frame4.BackgroundTransparency = 1
	Frame4.BackgroundColor3 = ChatSettings.BackGroundColor
	Frame4.BackgroundTransparency = 0.6
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Selectable = false
	ImageButton.Image = ""
	ImageButton.BackgroundTransparency = 0.6
	ImageButton.BorderSizePixel = 0
	ImageButton.Visible = false
	ImageButton.BackgroundColor3 = ChatSettings.BackGroundColor
	ImageButton.Active = true

	if bubbleChatOnly() then
		ImageButton.Position = UDim2.new(1, -ImageButton.AbsoluteSize.X, 0, 0)
	else
		ImageButton.Position = UDim2.new(1, -ImageButton.AbsoluteSize.X, 1, -ImageButton.AbsoluteSize.Y)
	end

	ImageButton.Parent = Frame

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Selectable = false
	ImageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
	ImageLabel.Position = UDim2.new(0.2, 0, 0.2, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxassetid://261880743"
	ImageLabel.Parent = ImageButton

	local function GetScreenGuiParent() -- line: 122
		-- upvalues: Frame (copy)
		local v102 = Frame

		while v102 and not v102:IsA("ScreenGui") do
			v102 = v102.Parent
		end

		return v102
	end

	local n1 = 3
	local v26 = Frame

	while v26 and not v26:IsA("ScreenGui") do
		v26 = v26.Parent
	end

	if v26.AbsoluteSize.X <= 640 then
		n1 = 1
	elseif v26.AbsoluteSize.X <= 1024 then
		n1 = 2
	end

	local u27 = false

	local function doCheckSizeBounds() -- line: 145
		-- upvalues: u27 (ref), Frame (copy), PlayerGui (copy), ChatSettings (copy), Frame3 (copy), Frame2 (copy)
		if u27 then
			return
		end

		u27 = true

		if not Frame:IsDescendantOf(PlayerGui) then
			return
		end

		local v103 = Frame

		while v103 and not v103:IsA("ScreenGui") do
			v103 = v103.Parent
		end

		local MinimumWindowSize = ChatSettings.MinimumWindowSize
		local MaximumWindowSize = ChatSettings.MaximumWindowSize
		local v106 = Frame3.AbsoluteSize.Y + Frame2.AbsoluteSize.Y
		local v107 = MinimumWindowSize.X.Scale * v103.AbsoluteSize.X + MinimumWindowSize.X.Offset
		local v108 = math.max(MinimumWindowSize.Y.Scale * v103.AbsoluteSize.Y + MinimumWindowSize.Y.Offset, v106)
		local v109 = MaximumWindowSize.X.Scale * v103.AbsoluteSize.X + MaximumWindowSize.X.Offset
		local v110 = MaximumWindowSize.Y.Scale * v103.AbsoluteSize.Y + MaximumWindowSize.Y.Offset
		local AbsoluteSizeX = Frame.AbsoluteSize.X
		local AbsoluteSizeY = Frame.AbsoluteSize.Y

		if AbsoluteSizeX < v107 then
			local uDim2 = UDim2.new(0, v107 - AbsoluteSizeX, 0, 0)

			Frame.Size = Frame.Size + uDim2
		elseif v109 < AbsoluteSizeX then
			local uDim2 = UDim2.new(0, v109 - AbsoluteSizeX, 0, 0)

			Frame.Size = Frame.Size + uDim2
		end

		if AbsoluteSizeY < v108 then
			local uDim2 = UDim2.new(0, 0, 0, v108 - AbsoluteSizeY)

			Frame.Size = Frame.Size + uDim2
		elseif v110 < AbsoluteSizeY then
			local uDim2 = UDim2.new(0, 0, 0, v110 - AbsoluteSizeY)

			Frame.Size = Frame.Size + uDim2
		end

		local v117 = Frame.AbsoluteSize.X / v103.AbsoluteSize.X
		local v118 = Frame.AbsoluteSize.Y / v103.AbsoluteSize.Y

		Frame.Size = UDim2.new(v117, 0, v118, 0)
		u27 = false
	end

	Frame.Changed:connect(function(p5) -- line: 196
		-- upvalues: doCheckSizeBounds (copy)
		if p5 == "AbsoluteSize" then
			doCheckSizeBounds()
		end
	end)
	ImageButton.DragBegin:connect(function(_) -- line: 202
		-- upvalues: Frame (copy)
		Frame.Draggable = false
	end)

	local function UpdatePositionFromDrag(p7) -- line: 206
		-- upvalues: ChatSettings (copy), Frame (copy), ImageButton (copy)
		if ChatSettings.WindowDraggable == false and ChatSettings.WindowResizable == false then
			return
		end

		local v122 = p7 - Frame.AbsolutePosition + ImageButton.AbsoluteSize

		Frame.Size = UDim2.new(0, v122.X, 0, v122.Y)

		if bubbleChatOnly() then
			ImageButton.Position = UDim2.new(1, -ImageButton.AbsoluteSize.X, 0, 0)

			return
		end

		ImageButton.Position = UDim2.new(1, -ImageButton.AbsoluteSize.X, 1, -ImageButton.AbsoluteSize.Y)
	end

	ImageButton.DragStopped:connect(function(_, _) -- line: 219
		-- upvalues: Frame (copy), ChatSettings (copy)
		Frame.Draggable = ChatSettings.WindowDraggable
	end)

	local u30 = false

	ImageButton.Changed:connect(function(p10) -- line: 225
		-- upvalues: Frame (copy), u30 (ref), UpdatePositionFromDrag (copy), ImageButton (copy)
		if p10 == "AbsolutePosition" and not Frame.Draggable then
			if u30 then
				return
			end

			u30 = true
			UpdatePositionFromDrag(ImageButton.AbsolutePosition)
			u30 = false
		end
	end)

	local function CalculateChannelsBarPixelSize(p11) -- line: 236
		-- upvalues: n1 (ref), ChatSettings (copy)
		return math.max(32, ((if n1 ~= 1 then p11 or ChatSettings.ChatChannelsTabTextSize else p11 or ChatSettings.ChatChannelsTabTextSizePhone)) + 8) + 2
	end
	local function CalculateChatBarPixelSize(p12) -- line: 249
		-- upvalues: n1 (ref), ChatSettings (copy)
		return ((if n1 ~= 1 then p12 or ChatSettings.ChatBarTextSize else p12 or ChatSettings.ChatBarTextSizePhone)) + 14 + 10
	end

	if bubbleChatOnly() then
		Frame2.Position = UDim2.new(0, 0, 0, 0)
		Frame3.Visible = false
		Frame3.Active = false
		Frame4.Visible = false
		Frame4.Active = false

		local v33 = Frame

		while v33 and not v33:IsA("ScreenGui") do
			v33 = v33.Parent
		end

		local XScale, XOffset

		if n1 == 1 then
			XScale = ChatSettings.DefaultWindowSizePhone.X.Scale
			XOffset = ChatSettings.DefaultWindowSizePhone.X.Offset
		elseif n1 == 2 then
			XScale = ChatSettings.DefaultWindowSizeTablet.X.Scale
			XOffset = ChatSettings.DefaultWindowSizeTablet.X.Offset
		else
			XScale = ChatSettings.DefaultWindowSizeDesktop.X.Scale
			XOffset = ChatSettings.DefaultWindowSizeDesktop.X.Offset
		end

		local v36 = nil
		local v37 = ((if n1 ~= 1 then v36 or ChatSettings.ChatBarTextSize else v36 or ChatSettings.ChatBarTextSizePhone)) + 14 + 10

		Frame.Size = UDim2.new(XScale, XOffset, 0, v37)
		Frame.Position = ChatSettings.DefaultWindowPosition
	else
		local v38 = Frame

		while v38 and not v38:IsA("ScreenGui") do
			v38 = v38.Parent
		end

		if n1 == 1 then
			Frame.Size = ChatSettings.DefaultWindowSizePhone
		elseif n1 == 2 then
			Frame.Size = ChatSettings.DefaultWindowSizeTablet
		else
			Frame.Size = ChatSettings.DefaultWindowSizeDesktop
		end

		Frame.Position = ChatSettings.DefaultWindowPosition
	end

	if n1 == 1 then
		ChatSettings.ChatWindowTextSize = ChatSettings.ChatWindowTextSizePhone
		ChatSettings.ChatChannelsTabTextSize = ChatSettings.ChatChannelsTabTextSizePhone
		ChatSettings.ChatBarTextSize = ChatSettings.ChatBarTextSizePhone
	end

	local function UpdateDraggable(p13) -- line: 318
		-- upvalues: Frame (copy)
		Frame.Active = p13
		Frame.Draggable = p13
	end
	local function UpdateResizable(p14) -- line: 323
		-- upvalues: ImageButton (copy), Frame2 (copy)
		ImageButton.Visible = p14
		ImageButton.Draggable = p14

		local YOffset = Frame2.Size.Y.Offset

		if p14 then
			Frame2.Size = UDim2.new(1, -YOffset - 2, 0, YOffset)

			if not bubbleChatOnly() then
				Frame2.Position = UDim2.new(0, 0, 1, -YOffset)

				return
			end
		else
			Frame2.Size = UDim2.new(1, 0, 0, YOffset)

			if not bubbleChatOnly() then
				Frame2.Position = UDim2.new(0, 0, 1, -YOffset)
			end
		end
	end
	local function UpdateChatChannelParentFrameSize() -- line: 342
		-- upvalues: n1 (ref), ChatSettings (copy), Frame4 (copy)
		local v131 = nil
		local v132 = math.max(32, ((if n1 ~= 1 then v131 or ChatSettings.ChatChannelsTabTextSize else v131 or ChatSettings.ChatChannelsTabTextSizePhone)) + 8) + 2
		local v133 = nil
		local v134 = ((if n1 ~= 1 then v133 or ChatSettings.ChatBarTextSize else v133 or ChatSettings.ChatBarTextSizePhone)) + 14 + 10

		if ChatSettings.ShowChannelsBar then
			Frame4.Size = UDim2.new(1, 0, 1, -(v132 + v134 + 2 + 2))
			Frame4.Position = UDim2.new(0, 0, 0, v132 + 2)

			return
		end

		Frame4.Size = UDim2.new(1, 0, 1, -(v134 + 2 + 2))
		Frame4.Position = UDim2.new(0, 0, 0, 2)
	end
	local function UpdateChatChannelsTabTextSize(p15) -- line: 357
		-- upvalues: n1 (ref), ChatSettings (copy), Frame3 (copy), UpdateChatChannelParentFrameSize (copy)
		local v136 = math.max(32, ((if n1 ~= 1 then p15 or ChatSettings.ChatChannelsTabTextSize else p15 or ChatSettings.ChatChannelsTabTextSizePhone)) + 8) + 2

		Frame3.Size = UDim2.new(1, 0, 0, v136)
		UpdateChatChannelParentFrameSize()
	end
	local function UpdateChatBarTextSize(p16) -- line: 364
		-- upvalues: n1 (ref), ChatSettings (copy), Frame2 (copy), ImageButton (copy), UpdateChatChannelParentFrameSize (copy), UpdateResizable (copy)
		local v138 = ((if n1 ~= 1 then p16 or ChatSettings.ChatBarTextSize else p16 or ChatSettings.ChatBarTextSizePhone)) + 14 + 10

		Frame2.Size = UDim2.new(1, 0, 0, v138)

		if not bubbleChatOnly() then
			Frame2.Position = UDim2.new(0, 0, 1, -v138)
		end

		ImageButton.Size = UDim2.new(0, v138, 0, v138)
		ImageButton.Position = UDim2.new(1, -v138, 1, -v138)
		UpdateChatChannelParentFrameSize()
		UpdateResizable(ChatSettings.WindowResizable)
	end
	local function UpdateShowChannelsBar(p17) -- line: 379
		-- upvalues: Frame3 (copy), UpdateChatChannelParentFrameSize (copy)
		Frame3.Visible = p17
		UpdateChatChannelParentFrameSize()
	end

	local ChatChannelsTabTextSize = ChatSettings.ChatChannelsTabTextSize
	local v46 = math.max(32, ((if n1 ~= 1 then ChatChannelsTabTextSize or ChatSettings.ChatChannelsTabTextSize else ChatChannelsTabTextSize or ChatSettings.ChatChannelsTabTextSizePhone)) + 8) + 2

	Frame3.Size = UDim2.new(1, 0, 0, v46)
	UpdateChatChannelParentFrameSize()
	UpdateChatBarTextSize(ChatSettings.ChatBarTextSize)

	local WindowDraggable = ChatSettings.WindowDraggable

	Frame.Active = WindowDraggable
	Frame.Draggable = WindowDraggable
	UpdateResizable(ChatSettings.WindowResizable)
	Frame3.Visible = ChatSettings.ShowChannelsBar
	UpdateChatChannelParentFrameSize()
	ChatSettings.SettingsChanged:connect(function(p18, p19) -- line: 390
		-- upvalues: Frame (copy), UpdateResizable (copy), n1 (ref), ChatSettings (copy), Frame3 (copy), UpdateChatChannelParentFrameSize (copy), UpdateChatBarTextSize (copy)
		if p18 == "WindowDraggable" then
			Frame.Active = p19
			Frame.Draggable = p19

			return
		end

		if p18 == "WindowResizable" then
			UpdateResizable(p19)

			return
		end

		if p18 == "ChatChannelsTabTextSize" then
			local v142 = math.max(32, ((if n1 ~= 1 then p19 or ChatSettings.ChatChannelsTabTextSize else p19 or ChatSettings.ChatChannelsTabTextSizePhone)) + 8) + 2

			Frame3.Size = UDim2.new(1, 0, 0, v142)
			UpdateChatChannelParentFrameSize()

			return
		end

		if p18 == "ChatBarTextSize" then
			UpdateChatBarTextSize(p19)

			return
		end

		if p18 == "ShowChannelsBar" then
			Frame3.Visible = p19
			UpdateChatChannelParentFrameSize()
		end
	end)
	p3.GuiObject = Frame
	p3.GuiObjects.BaseFrame = Frame
	p3.GuiObjects.ChatBarParentFrame = Frame2
	p3.GuiObjects.ChannelsBarParentFrame = Frame3
	p3.GuiObjects.ChatChannelParentFrame = Frame4
	p3.GuiObjects.ChatResizerFrame = ImageButton
	p3.GuiObjects.ResizeIcon = ImageLabel
	p3:AnimGuiObjects()
end
function t2.GetChatBar(p20) -- line: 420
	return p20.ChatBar
end
function t2.RegisterChatBar(p21, p22) -- line: 424
	p21.ChatBar = p22
	p21.ChatBar:CreateGuiObjects(p21.GuiObjects.ChatBarParentFrame)
end
function t2.RegisterChannelsBar(p23, p24) -- line: 429
	p23.ChannelsBar = p24
	p23.ChannelsBar:CreateGuiObjects(p23.GuiObjects.ChannelsBarParentFrame)
end
function t2.RegisterMessageLogDisplay(p25, p26) -- line: 434
	p25.MessageLogDisplay = p26
	p25.MessageLogDisplay.GuiObject.Parent = p25.GuiObjects.ChatChannelParentFrame
end
function t2.AddChannel(p27, p28) -- line: 439
	-- upvalues: ChatChannel (copy)
	if p27:GetChannel(p28) then
		error("Channel '" .. p28 .. "' already exists!")

		return
	end

	local v57 = ChatChannel.new(p28, p27.MessageLogDisplay)

	p27.Channels[p28:lower()] = v57
	v57:SetActive(false)

	local v58 = p27.ChannelsBar:AddChannelTab(p28)

	v58.NameTag.MouseButton1Click:connect(function() -- line: 451
		-- upvalues: p27 (copy), p28 (copy)
		p27:SwitchCurrentChannel(p28)
	end)
	v57:RegisterChannelTab(v58)

	return v57
end
function t2.GetFirstChannel(p29) -- line: 460
	for _, v in pairs(p29.Channels) do
		return v
	end

	return nil
end
function t2.RemoveChannel(p30, p31) -- line: 469
	-- upvalues: ChatSettings (copy)
	if not p30:GetChannel(p31) then
		error("Channel '" .. p31 .. "' does not exist!")
	end

	local v64 = p31:lower()
	local v65 = false

	if p30.Channels[v64] == p30:GetCurrentChannel() then
		v65 = true
		p30:SwitchCurrentChannel(nil)
	end

	p30.Channels[v64]:Destroy()
	p30.Channels[v64] = nil
	p30.ChannelsBar:RemoveChannelTab(p31)

	if v65 then
		local v66 = p30:GetChannel(ChatSettings.GeneralChannelName) ~= nil
		local v67 = v64 == ChatSettings.GeneralChannelName:lower()
		local GeneralChannelName

		if v66 and not v67 then
			GeneralChannelName = ChatSettings.GeneralChannelName
		else
			local FirstChannel = p30:GetFirstChannel()

			GeneralChannelName = FirstChannel and FirstChannel.Name or nil
		end

		p30:SwitchCurrentChannel(GeneralChannelName)
	end

	if not ChatSettings.ShowChannelsBar and p31 == p30.ChatBar.TargetChannel then
		p30.ChatBar:SetChannelTarget(ChatSettings.GeneralChannelName)
	end
end
function t2.GetChannel(p32, p33) -- line: 511
	return p33 and p32.Channels[p33:lower()] or nil
end
function t2.GetTargetMessageChannel(p34) -- line: 515
	-- upvalues: ChatSettings (copy)
	if not ChatSettings.ShowChannelsBar then
		return p34.ChatBar.TargetChannel
	end

	local CurrentChannel = p34:GetCurrentChannel()

	return CurrentChannel and CurrentChannel.Name
end
function t2.GetCurrentChannel(p35) -- line: 524
	return p35.CurrentChannel
end
function t2.SwitchCurrentChannel(p36, p37) -- line: 528
	-- upvalues: ChatSettings (copy)
	if not ChatSettings.ShowChannelsBar then
		local Channel = p36:GetChannel(p37)

		if Channel then
			p36.ChatBar:SetChannelTarget(Channel.Name)
		end

		p37 = ChatSettings.GeneralChannelName
	end

	local CurrentChannel = p36:GetCurrentChannel()
	local Channel = p36:GetChannel(p37)

	if Channel == nil then
		error(string.format("Channel '%s' does not exist.", p37))
	end

	if Channel ~= CurrentChannel then
		if CurrentChannel then
			CurrentChannel:SetActive(false)
			p36.ChannelsBar:GetChannelTab(CurrentChannel.Name):SetActive(false)
		end

		if Channel then
			Channel:SetActive(true)
			p36.ChannelsBar:GetChannelTab(Channel.Name):SetActive(true)
		end

		p36.CurrentChannel = Channel
	end
end
function t2.UpdateFrameVisibility(p38) -- line: 562
	p38.GuiObject.Visible = p38.Visible and p38.CoreGuiEnabled
end
function t2.GetVisible(p39) -- line: 566
	return p39.Visible
end
function t2.SetVisible(p40, p41) -- line: 570
	p40.Visible = p41
	p40:UpdateFrameVisibility()
end
function t2.GetCoreGuiEnabled(p42) -- line: 575
	return p42.CoreGuiEnabled
end
function t2.SetCoreGuiEnabled(p43, p44) -- line: 579
	p43.CoreGuiEnabled = p44
	p43:UpdateFrameVisibility()
end
function t2.EnableResizable(p45) -- line: 584
	p45.GuiObjects.ChatResizerFrame.Active = true
end
function t2.DisableResizable(p46) -- line: 588
	p46.GuiObjects.ChatResizerFrame.Active = false
end
function t2.FadeOutBackground(p47, p48) -- line: 592
	-- upvalues: CurveUtil (copy)
	p47.ChannelsBar:FadeOutBackground(p48)
	p47.MessageLogDisplay:FadeOutBackground(p48)
	p47.ChatBar:FadeOutBackground(p48)
	p47.AnimParams.Background_TargetTransparency = 1
	p47.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p48)
end
function t2.FadeInBackground(p49, p50) -- line: 601
	-- upvalues: CurveUtil (copy)
	p49.ChannelsBar:FadeInBackground(p50)
	p49.MessageLogDisplay:FadeInBackground(p50)
	p49.ChatBar:FadeInBackground(p50)
	p49.AnimParams.Background_TargetTransparency = 0.6
	p49.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p50)
end
function t2.FadeOutText(p51, p52) -- line: 610
	p51.MessageLogDisplay:FadeOutText(p52)
	p51.ChannelsBar:FadeOutText(p52)
end
function t2.FadeInText(p53, p54) -- line: 615
	p53.MessageLogDisplay:FadeInText(p54)
	p53.ChannelsBar:FadeInText(p54)
end
function t2.AnimGuiObjects(p55) -- line: 620
	p55.GuiObjects.ChatChannelParentFrame.BackgroundTransparency = p55.AnimParams.Background_CurrentTransparency
	p55.GuiObjects.ChatResizerFrame.BackgroundTransparency = p55.AnimParams.Background_CurrentTransparency
	p55.GuiObjects.ResizeIcon.ImageTransparency = p55.AnimParams.Background_CurrentTransparency
end
function t2.InitializeAnimParams(p56) -- line: 626
	-- upvalues: CurveUtil (copy)
	p56.AnimParams.Background_TargetTransparency = 0.6
	p56.AnimParams.Background_CurrentTransparency = 0.6
	p56.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end
function t2.Update(p57, p58) -- line: 632
	-- upvalues: CurveUtil (copy)
	p57.ChatBar:Update(p58)
	p57.ChannelsBar:Update(p58)
	p57.MessageLogDisplay:Update(p58)
	p57.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(p57.AnimParams.Background_CurrentTransparency, p57.AnimParams.Background_TargetTransparency, p57.AnimParams.Background_NormalizedExptValue, p58)
	p57:AnimGuiObjects()
end
function t1.new() -- line: 650
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.GuiObject = nil
	self.GuiObjects = {}
	self.ChatBar = nil
	self.ChannelsBar = nil
	self.MessageLogDisplay = nil
	self.Channels = {}
	self.CurrentChannel = nil
	self.Visible = true
	self.CoreGuiEnabled = true
	self.AnimParams = {}
	self:InitializeAnimParams()

	return self
end

return t1
