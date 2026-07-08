local t1 = {
	Visible = nil,
	IsCoreGuiEnabled = nil,
	TopbarEnabled = nil,
	VisibilityStateChanged = nil
}
local v2 = false
local ok, result = pcall(function() -- line: 22
	return UserSettings():IsUserFeatureEnabled("UserHandleFriendJoinNotifierOnClient")
end)

if ok then
	v2 = result
end

local ok2, result2 = pcall(function() -- line: 32
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u7 = ok2 and result2
local ok3, result3 = pcall(function() -- line: 39
	return UserSettings():IsUserFeatureEnabled("UserAddBetterConsoleCheckForLegacyChat")
end)
local v10 = ok3 and result3

game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chat = game:GetService("Chat")
local StarterGui = game:GetService("StarterGui")

game:GetService("ContextActionService")

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local DefaultChatSystemChatEvents2 = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local MessageCreatorModules = ClientChatModules:WaitForChild("MessageCreatorModules")
local Util = require(MessageCreatorModules:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 63
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {
		Get = function(_, _, p3) -- line: 64
			return p3
		end
	}
end

local ChatTranslationEnabled = nil

if u7 then
	ChatTranslationEnabled = script:FindFirstChild("ChatTranslationEnabled")

	if ChatTranslationEnabled == nil then
		local connection = nil

		connection = script.ChildAdded:Connect(function(child) -- line: 71
			-- upvalues: ChatTranslationEnabled (ref), connection (ref)
			if child.Name == "ChatTranslationEnabled" then
				ChatTranslationEnabled = child
				connection:Disconnect()
			end
		end)
	end
end

local n1 = 10
local t2 = {
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
local t3 = {}
local BindableEvent = Instance.new("BindableEvent")

function TryRemoveChildWithVerifyingIsCorrectType(p4) -- line: 104
	-- upvalues: t2 (copy), t3 (copy), n1 (ref)
	if t2[p4.Name] and p4:IsA(t2[p4.Name]) then
		t2[p4.Name] = nil
		t3[p4.Name] = p4
		n1 -= 1
	end
end

for _, child in pairs(DefaultChatSystemChatEvents2:GetChildren()) do
	TryRemoveChildWithVerifyingIsCorrectType(child)
end

if n1 > 0 then
	local v30 = DefaultChatSystemChatEvents2.ChildAdded:connect(function(p5) -- line: 117
		-- upvalues: n1 (ref), BindableEvent (copy)
		TryRemoveChildWithVerifyingIsCorrectType(p5)

		if n1 < 1 then
			BindableEvent:Fire()
		end
	end)

	BindableEvent.Event:wait()
	v30:disconnect()
	BindableEvent:Destroy()
end

local v31 = t3
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local u36 = true
local n2 = 6

if ChatSettings.ScreenGuiDisplayOrder ~= nil then
	n2 = ChatSettings.ScreenGuiDisplayOrder
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "Chat"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = n2
ScreenGui.Parent = PlayerGui

if v10 and game:GetService("GuiService"):IsTenFootInterface() then
	ScreenGui.Enabled = false
end

local u40 = false
local _script = script
local ChatWindow = require(_script:WaitForChild("ChatWindow"))
local ChatBar = require(_script:WaitForChild("ChatBar"))
local ChannelsBar = require(_script:WaitForChild("ChannelsBar"))

require(_script:WaitForChild("MessageLabelCreator"))

local MessageLogDisplay = require(_script:WaitForChild("MessageLogDisplay"))

require(_script:WaitForChild("ChatChannel"))

local CommandProcessor = require(_script:WaitForChild("CommandProcessor"))
local v47 = ChatWindow.new()
local v48 = ChannelsBar.new()
local v49 = MessageLogDisplay.new()
local v50 = CommandProcessor.new()
local v51 = ChatBar.new(v50, v47)

v47:CreateGuiObjects(ScreenGui)
v47:RegisterChatBar(v51)
v47:RegisterChannelsBar(v48)
v47:RegisterMessageLogDisplay(v49)
Util:RegisterChatWindow(v47)

local MessageSender = require(_script:WaitForChild("MessageSender"))

MessageSender:RegisterSayMessageFunction(v31.SayMessageRequest)

if UserInputService.TouchEnabled then
	v51:SetTextLabelText(ChatLocalization:Get("GameChat_ChatMain_ChatBarTextTouch", "Tap here to chat"))
else
	v51:SetTextLabelText(ChatLocalization:Get("GameChat_ChatMain_ChatBarText", "To chat click here or press \"/\" key"))
end

spawn(function() -- line: 204
	-- upvalues: _script (copy), ChatSettings (copy), v47 (copy)
	local CurveUtil = require(_script:WaitForChild("CurveUtil"))
	local v81 = 1 / (ChatSettings.ChatAnimationFPS or 20)
	local timestamp = tick()

	while true do
		local timestamp2 = tick()
		local v84 = CurveUtil:DeltaTimeToTimescale(timestamp2 - timestamp)

		if v84 ~= 0 then
			v47:Update(v84)
		end

		timestamp = timestamp2
		wait(v81)
	end
end)

function CheckIfPointIsInSquare(p6, p7, p8) -- line: 230
	return p7.X <= p6.X and (p6.X <= p8.X and (p7.Y <= p6.Y and p6.Y <= p8.Y))
end

local u53 = false
local u54 = false
local n3 = 0
local n4 = 0
local BindableEvent2 = Instance.new("BindableEvent")
local BindableEvent3 = Instance.new("BindableEvent")
local BindableEvent4 = Instance.new("BindableEvent")

function DoBackgroundFadeIn(p9) -- line: 244
	-- upvalues: n4 (ref), u53 (ref), BindableEvent2 (copy), v47 (copy), ChatSettings (copy), v49 (copy), MessageLogDisplay (copy)
	n4 = tick()
	u53 = false
	BindableEvent2:Fire()
	v47:FadeInBackground(p9 or ChatSettings.ChatDefaultFadeDuration)

	if v47:GetCurrentChannel() then
		local Scroller = v49.Scroller

		Scroller.ScrollingEnabled = true
		Scroller.ScrollBarThickness = MessageLogDisplay.ScrollBarThickness
	end
end
function DoBackgroundFadeOut(p10) -- line: 259
	-- upvalues: n4 (ref), u53 (ref), BindableEvent2 (copy), v47 (copy), ChatSettings (copy), v49 (copy)
	n4 = tick()
	u53 = true
	BindableEvent2:Fire()
	v47:FadeOutBackground(p10 or ChatSettings.ChatDefaultFadeDuration)

	if v47:GetCurrentChannel() then
		local Scroller = v49.Scroller

		Scroller.ScrollingEnabled = false
		Scroller.ScrollBarThickness = 0
	end
end
function DoTextFadeIn(p11) -- line: 274
	-- upvalues: n3 (ref), u54 (ref), BindableEvent2 (copy), v47 (copy), ChatSettings (copy)
	n3 = tick()
	u54 = false
	BindableEvent2:Fire()
	v47:FadeInText((p11 or ChatSettings.ChatDefaultFadeDuration) * 0)
end
function DoTextFadeOut(p12) -- line: 281
	-- upvalues: n3 (ref), u54 (ref), BindableEvent2 (copy), v47 (copy), ChatSettings (copy)
	n3 = tick()
	u54 = true
	BindableEvent2:Fire()
	v47:FadeOutText(p12 or ChatSettings.ChatDefaultFadeDuration)
end
function DoFadeInFromNewInformation() -- line: 288
	-- upvalues: ChatSettings (copy)
	DoTextFadeIn()

	if ChatSettings.ChatShouldFadeInFromNewInformation then
		DoBackgroundFadeIn()
	end
end
function InstantFadeIn() -- line: 295
	DoBackgroundFadeIn(0)
	DoTextFadeIn(0)
end
function InstantFadeOut() -- line: 300
	DoBackgroundFadeOut(0)
	DoTextFadeOut(0)
end

local u60 = nil

function UpdateFadingForMouseState(p13) -- line: 306
	-- upvalues: u60 (ref), BindableEvent3 (copy), v51 (copy)
	u60 = p13
	BindableEvent3:Fire()

	if v51:IsFocused() then
		return
	end

	if p13 then
		DoBackgroundFadeIn()
		DoTextFadeIn()

		return
	end

	DoBackgroundFadeIn()
end

spawn(function() -- line: 322
	-- upvalues: RunService (copy), u60 (ref), v51 (copy), BindableEvent3 (copy), BindableEvent4 (copy), u53 (ref), n4 (ref), ChatSettings (copy), u54 (ref), n3 (ref), BindableEvent2 (copy)
	while true do
		RunService.RenderStepped:wait()

		while u60 or v51:IsFocused() do
			if u60 then
				BindableEvent3.Event:wait()
			end

			if v51:IsFocused() then
				BindableEvent4.Event:wait()
			end
		end

		if not u53 then
			if tick() - n4 > ChatSettings.ChatWindowBackgroundFadeOutTime then
				DoBackgroundFadeOut()
			end
		elseif not u54 then
			if tick() - n3 > ChatSettings.ChatWindowTextFadeOutTime then
				DoTextFadeOut()
			end
		else
			BindableEvent2.Event:wait()
		end
	end
end)

function getClassicChatEnabled() -- line: 355
	-- upvalues: ChatSettings (copy), Players (copy)
	if ChatSettings.ClassicChatEnabled ~= nil then
		return ChatSettings.ClassicChatEnabled
	end

	return Players.ClassicChat
end
function getBubbleChatEnabled() -- line: 362
	-- upvalues: ChatSettings (copy), Players (copy)
	if ChatSettings.BubbleChatEnabled ~= nil then
		return ChatSettings.BubbleChatEnabled
	end

	return Players.BubbleChat
end
function bubbleChatOnly() -- line: 369
	return not getClassicChatEnabled() and getBubbleChatEnabled()
end
function UpdateMousePosition(p14) -- line: 373
	-- upvalues: t1 (copy), ChatSettings (copy), v47 (copy), u60 (ref)
	if not t1.Visible or not t1.IsCoreGuiEnabled or not t1.TopbarEnabled and not ChatSettings.ChatOnWithTopBarOff then
		return
	end

	if bubbleChatOnly() then
		return
	end

	local AbsolutePosition = v47.GuiObject.AbsolutePosition
	local AbsoluteSize = v47.GuiObject.AbsoluteSize
	local v98 = CheckIfPointIsInSquare(p14, AbsolutePosition, AbsolutePosition + AbsoluteSize)

	if v98 ~= u60 then
		UpdateFadingForMouseState(v98)
	end
end

UserInputService.InputChanged:connect(function(p15, _) -- line: 390
	if p15.UserInputType == Enum.UserInputType.MouseMovement then
		local vector2 = Vector2.new(p15.Position.X, p15.Position.Y)

		UpdateMousePosition(vector2)
	end
end)
UserInputService.TouchTap:connect(function(p17, _) -- line: 397
	UpdateMousePosition(p17[1])
end)
UserInputService.TouchMoved:connect(function(p19, _) -- line: 401
	local vector2 = Vector2.new(p19.Position.X, p19.Position.Y)

	UpdateMousePosition(vector2)
end)
UserInputService.Changed:connect(function(p21) -- line: 406
	-- upvalues: UserInputService (copy), v47 (copy), ScreenGui (copy)
	if p21 == "MouseBehavior" and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		local AbsolutePosition = v47.GuiObject.AbsolutePosition
		local AbsoluteSize = v47.GuiObject.AbsoluteSize
		local AbsoluteSize2 = ScreenGui.AbsoluteSize

		if CheckIfPointIsInSquare(AbsoluteSize2 / 2, AbsolutePosition, AbsolutePosition + AbsoluteSize) then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
end)
UpdateFadingForMouseState(true)
UpdateFadingForMouseState(false)

local t6 = {
	Signal = function() -- line: 431
		local t4 = {}
		local BindableEvent5 = Instance.new("BindableEvent")
		local t5 = nil
		local u114 = nil

		function t4.fire(_, ...) -- line: 439
			-- upvalues: t5 (ref), u114 (ref), BindableEvent5 (copy)
			t5 = { ... }
			u114 = select("#", ...)
			BindableEvent5:Fire()
		end
		function t4.connect(_, p24) -- line: 445
			-- upvalues: BindableEvent5 (copy), t5 (ref), u114 (ref)
			if not p24 then
				error("connect(nil)", 2)
			end

			return BindableEvent5.Event:connect(function() -- line: 447
				-- upvalues: p24 (copy), t5 (ref), u114 (ref)
				p24(unpack(t5, 1, u114))
			end)
		end
		function t4.wait(_) -- line: 452
			-- upvalues: BindableEvent5 (copy), t5 (ref), u114 (ref)
			BindableEvent5.Event:wait()
			assert(t5, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")

			return unpack(t5, 1, u114)
		end

		return t4
	end
}

function SetVisibility(p26) -- line: 463
	-- upvalues: v47 (copy), t1 (copy)
	v47:SetVisible(p26)
	t1.VisibilityStateChanged:fire(p26)
	t1.Visible = p26

	if t1.IsCoreGuiEnabled then
		if p26 then
			InstantFadeIn()

			return
		end

		InstantFadeOut()
	end
end

local DoChatBarFocus = nil

t1.TopbarEnabled = true
t1.MessageCount = 0
t1.Visible = true
t1.IsCoreGuiEnabled = true

function t1.ToggleVisibility(_) -- line: 485
	-- upvalues: v47 (copy)
	SetVisibility(not v47:GetVisible())
end
function t1.SetVisible(_, p29) -- line: 489
	-- upvalues: v47 (copy)
	if p29 ~= v47:GetVisible() then
		SetVisibility(p29)
	end
end
function t1.FocusChatBar(_) -- line: 495
	-- upvalues: v51 (copy)
	v51:CaptureFocus()
end
function t1.EnterWhisperState(_, p32) -- line: 499
	-- upvalues: v51 (copy)
	v51:EnterWhisperState(p32)
end
function t1.GetVisibility(_) -- line: 503
	-- upvalues: v47 (copy)
	return v47:GetVisible()
end
function t1.GetMessageCount(p34) -- line: 507
	return p34.MessageCount
end
function t1.TopbarEnabledChanged(p35, p36) -- line: 511
	p35.TopbarEnabled = p36
	p35.CoreGuiEnabled:fire(game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.Chat))
end
function t1.IsFocused(_, _) -- line: 516
	-- upvalues: v51 (copy)
	return v51:IsFocused()
end

t1.ChatBarFocusChanged = t6.Signal()
t1.VisibilityStateChanged = t6.Signal()
t1.MessagesChanged = t6.Signal()
t1.MessagePosted = t6.Signal()
t1.CoreGuiEnabled = t6.Signal()
t1.ChatMakeSystemMessageEvent = t6.Signal()
t1.ChatWindowPositionEvent = t6.Signal()
t1.ChatWindowSizeEvent = t6.Signal()
t1.ChatBarDisabledEvent = t6.Signal()

function t1.fChatWindowPosition(_) -- line: 534
	-- upvalues: v47 (copy)
	return v47.GuiObject.Position
end
function t1.fChatWindowSize(_) -- line: 538
	-- upvalues: v47 (copy)
	return v47.GuiObject.Size
end
function t1.fChatBarDisabled(_) -- line: 542
	-- upvalues: v51 (copy)
	return not v51:GetEnabled()
end
function t1.SpecialKeyPressed(_, p43, _) -- line: 546
	-- upvalues: u36 (ref), DoChatBarFocus (ref)
	if p43 == Enum.SpecialKey.ChatHotkey and u36 then
		DoChatBarFocus()
	end
end

t1.CoreGuiEnabled:connect(function(p45) -- line: 555
	-- upvalues: t1 (copy), ChatSettings (copy), v47 (copy), v51 (copy)
	t1.IsCoreGuiEnabled = p45

	local v135 = p45 and (t1.TopbarEnabled or ChatSettings.ChatOnWithTopBarOff)

	v47:SetCoreGuiEnabled(v135)

	if not v135 then
		v51:ReleaseFocus()
		InstantFadeOut()

		return
	end

	InstantFadeIn()
end)

function trimTrailingSpaces(p46) -- line: 570
	local v137 = #p46

	while v137 > 0 and p46:find("^%s", v137) do
		v137 -= 1
	end

	return p46:sub(1, v137)
end

t1.ChatMakeSystemMessageEvent:connect(function(p47) -- line: 583
	-- upvalues: u40 (ref), ChatSettings (copy), v47 (copy), ChatConstants (copy), v48 (copy), t1 (copy)
	if p47.Text and type(p47.Text) == "string" then
		while not u40 do
			wait()
		end

		local GeneralChannelName = ChatSettings.GeneralChannelName
		local Channel = v47:GetChannel(GeneralChannelName)

		if Channel then
			Channel:AddMessageToChannel({
				ID = -1,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				IsFiltered = true,
				OriginalChannel = GeneralChannelName,
				MessageLength = string.len(p47.Text),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p47.Text)),
				Message = trimTrailingSpaces(p47.Text),
				MessageType = ChatConstants.MessageTypeSetCore,
				Time = os.time(),
				ExtraData = p47
			})
			v48:UpdateMessagePostedInChannel(GeneralChannelName)
			t1.MessageCount = t1.MessageCount + 1
			t1.MessagesChanged:fire(t1.MessageCount)
		end
	end
end)
t1.ChatBarDisabledEvent:connect(function(p48) -- line: 613
	-- upvalues: u36 (ref), v51 (copy)
	if u36 then
		v51:SetEnabled(not p48)

		if p48 then
			v51:ReleaseFocus()
		end
	end
end)
t1.ChatWindowSizeEvent:connect(function(p49) -- line: 622
	-- upvalues: v47 (copy)
	v47.GuiObject.Size = p49
end)
t1.ChatWindowPositionEvent:connect(function(p50) -- line: 626
	-- upvalues: v47 (copy)
	v47.GuiObject.Position = p50
end)

function DoChatBarFocus() -- line: 634
	-- upvalues: v47 (copy), v51 (copy), t1 (copy)
	if not v47:GetCoreGuiEnabled() then
		return
	end

	if not v51:GetEnabled() then
		return
	end

	if not v51:IsFocused() and v51:GetVisible() then
		t1:SetVisible(true)
		InstantFadeIn()
		v51:CaptureFocus()
		t1.ChatBarFocusChanged:fire(true)
	end
end

BindableEvent4.Event:connect(function(p51) -- line: 646
	-- upvalues: t1 (copy)
	t1.ChatBarFocusChanged:fire(p51)
end)

function DoSwitchCurrentChannel(p52) -- line: 650
	-- upvalues: v47 (copy)
	if v47:GetChannel(p52) then
		v47:SwitchCurrentChannel(p52)
	end
end
function SendMessageToSelfInTargetChannel(p53, p54, p55) -- line: 656
	-- upvalues: v47 (copy), ChatConstants (copy)
	local Channel = v47:GetChannel(p54)

	if Channel then
		Channel:AddMessageToChannel({
			ID = -1,
			FromSpeaker = nil,
			SpeakerUserId = 0,
			IsFiltered = true,
			OriginalChannel = p54,
			MessageLength = string.len(p53),
			MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p53)),
			Message = trimTrailingSpaces(p53),
			MessageType = ChatConstants.MessageTypeSystem,
			Time = os.time(),
			ExtraData = p55
		})
	end
