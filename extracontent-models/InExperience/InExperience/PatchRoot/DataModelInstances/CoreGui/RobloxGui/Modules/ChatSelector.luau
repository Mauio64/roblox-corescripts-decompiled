local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

RobloxGui:WaitForChild("Modules")

local StarterGui = game:GetService("StarterGui")

game:GetService("UserInputService")
game:GetService("GuiService")

local Players = game:GetService("Players")
local ChatUtil = require(RobloxGui.Modules.ChatUtil)
local ClassicChat = Players.ClassicChat
local BubbleChat = Players.BubbleChat
local VRService = game:GetService("VRService")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local _ = SharedFlags.FFlagChromeChatGamepadSupportFix
local NewChat = nil
local Visibility = nil
local t1 = {}
local t2 = {
	Visible = not VRService.VREnabled
}
local t5 = {
	ToggleVisibility = function(_) -- line: 39
		-- upvalues: NewChat (ref), t2 (copy)
		if NewChat then
			NewChat:ToggleVisibility()

			return
		end

		t2.Visible = not t2.Visible
	end,
	SetVisible = function(_, p3) -- line: 47
		-- upvalues: NewChat (ref), t2 (copy)
		if NewChat then
			NewChat:SetVisible(p3)

			return
		end

		t2.Visible = p3
	end,
	FocusChatBar = function(_) -- line: 55
		-- upvalues: NewChat (ref)
		if NewChat then
			NewChat:FocusChatBar()
		end
	end,
	FocusSelectChatBar = function(_: {[any]: any}, p5: ((...any) -> ...any)?, t4: {[any]: any}?) -- line: 61
		-- upvalues: NewChat (ref), FFlagEnableConsoleExpControls (copy)
		if NewChat and FFlagEnableConsoleExpControls then
			NewChat:FocusSelectChatBar(p5, t4)
		end
	end,
	EnterWhisperState = function(_, p7) -- line: 69
		-- upvalues: NewChat (ref)
		if NewChat then
			return NewChat:EnterWhisperState(p7)
		end
	end,
	GetVisibility = function(_) -- line: 75
		-- upvalues: NewChat (ref), t2 (copy)
		if NewChat then
			return NewChat:GetVisibility()
		end

		return t2.Visible
	end,
	GetMessageCount = function(_) -- line: 83
		-- upvalues: NewChat (ref)
		if NewChat then
			return NewChat:GetMessageCount()
		end

		return 0
	end,
	TopbarEnabledChanged = function(_, ...) -- line: 91
		-- upvalues: NewChat (ref)
		if NewChat then
			return NewChat:TopbarEnabledChanged(...)
		end
	end,
	IsFocused = function(_, p12) -- line: 97
		-- upvalues: NewChat (ref)
		if NewChat then
			return NewChat:IsFocused(p12)
		end

		return false
	end,
	ClassicChatEnabled = function(_) -- line: 105
		-- upvalues: NewChat (ref), ClassicChat (copy)
		if NewChat then
			return NewChat:ClassicChatEnabled()
		end

		return ClassicChat
	end,
	IsBubbleChatOnly = function(_) -- line: 113
		-- upvalues: NewChat (ref), BubbleChat (copy), ClassicChat (copy)
		if NewChat then
			return NewChat:IsBubbleChatOnly()
		end

		return BubbleChat and not ClassicChat
	end,
	IsDisabled = function(_) -- line: 120
		-- upvalues: NewChat (ref), BubbleChat (copy), ClassicChat (copy)
		if NewChat then
			return NewChat:IsDisabled()
		end

		return not (BubbleChat or ClassicChat)
	end
}

function t5.HideTemp(_: {[any]: any}, s1: string, b1: boolean) -- line: 127
	-- upvalues: t1 (copy), Visibility (ref), t5 (copy)
	local function isHideTempKeysEmpty() -- line: 128
		-- upvalues: t1 (copy)
		return next(t1) == nil
	end

	if next(t1) == nil then
		Visibility = t5:GetVisibility()
	end

	if b1 then
		t1[s1] = b1
	else
		t1[s1] = nil
	end

	t5:SetVisible(Visibility and next(t1) == nil)
end

t5.ChatBarFocusChanged = ChatUtil.Signal()
t5.ChatWindowToggled = ChatUtil.Signal()
t5.ChatActiveChanged = ChatUtil.Signal()
t5.ChatActiveChanged:connect(function(p16) -- line: 149
	-- upvalues: t5 (copy)
	t5:SetVisible(p16)
end)
t5.VisibilityStateChanged = ChatUtil.Signal()
t5.MessagesChanged = ChatUtil.Signal()
t5.BubbleChatOnlySet = ChatUtil.Signal()
t5.ChatDisabled = ChatUtil.Signal()

