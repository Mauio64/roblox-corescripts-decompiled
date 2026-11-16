local ChatMain = {}
ChatMain.Visible = nil
ChatMain.IsCoreGuiEnabled = nil
ChatMain.TopbarEnabled = nil
ChatMain.VisibilityStateChanged = nil
local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserHandleFriendJoinNotifierOnClient")
end)

if not success then
	result = false
end

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v = success2 and result2

local success3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserAddBetterConsoleCheckForLegacyChat")
end)

game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chat = game:GetService("Chat")
local StarterGui = game:GetService("StarterGui")
game:GetService("ContextActionService")

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local defaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local MessageCreatorModules = ClientChatModules:WaitForChild("MessageCreatorModules")
local Util = require(MessageCreatorModules:WaitForChild("Util"))

local v2 = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v2 = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v2 == nil then
	v2 = {}
	function v2:Get(_, p)
		return p
	end
end

local v3

if v then
	v3 = script:FindFirstChild("ChatTranslationEnabled")

	if v3 == nil then
		local childAddedConnection = nil
		childAddedConnection = script.ChildAdded:Connect(function(child)
			if child.Name == "ChatTranslationEnabled" then
				v3 = child

				childAddedConnection:Disconnect()
			end
		end)
	end
else
	v3 = nil
end

local v4 = 10
local v5 = {
	OnNewMessage = "RemoteEvent",
	OnMessageDoneFiltering = "RemoteEvent",
	OnNewSystemMessage = "RemoteEvent",
	OnChannelJoined = "RemoteEvent",
	OnChannelLeft = "RemoteEvent",
	OnMuted = "RemoteEvent",
	OnUnmuted = "RemoteEvent",
	OnMainChannelSet = "RemoteEvent",
	SayMessageRequest = "RemoteEvent",
	GetInitDataRequest = "RemoteFunction"
}

local instancesByName = {}

local bindableEvent = Instance.new("BindableEvent")

function TryRemoveChildWithVerifyingIsCorrectType(instance)
	if v5[instance.Name] and instance:IsA(v5[instance.Name]) then
		v5[instance.Name] = nil
		instancesByName[instance.Name] = instance
		v4 -= 1
	end
end

for _, child in pairs(defaultChatSystemChatEvents:GetChildren()) do
	TryRemoveChildWithVerifyingIsCorrectType(child)
end

if v4 > 0 then
	local childAddedConnection = defaultChatSystemChatEvents.ChildAdded:connect(function(p)
		TryRemoveChildWithVerifyingIsCorrectType(p)

		if v4 < 1 then
			bindableEvent:Fire()
		end
	end)

	bindableEvent.Event:wait()
	childAddedConnection:disconnect()

	bindableEvent:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v6 = true

local displayOrder = ChatSettings.ScreenGuiDisplayOrder == nil and 6 or ChatSettings.ScreenGuiDisplayOrder

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local chat = Instance.new("ScreenGui")
chat.Name = "Chat"
chat.ResetOnSpawn = false
chat.DisplayOrder = displayOrder
chat.Parent = PlayerGui

if success3 and result3 then
	local GuiService = game:GetService("GuiService")

	if GuiService:IsTenFootInterface() then
		chat.Enabled = false
	end
end

local v7 = false

local script = script

local ChatWindow = require(script:WaitForChild("ChatWindow"))
local ChatBar = require(script:WaitForChild("ChatBar"))
local ChannelsBar = require(script:WaitForChild("ChannelsBar"))
require(script:WaitForChild("MessageLabelCreator"))
local MessageLogDisplay = require(script:WaitForChild("MessageLogDisplay"))
require(script:WaitForChild("ChatChannel"))
local CommandProcessor = require(script:WaitForChild("CommandProcessor"))

local v8 = ChatWindow.new()
local v9 = ChannelsBar.new()
local v10 = MessageLogDisplay.new()
local v11 = CommandProcessor.new()
local v12 = ChatBar.new(v11, v8)

v8:CreateGuiObjects(chat)

v8:RegisterChatBar(v12)
v8:RegisterChannelsBar(v9)
v8:RegisterMessageLogDisplay(v10)

Util:RegisterChatWindow(v8)

local MessageSender = require(script:WaitForChild("MessageSender"))
MessageSender:RegisterSayMessageFunction(instancesByName.SayMessageRequest)