end
function chatBarFocused() -- line: 677
	-- upvalues: u60 (ref), u54 (ref), BindableEvent4 (copy)
	if not u60 then
		DoBackgroundFadeIn()

		if u54 then
			DoTextFadeIn()
		end
	end

	BindableEvent4:Fire(true)
end
function chatBarFocusLost(p56, _) -- line: 689
	-- upvalues: BindableEvent4 (copy), v51 (copy), t1 (copy), v50 (copy), v47 (copy), ChatSettings (copy), MessageSender (copy)
	DoBackgroundFadeIn()
	BindableEvent4:Fire(false)

	if p56 then
		local Text = v51:GetTextBox().Text

		if v51:IsInCustomState() then
			local CustomMessage = v51:GetCustomMessage()

			if CustomMessage then
				Text = CustomMessage
			end

			local v154 = v51:CustomStateProcessCompletedMessage(Text)

			v51:ResetCustomState()

			if v154 then
				return
			end
		end

		v51:GetTextBox().Text = ""

		if Text ~= "" then
			t1.MessagePosted:fire(Text)

			if not v50:ProcessCompletedChatMessage(Text, v47) then
				if ChatSettings.DisallowedWhiteSpace then
					for i = 1, #ChatSettings.DisallowedWhiteSpace do
						Text = if ChatSettings.DisallowedWhiteSpace[i] ~= "\t" then string.gsub(Text, ChatSettings.DisallowedWhiteSpace[i], "") else string.gsub(Text, ChatSettings.DisallowedWhiteSpace[i], " ")
					end
				end

				local v156 = string.gsub(Text, "\n", "")
				local v157 = string.gsub(v156, "[ ]+", " ")
				local TargetMessageChannel = v47:GetTargetMessageChannel()

				if TargetMessageChannel then
					MessageSender:SendMessage(v157, TargetMessageChannel)

					return
				end

				MessageSender:SendMessage(v157, nil)
			end
		end
	end
