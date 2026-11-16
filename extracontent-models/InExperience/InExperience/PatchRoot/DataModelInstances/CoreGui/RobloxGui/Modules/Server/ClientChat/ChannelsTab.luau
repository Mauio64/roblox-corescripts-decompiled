local ChannelsTab = {}

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(parent:WaitForChild("CurveUtil"))

local class = {}
class.__index = class

local function CreateGuiObjects()
	local frame = Instance.new("Frame")
	frame.Selectable = false
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1

	local backgroundFrame = Instance.new("Frame")
	backgroundFrame.Selectable = false
	backgroundFrame.Name = "BackgroundFrame"
	backgroundFrame.Size = UDim2.new(1, -2, 1, -2)
	backgroundFrame.Position = UDim2.new(0, 1, 0, 1)
	backgroundFrame.BackgroundTransparency = 1
	backgroundFrame.Parent = frame

	local unselectedFrame = Instance.new("Frame")
	unselectedFrame.Selectable = false
	unselectedFrame.Name = "UnselectedFrame"
	unselectedFrame.Size = UDim2.new(1, 0, 1, 0)
	unselectedFrame.Position = UDim2.new(0, 0, 0, 0)
	unselectedFrame.BorderSizePixel = 0
	unselectedFrame.BackgroundColor3 = ChatSettings.ChannelsTabUnselectedColor
	unselectedFrame.BackgroundTransparency = 0.6
	unselectedFrame.Parent = backgroundFrame

	local selectedFrame = Instance.new("Frame")
	selectedFrame.Selectable = false
	selectedFrame.Name = "SelectedFrame"
	selectedFrame.Size = UDim2.new(1, 0, 1, 0)
	selectedFrame.Position = UDim2.new(0, 0, 0, 0)
	selectedFrame.BorderSizePixel = 0
	selectedFrame.BackgroundColor3 = ChatSettings.ChannelsTabSelectedColor
	selectedFrame.BackgroundTransparency = 1
	selectedFrame.Parent = backgroundFrame

	local backgroundImage = Instance.new("ImageLabel")
	backgroundImage.Selectable = false
	backgroundImage.Name = "BackgroundImage"
	backgroundImage.BackgroundTransparency = 1
	backgroundImage.BorderSizePixel = 0
	backgroundImage.Size = UDim2.new(1, 0, 1, 0)
	backgroundImage.Position = UDim2.new(0, 0, 0, 0)
	backgroundImage.ScaleType = Enum.ScaleType.Slice
	backgroundImage.Parent = selectedFrame

	backgroundImage.BackgroundTransparency = -0.4

	backgroundImage.BackgroundColor3 = Color3.fromRGB(93.6, 100.8, 115.19999999999999)

	local blueBarLeft = Instance.new("ImageLabel")
	blueBarLeft.Selectable = false
	blueBarLeft.Size = UDim2.new(0.5, -2, 0, 4)
	blueBarLeft.BackgroundTransparency = 1
	blueBarLeft.ScaleType = Enum.ScaleType.Slice
	blueBarLeft.SliceCenter = Rect.new(3, 3, 32, 21)
	blueBarLeft.Parent = selectedFrame

	local blueBarRight = blueBarLeft:Clone()
	blueBarRight.Parent = selectedFrame

	blueBarLeft.Position = UDim2.new(0, 2, 1, -4)
	blueBarRight.Position = UDim2.new(0.5, 0, 1, -4)
	blueBarLeft.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png"
	blueBarRight.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png"

	blueBarLeft.Name = "BlueBarLeft"
	blueBarRight.Name = "BlueBarRight"

	local textButton = Instance.new("TextButton")
	textButton.Selectable = ChatSettings.GamepadNavigationEnabled
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.Position = UDim2.new(0, 0, 0, 0)
	textButton.BackgroundTransparency = 1
	textButton.Font = ChatSettings.DefaultFont
	textButton.TextSize = ChatSettings.ChatChannelsTabTextSize
	textButton.TextColor3 = Color3.new(1, 1, 1)
	textButton.TextStrokeTransparency = 0.75
	textButton.Parent = backgroundFrame

	local clone = textButton:Clone()
	local clone2 = textButton:Clone()
	clone.Parent = unselectedFrame
	clone2.Parent = selectedFrame
	clone.Font = Enum.Font.SourceSans
	clone.Active = false
	clone2.Active = false

	local frame2 = Instance.new("Frame")
	frame2.Selectable = false
	frame2.Size = UDim2.new(0, 18, 0, 18)
	frame2.Position = UDim2.new(0.8, -9, 0.5, -9)
	frame2.BackgroundTransparency = 1
	frame2.Parent = backgroundFrame

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Selectable = false
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxasset://textures/ui/Chat/MessageCounter.png"
	imageLabel.Visible = false
	imageLabel.Parent = frame2

	local textLabel = Instance.new("TextLabel")
	textLabel.Selectable = false
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(0, 13, 0, 9)
	textLabel.Position = UDim2.new(0.5, -7, 0.5, -7)
	textLabel.Font = ChatSettings.DefaultFont
	textLabel.TextSize = 14
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = ""
	textLabel.Parent = imageLabel

	return frame, textButton, clone, clone2, imageLabel, unselectedFrame, selectedFrame
end

function class:Destroy()
	self.GuiObject:Destroy()
end