if UserInputService.TouchEnabled then
	v12:SetTextLabelText(v2:Get("GameChat_ChatMain_ChatBarTextTouch", "Tap here to chat"))
else
	v12:SetTextLabelText(v2:Get("GameChat_ChatMain_ChatBarText", "To chat click here or press \"/\" key"))
end

spawn(function()
	local CurveUtil = require(script:WaitForChild("CurveUtil"))
	local v13 = 1 / (ChatSettings.ChatAnimationFPS or 20)
	local v14 = tick()

	while true do
		local now = tick()
		local deltaTimeToTimescale = CurveUtil:DeltaTimeToTimescale(now - v14)

		if deltaTimeToTimescale ~= 0 then
			v8:Update(deltaTimeToTimescale)
		end

		wait(v13)
		v14 = now
	end
end)

function CheckIfPointIsInSquare(p, p2, p3): boolean
	return p2.X <= p.X and p.X <= p3.X and p2.Y <= p.Y and p.Y <= p3.Y
end

local flag = false
local flag2 = false
local lastTime = 0
local lastTime2 = 0

local bindableEvent2 = Instance.new("BindableEvent")
local bindableEvent3 = Instance.new("BindableEvent")
local bindableEvent4 = Instance.new("BindableEvent")

function DoBackgroundFadeIn(p)
	lastTime2 = tick()
	flag = false
	bindableEvent2:Fire()
	v8:FadeInBackground(p or ChatSettings.ChatDefaultFadeDuration)

	if v8:GetCurrentChannel() then
		local scroller = v10.Scroller
		scroller.ScrollingEnabled = true
		scroller.ScrollBarThickness = MessageLogDisplay.ScrollBarThickness
	end
end

function DoBackgroundFadeOut(p)
	lastTime2 = tick()
	flag = true
	bindableEvent2:Fire()
	v8:FadeOutBackground(p or ChatSettings.ChatDefaultFadeDuration)

	if v8:GetCurrentChannel() then
		local scroller = v10.Scroller
		scroller.ScrollingEnabled = false
		scroller.ScrollBarThickness = 0
	end
end

function DoTextFadeIn(p)
	lastTime = tick()
	flag2 = false
	bindableEvent2:Fire()
	v8:FadeInText((p or ChatSettings.ChatDefaultFadeDuration) * 0)
end

function DoTextFadeOut(p)
	lastTime = tick()
	flag2 = true
	bindableEvent2:Fire()
	v8:FadeOutText(p or ChatSettings.ChatDefaultFadeDuration)
end

function DoFadeInFromNewInformation()
	DoTextFadeIn()

	if ChatSettings.ChatShouldFadeInFromNewInformation then
		DoBackgroundFadeIn()
	end
end

function InstantFadeIn()
	DoBackgroundFadeIn(0)
	DoTextFadeIn(0)
end

function InstantFadeOut()
	DoBackgroundFadeOut(0)
	DoTextFadeOut(0)
end

local v13 = nil
function UpdateFadingForMouseState(p)
	v13 = p

	bindableEvent3:Fire()

	if v12:IsFocused() then
		return
	end

	if not p then
		DoBackgroundFadeIn()

		return
	end

	DoBackgroundFadeIn()
	DoTextFadeIn()
end

spawn(function()
	while true do
		RunService.RenderStepped:wait()

		while v13 or v12:IsFocused() do
			if v13 then
				bindableEvent3.Event:wait()
			end

			if v12:IsFocused() then
				bindableEvent4.Event:wait()
			end
		end

		if flag then
			if flag2 then
				bindableEvent2.Event:wait()
			elseif tick() - lastTime > ChatSettings.ChatWindowTextFadeOutTime then
				DoTextFadeOut()
			end
		elseif tick() - lastTime2 > ChatSettings.ChatWindowBackgroundFadeOutTime then
			DoBackgroundFadeOut()
		end
	end
end)

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

function UpdateMousePosition(p)
	if
		not (ChatMain.Visible and ChatMain.IsCoreGuiEnabled and (ChatMain.TopbarEnabled or ChatSettings.ChatOnWithTopBarOff))
		or bubbleChatOnly()
	then
		return
	end

	local absolutePosition = v8.GuiObject.AbsolutePosition
	local absoluteSize = v8.GuiObject.AbsoluteSize

	local v14 = CheckIfPointIsInSquare(p, absolutePosition, absolutePosition + absoluteSize)

	if v14 ~= v13 then
		UpdateFadingForMouseState(v14)
	end
