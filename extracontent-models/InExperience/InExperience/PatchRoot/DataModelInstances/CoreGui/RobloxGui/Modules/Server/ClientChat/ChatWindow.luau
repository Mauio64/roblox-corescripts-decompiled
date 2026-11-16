local ChatWindow = {}

local Players = game:GetService("Players")
game:GetService("Chat")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent
local ChatChannel = require(parent:WaitForChild("ChatChannel"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(parent:WaitForChild("CurveUtil"))

local class = {}
class.__index = class

function getClassicChatEnabled()
	if ChatSettings.ClassicChatEnabled == nil then
		return Players.ClassicChat
	end

	return ChatSettings.ClassicChatEnabled
end

function getBubbleChatEnabled()
	if ChatSettings.BubbleChatEnabled == nil then
		return Players.BubbleChat
	end

	return ChatSettings.BubbleChatEnabled
end

function bubbleChatOnly()
	return not getClassicChatEnabled() and getBubbleChatEnabled()
end

function mergeProps(items, p)
	if not (items and p) then
		return
	end

	for k, item in pairs(items) do
		if p[k] ~= nil then
			p[k] = item
		end
	end
end

function class:CreateGuiObjects(parent2)
	local v = nil
	pcall(function()
		v = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, nil)
	end)

	mergeProps(v, ChatSettings)

	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Active = ChatSettings.WindowDraggable
	frame.Parent = parent2
	frame.AutoLocalize = false

	local chatBarParentFrame = Instance.new("Frame")
	chatBarParentFrame.Selectable = false
	chatBarParentFrame.Name = "ChatBarParentFrame"
	chatBarParentFrame.BackgroundTransparency = 1
	chatBarParentFrame.Parent = frame

	local channelsBarParentFrame = Instance.new("Frame")
	channelsBarParentFrame.Selectable = false
	channelsBarParentFrame.Name = "ChannelsBarParentFrame"
	channelsBarParentFrame.BackgroundTransparency = 1
	channelsBarParentFrame.Position = UDim2.new(0, 0, 0, 0)
	channelsBarParentFrame.Parent = frame

	local chatChannelParentFrame = Instance.new("Frame")
	chatChannelParentFrame.Selectable = false
	chatChannelParentFrame.Name = "ChatChannelParentFrame"
	chatChannelParentFrame.BackgroundTransparency = 1
	chatChannelParentFrame.BackgroundColor3 = ChatSettings.BackGroundColor
	chatChannelParentFrame.BackgroundTransparency = 0.6
	chatChannelParentFrame.BorderSizePixel = 0
	chatChannelParentFrame.Parent = frame

	local imageButton = Instance.new("ImageButton")
	imageButton.Selectable = false
	imageButton.Image = ""
	imageButton.BackgroundTransparency = 0.6
	imageButton.BorderSizePixel = 0
	imageButton.Visible = false
	imageButton.BackgroundColor3 = ChatSettings.BackGroundColor
	imageButton.Active = true

	if bubbleChatOnly() then
		imageButton.Position = UDim2.new(1, -imageButton.AbsoluteSize.X, 0, 0)
	else
		imageButton.Position = UDim2.new(1, -imageButton.AbsoluteSize.X, 1, -imageButton.AbsoluteSize.Y)
	end

	imageButton.Parent = frame

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Selectable = false
	imageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
	imageLabel.Position = UDim2.new(0.2, 0, 0.2, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxassetid://261880743"
	imageLabel.Parent = imageButton

	local function GetScreenGuiParent() -- 4 equivalent calls inferred from this helper
		local screenGui = frame

		while screenGui and not screenGui:IsA("ScreenGui") do
			screenGui = screenGui.Parent
		end

		return screenGui
	end

	local screenGuiParent = GetScreenGuiParent() -- inferred equivalent call
	local v2 = screenGuiParent.AbsoluteSize.X <= 640 and 1 or screenGuiParent.AbsoluteSize.X <= 1024 and 2 or 3

	local flag = false
	local function doCheckSizeBounds()
		if flag then
			return
		end

		flag = true

		if not frame:IsDescendantOf(PlayerGui) then
			return
		end

		local screenGuiParent2 = GetScreenGuiParent() -- inferred equivalent call
		local minimumWindowSize = ChatSettings.MinimumWindowSize
		local maximumWindowSize = ChatSettings.MaximumWindowSize

		local v3 = channelsBarParentFrame.AbsoluteSize.Y + chatBarParentFrame.AbsoluteSize.Y

		local v4 = minimumWindowSize.X.Scale * screenGuiParent2.AbsoluteSize.X + minimumWindowSize.X.Offset
		local v5 = math.max(
			minimumWindowSize.Y.Scale * screenGuiParent2.AbsoluteSize.Y + minimumWindowSize.Y.Offset,
			v3
		)

		local v6 = maximumWindowSize.X.Scale * screenGuiParent2.AbsoluteSize.X + maximumWindowSize.X.Offset
		local v7 = maximumWindowSize.Y.Scale * screenGuiParent2.AbsoluteSize.Y + maximumWindowSize.Y.Offset

		local x = frame.AbsoluteSize.X
		local y = frame.AbsoluteSize.Y

		if x < v4 then
			local udim = UDim2.new(0, v4 - x, 0, 0)
			frame.Size += udim
		elseif v6 < x then
			local udim = UDim2.new(0, v6 - x, 0, 0)
			frame.Size += udim
		end

		if y < v5 then
			local udim = UDim2.new(0, 0, 0, v5 - y)
			frame.Size += udim
		elseif v7 < y then
			local udim = UDim2.new(0, 0, 0, v7 - y)
			frame.Size += udim
		end

		local v8 = frame.AbsoluteSize.X / screenGuiParent2.AbsoluteSize.X
		local v9 = frame.AbsoluteSize.Y / screenGuiParent2.AbsoluteSize.Y

		frame.Size = UDim2.new(v8, 0, v9, 0)

		flag = false
	end

	frame.Changed:connect(function(p)
		if p == "AbsoluteSize" then
			doCheckSizeBounds()
		end
	end)

	imageButton.DragBegin:connect(function(_)
		frame.Draggable = false
	end)

	local function UpdatePositionFromDrag(absolutePosition)
		if ChatSettings.WindowDraggable == false and ChatSettings.WindowResizable == false then
			return
		end

		local v3 = absolutePosition - frame.AbsolutePosition + imageButton.AbsoluteSize
		frame.Size = UDim2.new(0, v3.X, 0, v3.Y)

		if bubbleChatOnly() then
			imageButton.Position = UDim2.new(1, -imageButton.AbsoluteSize.X, 0, 0)
		else
			imageButton.Position = UDim2.new(1, -imageButton.AbsoluteSize.X, 1, -imageButton.AbsoluteSize.Y)
		end
	end

	imageButton.DragStopped:connect(function(_, _)
		frame.Draggable = ChatSettings.WindowDraggable
	end)

	local flag2 = false
	imageButton.Changed:connect(function(p)
		if p == "AbsolutePosition" and not frame.Draggable then
			if flag2 then
				return
			end

			flag2 = true

			UpdatePositionFromDrag(imageButton.AbsolutePosition)

			flag2 = false
		end
	end)

	local function CalculateChannelsBarPixelSize(p) -- 2 equivalent calls inferred from this helper
		local v3

		if v2 == 1 then
			v3 = p or ChatSettings.ChatChannelsTabTextSizePhone
		else
			v3 = p or ChatSettings.ChatChannelsTabTextSize
		end

		return math.max(32, v3 + 8) + 2
	end

	local function CalculateChatBarPixelSize(p) -- 3 equivalent calls inferred from this helper
		local v3

		if v2 == 1 then
			v3 = p or ChatSettings.ChatBarTextSizePhone
		else
			v3 = p or ChatSettings.ChatBarTextSize
		end

		return v3 + 14 + 10
	end

	if bubbleChatOnly() then
		chatBarParentFrame.Position = UDim2.new(0, 0, 0, 0)
		channelsBarParentFrame.Visible = false
		channelsBarParentFrame.Active = false
		chatChannelParentFrame.Visible = false
		chatChannelParentFrame.Active = false
		GetScreenGuiParent() -- inferred equivalent call
		local scale, offset

		if v2 == 1 then
			scale = ChatSettings.DefaultWindowSizePhone.X.Scale
			offset = ChatSettings.DefaultWindowSizePhone.X.Offset
		elseif v2 == 2 then
			scale = ChatSettings.DefaultWindowSizeTablet.X.Scale
			offset = ChatSettings.DefaultWindowSizeTablet.X.Offset
		else
			scale = ChatSettings.DefaultWindowSizeDesktop.X.Scale
			offset = ChatSettings.DefaultWindowSizeDesktop.X.Offset
		end

		frame.Size = UDim2.new(scale, offset, 0, CalculateChatBarPixelSize(nil)) -- inferred equivalent call
		frame.Position = ChatSettings.DefaultWindowPosition
	else
		GetScreenGuiParent() -- inferred equivalent call

		if v2 == 1 then
			frame.Size = ChatSettings.DefaultWindowSizePhone
		elseif v2 == 2 then
			frame.Size = ChatSettings.DefaultWindowSizeTablet
		else
			frame.Size = ChatSettings.DefaultWindowSizeDesktop
		end

		frame.Position = ChatSettings.DefaultWindowPosition
	end

	if v2 == 1 then
		ChatSettings.ChatWindowTextSize = ChatSettings.ChatWindowTextSizePhone
		ChatSettings.ChatChannelsTabTextSize = ChatSettings.ChatChannelsTabTextSizePhone
		ChatSettings.ChatBarTextSize = ChatSettings.ChatBarTextSizePhone
	end

	local function UpdateDraggable(p) -- 2 equivalent calls inferred from this helper
		frame.Active = p
		frame.Draggable = p
	end

	local function UpdateResizable(p)
		imageButton.Visible = p
		imageButton.Draggable = p

		local offset = chatBarParentFrame.Size.Y.Offset

		if p then
			chatBarParentFrame.Size = UDim2.new(1, -offset - 2, 0, offset)

			if not bubbleChatOnly() then
				chatBarParentFrame.Position = UDim2.new(0, 0, 1, -offset)
			end
		else
			chatBarParentFrame.Size = UDim2.new(1, 0, 0, offset)

			if not bubbleChatOnly() then
				chatBarParentFrame.Position = UDim2.new(0, 0, 1, -offset)
			end
		end
	end

	local function UpdateChatChannelParentFrameSize()
		local calculateChannelsBarPixelSize = CalculateChannelsBarPixelSize(nil) -- inferred equivalent call
		local calculateChatBarPixelSize = CalculateChatBarPixelSize(nil) -- inferred equivalent call

		if ChatSettings.ShowChannelsBar then
			chatChannelParentFrame.Size = UDim2.new(
				1,
				0,
				1,
				-(calculateChannelsBarPixelSize + calculateChatBarPixelSize + 2 + 2)
			)
			chatChannelParentFrame.Position = UDim2.new(0, 0, 0, calculateChannelsBarPixelSize + 2)
		else
			chatChannelParentFrame.Size = UDim2.new(1, 0, 1, -(calculateChatBarPixelSize + 2 + 2))
			chatChannelParentFrame.Position = UDim2.new(0, 0, 0, 2)
		end
	end

	local function UpdateChatChannelsTabTextSize(p) -- 2 equivalent calls inferred from this helper
		channelsBarParentFrame.Size = UDim2.new(1, 0, 0, CalculateChannelsBarPixelSize(p)) -- inferred equivalent call

		UpdateChatChannelParentFrameSize()
	end

	local function UpdateChatBarTextSize(p)
		local calculateChatBarPixelSize = CalculateChatBarPixelSize(p) -- inferred equivalent call
		chatBarParentFrame.Size = UDim2.new(1, 0, 0, calculateChatBarPixelSize)

		if not bubbleChatOnly() then
			chatBarParentFrame.Position = UDim2.new(0, 0, 1, -calculateChatBarPixelSize)
		end

		imageButton.Size = UDim2.new(0, calculateChatBarPixelSize, 0, calculateChatBarPixelSize)
		imageButton.Position = UDim2.new(1, -calculateChatBarPixelSize, 1, -calculateChatBarPixelSize)

		UpdateChatChannelParentFrameSize()
		UpdateResizable(ChatSettings.WindowResizable)
	end

	local function UpdateShowChannelsBar(visible) -- 2 equivalent calls inferred from this helper
		channelsBarParentFrame.Visible = visible
		UpdateChatChannelParentFrameSize()
	end

	UpdateChatChannelsTabTextSize(ChatSettings.ChatChannelsTabTextSize) -- inferred equivalent call
	UpdateChatBarTextSize(ChatSettings.ChatBarTextSize)
	UpdateDraggable(ChatSettings.WindowDraggable) -- inferred equivalent call
	UpdateResizable(ChatSettings.WindowResizable)
	UpdateShowChannelsBar(ChatSettings.ShowChannelsBar) -- inferred equivalent call

	ChatSettings.SettingsChanged:connect(function(p, visible)
		if p == "WindowDraggable" then
			UpdateDraggable(visible) -- inferred equivalent call
		elseif p == "WindowResizable" then
			UpdateResizable(visible)
		elseif p == "ChatChannelsTabTextSize" then
			UpdateChatChannelsTabTextSize(visible) -- inferred equivalent call
		elseif p == "ChatBarTextSize" then
			UpdateChatBarTextSize(visible)
		elseif p == "ShowChannelsBar" then
			UpdateShowChannelsBar(visible) -- inferred equivalent call
		end
	end)

	self.GuiObject = frame

	self.GuiObjects.BaseFrame = frame
	self.GuiObjects.ChatBarParentFrame = chatBarParentFrame
	self.GuiObjects.ChannelsBarParentFrame = channelsBarParentFrame
	self.GuiObjects.ChatChannelParentFrame = chatChannelParentFrame
	self.GuiObjects.ChatResizerFrame = imageButton
	self.GuiObjects.ResizeIcon = imageLabel
	self:AnimGuiObjects()
end

function class.GetChatBar(p)
	return p.ChatBar
end

function class:RegisterChatBar(chatBar)
	self.ChatBar = chatBar
	self.ChatBar:CreateGuiObjects(self.GuiObjects.ChatBarParentFrame)
end

function class:RegisterChannelsBar(channelsBar)
	self.ChannelsBar = channelsBar
	self.ChannelsBar:CreateGuiObjects(self.GuiObjects.ChannelsBarParentFrame)
end

function class:RegisterMessageLogDisplay(messageLogDisplay)
	self.MessageLogDisplay = messageLogDisplay
	self.MessageLogDisplay.GuiObject.Parent = self.GuiObjects.ChatChannelParentFrame
end

function class:AddChannel(value)
	if self:GetChannel(value) then
		error("Channel '" .. value .. "' already exists!")
		return
	end

	local v = ChatChannel.new(value, self.MessageLogDisplay)
	self.Channels[value:lower()] = v

	v:SetActive(false)

	local v2 = self.ChannelsBar:AddChannelTab(value)
	v2.NameTag.MouseButton1Click:connect(function()
		self:SwitchCurrentChannel(value)
	end)

	v:RegisterChannelTab(v2)

	return v
end

function class:GetFirstChannel()
	for _, channel in pairs(self.Channels) do
		return channel
	end

	return nil
end

function class:RemoveChannel(value)
	if not self:GetChannel(value) then
		error("Channel '" .. value .. "' does not exist!")
	end

	local lower = value:lower()
	local flag

	if self.Channels[lower] == self:GetCurrentChannel() then
		self:SwitchCurrentChannel(nil)
		flag = true
	else
		flag = false
	end

	self.Channels[lower]:Destroy()
	self.Channels[lower] = nil

	self.ChannelsBar:RemoveChannelTab(value)

	if flag then
		local v = self:GetChannel(ChatSettings.GeneralChannelName) ~= nil
		local v2 = lower == ChatSettings.GeneralChannelName:lower()
		local v3

		if v and not v2 then
			v3 = ChatSettings.GeneralChannelName
		else
			local firstChannel = self:GetFirstChannel()
			v3 = firstChannel and firstChannel.Name or nil
		end

		self:SwitchCurrentChannel(v3)
	end

	if not ChatSettings.ShowChannelsBar and self.ChatBar.TargetChannel == value then
		self.ChatBar:SetChannelTarget(ChatSettings.GeneralChannelName)
	end
end

function class:GetChannel(value)
	return value and self.Channels[value:lower()] or nil
end

function class:GetTargetMessageChannel()
	if not ChatSettings.ShowChannelsBar then
		return self.ChatBar.TargetChannel
	end

	local currentChannel = self:GetCurrentChannel()
	return currentChannel and currentChannel.Name
end

function class:GetCurrentChannel()
	return self.CurrentChannel
end

function class:SwitchCurrentChannel(p)
	if not ChatSettings.ShowChannelsBar then
		local channel = self:GetChannel(p)

		if channel then
			self.ChatBar:SetChannelTarget(channel.Name)
		end

		p = ChatSettings.GeneralChannelName
	end

	local currentChannel = self:GetCurrentChannel()
	local channel = self:GetChannel(p)

	if channel == nil then
		error(string.format("Channel '%s' does not exist.", p))
	end

	if channel ~= currentChannel then
		if currentChannel then
			currentChannel:SetActive(false)
			self.ChannelsBar:GetChannelTab(currentChannel.Name):SetActive(false)
		end

		if channel then
			channel:SetActive(true)
			self.ChannelsBar:GetChannelTab(channel.Name):SetActive(true)
		end

		self.CurrentChannel = channel
	end
end

function class:UpdateFrameVisibility()
	self.GuiObject.Visible = self.Visible and self.CoreGuiEnabled
end

function class.GetVisible(p)
	return p.Visible
end

function class:SetVisible(visible)
	self.Visible = visible
	self:UpdateFrameVisibility()
end

function class.GetCoreGuiEnabled(p)
	return p.CoreGuiEnabled
end

function class:SetCoreGuiEnabled(coreGuiEnabled)
	self.CoreGuiEnabled = coreGuiEnabled
	self:UpdateFrameVisibility()
end

function class.EnableResizable(p)
	p.GuiObjects.ChatResizerFrame.Active = true
end

function class.DisableResizable(p)
	p.GuiObjects.ChatResizerFrame.Active = false
end

function class:FadeOutBackground(p)
	self.ChannelsBar:FadeOutBackground(p)
	self.MessageLogDisplay:FadeOutBackground(p)
	self.ChatBar:FadeOutBackground(p)

	self.AnimParams.Background_TargetTransparency = 1
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:FadeInBackground(p)
	self.ChannelsBar:FadeInBackground(p)
	self.MessageLogDisplay:FadeInBackground(p)
	self.ChatBar:FadeInBackground(p)

	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:FadeOutText(p)
	self.MessageLogDisplay:FadeOutText(p)
	self.ChannelsBar:FadeOutText(p)
end

function class:FadeInText(p)
	self.MessageLogDisplay:FadeInText(p)
	self.ChannelsBar:FadeInText(p)
end

function class:AnimGuiObjects()
	self.GuiObjects.ChatChannelParentFrame.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.ChatResizerFrame.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.ResizeIcon.ImageTransparency = self.AnimParams.Background_CurrentTransparency
end

function class:InitializeAnimParams()
	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_CurrentTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end

function class:Update(p)
	self.ChatBar:Update(p)
	self.ChannelsBar:Update(p)
	self.MessageLogDisplay:Update(p)

	self.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Background_CurrentTransparency,
		self.AnimParams.Background_TargetTransparency,
		self.AnimParams.Background_NormalizedExptValue,
		p
	)

	self:AnimGuiObjects()
end

function ChatWindow.new()
	local self = setmetatable({}, class)

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

return ChatWindow