function class:UpdateMessagePostedInChannel(p)
	if self.Active and p ~= true then
		return
	end

	local unreadMessageCount = self.UnreadMessageCount + 1
	self.UnreadMessageCount = unreadMessageCount

	local newMessageIcon = self.NewMessageIcon
	newMessageIcon.Visible = true
	newMessageIcon.TextLabel.Text = unreadMessageCount < 100 and tostring(unreadMessageCount) or "!"

	local udim = UDim2.new(0, 0, -0.1, 0)

	local _ = newMessageIcon.Position + udim
	local out = Enum.EasingDirection.Out
	local quad = Enum.EasingStyle.Quad

	newMessageIcon.Position = UDim2.new(0, 0, -0.15, 0)
	newMessageIcon:TweenPosition(UDim2.new(0, 0, 0, 0), out, quad, 0.15, true)
end

function class:SetActive(p)
	self.Active = p
	self.UnselectedFrame.Visible = not p
	self.SelectedFrame.Visible = p

	if not p then
		self.NameTag.Font = Enum.Font.SourceSans

		return
	end

	self.UnreadMessageCount = 0
	self.NewMessageIcon.Visible = false

	self.NameTag.Font = Enum.Font.SourceSansBold
end

function class.SetTextSize(p, textSize)
	p.NameTag.TextSize = textSize
end

function class.FadeOutBackground(p, p2)
	p.AnimParams.Background_TargetTransparency = 1
	p.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
end

function class.FadeInBackground(p, p2)
	p.AnimParams.Background_TargetTransparency = 0.6
	p.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
end

function class.FadeOutText(p, p2)
	p.AnimParams.Text_TargetTransparency = 1
	p.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
	p.AnimParams.TextStroke_TargetTransparency = 1
	p.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
end

function class.FadeInText(p, p2)
	p.AnimParams.Text_TargetTransparency = 0
	p.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
	p.AnimParams.TextStroke_TargetTransparency = 0.75
	p.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p2)
end

function class:AnimGuiObjects()
	self.UnselectedFrame.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency
	self.SelectedFrame.BackgroundImage.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency
	self.SelectedFrame.BlueBarLeft.ImageTransparency = self.AnimParams.Background_CurrentTransparency
	self.SelectedFrame.BlueBarRight.ImageTransparency = self.AnimParams.Background_CurrentTransparency
	self.NameTagNonSelect.TextTransparency = self.AnimParams.Background_CurrentTransparency
	self.NameTagNonSelect.TextStrokeTransparency = self.AnimParams.Background_CurrentTransparency

	self.NameTag.TextTransparency = self.AnimParams.Text_CurrentTransparency
	self.NewMessageIcon.ImageTransparency = self.AnimParams.Text_CurrentTransparency
	self.WhiteTextNewMessageNotification.TextTransparency = self.AnimParams.Text_CurrentTransparency
	self.NameTagSelect.TextTransparency = self.AnimParams.Text_CurrentTransparency

	self.NameTag.TextStrokeTransparency = self.AnimParams.TextStroke_CurrentTransparency
	self.WhiteTextNewMessageNotification.TextStrokeTransparency = self.AnimParams.TextStroke_CurrentTransparency
	self.NameTagSelect.TextStrokeTransparency = self.AnimParams.TextStroke_CurrentTransparency
end

function class:InitializeAnimParams()
	self.AnimParams.Text_TargetTransparency = 0
	self.AnimParams.Text_CurrentTransparency = 0
	self.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)

	self.AnimParams.TextStroke_TargetTransparency = 0.75
	self.AnimParams.TextStroke_CurrentTransparency = 0.75
	self.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)

	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_CurrentTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end

function class:Update(p)
	self.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Background_CurrentTransparency,
		self.AnimParams.Background_TargetTransparency,
		self.AnimParams.Background_NormalizedExptValue,
		p
	)

	self.AnimParams.Text_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Text_CurrentTransparency,
		self.AnimParams.Text_TargetTransparency,
		self.AnimParams.Text_NormalizedExptValue,
		p
	)

	self.AnimParams.TextStroke_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.TextStroke_CurrentTransparency,
		self.AnimParams.TextStroke_TargetTransparency,
		self.AnimParams.TextStroke_NormalizedExptValue,
		p
	)

	self:AnimGuiObjects()
end

function ChannelsTab.new(value)
	local self = setmetatable({}, class)

	local guiObject, nameTag, nameTagNonSelect, nameTagSelect, newMessageIcon, unselectedFrame, selectedFrame = CreateGuiObjects()
	self.GuiObject = guiObject
	self.NameTag = nameTag
	self.NameTagNonSelect = nameTagNonSelect
	self.NameTagSelect = nameTagSelect
	self.NewMessageIcon = newMessageIcon
	self.UnselectedFrame = unselectedFrame
	self.SelectedFrame = selectedFrame

	self.BlueBarLeft = selectedFrame.BlueBarLeft
	self.BlueBarRight = selectedFrame.BlueBarRight
	self.BackgroundImage = selectedFrame.BackgroundImage
	self.WhiteTextNewMessageNotification = self.NewMessageIcon.TextLabel

	self.ChannelName = value
	self.UnreadMessageCount = 0
	self.Active = false

	self.GuiObject.Name = "Frame_" .. self.ChannelName

	if string.len(value) > ChatSettings.MaxChannelNameLength then
		value = string.sub(value, 1, ChatSettings.MaxChannelNameLength - 3) .. "..."
	end

	self.NameTag.Text = ""
	self.NameTagNonSelect.Text = value
	self.NameTagSelect.Text = value

	self.AnimParams = {}

	self:InitializeAnimParams()
	self:AnimGuiObjects()
	self:SetActive(false)

	return self
end

return ChannelsTab