end

UserInputService.InputChanged:connect(function(p, _)
	if p.UserInputType == Enum.UserInputType.MouseMovement then
		local vector2 = Vector2.new(p.Position.X, p.Position.Y)
		UpdateMousePosition(vector2)
	end
end)

UserInputService.TouchTap:connect(function(list, _)
	UpdateMousePosition(list[1])
end)

UserInputService.TouchMoved:connect(function(p, _)
	local vector2 = Vector2.new(p.Position.X, p.Position.Y)
	UpdateMousePosition(vector2)
end)

UserInputService.Changed:connect(function(p)
	if p == "MouseBehavior" and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		local absolutePosition = v8.GuiObject.AbsolutePosition
		local absoluteSize = v8.GuiObject.AbsoluteSize
		local absoluteSize2 = chat.AbsoluteSize

		if CheckIfPointIsInSquare(absoluteSize2 / 2, absolutePosition, absolutePosition + absoluteSize) then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
end)

UpdateFadingForMouseState(true)
UpdateFadingForMouseState(false)

local v14 = {
	Signal = function()
		local bindableEvent5 = Instance.new("BindableEvent")

		local v14 = nil
		local v15 = nil
		return {
			fire = function(self, ...)
				v14 = { ... }
				v15 = select("#", ...)
				bindableEvent5:Fire()
			end,
			connect = function(self, callback)
				if not callback then
					error("connect(nil)", 2)
				end

				return bindableEvent5.Event:connect(function()
					callback(unpack(v14, 1, v15))
				end)
			end,
			wait = function(self)
				bindableEvent5.Event:wait()
				assert(v14, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
				return unpack(v14, 1, v15)
			end
		}
	end
}

function SetVisibility(visible)
	v8:SetVisible(visible)
	ChatMain.VisibilityStateChanged:fire(visible)
	ChatMain.Visible = visible

	if ChatMain.IsCoreGuiEnabled then
		if visible then
			InstantFadeIn()
		else
			InstantFadeOut()
		end
	end
end

local DoChatBarFocus

ChatMain.TopbarEnabled = true
ChatMain.MessageCount = 0
ChatMain.Visible = true
ChatMain.IsCoreGuiEnabled = true

function ChatMain.ToggleVisibility(_)
	SetVisibility(not v8:GetVisible())
end

function ChatMain:SetVisible(p)
	if v8:GetVisible() ~= p then
		SetVisibility(p)
	end
end

function ChatMain.FocusChatBar(_)
	v12:CaptureFocus()
end

function ChatMain:EnterWhisperState(p)
	v12:EnterWhisperState(p)
end

function ChatMain.GetVisibility(_)
	return v8:GetVisible()
end

function ChatMain.GetMessageCount(p)
	return p.MessageCount
end

function ChatMain:TopbarEnabledChanged(topbarEnabled)
	self.TopbarEnabled = topbarEnabled
	local coreGuiEnabled = self.CoreGuiEnabled
	local StarterGui2 = game:GetService("StarterGui")
	coreGuiEnabled:fire(StarterGui2:GetCoreGuiEnabled(Enum.CoreGuiType.Chat))
end

function ChatMain:IsFocused(_)
	return v12:IsFocused()
end

ChatMain.ChatBarFocusChanged = v14.Signal()
ChatMain.VisibilityStateChanged = v14.Signal()
ChatMain.MessagesChanged = v14.Signal()

ChatMain.MessagePosted = v14.Signal()
ChatMain.CoreGuiEnabled = v14.Signal()

ChatMain.ChatMakeSystemMessageEvent = v14.Signal()
ChatMain.ChatWindowPositionEvent = v14.Signal()
ChatMain.ChatWindowSizeEvent = v14.Signal()
ChatMain.ChatBarDisabledEvent = v14.Signal()

function ChatMain.fChatWindowPosition(_)
	return v8.GuiObject.Position
end

function ChatMain.fChatWindowSize(_)
	return v8.GuiObject.Size
end

function ChatMain.fChatBarDisabled(_): boolean
	return not v12:GetEnabled()
end

function ChatMain.SpecialKeyPressed(_, p, _)
	if p == Enum.SpecialKey.ChatHotkey and v6 then
		DoChatBarFocus()
	end
end

ChatMain.CoreGuiEnabled:connect(function(isCoreGuiEnabled)
	ChatMain.IsCoreGuiEnabled = isCoreGuiEnabled

	local topbarEnabled = isCoreGuiEnabled and (ChatMain.TopbarEnabled or ChatSettings.ChatOnWithTopBarOff)

	v8:SetCoreGuiEnabled(topbarEnabled)

	if topbarEnabled then
		InstantFadeIn()

		return
	end

	v12:ReleaseFocus()
	InstantFadeOut()
end)

function trimTrailingSpaces(value)
	local count = #value

	while count > 0 and value:find("^%s", count) do
		count -= 1
	end

	return value:sub(1, count)
end

ChatMain.ChatMakeSystemMessageEvent:connect(function(extraData)
	if extraData.Text and type(extraData.Text) == "string" then
		while not v7 do
			wait()
		end

		local generalChannelName = ChatSettings.GeneralChannelName
		local channel = v8:GetChannel(generalChannelName)

		if channel then
			channel:AddMessageToChannel({
				ID = -1,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				OriginalChannel = generalChannelName,
				IsFiltered = true,
				MessageLength = string.len(extraData.Text),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(extraData.Text)),
				Message = trimTrailingSpaces(extraData.Text),
				MessageType = ChatConstants.MessageTypeSetCore,
				Time = os.time(),
				ExtraData = extraData
			})
			v9:UpdateMessagePostedInChannel(generalChannelName)

			ChatMain.MessageCount += 1
			ChatMain.MessagesChanged:fire(ChatMain.MessageCount)
		end
	end
end)

