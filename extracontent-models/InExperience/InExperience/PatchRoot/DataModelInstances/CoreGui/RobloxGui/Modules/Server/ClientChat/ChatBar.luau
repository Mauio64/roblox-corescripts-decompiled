local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local ChatBar = {}

while not LocalPlayer do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(parent:WaitForChild("CurveUtil"))

local CommandModules = ClientChatModules:WaitForChild("CommandModules")
local Whisper = require(CommandModules:WaitForChild("Whisper"))

require(parent:WaitForChild("MessageSender"))

local v = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {}
	function v:Get(_, p)
		return p
	end
end

local class = {}
class.__index = class

function class:CreateGuiObjects(p)
	self.ChatBarParentFrame = p

	local frame = Instance.new("Frame")
	frame.Selectable = false
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0.6
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = ChatSettings.ChatBarBackGroundColor
	frame.Parent = p

	local boxFrame = Instance.new("Frame")
	boxFrame.Selectable = false
	boxFrame.Name = "BoxFrame"
	boxFrame.BackgroundTransparency = 0.6
	boxFrame.BorderSizePixel = 0
	boxFrame.BackgroundColor3 = ChatSettings.ChatBarBoxColor
	boxFrame.Size = UDim2.new(1, -14, 1, -14)
	boxFrame.Position = UDim2.new(0, 7, 0, 7)
	boxFrame.Parent = frame

	local frame2 = Instance.new("Frame")
	frame2.BackgroundTransparency = 1
	frame2.Size = UDim2.new(1, -10, 1, -10)
	frame2.Position = UDim2.new(0, 5, 0, 5)
	frame2.Parent = boxFrame

	local chatBar = Instance.new("TextBox")
	chatBar.Selectable = ChatSettings.GamepadNavigationEnabled
	chatBar.Name = "ChatBar"
	chatBar.BackgroundTransparency = 1
	chatBar.Size = UDim2.new(1, 0, 1, 0)
	chatBar.Position = UDim2.new(0, 0, 0, 0)
	chatBar.TextSize = ChatSettings.ChatBarTextSize
	chatBar.Font = ChatSettings.ChatBarFont
	chatBar.TextColor3 = ChatSettings.ChatBarTextColor
	chatBar.TextTransparency = 0.4
	chatBar.TextStrokeTransparency = 1
	chatBar.ClearTextOnFocus = false
	chatBar.TextXAlignment = Enum.TextXAlignment.Left
	chatBar.TextYAlignment = Enum.TextYAlignment.Top
	chatBar.TextWrapped = true
	chatBar.Text = ""
	chatBar.Parent = frame2

	local messageMode = Instance.new("TextButton")
	messageMode.Selectable = false
	messageMode.Name = "MessageMode"
	messageMode.BackgroundTransparency = 1
	messageMode.Position = UDim2.new(0, 0, 0, 0)
	messageMode.TextSize = ChatSettings.ChatBarTextSize
	messageMode.Font = ChatSettings.ChatBarFont
	messageMode.TextXAlignment = Enum.TextXAlignment.Left
	messageMode.TextWrapped = true
	messageMode.Text = ""
	messageMode.Size = UDim2.new(0, 0, 0, 0)
	messageMode.TextYAlignment = Enum.TextYAlignment.Center
	messageMode.TextColor3 = self:GetDefaultChannelNameColor()
	messageMode.Visible = true
	messageMode.Parent = frame2

	local textLabel = Instance.new("TextLabel")
	textLabel.Selectable = false
	textLabel.TextWrapped = true
	textLabel.BackgroundTransparency = 1
	textLabel.Size = chatBar.Size
	textLabel.Position = chatBar.Position
	textLabel.TextSize = chatBar.TextSize
	textLabel.Font = chatBar.Font
	textLabel.TextColor3 = chatBar.TextColor3
	textLabel.TextTransparency = chatBar.TextTransparency
	textLabel.TextStrokeTransparency = chatBar.TextStrokeTransparency
	textLabel.TextXAlignment = chatBar.TextXAlignment
	textLabel.TextYAlignment = chatBar.TextYAlignment
	textLabel.Text = "..."
	textLabel.Parent = frame2

	self.GuiObject = frame
	self.TextBox = chatBar
	self.TextLabel = textLabel

	self.GuiObjects.BaseFrame = frame
	self.GuiObjects.TextBoxFrame = boxFrame
	self.GuiObjects.TextBox = chatBar
	self.GuiObjects.TextLabel = textLabel
	self.GuiObjects.MessageModeTextButton = messageMode

	self:AnimGuiObjects()
	self:SetUpTextBoxEvents(chatBar, textLabel, messageMode)

	if self.UserHasChatOff then
		self:DoLockChatBar()
	end

	self.eGuiObjectsChanged:Fire()