end

local t7 = {}

function setupChatBarConnections() -- line: 740
	-- upvalues: t7 (ref), v51 (copy)
	for i = 1, #t7 do
		t7[i]:Disconnect()
	end

	t7 = {}

	local v160 = v51:GetTextBox().FocusLost:connect(chatBarFocusLost)

	table.insert(t7, v160)

	local v161 = v51:GetTextBox().Focused:connect(chatBarFocused)

	table.insert(t7, v161)
end

setupChatBarConnections()
v51.GuiObjectsChanged:connect(setupChatBarConnections)

function getEchoMessagesInGeneral() -- line: 756
	-- upvalues: ChatSettings (copy)
	if ChatSettings.EchoMessagesInGeneralChannel == nil then
		return true
	end

	return ChatSettings.EchoMessagesInGeneralChannel
end

v31.OnMessageDoneFiltering.OnClientEvent:connect(function(p58) -- line: 763
	-- upvalues: ChatSettings (copy), LocalPlayer (ref), v47 (copy)
	if not ChatSettings.ShowUserOwnFilteredMessage and p58.FromSpeaker == LocalPlayer.Name then
		return
	end

	local OriginalChannel = p58.OriginalChannel
	local Channel = v47:GetChannel(OriginalChannel)

	if Channel then
		Channel:UpdateMessageFiltered(p58)
	end

	if getEchoMessagesInGeneral() and ChatSettings.GeneralChannelName and OriginalChannel ~= ChatSettings.GeneralChannelName then
		local Channel2 = v47:GetChannel(ChatSettings.GeneralChannelName)

		if Channel2 then
			Channel2:UpdateMessageFiltered(p58)
		end
	end
end)
v31.OnNewMessage.OnClientEvent:connect(function(p59, p60) -- line: 784
	-- upvalues: v47 (copy), LocalPlayer (ref), v48 (copy), ChatSettings (copy), t1 (copy)
	local Channel = v47:GetChannel(p60)

	if Channel then
		Channel:AddMessageToChannel(p59)

		if p59.FromSpeaker ~= LocalPlayer.Name then
			v48:UpdateMessagePostedInChannel(p60)
		end

		if getEchoMessagesInGeneral() and ChatSettings.GeneralChannelName and p60 ~= ChatSettings.GeneralChannelName then
			local Channel3 = v47:GetChannel(ChatSettings.GeneralChannelName)

			if Channel3 then
				Channel3:AddMessageToChannel(p59)
			end
		end

		t1.MessageCount = t1.MessageCount + 1
		t1.MessagesChanged:fire(t1.MessageCount)
		DoFadeInFromNewInformation()
	end
end)
v31.OnNewSystemMessage.OnClientEvent:connect(function(p61, p62) -- line: 807
	-- upvalues: v47 (copy), v48 (copy), t1 (copy), ChatSettings (copy)
	local v172 = p62 or "System"
	local Channel = v47:GetChannel(v172)

	if Channel then
		Channel:AddMessageToChannel(p61)
		v48:UpdateMessagePostedInChannel(v172)
		t1.MessageCount = t1.MessageCount + 1
		t1.MessagesChanged:fire(t1.MessageCount)
		DoFadeInFromNewInformation()

		if getEchoMessagesInGeneral() and ChatSettings.GeneralChannelName and v172 ~= ChatSettings.GeneralChannelName then
			local Channel4 = v47:GetChannel(ChatSettings.GeneralChannelName)

			if Channel4 then
				Channel4:AddMessageToChannel(p61)

				return
			end
		end
	else
		warn(string.format("Just received system message for channel I'm not in [%s]", v172))
	end
end)

