local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local u6 = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
local u7 = false
local ClassicChat = Players.ClassicChat
local BubbleChat = Players.BubbleChat
local ChatUtil = require(RobloxGui.Modules.ChatUtil)
local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar
local v17 = ExpChat.Stores.GetTransparencyStore(false)

local function shouldForceLegacyChatToBeHidden() -- line: 35
	-- upvalues: u6 (ref), TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy)
	u6 = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

	if getFFlagExpChatAlwaysRunTCS() then
		return u6
	end

	return false
end

local t1 = {}
local t2 = {
	Visible = true,
	MessageCount = 0,
	TopbarEnabled = true,
	CoreGuiEnabled = true
}
local t3 = {
	ChatWindow = nil,
	GetCore = nil,
	SetCore = nil
}
local t4 = {}
local t5 = {}

local function FindInCollectionByKeyAndType(p1, p2, p3) -- line: 62
	if p1 and (p1[p2] and p1[p2]:IsA(p3)) then
		return p1[p2]
	end

	return nil
end
local function DispatchEvent(p4, ...) -- line: 69
	-- upvalues: t3 (copy)
	local ChatWindow = t3.ChatWindow
	local v38 = if not ChatWindow or (not ChatWindow[p4] or not ChatWindow[p4]:IsA("BindableEvent")) then nil else ChatWindow[p4]

	if v38 then
		v38:Fire(...)

		return true
	end

	return false
end
local function AttemptInvokeFunction(p5, ...) -- line: 78
	-- upvalues: t3 (copy)
	local ChatWindow = t3.ChatWindow
	local v41 = if not ChatWindow or (not ChatWindow[p5] or not ChatWindow[p5]:IsA("BindableFunction")) then nil else ChatWindow[p5]

	if v41 then
		return true, v41:Invoke()
	end

	return false, nil
end
local function DoConnectGetCore(p6) -- line: 87
	-- upvalues: StarterGui (copy), t3 (copy)
	StarterGui:RegisterGetCore(p6, function(p7) -- line: 88
		-- upvalues: t3 (copy), p6 (copy)
		local GetCore = t3.GetCore
		local v103 = p6
		local v104 = if not GetCore or (not GetCore[v103] or not GetCore[v103]:IsA("BindableFunction")) then nil else GetCore[v103]
		local v105 = nil

		if v104 then
			v105 = v104:Invoke(p7)
		end

		return v105
	end)
end

function t1.ToggleVisibility(_) -- line: 99
	-- upvalues: t2 (copy), u6 (ref), TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy), t1 (copy), DispatchEvent (copy), FFlagExpChatWindowSyncUnibar (copy), ExpChat (copy), v17 (copy)
	t2.Visible = not t2.Visible
	u6 = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

	if not not getFFlagExpChatAlwaysRunTCS() and u6 then
		t1.VisibilityStateChanged:fire(t2.Visible)
	elseif not DispatchEvent("ToggleVisibility") then
		t1.VisibilityStateChanged:fire(t2.Visible)
	end

	if not FFlagExpChatWindowSyncUnibar then
		ExpChat.Events.ChatTopBarButtonActivated(t2.Visible)
	end

	if t2.Visible then
		v17.resetAllTransparency()
	end

	t1.ChatWindowToggled:fire(t2.Visible)
end
function t1.SetVisible(_, p10) -- line: 121
	-- upvalues: t2 (copy), FFlagExpChatWindowSyncUnibar (copy), ExpChat (copy), v17 (copy), t1 (copy), u6 (ref), TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy), DispatchEvent (copy)
	t2.Visible = p10

	if not FFlagExpChatWindowSyncUnibar then
		ExpChat.Events.ChatTopBarButtonActivated(t2.Visible)
	end

	if t2.Visible then
		v17.resetAllTransparency()
	end

	t1.ChatWindowToggled:fire(t2.Visible)
	u6 = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

	if not not getFFlagExpChatAlwaysRunTCS() and u6 then
		DispatchEvent("SetVisible", false)
		t1.VisibilityStateChanged:fire(false)

		return
	end

	if not DispatchEvent("SetVisible", t2.Visible) then
		t1.VisibilityStateChanged:fire(t2.Visible)
	end
end
function t1.FocusChatBar(_) -- line: 144
	-- upvalues: DispatchEvent (copy), ExpChat (copy)
	DispatchEvent("FocusChatBar")
	ExpChat.Events.ChatTopBarFocusActivated()