end

function class:DoLockChatBar()
	if self.TextLabel then
		if LocalPlayer.UserId > 0 then
			self.TextLabel.Text = v:Get(
				"GameChat_ChatMessageValidator_SettingsError",
				"To chat in game, turn on chat in your Privacy Settings."
			)
		else
			self.TextLabel.Text = v:Get("GameChat_SwallowGuestChat_Message", "Sign up to chat in game.")
		end

		self:CalculateSize()
	end

	if self.TextBox then
		self.TextBox.Active = false
		self.TextBox.Focused:connect(function()
			self.TextBox:ReleaseFocus()
		end)
	end
end

function class:SetUpTextBoxEvents(state, p, p2)
	for k, textBoxConnection in pairs(self.TextBoxConnections) do
		textBoxConnection:disconnect()
		self.TextBoxConnections[k] = nil
	end

	self.TextBoxConnections.UserInputBegan = UserInputService.InputBegan:connect(function(p3, _)
		if p3.KeyCode == Enum.KeyCode.Backspace and self:IsFocused() and state.Text == "" then
			self:SetChannelTarget(ChatSettings.GeneralChannelName)
		end
	end)

	self.TextBoxConnections.TextBoxChanged = state.Changed:connect(function(p3)
		if p3 == "AbsoluteSize" then
			self:CalculateSize()
			return
		end

		if p3 ~= "Text" then
			return
		end

		self:CalculateSize()

		if utf8.len(utf8.nfcnormalize(state.Text)) > ChatSettings.MaximumMessageLength then
			state.Text = self.PreviousText
		else
			self.PreviousText = state.Text
		end

		if self.InCustomState then
			self.CustomState:TextUpdated()
		else
			local customState = self.CommandProcessor:ProcessInProgressChatMessage(state.Text, self.ChatWindow, self)

			if customState then
				self.InCustomState = true
				self.CustomState = customState
			end
		end
	end)

	local function UpdateOnFocusStatusChanged(p3) -- 2 equivalent calls inferred from this helper
		if p3 or state.Text ~= "" then
			p.Visible = false
		else
			p.Visible = true
		end
	end

	self.TextBoxConnections.MessageModeClick = p2.MouseButton1Click:connect(function()
		if p2.Text ~= "" then
			self:SetChannelTarget(ChatSettings.GeneralChannelName)
		end
	end)

	self.TextBoxConnections.TextBoxFocused = state.Focused:connect(function()
		if not self.UserHasChatOff then
			self:CalculateSize()
			UpdateOnFocusStatusChanged(true) -- inferred equivalent call
		end
	end)

	self.TextBoxConnections.TextBoxFocusLost = state.FocusLost:connect(function(_, p3)
		self:CalculateSize()

		if p3 and p3.KeyCode == Enum.KeyCode.Escape then
			state.Text = ""
		end

		if state.Text == "" then
			p.Visible = true
		else
			UpdateOnFocusStatusChanged(true) -- inferred equivalent call
		end
	end)
end

function class:GetTextBox()
	return self.TextBox
end

function class:GetMessageModeTextButton()
	return self.GuiObjects.MessageModeTextButton
end

function class:GetMessageModeTextLabel()
	return self:GetMessageModeTextButton()
end

function class:IsFocused()
	if self.UserHasChatOff then
		return false
	end

	return self:GetTextBox():IsFocused()
end

function class.GetVisible(p)
	return p.GuiObject.Visible
end

function class:CaptureFocus()
	if not self.UserHasChatOff then
		self:GetTextBox():CaptureFocus()
	end
end

function class:ReleaseFocus(p)
	self:GetTextBox():ReleaseFocus(p)
end

function class:ResetText()
	local textBox = self:GetTextBox()
	textBox.Text = ""
end

function class:SetText(text)
	local textBox = self:GetTextBox()
	textBox.Text = text
end

function class.GetEnabled(p)
	return p.GuiObject.Visible
end

function class.SetEnabled(p, visible)
	if p.UserHasChatOff then
		p.GuiObject.Visible = true
	else
		p.GuiObject.Visible = visible
	end