function HandleChannelJoined(p63, p64, p65, p66, p67, p68) -- line: 833
	-- upvalues: v47 (copy), ChatSettings (copy), u40 (ref), v51 (copy), ChatConstants (copy), ChatLocalization (ref), u7 (ref), ChatTranslationEnabled (ref)
	if v47:GetChannel(p63) then
		v47:RemoveChannel(p63)
	end

	if p63 == ChatSettings.GeneralChannelName then
		u40 = true
	end

	if p66 then
		v51:SetChannelNameColor(p63, p66)
	end

	local v181 = v47:AddChannel(p63)

	if v181 then
		if p63 == ChatSettings.GeneralChannelName then
			DoSwitchCurrentChannel(p63)
		end

		if p65 then
			local n5 = 1

			if #p65 > ChatSettings.MessageHistoryLengthPerChannel then
				n5 = #p65 - ChatSettings.MessageHistoryLengthPerChannel
			end

			for i = n5, #p65 do
				v181:AddMessageToChannel(p65[i])
			end

			if getEchoMessagesInGeneral() and p67 and ChatSettings.GeneralChannelName and p63 ~= ChatSettings.GeneralChannelName then
				local Channel = v47:GetChannel(ChatSettings.GeneralChannelName)

				if Channel then
					Channel:AddMessagesToChannelByTimeStamp(p65, n5)
				end
			end
		end

		if p64 ~= "" then
			local t8 = {
				ID = -1,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				IsFiltered = true,
				ExtraData = nil,
				OriginalChannel = p63,
				MessageLength = string.len(p64),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p64)),
				Message = trimTrailingSpaces(p64),
				MessageType = ChatConstants.MessageTypeWelcome,
				Time = os.time()
			}

			v181:AddMessageToChannel(t8)

			if getEchoMessagesInGeneral() and p68 and not ChatSettings.ShowChannelsBar and p63 ~= ChatSettings.GeneralChannelName then
				local Channel = v47:GetChannel(ChatSettings.GeneralChannelName)

				if Channel then
					Channel:AddMessageToChannel(t8)
				end
			end
		end

		local v187 = ChatLocalization:Get("GameChat_ChatMain_ChatTranslationOnboarding", "Text chat will be translated into your language. Tap the symbol in front of the message to see the original. You can turn off translations in the Settings menu.")

		if u7 and v187 ~= "" and p63 == ChatSettings.GeneralChannelName and ChatTranslationEnabled ~= nil and ChatTranslationEnabled.Value then
			v181:AddMessageToChannel({
				ID = -2,
				FromSpeaker = nil,
				SpeakerUserId = 0,
				IsFiltered = true,
				ExtraData = nil,
				OriginalChannel = p63,
				MessageLength = string.len(v187),
				MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(v187)),
				Message = trimTrailingSpaces(v187),
				MessageType = ChatConstants.MessageTypeWelcome,
				Time = os.time()
			})
		end

		DoFadeInFromNewInformation()
	end
