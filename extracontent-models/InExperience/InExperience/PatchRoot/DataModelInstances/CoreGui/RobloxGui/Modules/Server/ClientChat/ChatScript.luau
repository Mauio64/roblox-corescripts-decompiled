local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Chat = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local function DoEverything()
	local ChatMain = require(script:WaitForChild("ChatMain"))

	local v = { ChatWindow = {}, SetCore = {}, GetCore = {} }

	v.ChatWindow.ChatTypes = {}
	v.ChatWindow.ChatTypes.BubbleChatEnabled = ChatSettings.BubbleChatEnabled
	v.ChatWindow.ChatTypes.ClassicChatEnabled = ChatSettings.ClassicChatEnabled

	local function ConnectEvent(name)
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = name
		v.ChatWindow[name] = bindableEvent

		bindableEvent.Event:connect(function(...)
			ChatMain[name](ChatMain, ...)
		end)
	end

	local function ConnectFunction(name)
		local bindableFunction = Instance.new("BindableFunction")
		bindableFunction.Name = name
		v.ChatWindow[name] = bindableFunction

		function bindableFunction.OnInvoke(...)
			return ChatMain[name](ChatMain, ...)
		end
	end

	local function ReverseConnectEvent(name) -- 4 equivalent calls inferred from this helper
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = name
		v.ChatWindow[name] = bindableEvent

		ChatMain[name]:connect(function(...)
			bindableEvent:Fire(...)
		end)
	end

	local function ConnectSignal(name)
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = name
		v.ChatWindow[name] = bindableEvent

		bindableEvent.Event:connect(function(...)
			ChatMain[name]:fire(...)
		end)
	end

	local function ConnectSetCore(name)
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = name
		v.SetCore[name] = bindableEvent

		bindableEvent.Event:connect(function(...)
			ChatMain[name .. "Event"]:fire(...)
		end)
	end

	local function ConnectGetCore(name)
		local bindableFunction = Instance.new("BindableFunction")
		bindableFunction.Name = name
		v.GetCore[name] = bindableFunction

		function bindableFunction.OnInvoke(...)
			return ChatMain["f" .. name](...)
		end
	end

	local toggleVisibility = Instance.new("BindableEvent")
	toggleVisibility.Name = "ToggleVisibility"
	v.ChatWindow.ToggleVisibility = toggleVisibility

	local v2 = "ToggleVisibility"
	toggleVisibility.Event:connect(function(...)
		ChatMain[v2](ChatMain, ...)
	end)
	local setVisible = Instance.new("BindableEvent")
	setVisible.Name = "SetVisible"
	v.ChatWindow.SetVisible = setVisible

	local v3 = "SetVisible"
	setVisible.Event:connect(function(...)
		ChatMain[v3](ChatMain, ...)
	end)
	local focusChatBar = Instance.new("BindableEvent")
	focusChatBar.Name = "FocusChatBar"
	v.ChatWindow.FocusChatBar = focusChatBar

	local v4 = "FocusChatBar"
	focusChatBar.Event:connect(function(...)
		ChatMain[v4](ChatMain, ...)
	end)
	local enterWhisperState = Instance.new("BindableEvent")
	enterWhisperState.Name = "EnterWhisperState"
	v.ChatWindow.EnterWhisperState = enterWhisperState

	local v5 = "EnterWhisperState"
	enterWhisperState.Event:connect(function(...)
		ChatMain[v5](ChatMain, ...)
	end)

	local getVisibility = Instance.new("BindableFunction")
	getVisibility.Name = "GetVisibility"
	v.ChatWindow.GetVisibility = getVisibility

	local v6 = "GetVisibility"
	function getVisibility.OnInvoke(...)
		return ChatMain[v6](ChatMain, ...)
	end

	local getMessageCount = Instance.new("BindableFunction")
	getMessageCount.Name = "GetMessageCount"
	v.ChatWindow.GetMessageCount = getMessageCount

	local v7 = "GetMessageCount"
	function getMessageCount.OnInvoke(...)
		return ChatMain[v7](ChatMain, ...)
	end

	local topbarEnabledChanged = Instance.new("BindableEvent")
	topbarEnabledChanged.Name = "TopbarEnabledChanged"
	v.ChatWindow.TopbarEnabledChanged = topbarEnabledChanged

	local v8 = "TopbarEnabledChanged"
	topbarEnabledChanged.Event:connect(function(...)
		ChatMain[v8](ChatMain, ...)
	end)

	local isFocused = Instance.new("BindableFunction")
	isFocused.Name = "IsFocused"
	v.ChatWindow.IsFocused = isFocused

	local v9 = "IsFocused"
	function isFocused.OnInvoke(...)
		return ChatMain[v9](ChatMain, ...)
	end

	ReverseConnectEvent("ChatBarFocusChanged") -- inferred equivalent call
	ReverseConnectEvent("VisibilityStateChanged") -- inferred equivalent call
	ReverseConnectEvent("MessagesChanged") -- inferred equivalent call
	ReverseConnectEvent("MessagePosted") -- inferred equivalent call
	local coreGuiEnabled = Instance.new("BindableEvent")
	coreGuiEnabled.Name = "CoreGuiEnabled"
	v.ChatWindow.CoreGuiEnabled = coreGuiEnabled

	local v10 = "CoreGuiEnabled"
	coreGuiEnabled.Event:connect(function(...)
		ChatMain[v10]:fire(...)
	end)

	local chatMakeSystemMessage = Instance.new("BindableEvent")
	chatMakeSystemMessage.Name = "ChatMakeSystemMessage"
	v.SetCore.ChatMakeSystemMessage = chatMakeSystemMessage

	local v11 = "ChatMakeSystemMessage"
	chatMakeSystemMessage.Event:connect(function(...)
		ChatMain[v11 .. "Event"]:fire(...)
	end)
	local chatWindowPosition = Instance.new("BindableEvent")
	chatWindowPosition.Name = "ChatWindowPosition"
	v.SetCore.ChatWindowPosition = chatWindowPosition

	local v12 = "ChatWindowPosition"
	chatWindowPosition.Event:connect(function(...)
		ChatMain[v12 .. "Event"]:fire(...)
	end)
	local chatWindowSize = Instance.new("BindableEvent")
	chatWindowSize.Name = "ChatWindowSize"
	v.SetCore.ChatWindowSize = chatWindowSize

	local v13 = "ChatWindowSize"
	chatWindowSize.Event:connect(function(...)
		ChatMain[v13 .. "Event"]:fire(...)
	end)

	local chatWindowPosition2 = Instance.new("BindableFunction")
	chatWindowPosition2.Name = "ChatWindowPosition"
	v.GetCore.ChatWindowPosition = chatWindowPosition2

	local v14 = "ChatWindowPosition"
	function chatWindowPosition2.OnInvoke(...)
		return ChatMain["f" .. v14](...)
	end

	local chatWindowSize2 = Instance.new("BindableFunction")
	chatWindowSize2.Name = "ChatWindowSize"
	v.GetCore.ChatWindowSize = chatWindowSize2

	local v15 = "ChatWindowSize"
	function chatWindowSize2.OnInvoke(...)
		return ChatMain["f" .. v15](...)
	end

	local chatBarDisabled = Instance.new("BindableEvent")
	chatBarDisabled.Name = "ChatBarDisabled"
	v.SetCore.ChatBarDisabled = chatBarDisabled

	local v16 = "ChatBarDisabled"
	chatBarDisabled.Event:connect(function(...)
		ChatMain[v16 .. "Event"]:fire(...)
	end)

	local chatBarDisabled2 = Instance.new("BindableFunction")
	chatBarDisabled2.Name = "ChatBarDisabled"
	v.GetCore.ChatBarDisabled = chatBarDisabled2

	local v17 = "ChatBarDisabled"
	function chatBarDisabled2.OnInvoke(...)
		return ChatMain["f" .. v17](...)
	end

	local specialKeyPressed = Instance.new("BindableEvent")
	specialKeyPressed.Name = "SpecialKeyPressed"
	v.ChatWindow.SpecialKeyPressed = specialKeyPressed

	local v18 = "SpecialKeyPressed"
	specialKeyPressed.Event:connect(function(...)
		ChatMain[v18](ChatMain, ...)
	end)

	SetCoreGuiChatConnections(v)
end

function SetCoreGuiChatConnections(p)
	local count = 0

	while count < 10 do
		count += 1
		local success, result = pcall(function()
			StarterGui:SetCore("CoreGuiChatConnections", p)
		end)

		if success then
			break
		end

		if not success and count == 10 then
			error("Error calling SetCore CoreGuiChatConnections: " .. result)
		end

		wait()
	end
end

function checkBothChatTypesDisabled(): boolean
	if ChatSettings.BubbleChatEnabled == nil or ChatSettings.ClassicChatEnabled == nil then
		return false
	end

	return not (ChatSettings.BubbleChatEnabled or ChatSettings.ClassicChatEnabled)
end

if GuiService:IsTenFootInterface() then
	ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents").GetInitDataRequest:InvokeServer()

	return
end

if not checkBothChatTypesDisabled() then
	DoEverything()
	return
end

local v = { ChatWindow = {} }

v.ChatWindow.ChatTypes = {}
v.ChatWindow.ChatTypes.BubbleChatEnabled = false
v.ChatWindow.ChatTypes.ClassicChatEnabled = false
SetCoreGuiChatConnections(v)