end

function class:SetTextLabelText(text)
	if not self.UserHasChatOff then
		self.TextLabel.Text = text
	end
end

function class.SetTextBoxText(p, text)
	p.TextBox.Text = text
end

function class.GetTextBoxText(p)
	return p.TextBox.Text
end

function class:ResetSize()
	self.TargetYSize = 0
	self:TweenToTargetYSize()
end

local function measureSize(data) -- 2 equivalent calls inferred from this helper
	return TextService:GetTextSize(data.Text, data.TextSize, data.Font, Vector2.new(data.AbsoluteSize.X, 10000))
end

function class:CalculateSize()
	if self.CalculatingSizeLock then
		return
	end

	self.CalculatingSizeLock = true
	local textSize, y

	if self:IsFocused() or self.TextBox.Text ~= "" then
		textSize = self.TextBox.TextSize
		y = measureSize(self.TextBox).Y -- inferred equivalent call
	else
		textSize = self.TextLabel.TextSize
		y = measureSize(self.TextLabel).Y -- inferred equivalent call
	end

	local targetYSize = y - textSize

	if self.TargetYSize ~= targetYSize then
		self.TargetYSize = targetYSize
		self:TweenToTargetYSize()
	end

	self.CalculatingSizeLock = false
end

function class:TweenToTargetYSize()
	local udim = UDim2.new(1, 0, 1, self.TargetYSize)
	local size = self.GuiObject.Size

	local y = self.GuiObject.AbsoluteSize.Y
	self.GuiObject.Size = udim
	local y2 = self.GuiObject.AbsoluteSize.Y
	self.GuiObject.Size = size

	local v2 = math.min(1, math.abs(y2 - y) * (1 / self.TweenPixelsPerSecond))

	if not pcall(function()
		self.GuiObject:TweenSize(udim, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, v2, true)
	end) then
		self.GuiObject.Size = udim
	end
end

function class:SetTextSize(textSize)
	if not self:IsInCustomState() then
		if self.TextBox then
			self.TextBox.TextSize = textSize
		end

		if self.TextLabel then
			self.TextLabel.TextSize = textSize
		end
	end
end

function class:GetDefaultChannelNameColor()
	if ChatSettings.DefaultChannelNameColor then
		return ChatSettings.DefaultChannelNameColor
	end

	return Color3.fromRGB(35, 76, 142)
end

function class:SetChannelTarget(targetChannel)
	local messageModeTextButton = self.GuiObjects.MessageModeTextButton
	local textBox = self.TextBox
	local textLabel = self.TextLabel

	self.TargetChannel = targetChannel

	if not self:IsInCustomState() then
		if targetChannel == ChatSettings.GeneralChannelName then
			messageModeTextButton.Text = ""
			messageModeTextButton.Size = UDim2.new(0, 0, 0, 0)
			textBox.Size = UDim2.new(1, 0, 1, 0)
			textBox.Position = UDim2.new(0, 0, 0, 0)
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.Position = UDim2.new(0, 0, 0, 0)
		else
			messageModeTextButton.Size = UDim2.new(0, 1000, 1, 0)
			local v2

			if v.tryLocalize then
				v2 = v:tryLocalize(targetChannel)
			else
				v2 = targetChannel
			end

			messageModeTextButton.Text = string.format("[%s] ", v2)

			local channelNameColor = self:GetChannelNameColor(targetChannel)

			if channelNameColor then
				messageModeTextButton.TextColor3 = channelNameColor
			else
				messageModeTextButton.TextColor3 = self:GetDefaultChannelNameColor()
			end

			local x = messageModeTextButton.TextBounds.X
			messageModeTextButton.Size = UDim2.new(0, x, 1, 0)
			textBox.Size = UDim2.new(1, -x, 1, 0)
			textBox.Position = UDim2.new(0, x, 0, 0)
			textLabel.Size = UDim2.new(1, -x, 1, 0)
			textLabel.Position = UDim2.new(0, x, 0, 0)
		end
	end
end

function class:IsInCustomState()
	return self.InCustomState
end

function class:ResetCustomState()
	if self.InCustomState then
		self.CustomState:Destroy()
		self.CustomState = nil
		self.InCustomState = false

		self.ChatBarParentFrame:ClearAllChildren()
		self:CreateGuiObjects(self.ChatBarParentFrame)
		self:SetTextLabelText(v:Get("GameChat_ChatMain_ChatBarText", "To chat click here or press \"/\" key"))
	end
