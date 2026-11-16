local ChannelsBar = {}

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent
local ChannelsTab = require(parent:WaitForChild("ChannelsTab"))
local MessageSender = require(parent:WaitForChild("MessageSender"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(parent:WaitForChild("CurveUtil"))

local class = {}
class.__index = class

function class:CreateGuiObjects(parent2)
	local frame = Instance.new("Frame")
	frame.Selectable = false
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Parent = parent2

	local scrollingBase = Instance.new("Frame")
	scrollingBase.Selectable = false
	scrollingBase.Name = "ScrollingBase"
	scrollingBase.BackgroundTransparency = 1
	scrollingBase.ClipsDescendants = true
	scrollingBase.Size = UDim2.new(1, 0, 1, 0)
	scrollingBase.Position = UDim2.new(0, 0, 0, 0)
	scrollingBase.Parent = frame

	local scrollerSizer = Instance.new("Frame")
	scrollerSizer.Selectable = false
	scrollerSizer.Name = "ScrollerSizer"
	scrollerSizer.BackgroundTransparency = 1
	scrollerSizer.Size = UDim2.new(1, 0, 1, 0)
	scrollerSizer.Position = UDim2.new(0, 0, 0, 0)
	scrollerSizer.Parent = scrollingBase

	local scrollerFrame = Instance.new("Frame")
	scrollerFrame.Selectable = false
	scrollerFrame.Name = "ScrollerFrame"
	scrollerFrame.BackgroundTransparency = 1
	scrollerFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollerFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollerFrame.Parent = scrollerSizer

	local frame2 = Instance.new("Frame")
	frame2.Selectable = false
	frame2.Size = UDim2.new(1, 0, 1, 0)
	frame2.Position = UDim2.new(0, 0, 0, 0)
	frame2.ClipsDescendants = true
	frame2.BackgroundTransparency = 1
	frame2.Parent = frame

	local leaveConfirmationFrame = Instance.new("Frame")
	leaveConfirmationFrame.Selectable = false
	leaveConfirmationFrame.Name = "LeaveConfirmationFrame"
	leaveConfirmationFrame.Size = UDim2.new(1, 0, 1, 0)
	leaveConfirmationFrame.Position = UDim2.new(0, 0, 1, 0)
	leaveConfirmationFrame.BackgroundTransparency = 0.6
	leaveConfirmationFrame.BorderSizePixel = 0
	leaveConfirmationFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	leaveConfirmationFrame.Parent = frame2

	local textButton = Instance.new("TextButton")
	textButton.Selectable = false
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.BackgroundTransparency = 1
	textButton.Text = ""
	textButton.Parent = leaveConfirmationFrame

	local textButton2 = Instance.new("TextButton")
	textButton2.Selectable = false
	textButton2.Size = UDim2.new(0.25, 0, 1, 0)
	textButton2.BackgroundTransparency = 1
	textButton2.Font = ChatSettings.DefaultFont
	textButton2.TextSize = 18
	textButton2.TextStrokeTransparency = 0.75
	textButton2.Position = UDim2.new(0, 0, 0, 0)
	textButton2.TextColor3 = Color3.new(0, 1, 0)
	textButton2.Text = "Confirm"
	textButton2.Parent = leaveConfirmationFrame

	local clone = textButton2:Clone()
	clone.Parent = leaveConfirmationFrame
	clone.Position = UDim2.new(0.75, 0, 0, 0)
	clone.TextColor3 = Color3.new(1, 0, 0)
	clone.Text = "Cancel"

	local textLabel = Instance.new("TextLabel")
	textLabel.Selectable = false
	textLabel.Size = UDim2.new(0.5, 0, 1, 0)
	textLabel.Position = UDim2.new(0.25, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0.75
	textLabel.Text = "Leave channel <XX>?"
	textLabel.Font = ChatSettings.DefaultFont
	textLabel.TextSize = 18
	textLabel.Parent = leaveConfirmationFrame

	local leaveTarget = Instance.new("StringValue")
	leaveTarget.Name = "LeaveTarget"
	leaveTarget.Parent = leaveConfirmationFrame

	local position = leaveConfirmationFrame.Position
	textButton2.MouseButton1Click:connect(function()
		MessageSender:SendMessage(string.format("/leave %s", leaveTarget.Value), nil)
		leaveConfirmationFrame:TweenPosition(position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)
	clone.MouseButton1Click:connect(function()
		leaveConfirmationFrame:TweenPosition(position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)

	local pageLeftButton = Instance.new("ImageButton", frame)
	pageLeftButton.Selectable = ChatSettings.GamepadNavigationEnabled
	pageLeftButton.Name = "PageLeftButton"
	pageLeftButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	pageLeftButton.Size = UDim2.new(0.7, 0, 0.7, 0)
	pageLeftButton.BackgroundTransparency = 1
	pageLeftButton.Position = UDim2.new(0, 4, 0.15000000000000002, 0)
	pageLeftButton.Visible = false
	pageLeftButton.Image = "rbxassetid://471630199"
	local arrowLabel = Instance.new("ImageLabel", pageLeftButton)
	arrowLabel.Name = "ArrowLabel"
	arrowLabel.BackgroundTransparency = 1
	arrowLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
	arrowLabel.Image = "rbxassetid://471630112"

	local positionalHelper = Instance.new("Frame", frame)
	positionalHelper.Selectable = false
	positionalHelper.BackgroundTransparency = 1
	positionalHelper.Name = "PositionalHelper"
	positionalHelper.Size = pageLeftButton.Size
	positionalHelper.SizeConstraint = pageLeftButton.SizeConstraint
	positionalHelper.Position = UDim2.new(1, 0, 0.15000000000000002, 0)

	local pageRightButton = pageLeftButton:Clone()
	pageRightButton.Parent = positionalHelper
	pageRightButton.Name = "PageRightButton"
	pageRightButton.Size = UDim2.new(1, 0, 1, 0)
	pageRightButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
	pageRightButton.Position = UDim2.new(-1, -4, 0, 0)

	local udim = UDim2.new(0.05, 0, 0, 0)

	pageRightButton.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) + udim
	pageLeftButton.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) - udim
	pageLeftButton.ArrowLabel.Rotation = 180

	self.GuiObject = frame

	self.GuiObjects.BaseFrame = frame
	self.GuiObjects.ScrollerSizer = scrollerSizer
	self.GuiObjects.ScrollerFrame = scrollerFrame
	self.GuiObjects.PageLeftButton = pageLeftButton
	self.GuiObjects.PageRightButton = pageRightButton
	self.GuiObjects.LeaveConfirmationFrame = leaveConfirmationFrame
	self.GuiObjects.LeaveConfirmationNotice = textLabel

	self.GuiObjects.PageLeftButtonArrow = pageLeftButton.ArrowLabel
	self.GuiObjects.PageRightButtonArrow = pageRightButton.ArrowLabel
	self:AnimGuiObjects()

	pageLeftButton.MouseButton1Click:connect(function()
		self:ScrollChannelsFrame(-1)
	end)
	pageRightButton.MouseButton1Click:connect(function()
		self:ScrollChannelsFrame(1)
	end)

	self:ScrollChannelsFrame(0)
end

function class:UpdateMessagePostedInChannel(p)
	local channelTab = self:GetChannelTab(p)

	if channelTab then
		channelTab:UpdateMessagePostedInChannel()
	else
		warn("ChannelsTab '" .. p .. "' does not exist!")
	end
end

function class:AddChannelTab(value)
	if self:GetChannelTab(value) then
		error("Channel tab '" .. value .. "'already exists!")
	end

	local v = ChannelsTab.new(value)
	v.GuiObject.Parent = self.GuiObjects.ScrollerFrame
	self.ChannelTabs[value:lower()] = v

	self.NumTabs += 1
	self:OrganizeChannelTabs()

	if ChatSettings.RightClickToLeaveChannelEnabled then
		v.NameTag.MouseButton2Click:connect(function()
			self.LeaveConfirmationNotice.Text = string.format("Leave channel %s?", v.ChannelName)
			self.LeaveConfirmationFrame.LeaveTarget.Value = v.ChannelName
			self.LeaveConfirmationFrame:TweenPosition(
				UDim2.new(0, 0, 0, 0),
				Enum.EasingDirection.In,
				Enum.EasingStyle.Quad,
				0.2,
				true
			)
		end)
	end

	return v
end

function class:RemoveChannelTab(value)
	if not self:GetChannelTab(value) then
		error("Channel tab '" .. value .. "'does not exist!")
	end

	local lower = value:lower()
	self.ChannelTabs[lower]:Destroy()
	self.ChannelTabs[lower] = nil

	self.NumTabs -= 1
	self:OrganizeChannelTabs()
end

function class:GetChannelTab(value)
	return self.ChannelTabs[value:lower()]
end

function class:OrganizeChannelTabs()
	local channelTabs = {}

	table.insert(channelTabs, self:GetChannelTab(ChatSettings.GeneralChannelName))
	table.insert(channelTabs, self:GetChannelTab("System"))

	for _, channelTab in pairs(self.ChannelTabs) do
		if channelTab.ChannelName ~= ChatSettings.GeneralChannelName and channelTab.ChannelName ~= "System" then
			table.insert(channelTabs, channelTab)
		end
	end

	for k, v in pairs(channelTabs) do
		v.GuiObject.Position = UDim2.new(k - 1, 0, 0, 0)
	end

	self.GuiObjects.ScrollerSizer.Size = UDim2.new(
		1 / math.max(1, (math.min(ChatSettings.ChannelsBarFullTabSize, self.NumTabs))),
		0,
		1,
		0
	)

	self:ScrollChannelsFrame(0)
end

function class:ResizeChannelTabText(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:SetTextSize(p)
	end
end

function class:ScrollChannelsFrame(p)
	if self.ScrollChannelsFrameLock then
		return
	end

	self.ScrollChannelsFrameLock = true

	local channelsBarFullTabSize = ChatSettings.ChannelsBarFullTabSize

	local curPageNum = self.CurPageNum + p

	if curPageNum < 0 then
		curPageNum = 0
	elseif curPageNum > 0 and curPageNum + channelsBarFullTabSize > self.NumTabs then
		curPageNum = self.NumTabs - channelsBarFullTabSize
	end

	self.CurPageNum = curPageNum

	local udim = UDim2.new(-self.CurPageNum, 0, 0, 0)

	self.GuiObjects.PageLeftButton.Visible = self.CurPageNum > 0
	self.GuiObjects.PageRightButton.Visible = self.CurPageNum + channelsBarFullTabSize < self.NumTabs

	if p == 0 then
		self.ScrollChannelsFrameLock = false
		return
	end

	local function UnlockFunc()
		self.ScrollChannelsFrameLock = false
	end

	self:WaitUntilParentedCorrectly()

	self.GuiObjects.ScrollerFrame:TweenPosition(
		udim,
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quad,
		0.15,
		true,
		UnlockFunc
	)
end

function class:FadeOutBackground(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:FadeOutBackground(p)
	end

	self.AnimParams.Background_TargetTransparency = 1
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:FadeInBackground(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:FadeInBackground(p)
	end

	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:FadeOutText(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:FadeOutText(p)
	end
end

function class:FadeInText(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:FadeInText(p)
	end
end

function class:AnimGuiObjects()
	self.GuiObjects.PageLeftButton.ImageTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.PageRightButton.ImageTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.PageLeftButtonArrow.ImageTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.PageRightButtonArrow.ImageTransparency = self.AnimParams.Background_CurrentTransparency
end

function class:InitializeAnimParams()
	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_CurrentTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end

function class:Update(p)
	for _, channelTab in pairs(self.ChannelTabs) do
		channelTab:Update(p)
	end

	self.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Background_CurrentTransparency,
		self.AnimParams.Background_TargetTransparency,
		self.AnimParams.Background_NormalizedExptValue,
		p
	)

	self:AnimGuiObjects()
end

function class:WaitUntilParentedCorrectly()
	while true do
		local guiObject = self.GuiObject
		local Players = game:GetService("Players")

		if guiObject:IsDescendantOf(Players.LocalPlayer) then
			break
		end

		self.GuiObject.AncestryChanged:wait()
	end
end

function ChannelsBar.new()
	local object = setmetatable({}, class)

	object.GuiObject = nil
	object.GuiObjects = {}

	object.ChannelTabs = {}
	object.NumTabs = 0
	object.CurPageNum = 0

	object.ScrollChannelsFrameLock = false

	object.AnimParams = {}

	object:InitializeAnimParams()

	ChatSettings.SettingsChanged:connect(function(p, p2)
		if p == "ChatChannelsTabTextSize" then
			object:ResizeChannelTabText(p2)
		end
	end)

	return object
end

return ChannelsBar