end
function t1.FocusSelectChatBar(_: {[any]: any}, p12: ((...any) -> ...any)?, t7: {[any]: any}?) -- line: 150
	-- upvalues: FFlagEnableConsoleExpControls (copy), ExpChat (copy)
	if FFlagEnableConsoleExpControls then
		ExpChat.Events.ChatTopBarFocusSelect(p12, t7)
	end
end
function t1.EnterWhisperState(_, p14) -- line: 156
	-- upvalues: DispatchEvent (copy)
	return DispatchEvent("EnterWhisperState", p14)
end
function t1.GetVisibility(_) -- line: 160
	-- upvalues: AttemptInvokeFunction (copy), t2 (copy)
	local v53, v54 = AttemptInvokeFunction("GetVisibility")

	if v53 then
		return v54
	end

	return t2.Visible
end
function t1.GetMessageCount(_) -- line: 169
	-- upvalues: AttemptInvokeFunction (copy), t2 (copy)
	local v56, v57 = AttemptInvokeFunction("GetMessageCount")

	if v56 then
		return v57
	end

	return t2.MessageCount
end
function t1.TopbarEnabledChanged(_, p18) -- line: 178
	-- upvalues: t2 (copy), DispatchEvent (copy)
	t2.TopbarEnabled = p18
	DispatchEvent("TopbarEnabledChanged", t2.TopbarEnabled)
end
function t1.IsFocused(_, p20) -- line: 183
	-- upvalues: AttemptInvokeFunction (copy)
	local v62, v63 = AttemptInvokeFunction("IsFocused", p20)

	if v62 then
		return v63
	end

	return false
end
function t1.ClassicChatEnabled(_) -- line: 192
	-- upvalues: ClassicChat (ref)
	return ClassicChat
end
function t1.IsBubbleChatOnly(_) -- line: 196
	-- upvalues: BubbleChat (ref), ClassicChat (ref)
	return BubbleChat and not ClassicChat
end
function t1.IsDisabled(_) -- line: 200
	-- upvalues: BubbleChat (ref), ClassicChat (ref)
	return not (BubbleChat or ClassicChat)
end
function SetInitialChatTypes(p24) -- line: 204
	-- upvalues: u7 (ref), BubbleChat (ref), ClassicChat (ref), t1 (copy)
	if u7 then
		return
	end

	u7 = true

	local BubbleChatEnabled = p24.BubbleChatEnabled
	local ClassicChatEnabled = p24.ClassicChatEnabled

	if type(BubbleChatEnabled) == "boolean" then
		BubbleChat = BubbleChatEnabled
	end

	if type(ClassicChatEnabled) == "boolean" then
		ClassicChat = ClassicChatEnabled
	end

	if not ClassicChat and not BubbleChat then
		t1.ChatDisabled:fire()
	end

	if BubbleChat and not ClassicChat then
		t1.BubbleChatOnlySet:fire()
	end
end

t1.ChatBarFocusChanged = ChatUtil.Signal()
t1.VisibilityStateChanged = ChatUtil.Signal()
t1.ChatWindowToggled = ChatUtil.Signal()
t1.MessagesChanged = ChatUtil.Signal()
t1.BubbleChatOnlySet = ChatUtil.Signal()
t1.ChatDisabled = ChatUtil.Signal()

local Chat = game:GetService("Chat")

Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function() -- line: 237
	-- upvalues: Chat (copy), DispatchEvent (copy), t1 (copy)
	if Chat.IsAutoMigrated and not DispatchEvent("SetVisible", false) then
		t1.VisibilityStateChanged:fire(false)
	end
end)
StarterGui.CoreGuiChangedSignal:connect(function(p25, p26) -- line: 246
	-- upvalues: t2 (copy), DispatchEvent (copy)
	if p25 == Enum.CoreGuiType.All or p25 == Enum.CoreGuiType.Chat then
		t2.CoreGuiEnabled = p26
		DispatchEvent("CoreGuiEnabled", t2.CoreGuiEnabled)
	end
end)
GuiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
GuiService.SpecialKeyPressed:connect(function(p27, p28) -- line: 254
	-- upvalues: GuiService (copy), u6 (ref), TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy), DispatchEvent (copy)
	if GuiService.MenuIsOpen then
		return
	end

	u6 = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

	if not getFFlagExpChatAlwaysRunTCS() or not u6 then
		DispatchEvent("SpecialKeyPressed", p27, p28)
	end