end

v31.OnChannelJoined.OnClientEvent:connect(function(p69, p70, p71, p72) -- line: 925
	HandleChannelJoined(p69, p70, p71, p72, false, true)
end)
v31.OnChannelLeft.OnClientEvent:connect(function(p73) -- line: 929
	-- upvalues: v47 (copy)
	v47:RemoveChannel(p73)
	DoFadeInFromNewInformation()
end)
v31.OnMuted.OnClientEvent:connect(function(_) -- line: 935
end)
v31.OnUnmuted.OnClientEvent:connect(function(_) -- line: 941
end)
v31.OnMainChannelSet.OnClientEvent:connect(function(p76) -- line: 945
	DoSwitchCurrentChannel(p76)
end)
coroutine.wrap(function() -- line: 949
	-- upvalues: DefaultChatSystemChatEvents (copy), v51 (copy)
	local ChannelNameColorUpdated = DefaultChatSystemChatEvents:WaitForChild("ChannelNameColorUpdated", 5)

	if ChannelNameColorUpdated then
		ChannelNameColorUpdated.OnClientEvent:connect(function(p77, p78) -- line: 953
			-- upvalues: v51 (copy)
			v51:SetChannelNameColor(p77, p78)
		end)
	end
end)()

local Core = nil
local Core2 = nil
local Core3 = nil
local Core4 = nil

