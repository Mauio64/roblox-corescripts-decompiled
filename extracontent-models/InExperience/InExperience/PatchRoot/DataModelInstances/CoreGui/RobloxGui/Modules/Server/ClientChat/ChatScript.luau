local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Chat = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local function DoEverything() -- line: 16
	-- upvalues: ChatSettings (copy)
	local ChatMain = require(script:WaitForChild("ChatMain"))
	local t1 = {
		ChatWindow = {},
		SetCore = {},
		GetCore = {}
	}

	t1.ChatWindow.ChatTypes = {}
	t1.ChatWindow.ChatTypes.BubbleChatEnabled = ChatSettings.BubbleChatEnabled
	t1.ChatWindow.ChatTypes.ClassicChatEnabled = ChatSettings.ClassicChatEnabled

	local function ConnectEvent(p1) -- line: 29
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = p1
		t1.ChatWindow[p1] = BindableEvent
		BindableEvent.Event:connect(function(...) -- line: 34
			-- upvalues: ChatMain (copy), p1 (copy)
			ChatMain[p1](ChatMain, ...)
		end)
	end
	local function ConnectFunction(p2) -- line: 37
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableFunction = Instance.new("BindableFunction")

		BindableFunction.Name = p2
		t1.ChatWindow[p2] = BindableFunction

		function BindableFunction.OnInvoke(...) -- line: 42
			-- upvalues: ChatMain (copy), p2 (copy)
			return ChatMain[p2](ChatMain, ...)
		end
	end
	local function ReverseConnectEvent(p3) -- line: 45
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = p3
		t1.ChatWindow[p3] = BindableEvent
		ChatMain[p3]:connect(function(...) -- line: 50
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(...)
		end)
	end
	local function ConnectSignal(p4) -- line: 53
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = p4
		t1.ChatWindow[p4] = BindableEvent
		BindableEvent.Event:connect(function(...) -- line: 58
			-- upvalues: ChatMain (copy), p4 (copy)
			ChatMain[p4]:fire(...)
		end)
	end
	local function ConnectSetCore(p5) -- line: 61
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = p5
		t1.SetCore[p5] = BindableEvent
		BindableEvent.Event:connect(function(...) -- line: 66
			-- upvalues: ChatMain (copy), p5 (copy)
			ChatMain[p5 .. "Event"]:fire(...)
		end)
	end
	local function ConnectGetCore(p6) -- line: 69
		-- upvalues: t1 (copy), ChatMain (copy)
		local BindableFunction = Instance.new("BindableFunction")

		BindableFunction.Name = p6
		t1.GetCore[p6] = BindableFunction

		function BindableFunction.OnInvoke(...) -- line: 74
			-- upvalues: ChatMain (copy), p6 (copy)
			return ChatMain["f" .. p6](...)
		end
	end

	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ToggleVisibility"
	t1.ChatWindow.ToggleVisibility = BindableEvent

	local s1 = "ToggleVisibility"

	BindableEvent.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s1 (copy)
		ChatMain[s1](ChatMain, ...)
	end)

	local BindableEvent2 = Instance.new("BindableEvent")

	BindableEvent2.Name = "SetVisible"
	t1.ChatWindow.SetVisible = BindableEvent2

	local s2 = "SetVisible"

	BindableEvent2.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s2 (copy)
		ChatMain[s2](ChatMain, ...)
	end)

	local BindableEvent3 = Instance.new("BindableEvent")

	BindableEvent3.Name = "FocusChatBar"
	t1.ChatWindow.FocusChatBar = BindableEvent3

	local s3 = "FocusChatBar"

	BindableEvent3.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s3 (copy)
		ChatMain[s3](ChatMain, ...)
	end)

	local BindableEvent4 = Instance.new("BindableEvent")

	BindableEvent4.Name = "EnterWhisperState"
	t1.ChatWindow.EnterWhisperState = BindableEvent4

	local s4 = "EnterWhisperState"

	BindableEvent4.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s4 (copy)
		ChatMain[s4](ChatMain, ...)
	end)

	local BindableFunction = Instance.new("BindableFunction")

	BindableFunction.Name = "GetVisibility"
	t1.ChatWindow.GetVisibility = BindableFunction

	local s5 = "GetVisibility"

	function BindableFunction.OnInvoke(...) -- line: 42
		-- upvalues: ChatMain (copy), s5 (copy)
		return ChatMain[s5](ChatMain, ...)
	end

	local BindableFunction2 = Instance.new("BindableFunction")

	BindableFunction2.Name = "GetMessageCount"
	t1.ChatWindow.GetMessageCount = BindableFunction2

	local s6 = "GetMessageCount"

	function BindableFunction2.OnInvoke(...) -- line: 42
		-- upvalues: ChatMain (copy), s6 (copy)
		return ChatMain[s6](ChatMain, ...)
	end

	local BindableEvent5 = Instance.new("BindableEvent")

	BindableEvent5.Name = "TopbarEnabledChanged"
	t1.ChatWindow.TopbarEnabledChanged = BindableEvent5

	local s7 = "TopbarEnabledChanged"

	BindableEvent5.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s7 (copy)
		ChatMain[s7](ChatMain, ...)
	end)

	local BindableFunction3 = Instance.new("BindableFunction")

	BindableFunction3.Name = "IsFocused"
	t1.ChatWindow.IsFocused = BindableFunction3

	local s8 = "IsFocused"

	function BindableFunction3.OnInvoke(...) -- line: 42
		-- upvalues: ChatMain (copy), s8 (copy)
		return ChatMain[s8](ChatMain, ...)
	end

	local BindableEvent6 = Instance.new("BindableEvent")

	BindableEvent6.Name = "ChatBarFocusChanged"
	t1.ChatWindow.ChatBarFocusChanged = BindableEvent6
	ChatMain.ChatBarFocusChanged:connect(function(...) -- line: 50
		-- upvalues: BindableEvent6 (copy)
		BindableEvent6:Fire(...)
	end)

	local BindableEvent7 = Instance.new("BindableEvent")

	BindableEvent7.Name = "VisibilityStateChanged"
	t1.ChatWindow.VisibilityStateChanged = BindableEvent7
	ChatMain.VisibilityStateChanged:connect(function(...) -- line: 50
		-- upvalues: BindableEvent7 (copy)
		BindableEvent7:Fire(...)
	end)

	local BindableEvent8 = Instance.new("BindableEvent")

	BindableEvent8.Name = "MessagesChanged"
	t1.ChatWindow.MessagesChanged = BindableEvent8
	ChatMain.MessagesChanged:connect(function(...) -- line: 50
		-- upvalues: BindableEvent8 (copy)
		BindableEvent8:Fire(...)
	end)

	local BindableEvent9 = Instance.new("BindableEvent")

	BindableEvent9.Name = "MessagePosted"
	t1.ChatWindow.MessagePosted = BindableEvent9
	ChatMain.MessagePosted:connect(function(...) -- line: 50
		-- upvalues: BindableEvent9 (copy)
		BindableEvent9:Fire(...)
	end)

	local BindableEvent10 = Instance.new("BindableEvent")

	BindableEvent10.Name = "CoreGuiEnabled"
	t1.ChatWindow.CoreGuiEnabled = BindableEvent10

	local s9 = "CoreGuiEnabled"

	BindableEvent10.Event:connect(function(...) -- line: 58
		-- upvalues: ChatMain (copy), s9 (copy)
		ChatMain[s9]:fire(...)
	end)

	local BindableEvent11 = Instance.new("BindableEvent")

	BindableEvent11.Name = "ChatMakeSystemMessage"
	t1.SetCore.ChatMakeSystemMessage = BindableEvent11

	local s10 = "ChatMakeSystemMessage"

	BindableEvent11.Event:connect(function(...) -- line: 66
		-- upvalues: ChatMain (copy), s10 (copy)
		ChatMain[s10 .. "Event"]:fire(...)
	end)

	local BindableEvent12 = Instance.new("BindableEvent")

	BindableEvent12.Name = "ChatWindowPosition"
	t1.SetCore.ChatWindowPosition = BindableEvent12

	local s11 = "ChatWindowPosition"

	BindableEvent12.Event:connect(function(...) -- line: 66
		-- upvalues: ChatMain (copy), s11 (copy)
		ChatMain[s11 .. "Event"]:fire(...)
	end)

	local BindableEvent13 = Instance.new("BindableEvent")

	BindableEvent13.Name = "ChatWindowSize"
	t1.SetCore.ChatWindowSize = BindableEvent13

	local s12 = "ChatWindowSize"

	BindableEvent13.Event:connect(function(...) -- line: 66
		-- upvalues: ChatMain (copy), s12 (copy)
		ChatMain[s12 .. "Event"]:fire(...)
	end)

	local BindableFunction4 = Instance.new("BindableFunction")

	BindableFunction4.Name = "ChatWindowPosition"
	t1.GetCore.ChatWindowPosition = BindableFunction4

	local s13 = "ChatWindowPosition"

	function BindableFunction4.OnInvoke(...) -- line: 74
		-- upvalues: ChatMain (copy), s13 (copy)
		return ChatMain["f" .. s13](...)
	end

	local BindableFunction5 = Instance.new("BindableFunction")

	BindableFunction5.Name = "ChatWindowSize"
	t1.GetCore.ChatWindowSize = BindableFunction5

	local s14 = "ChatWindowSize"

	function BindableFunction5.OnInvoke(...) -- line: 74
		-- upvalues: ChatMain (copy), s14 (copy)
		return ChatMain["f" .. s14](...)
	end

	local BindableEvent14 = Instance.new("BindableEvent")

	BindableEvent14.Name = "ChatBarDisabled"
	t1.SetCore.ChatBarDisabled = BindableEvent14

	local s15 = "ChatBarDisabled"

	BindableEvent14.Event:connect(function(...) -- line: 66
		-- upvalues: ChatMain (copy), s15 (copy)
		ChatMain[s15 .. "Event"]:fire(...)
	end)

	local BindableFunction6 = Instance.new("BindableFunction")

	BindableFunction6.Name = "ChatBarDisabled"
	t1.GetCore.ChatBarDisabled = BindableFunction6

	local s16 = "ChatBarDisabled"

	function BindableFunction6.OnInvoke(...) -- line: 74
		-- upvalues: ChatMain (copy), s16 (copy)
		return ChatMain["f" .. s16](...)
	end

	local BindableEvent15 = Instance.new("BindableEvent")

	BindableEvent15.Name = "SpecialKeyPressed"
	t1.ChatWindow.SpecialKeyPressed = BindableEvent15

	local s17 = "SpecialKeyPressed"

	BindableEvent15.Event:connect(function(...) -- line: 34
		-- upvalues: ChatMain (copy), s17 (copy)
		ChatMain[s17](ChatMain, ...)
	end)
	SetCoreGuiChatConnections(t1)