local u18 = false
local t7 = {}

local function MakeSystemMessageQueueingFunction(p17) -- line: 163
	-- upvalues: u18 (ref), t7 (copy)
	if u18 then
		return
	end

	table.insert(t7, p17)
end
local function NonFunc() -- line: 168
end

StarterGui:RegisterSetCore("ChatMakeSystemMessage", MakeSystemMessageQueueingFunction)
StarterGui:RegisterSetCore("ChatWindowPosition", NonFunc)
StarterGui:RegisterGetCore("ChatWindowPosition", NonFunc)
StarterGui:RegisterSetCore("ChatWindowSize", NonFunc)
StarterGui:RegisterGetCore("ChatWindowSize", NonFunc)
StarterGui:RegisterSetCore("ChatBarDisabled", NonFunc)
StarterGui:RegisterGetCore("ChatBarDisabled", NonFunc)
StarterGui:RegisterGetCore("ChatActive", function() -- line: 178
	-- upvalues: t5 (copy)
	return t5:GetVisibility()
end)
StarterGui:RegisterSetCore("ChatActive", function(p18) -- line: 181
	-- upvalues: t5 (copy)
	t5.ChatActiveChanged:fire(p18)
end)

local function ConnectSignals(p19, p20, p21) -- line: 186
	if p19[p21] then
		p19[p21]:connect(function(...) -- line: 189
			-- upvalues: p20 (copy), p21 (copy)
			p20[p21]:fire(...)
		end)
	end
end

coroutine.wrap(function() -- line: 193
	-- upvalues: NewChat (ref), RobloxGui (copy), t5 (copy), Players (copy), StarterGui (copy), t2 (copy), u18 (ref), t7 (copy)
	NewChat = require(RobloxGui.Modules.NewChat)

	local v50 = NewChat
	local v51 = t5

	if v50.ChatBarFocusChanged then
		local s2 = "ChatBarFocusChanged"

		v50.ChatBarFocusChanged:connect(function(...) -- line: 189
			-- upvalues: v51 (copy), s2 (copy)
			v51[s2]:fire(...)
		end)
	end

	local v53 = NewChat
	local v54 = t5

	if v53.VisibilityStateChanged then
		local s3 = "VisibilityStateChanged"

		v53.VisibilityStateChanged:connect(function(...) -- line: 189
			-- upvalues: v54 (copy), s3 (copy)
			v54[s3]:fire(...)
		end)
	end

	local v56 = NewChat
	local v57 = t5

	if v56.ChatWindowToggled then
		local s4 = "ChatWindowToggled"

		v56.ChatWindowToggled:connect(function(...) -- line: 189
			-- upvalues: v57 (copy), s4 (copy)
			v57[s4]:fire(...)
		end)
	end

	local v59 = NewChat
	local v60 = t5

	if v59.ChatActiveChanged then
		local s5 = "ChatActiveChanged"

		v59.ChatActiveChanged:connect(function(...) -- line: 189
			-- upvalues: v60 (copy), s5 (copy)
			v60[s5]:fire(...)
		end)
	end

	local v62 = NewChat
	local v63 = t5

	if v62.BubbleChatOnlySet then
		local s6 = "BubbleChatOnlySet"

		v62.BubbleChatOnlySet:connect(function(...) -- line: 189
			-- upvalues: v63 (copy), s6 (copy)
			v63[s6]:fire(...)
		end)
	end

	local v65 = NewChat
	local v66 = t5

	if v65.ChatDisabled then
		local s7 = "ChatDisabled"

		v65.ChatDisabled:connect(function(...) -- line: 189
			-- upvalues: v66 (copy), s7 (copy)
			v66[s7]:fire(...)
		end)
	end

	while Players.LocalPlayer == nil do
		Players.ChildAdded:wait()
	end

	local _ = Players.LocalPlayer
	local v69 = NewChat
	local v70 = t5

	if v69.MessagesChanged then
		local s8 = "MessagesChanged"

		v69.MessagesChanged:connect(function(...) -- line: 189
			-- upvalues: v70 (copy), s8 (copy)
			v70[s8]:fire(...)
		end)
	end

	StarterGui:RegisterGetCore("UseNewLuaChat", function() -- line: 208
		return true
	end)
	NewChat:SetVisible(t2.Visible)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat))
	u18 = true

	for _, v in pairs(t7) do
		pcall(function() -- line: 215
			-- upvalues: StarterGui (copy), v (copy)
			StarterGui:SetCore("ChatMakeSystemMessage", v)
		end)
	end
end)()

return t5