end)

function DoConnectSetCore(p29) -- line: 264
	-- upvalues: StarterGui (copy), t3 (copy), t5 (copy)
	StarterGui:RegisterSetCore(p29, function(p30) -- line: 265
		-- upvalues: t3 (copy), p29 (copy), t5 (copy)
		local SetCore = t3.SetCore
		local v108 = p29
		local v109 = if not SetCore or (not SetCore[v108] or not SetCore[v108]:IsA("BindableEvent")) then nil else SetCore[v108]

		if v109 then
			v109:Fire(p30)

			return
		end

		if t5[p29] == nil then
			t5[p29] = {}
		end

		table.insert(t5[p29], p30)
	end)
end

DoConnectSetCore("ChatMakeSystemMessage")
DoConnectSetCore("ChatWindowPosition")
DoConnectSetCore("ChatWindowSize")
DoConnectSetCore("ChatBarDisabled")

local s1 = "ChatWindowPosition"

StarterGui:RegisterGetCore("ChatWindowPosition", function(p31) -- line: 88
	-- upvalues: t3 (copy), s1 (copy)
	local GetCore = t3.GetCore
	local v77 = s1
	local v78 = if not GetCore or (not GetCore[v77] or not GetCore[v77]:IsA("BindableFunction")) then nil else GetCore[v77]
	local v79 = nil

	if v78 then
		v79 = v78:Invoke(p31)
	end

	return v79
end)

local s2 = "ChatWindowSize"

StarterGui:RegisterGetCore("ChatWindowSize", function(p32) -- line: 88
	-- upvalues: t3 (copy), s2 (copy)
	local GetCore = t3.GetCore
	local v82 = s2
	local v83 = if not GetCore or (not GetCore[v82] or not GetCore[v82]:IsA("BindableFunction")) then nil else GetCore[v82]
	local v84 = nil

	if v83 then
		v84 = v83:Invoke(p32)
	end

	return v84
end)

local s3 = "ChatBarDisabled"

StarterGui:RegisterGetCore("ChatBarDisabled", function(p33) -- line: 88
	-- upvalues: t3 (copy), s3 (copy)
	local GetCore = t3.GetCore
	local v87 = s3
	local v88 = if not GetCore or (not GetCore[v87] or not GetCore[v87]:IsA("BindableFunction")) then nil else GetCore[v87]
	local v89 = nil

	if v88 then
		v89 = v88:Invoke(p33)
	end

	return v89
end)