end

function SetCoreGuiChatConnections(p7) -- line: 107
	-- upvalues: StarterGui (copy)
	local n1 = 0

	while n1 < 10 do
		n1 += 1

		local ok, result = pcall(function() -- line: 111
			-- upvalues: StarterGui (copy), p7 (copy)
			StarterGui:SetCore("CoreGuiChatConnections", p7)
		end)

		if ok then
			return
		end

		if not ok and n1 == 10 then
			error("Error calling SetCore CoreGuiChatConnections: " .. result)
		end

		wait()
	end
end
function checkBothChatTypesDisabled() -- line: 122
	-- upvalues: ChatSettings (copy)
	if ChatSettings.BubbleChatEnabled ~= nil and ChatSettings.ClassicChatEnabled ~= nil then
		return not (ChatSettings.BubbleChatEnabled or ChatSettings.ClassicChatEnabled)
	end

	return false
end

if not GuiService:IsTenFootInterface() then
	if not checkBothChatTypesDisabled() then
		DoEverything()

		return
	end

	local t2 = {
		ChatWindow = {}
	}

	t2.ChatWindow.ChatTypes = {}
	t2.ChatWindow.ChatTypes.BubbleChatEnabled = false
	t2.ChatWindow.ChatTypes.ClassicChatEnabled = false
	SetCoreGuiChatConnections(t2)

	return
end

ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents").GetInitDataRequest:InvokeServer()