end

function class:EnterWhisperState(p)
	self:ResetCustomState()

	if Whisper.CustomStateCreator then
		self.CustomState = Whisper.CustomStateCreator(p, self.ChatWindow, self, ChatSettings)

		self.InCustomState = true
	else
		local v2

		if ChatSettings.PlayerDisplayNamesEnabled then
			v2 = p.DisplayName
		else
			v2 = p.Name
		end

		self:SetText("/w " .. v2)
	end

	self:CaptureFocus()
end

function class.GetCustomMessage(p)
	if p.InCustomState then
		return p.CustomState:GetMessage()
	end

	return nil
end

function class.CustomStateProcessCompletedMessage(p, _)
	if p.InCustomState then
		return p.CustomState:ProcessCompletedMessage()
	end

	return false
end

function class:FadeOutBackground(p)
	self.AnimParams.Background_TargetTransparency = 1
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
	self:FadeOutText(p)
end

function class:FadeInBackground(p)
	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
	self:FadeInText(p)
end

function class:FadeOutText(p)
	self.AnimParams.Text_TargetTransparency = 1
	self.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:FadeInText(p)
	self.AnimParams.Text_TargetTransparency = 0.4
	self.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p)
end

function class:AnimGuiObjects()
	self.GuiObject.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency
	self.GuiObjects.TextBoxFrame.BackgroundTransparency = self.AnimParams.Background_CurrentTransparency

	self.GuiObjects.TextLabel.TextTransparency = self.AnimParams.Text_CurrentTransparency
	self.GuiObjects.TextBox.TextTransparency = self.AnimParams.Text_CurrentTransparency
	self.GuiObjects.MessageModeTextButton.TextTransparency = self.AnimParams.Text_CurrentTransparency
end

function class:InitializeAnimParams()
	self.AnimParams.Text_TargetTransparency = 0.4
	self.AnimParams.Text_CurrentTransparency = 0.4
	self.AnimParams.Text_NormalizedExptValue = 1

	self.AnimParams.Background_TargetTransparency = 0.6
	self.AnimParams.Background_CurrentTransparency = 0.6
	self.AnimParams.Background_NormalizedExptValue = 1
end

function class:Update(p)
	self.AnimParams.Text_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Text_CurrentTransparency,
		self.AnimParams.Text_TargetTransparency,
		self.AnimParams.Text_NormalizedExptValue,
		p
	)

	self.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(
		self.AnimParams.Background_CurrentTransparency,
		self.AnimParams.Background_TargetTransparency,
		self.AnimParams.Background_NormalizedExptValue,
		p
	)

	self:AnimGuiObjects()
end

function class.SetChannelNameColor(p, p2, textColor)
	p.ChannelNameColors[p2] = textColor

	if p.GuiObjects.MessageModeTextButton.Text == p2 then
		p.GuiObjects.MessageModeTextButton.TextColor3 = textColor
	end
end

function class:GetChannelNameColor(p)
	return self.ChannelNameColors[p]
end

function ChatBar.new(commandProcessor, chatWindow)
	local object = setmetatable({}, class)

	object.GuiObject = nil
	object.ChatBarParentFrame = nil
	object.TextBox = nil
	object.TextLabel = nil
	object.GuiObjects = {}
	object.eGuiObjectsChanged = Instance.new("BindableEvent")
	object.GuiObjectsChanged = object.eGuiObjectsChanged.Event
	object.TextBoxConnections = {}
	object.PreviousText = ""

	object.InCustomState = false
	object.CustomState = nil

	object.TargetChannel = nil
	object.CommandProcessor = commandProcessor
	object.ChatWindow = chatWindow

	object.TweenPixelsPerSecond = 500
	object.TargetYSize = 0

	object.AnimParams = {}
	object.CalculatingSizeLock = false

	object.ChannelNameColors = {}

	object.UserHasChatOff = false

	object:InitializeAnimParams()

	ChatSettings.SettingsChanged:connect(function(p, p2)
		if p == "ChatBarTextSize" then
			object:SetTextSize(p2)
		end
	end)

	coroutine.wrap(function()
		local success, result = pcall(function()
			return Chat:CanUserChatAsync(LocalPlayer.UserId)
		end)

		if (success and (RunService:IsStudio() or result)) == false then
			object.UserHasChatOff = true
			object:DoLockChatBar()
		end
	end)()

	return object
end

return ChatBar