ChatMain.ChatBarDisabledEvent:connect(function(p)
	if v6 then
		v12:SetEnabled(not p)

		if p then
			v12:ReleaseFocus()
		end
	end
end)

ChatMain.ChatWindowSizeEvent:connect(function(size)
	v8.GuiObject.Size = size
end)

ChatMain.ChatWindowPositionEvent:connect(function(position)
	v8.GuiObject.Position = position
end)

DoChatBarFocus = function()
	if not (v8:GetCoreGuiEnabled() and v12:GetEnabled()) then
		return
	end

	if not v12:IsFocused() and v12:GetVisible() then
		ChatMain:SetVisible(true)
		InstantFadeIn()
		v12:CaptureFocus()
		ChatMain.ChatBarFocusChanged:fire(true)
	end
end

bindableEvent4.Event:connect(function(p)
	ChatMain.ChatBarFocusChanged:fire(p)
end)

function DoSwitchCurrentChannel(p)
	if v8:GetChannel(p) then
		v8:SwitchCurrentChannel(p)
	end
end

function SendMessageToSelfInTargetChannel(value, originalChannel, extraData)
	local channel = v8:GetChannel(originalChannel)

	if channel then
		channel:AddMessageToChannel({
			ID = -1,
			FromSpeaker = nil,
			SpeakerUserId = 0,
			OriginalChannel = originalChannel,
			IsFiltered = true,
			MessageLength = string.len(value),
			MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(value)),
			Message = trimTrailingSpaces(value),
			MessageType = ChatConstants.MessageTypeSystem,
			Time = os.time(),
			ExtraData = extraData
		})
	end
end

function chatBarFocused()
	if not v13 then
		DoBackgroundFadeIn()

		if flag2 then
			DoTextFadeIn()
		end
	end

	bindableEvent4:Fire(true)
end

function chatBarFocusLost(p, _)
	DoBackgroundFadeIn()
	bindableEvent4:Fire(false)

	if p then
		local v15 = v12:GetTextBox().Text

		if v12:IsInCustomState() then
			v15 = v12:GetCustomMessage() or v15

			local customStateProcessCompletedMessage = v12:CustomStateProcessCompletedMessage(v15)
			v12:ResetCustomState()

			if customStateProcessCompletedMessage then
				return
			end
		end

		local textBox = v12:GetTextBox()
		textBox.Text = ""

		if v15 ~= "" then
			ChatMain.MessagePosted:fire(v15)

			if not v11:ProcessCompletedChatMessage(v15, v8) then
				if ChatSettings.DisallowedWhiteSpace then
					for i = 1, #ChatSettings.DisallowedWhiteSpace do
						if ChatSettings.DisallowedWhiteSpace[i] == "\t" then
							v15 = string.gsub(v15, ChatSettings.DisallowedWhiteSpace[i], " ")
						else
							v15 = string.gsub(v15, ChatSettings.DisallowedWhiteSpace[i], "")
						end
					end
				end

				local v16 = string.gsub(v15, "\n", "")
				local v17 = string.gsub(v16, "[ ]+", " ")

				local targetMessageChannel = v8:GetTargetMessageChannel()

				if targetMessageChannel then
					MessageSender:SendMessage(v17, targetMessageChannel)
				else
					MessageSender:SendMessage(v17, nil)
				end
			end
		end
	end