local function RegisterCoreGuiConnections(p34) -- line: 287
	-- upvalues: t4 (ref), t3 (copy), t1 (copy), t2 (copy), t5 (copy)
	if type(p34) == "table" then
		local ChatWindow = p34.ChatWindow
		local SetCore = p34.SetCore
		local GetCore = p34.GetCore

		if type(ChatWindow) == "table" then
			for _, v in pairs(t4) do
				v:disconnect()
			end

			if type(ChatWindow.ChatTypes) == "table" then
				SetInitialChatTypes(ChatWindow.ChatTypes)
			end

			t4 = {}
			t3.ChatWindow = {}
			t3.ChatWindow.ToggleVisibility = if not ChatWindow or (not ChatWindow.ToggleVisibility or not ChatWindow.ToggleVisibility:IsA("BindableEvent")) then nil else ChatWindow.ToggleVisibility
			t3.ChatWindow.SetVisible = if not ChatWindow or (not ChatWindow.SetVisible or not ChatWindow.SetVisible:IsA("BindableEvent")) then nil else ChatWindow.SetVisible
			t3.ChatWindow.FocusChatBar = if not ChatWindow or (not ChatWindow.FocusChatBar or not ChatWindow.FocusChatBar:IsA("BindableEvent")) then nil else ChatWindow.FocusChatBar
			t3.ChatWindow.EnterWhisperState = if not ChatWindow or (not ChatWindow.EnterWhisperState or not ChatWindow.EnterWhisperState:IsA("BindableEvent")) then nil else ChatWindow.EnterWhisperState
			t3.ChatWindow.TopbarEnabledChanged = if not ChatWindow or (not ChatWindow.TopbarEnabledChanged or not ChatWindow.TopbarEnabledChanged:IsA("BindableEvent")) then nil else ChatWindow.TopbarEnabledChanged
			t3.ChatWindow.IsFocused = if not ChatWindow or (not ChatWindow.IsFocused or not ChatWindow.IsFocused:IsA("BindableFunction")) then nil else ChatWindow.IsFocused
			t3.ChatWindow.SpecialKeyPressed = if not ChatWindow or (not ChatWindow.SpecialKeyPressed or not ChatWindow.SpecialKeyPressed:IsA("BindableEvent")) then nil else ChatWindow.SpecialKeyPressed

			local function DoConnect(p35) -- line: 320
				-- upvalues: t3 (copy), ChatWindow (copy), t1 (copy), t4 (ref)
				local ChatWindow2 = t3.ChatWindow
				local v112 = ChatWindow

				ChatWindow2[p35] = if not v112 or (not v112[p35] or not v112[p35]:IsA("BindableEvent")) then nil else v112[p35]

				if t3.ChatWindow[p35] then
					local v113 = t3.ChatWindow[p35].Event:connect(function(...) -- line: 324
						-- upvalues: t1 (copy), p35 (copy)
						t1[p35]:fire(...)
					end)

					table.insert(t4, v113)
				end
			end

			DoConnect("ChatBarFocusChanged")
			DoConnect("VisibilityStateChanged")
			DoConnect("ChatWindowToggled")
			DoConnect("MessagesChanged")
			t3.ChatWindow.MessagePosted = if not ChatWindow or (not ChatWindow.MessagePosted or not ChatWindow.MessagePosted:IsA("BindableEvent")) then nil else ChatWindow.MessagePosted

			if t3.ChatWindow.MessagePosted then
				local v97 = t3.ChatWindow.MessagePosted.Event:connect(function(p36) -- line: 340
					game:GetService("Players"):Chat(p36)
				end)

				table.insert(t4, v97)
			end

			t1:SetVisible(t2.Visible)
			t1:TopbarEnabledChanged(t2.TopbarEnabled)

			local v98 = if not ChatWindow or (not ChatWindow.CoreGuiEnabled or not ChatWindow.CoreGuiEnabled:IsA("BindableEvent")) then nil else ChatWindow.CoreGuiEnabled

			if v98 then
				t3.ChatWindow.CoreGuiEnabled = v98
				v98:Fire(t2.CoreGuiEnabled)
			end
		else
			error("Table 'ChatWindow' must be provided!")
		end

		if type(SetCore) == "table" and type(GetCore) == "table" then
			t3.SetCore = {}
			t3.GetCore = {}

			local function addSetCore(p37) -- line: 362
				-- upvalues: SetCore (copy), t3 (copy), t5 (copy)
				local v116 = SetCore
				local v117 = if not v116 or (not v116[p37] or not v116[p37]:IsA("BindableEvent")) then nil else v116[p37]

				if v117 then
					t3.SetCore[p37] = v117

					if t5[p37] then
						for _, v in pairs(t5[p37]) do
							v117:Fire(v)
						end

						t5[p37] = nil
					end
				end
			end

			addSetCore("ChatMakeSystemMessage")
			addSetCore("ChatWindowPosition")
			addSetCore("ChatWindowSize")
			addSetCore("ChatBarDisabled")
			t3.GetCore.ChatWindowPosition = if not GetCore or (not GetCore.ChatWindowPosition or not GetCore.ChatWindowPosition:IsA("BindableFunction")) then nil else GetCore.ChatWindowPosition
			t3.GetCore.ChatWindowSize = if not GetCore or (not GetCore.ChatWindowSize or not GetCore.ChatWindowSize:IsA("BindableFunction")) then nil else GetCore.ChatWindowSize
			t3.GetCore.ChatBarDisabled = if not GetCore or (not GetCore.ChatBarDisabled or not GetCore.ChatBarDisabled:IsA("BindableFunction")) then nil else GetCore.ChatBarDisabled

			return
		end

		if type(SetCore) ~= "nil" or type(GetCore) ~= "nil" then
			error("Both 'SetCore' and 'GetCore' must be tables if provided!")
		end
	end
end

ExpChat.listenToDispatch(function(p38) -- line: 392
	-- upvalues: t1 (copy)
	if p38.type == "FocusChatHotKeyActivated" then
		t1:SetVisible(true)
	end
end)
StarterGui:RegisterSetCore("CoreGuiChatConnections", RegisterCoreGuiConnections)

return t1