pcall(function() -- line: 969
	-- upvalues: Core (ref), StarterGui (copy), Core2 (ref), Core3 (ref), Core4 (ref)
	Core = StarterGui:GetCore("PlayerBlockedEvent")
	Core2 = StarterGui:GetCore("PlayerMutedEvent")
	Core3 = StarterGui:GetCore("PlayerUnblockedEvent")
	Core4 = StarterGui:GetCore("PlayerUnmutedEvent")
end)

function SendSystemMessageToSelf(p79) -- line: 976
	-- upvalues: v47 (copy), ChatConstants (copy)
	local CurrentChannel = v47:GetCurrentChannel()

	if CurrentChannel then
		CurrentChannel:AddMessageToChannel({
			ID = -1,
			FromSpeaker = nil,
			SpeakerUserId = 0,
			IsFiltered = true,
			ExtraData = nil,
			OriginalChannel = CurrentChannel.Name,
			MessageLength = string.len(p79),
			MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p79)),
			Message = trimTrailingSpaces(p79),
			MessageType = ChatConstants.MessageTypeSystem,
			Time = os.time()
		})
	end
end
function MutePlayer(p80) -- line: 998
	-- upvalues: DefaultChatSystemChatEvents (copy)
	local MutePlayerRequest = DefaultChatSystemChatEvents:FindFirstChild("MutePlayerRequest")

	if MutePlayerRequest then
		return MutePlayerRequest:InvokeServer(p80.Name)
	end

	return false