end

local v15 = {}
function setupChatBarConnections()
	for i = 1, #v15 do
		v15[i]:Disconnect()
	end

	v15 = {}

	local focusLostConnection = v12:GetTextBox().FocusLost:connect(chatBarFocusLost)
	table.insert(v15, focusLostConnection)

	local focusedConnection = v12:GetTextBox().Focused:connect(chatBarFocused)
	table.insert(v15, focusedConnection)
end

setupChatBarConnections()
v12.GuiObjectsChanged:connect(setupChatBarConnections)

function getEchoMessagesInGeneral()
	return ChatSettings.EchoMessagesInGeneralChannel == nil or ChatSettings.EchoMessagesInGeneralChannel
end

instancesByName.OnMessageDoneFiltering.OnClientEvent:connect(function(p)
	if not ChatSettings.ShowUserOwnFilteredMessage and p.FromSpeaker == LocalPlayer.Name then
		return
	end

	local originalChannel = p.OriginalChannel
	local channel = v8:GetChannel(originalChannel)

	if channel then
		channel:UpdateMessageFiltered(p)
	end

	local channel2 = getEchoMessagesInGeneral()
		and ChatSettings.GeneralChannelName
		and originalChannel ~= ChatSettings.GeneralChannelName
		and v8:GetChannel(ChatSettings.GeneralChannelName)

	if channel2 then
		channel2:UpdateMessageFiltered(p)
	end
end)

instancesByName.OnNewMessage.OnClientEvent:connect(function(p, p2)
	local channel = v8:GetChannel(p2)

	if channel then
		channel:AddMessageToChannel(p)

		if p.FromSpeaker ~= LocalPlayer.Name then
			v9:UpdateMessagePostedInChannel(p2)
		end

		local channel2 = getEchoMessagesInGeneral()
			and ChatSettings.GeneralChannelName
			and p2 ~= ChatSettings.GeneralChannelName
			and v8:GetChannel(ChatSettings.GeneralChannelName)

		if channel2 then
			channel2:AddMessageToChannel(p)
		end

		ChatMain.MessageCount += 1
		ChatMain.MessagesChanged:fire(ChatMain.MessageCount)

		DoFadeInFromNewInformation()
	end
end)

instancesByName.OnNewSystemMessage.OnClientEvent:connect(function(p, value)
	value = value or "System"

	local channel = v8:GetChannel(value)

	if channel then
		channel:AddMessageToChannel(p)

		v9:UpdateMessagePostedInChannel(value)

		ChatMain.MessageCount += 1
		ChatMain.MessagesChanged:fire(ChatMain.MessageCount)

		DoFadeInFromNewInformation()

		local channel2 = getEchoMessagesInGeneral()
			and ChatSettings.GeneralChannelName
			and value ~= ChatSettings.GeneralChannelName
			and v8:GetChannel(ChatSettings.GeneralChannelName)

		if channel2 then
			channel2:AddMessageToChannel(p)
		end
	else
		warn(string.format("Just received system message for channel I'm not in [%s]", value))
	end
end)

function HandleChannelJoined(originalChannel, value, list, p, p2, p3)
	if v8:GetChannel(originalChannel) then
		v8:RemoveChannel(originalChannel)
	end

	if originalChannel == ChatSettings.GeneralChannelName then
		v7 = true
	end

	if p then
		v12:SetChannelNameColor(originalChannel, p)
	end

	local v16 = v8:AddChannel(originalChannel)

	if v16 then
		if originalChannel == ChatSettings.GeneralChannelName then
			DoSwitchCurrentChannel(originalChannel)
		end

		if list then
			local v17 = not (#list > ChatSettings.MessageHistoryLengthPerChannel) and 1
				or #list - ChatSettings.MessageHistoryLengthPerChannel

			for i = v17, #list do
				v16:AddMessageToChannel(list[i])
			end

			if
				getEchoMessagesInGeneral()
				and p2
				and ChatSettings.GeneralChannelName
				and originalChannel ~= ChatSettings.GeneralChannelName
			then
				local channel = v8:GetChannel(ChatSettings.GeneralChannelName)

				if channel then
					channel:AddMessagesToChannelByTimeStamp(list, v17)
				end
			end
		end

		if value ~= "" then
			local v17 = {
				ID = -1,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				OriginalChannel = originalChannel,
				IsFiltered = true,
				MessageLength = string.len(value),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(value)),
				Message = trimTrailingSpaces(value),
				MessageType = ChatConstants.MessageTypeWelcome,
				Time = os.time(),
				ExtraData = nil
			}

			v16:AddMessageToChannel(v17)

			local channel = getEchoMessagesInGeneral()
				and p3
				and not ChatSettings.ShowChannelsBar
				and originalChannel ~= ChatSettings.GeneralChannelName
				and v8:GetChannel(ChatSettings.GeneralChannelName)

			if channel then
				channel:AddMessageToChannel(v17)
			end
		end

		local v17 = v2:Get(
			"GameChat_ChatMain_ChatTranslationOnboarding",
			"Text chat will be translated into your language. Tap the symbol in front of the message to see the original. You can turn off translations in the Settings menu."
		)

		if v and v17 ~= "" and originalChannel == ChatSettings.GeneralChannelName and v3 ~= nil and v3.Value then
			v16:AddMessageToChannel({
				ID = -2,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				OriginalChannel = originalChannel,
				IsFiltered = true,
				MessageLength = string.len(v17),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(v17)),
				Message = trimTrailingSpaces(v17),
				MessageType = ChatConstants.MessageTypeWelcome,
				Time = os.time(),
				ExtraData = nil
			})
		end

		DoFadeInFromNewInformation()
	end
end

instancesByName.OnChannelJoined.OnClientEvent:connect(function(p, p2, p3, p4)
	HandleChannelJoined(p, p2, p3, p4, false, true)
end)

instancesByName.OnChannelLeft.OnClientEvent:connect(function(p)
	v8:RemoveChannel(p)

	DoFadeInFromNewInformation()
end)

instancesByName.OnMuted.OnClientEvent:connect(function(_) end)

instancesByName.OnUnmuted.OnClientEvent:connect(function(_) end)

instancesByName.OnMainChannelSet.OnClientEvent:connect(function(p)
	DoSwitchCurrentChannel(p)
end)

coroutine.wrap(function()
	local channelNameColorUpdated = DefaultChatSystemChatEvents:WaitForChild("ChannelNameColorUpdated", 5)

	if channelNameColorUpdated then
		channelNameColorUpdated.OnClientEvent:connect(function(p, p2)
			v12:SetChannelNameColor(p, p2)
		end)
	end
end)()

local core = nil
local core2 = nil
local core3 = nil
local core4 = nil

pcall(function()
	core = StarterGui:GetCore("PlayerBlockedEvent")
	core2 = StarterGui:GetCore("PlayerMutedEvent")
	core3 = StarterGui:GetCore("PlayerUnblockedEvent")
	core4 = StarterGui:GetCore("PlayerUnmutedEvent")
end)

function SendSystemMessageToSelf(value)
	local currentChannel = v8:GetCurrentChannel()

	if currentChannel then
		currentChannel:AddMessageToChannel({
			ID = -1,
			FromSpeaker = nil,
			SpeakerUserId = 0,
			OriginalChannel = currentChannel.Name,
			IsFiltered = true,
			MessageLength = string.len(value),
			MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(value)),
			Message = trimTrailingSpaces(value),
			MessageType = ChatConstants.MessageTypeSystem,
			Time = os.time(),
			ExtraData = nil
		})
	end
end

function MutePlayer(p)
	local mutePlayerRequest = DefaultChatSystemChatEvents:FindFirstChild("MutePlayerRequest")

	if mutePlayerRequest then
		return mutePlayerRequest:InvokeServer(p.Name)
	end

	return false
end