end

if Core then
	Core.Event:connect(function(p81) -- line: 1007
		-- upvalues: ChatSettings (copy), ChatLocalization (ref)
		if MutePlayer(p81) then
			local v202 = if not ChatSettings.PlayerDisplayNamesEnabled then p81.Name else p81.DisplayName

			SendSystemMessageToSelf(ChatLocalization:Get("GameChat_ChatMain_SpeakerHasBeenBlocked", string.format("Speaker '%s' has been blocked.", v202), {
				RBX_NAME = v202
			}))
		end
	end)
end

if v2 then
	local function ShowFriendJoinNotification() -- line: 1029
		-- upvalues: ChatSettings (copy)
		if ChatSettings.ShowFriendJoinNotification ~= nil then
			return ChatSettings.ShowFriendJoinNotification
		end

		return false
	end

	if ChatSettings.ShowFriendJoinNotification ~= nil and ChatSettings.ShowFriendJoinNotification then
		Players.PlayerAdded:Connect(function(player) -- line: 1037
			-- upvalues: LocalPlayer (ref), ChatSettings (copy), ChatLocalization (ref)
			local ok4, result4 = pcall(function() -- line: 1038
				-- upvalues: player (copy), LocalPlayer (ref)
				return player:IsFriendsWith(LocalPlayer.UserId)
			end)

			if ok4 and result4 then
				local playerName = player.Name

				if ChatSettings.PlayerDisplayNamesEnabled then
					playerName = player.DisplayName
				end

				local v207 = ChatLocalization:FormatMessageToSend("GameChat_FriendChatNotifier_JoinMessage", string.format("Your friend %s has joined the game.", playerName), "RBX_NAME", playerName)

				SendSystemMessageToSelf(v207)
			end
		end)
	end
end

if Core2 then
	Core2.Event:connect(function(p82) -- line: 1060
		-- upvalues: ChatSettings (copy), ChatLocalization (ref)
		if MutePlayer(p82) then
			local v209 = if not ChatSettings.PlayerDisplayNamesEnabled then p82.Name else p82.DisplayName

			SendSystemMessageToSelf(ChatLocalization:Get("GameChat_ChatMain_SpeakerHasBeenMuted", string.format("Speaker '%s' has been muted.", v209), {
				RBX_NAME = v209
			}))
		end
	end)
end

function UnmutePlayer(p83) -- line: 1081
	-- upvalues: DefaultChatSystemChatEvents (copy)
	local UnMutePlayerRequest = DefaultChatSystemChatEvents:FindFirstChild("UnMutePlayerRequest")

	if UnMutePlayerRequest then
		return UnMutePlayerRequest:InvokeServer(p83.Name)
	end

	return false
end

if Core3 then
	Core3.Event:connect(function(p84) -- line: 1090
		-- upvalues: ChatSettings (copy), ChatLocalization (ref)
		if UnmutePlayer(p84) then
			local v213 = if not ChatSettings.PlayerDisplayNamesEnabled then p84.Name else p84.DisplayName

			SendSystemMessageToSelf(ChatLocalization:Get("GameChat_ChatMain_SpeakerHasBeenUnBlocked", string.format("Speaker '%s' has been unblocked.", v213), {
				RBX_NAME = v213
			}))
		end
	end)
end

if Core4 then
	Core4.Event:connect(function(p85) -- line: 1112
		-- upvalues: ChatSettings (copy), ChatLocalization (ref)
		if UnmutePlayer(p85) then
			local v215 = if not ChatSettings.PlayerDisplayNamesEnabled then p85.Name else p85.DisplayName

			SendSystemMessageToSelf(ChatLocalization:Get("GameChat_ChatMain_SpeakerHasBeenUnMuted", string.format("Speaker '%s' has been unmuted.", v215), {
				RBX_NAME = v215
			}))
		end
	end)
end

spawn(function() -- line: 1135
	-- upvalues: LocalPlayer (ref), StarterGui (copy), DefaultChatSystemChatEvents (copy)
	if LocalPlayer.UserId > 0 then
		pcall(function() -- line: 1138
			-- upvalues: StarterGui (copy), DefaultChatSystemChatEvents (copy)
			local Core5 = StarterGui:GetCore("GetBlockedUserIds")

			if #Core5 > 0 then
				local SetBlockedUserIdsRequest = DefaultChatSystemChatEvents:FindFirstChild("SetBlockedUserIdsRequest")

				if SetBlockedUserIdsRequest then
					SetBlockedUserIdsRequest:FireServer(Core5)
				end
			end
		end)
	end
end)
spawn(function() -- line: 1150
	-- upvalues: Chat (copy), LocalPlayer (ref), u36 (ref), RunService (copy)
	local ok5, result5 = pcall(function() -- line: 1151
		-- upvalues: Chat (copy), LocalPlayer (ref)
		return Chat:CanUserChatAsync(LocalPlayer.UserId)
	end)

	if ok5 then
		u36 = RunService:IsStudio() or result5
	end
end)

local v69 = v31.GetInitDataRequest:InvokeServer()

for _, v in pairs(v69.Channels) do
	if v[1] == ChatSettings.GeneralChannelName then
		HandleChannelJoined(v[1], v[2], v[3], v[4], true, false)
	end
end

for _, v in pairs(v69.Channels) do
	if v[1] ~= ChatSettings.GeneralChannelName then
		HandleChannelJoined(v[1], v[2], v[3], v[4], true, false)
	end
end

return t1