if core then
	core.Event:connect(function(p)
		if MutePlayer(p) then
			local v16

			if ChatSettings.PlayerDisplayNamesEnabled then
				v16 = p.DisplayName
			else
				v16 = p.Name
			end

			SendSystemMessageToSelf(v2:Get(
				"GameChat_ChatMain_SpeakerHasBeenBlocked",
				string.format("Speaker '%s' has been blocked.", v16),
				{ RBX_NAME = v16 }
			))
		end
	end)
end

if result then
	local function ShowFriendJoinNotification() -- 1 equivalent call inferred from this helper
		return ChatSettings.ShowFriendJoinNotification ~= nil and ChatSettings.ShowFriendJoinNotification
	end

	if ShowFriendJoinNotification() then -- inferred equivalent call
		Players.PlayerAdded:Connect(function(player)
			local success4, result4 = pcall(function()
				return player:IsFriendsWith(LocalPlayer.UserId)
			end)

			if success4 and result4 then
				local v16 = player.Name

				if ChatSettings.PlayerDisplayNamesEnabled then
					v16 = player.DisplayName
				end

				local formatMessageToSend = v2:FormatMessageToSend(
					"GameChat_FriendChatNotifier_JoinMessage",
					string.format("Your friend %s has joined the game.", v16),
					"RBX_NAME",
					v16
				)

				SendSystemMessageToSelf(formatMessageToSend)
			end
		end)
	end
end

if core2 then
	core2.Event:connect(function(p)
		if MutePlayer(p) then
			local v16

			if ChatSettings.PlayerDisplayNamesEnabled then
				v16 = p.DisplayName
			else
				v16 = p.Name
			end

			SendSystemMessageToSelf(v2:Get(
				"GameChat_ChatMain_SpeakerHasBeenMuted",
				string.format("Speaker '%s' has been muted.", v16),
				{ RBX_NAME = v16 }
			))
		end
	end)
end

function UnmutePlayer(p)
	local unMutePlayerRequest = DefaultChatSystemChatEvents:FindFirstChild("UnMutePlayerRequest")

	if unMutePlayerRequest then
		return unMutePlayerRequest:InvokeServer(p.Name)
	end

	return false
end

if core3 then
	core3.Event:connect(function(p)
		if UnmutePlayer(p) then
			local v16

			if ChatSettings.PlayerDisplayNamesEnabled then
				v16 = p.DisplayName
			else
				v16 = p.Name
			end

			SendSystemMessageToSelf(v2:Get(
				"GameChat_ChatMain_SpeakerHasBeenUnBlocked",
				string.format("Speaker '%s' has been unblocked.", v16),
				{ RBX_NAME = v16 }
			))
		end
	end)
end

if core4 then
	core4.Event:connect(function(p)
		if UnmutePlayer(p) then
			local v16

			if ChatSettings.PlayerDisplayNamesEnabled then
				v16 = p.DisplayName
			else
				v16 = p.Name
			end

			SendSystemMessageToSelf(v2:Get(
				"GameChat_ChatMain_SpeakerHasBeenUnMuted",
				string.format("Speaker '%s' has been unmuted.", v16),
				{ RBX_NAME = v16 }
			))
		end
	end)
end

spawn(function()
	if LocalPlayer.UserId > 0 then
		pcall(function()
			local core5 = StarterGui:GetCore("GetBlockedUserIds")
			local setBlockedUserIdsRequest = #core5 > 0
				and DefaultChatSystemChatEvents:FindFirstChild("SetBlockedUserIdsRequest")

			if setBlockedUserIdsRequest then
				setBlockedUserIdsRequest:FireServer(core5)
			end
		end)
	end
end)

spawn(function()
	local success4, result4 = pcall(function()
		return Chat:CanUserChatAsync(LocalPlayer.UserId)
	end)

	if success4 then
		v6 = RunService:IsStudio() or result4
	end
end)

local v16 = instancesByName.GetInitDataRequest:InvokeServer()

for _, channel in pairs(v16.Channels) do
	if channel[1] == ChatSettings.GeneralChannelName then
		HandleChannelJoined(channel[1], channel[2], channel[3], channel[4], true, false)
	end
end

for _, channel in pairs(v16.Channels) do
	if channel[1] ~= ChatSettings.GeneralChannelName then
		HandleChannelJoined(channel[1], channel[2], channel[3], channel[4], true, false)
	end
end

return ChatMain
