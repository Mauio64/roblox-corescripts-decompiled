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
local FFlagChromeChatGamepadSupportFix = SharedFlags.FFlagChromeChatGamepadSupportFix

local v = nil

local visibility = nil
local v2 = {}
local v3 = {
	Visible = not VRService.VREnabled
}
local ChatSelector = {}

function ChatSelector:ToggleVisibility()
	if v then
		v:ToggleVisibility()
	else
		v3.Visible = not v3.Visible
	end
end

function ChatSelector:SetVisible(visible)
	if v then
		v:SetVisible(visible)
	else
		v3.Visible = visible
	end
end

function ChatSelector:FocusChatBar()
	if v then
		v:FocusChatBar()
	end
end

function ChatSelector:FocusSelectChatBar(callback, p)
	if v and FFlagEnableConsoleExpControls then
		v:FocusSelectChatBar(callback, p)
	end
end

function ChatSelector:EnterWhisperState(p)
	if v then
		return v:EnterWhisperState(p)
	end
end

function ChatSelector:GetVisibility()
	if v then
		return v:GetVisibility()
	end

	return v3.Visible
end

function ChatSelector:GetMessageCount()
	if v then
		return v:GetMessageCount()
	end

	return 0
end

function ChatSelector:TopbarEnabledChanged(...)
	if v then
		return v:TopbarEnabledChanged(...)
	end
end

function ChatSelector:IsFocused(p)
	if v then
		return v:IsFocused(p)
	end

	return false
end

function ChatSelector:ClassicChatEnabled()
	if v then
		return v:ClassicChatEnabled()
	end

	return ClassicChat
end

function ChatSelector:IsBubbleChatOnly()
	if v then
		return v:IsBubbleChatOnly()
	end

	return BubbleChat and not ClassicChat
end

function ChatSelector:IsDisabled()
	if v then
		return v:IsDisabled()
	end

	return not (BubbleChat or ClassicChat)
end

function ChatSelector.HideTemp(_, p: string, flag: boolean)
	local function isHideTempKeysEmpty(): boolean -- 2 equivalent calls inferred from this helper
		return next(v2) == nil
	end

	if isHideTempKeysEmpty() then -- inferred equivalent call
		visibility = ChatSelector:GetVisibility()
	end

	if flag then
		v2[p] = flag
	else
		v2[p] = nil
	end

	ChatSelector:SetVisible(visibility and isHideTempKeysEmpty()) -- inferred equivalent call
end

ChatSelector.ChatBarFocusChanged = ChatUtil.Signal()
ChatSelector.ChatWindowToggled = ChatUtil.Signal()
ChatSelector.ChatActiveChanged = ChatUtil.Signal()
ChatSelector.ChatActiveChanged:connect(function(p)
	ChatSelector:SetVisible(p)
end)

ChatSelector.VisibilityStateChanged = ChatUtil.Signal()
ChatSelector.MessagesChanged = ChatUtil.Signal()

ChatSelector.BubbleChatOnlySet = ChatUtil.Signal()
ChatSelector.ChatDisabled = ChatUtil.Signal()

local flag = false
local v4 = {}
local function MakeSystemMessageQueueingFunction(p)
	if flag then
		return
	end

	table.insert(v4, p)
end

local function NonFunc() end
StarterGui:RegisterSetCore("ChatMakeSystemMessage", MakeSystemMessageQueueingFunction)
StarterGui:RegisterSetCore("ChatWindowPosition", NonFunc)
StarterGui:RegisterGetCore("ChatWindowPosition", NonFunc)
StarterGui:RegisterSetCore("ChatWindowSize", NonFunc)
StarterGui:RegisterGetCore("ChatWindowSize", NonFunc)
StarterGui:RegisterSetCore("ChatBarDisabled", NonFunc)
StarterGui:RegisterGetCore("ChatBarDisabled", NonFunc)

StarterGui:RegisterGetCore("ChatActive", function()
	return ChatSelector:GetVisibility()
end)

StarterGui:RegisterSetCore("ChatActive", function(p)
	ChatSelector.ChatActiveChanged:fire(p)
end)

local function ConnectSignals(p, p2, p3)
	if p[p3] then
		p[p3]:connect(function(...)
			p2[p3]:fire(...)
		end)
	end
end

coroutine.wrap(function()
	local NewChat = require(RobloxGui.Modules.NewChat)
	v = NewChat

	local v5 = v
	local v6 = ChatSelector

	if v5.ChatBarFocusChanged then
		local v7 = "ChatBarFocusChanged"
		v5.ChatBarFocusChanged:connect(function(...)
			v6[v7]:fire(...)
		end)
	end

	local v7 = v
	local v8 = ChatSelector

	if v7.VisibilityStateChanged then
		local v9 = "VisibilityStateChanged"
		v7.VisibilityStateChanged:connect(function(...)
			v8[v9]:fire(...)
		end)
	end

	local v9 = v
	local v10 = ChatSelector

	if v9.ChatWindowToggled then
		local v11 = "ChatWindowToggled"
		v9.ChatWindowToggled:connect(function(...)
			v10[v11]:fire(...)
		end)
	end

	local v11 = v
	local v12 = ChatSelector

	if v11.ChatActiveChanged then
		local v13 = "ChatActiveChanged"
		v11.ChatActiveChanged:connect(function(...)
			v12[v13]:fire(...)
		end)
	end

	local v13 = v
	local v14 = ChatSelector

	if v13.BubbleChatOnlySet then
		local v15 = "BubbleChatOnlySet"
		v13.BubbleChatOnlySet:connect(function(...)
			v14[v15]:fire(...)
		end)
	end

	local v15 = v
	local v16 = ChatSelector

	if v15.ChatDisabled then
		local v17 = "ChatDisabled"
		v15.ChatDisabled:connect(function(...)
			v16[v17]:fire(...)
		end)
	end

	while Players.LocalPlayer == nil do
		Players.ChildAdded:wait()
	end

	local _localPlayer = Players.LocalPlayer

	local v17 = v
	local v18 = ChatSelector

	if v17.MessagesChanged then
		local v19 = "MessagesChanged"
		v17.MessagesChanged:connect(function(...)
			v18[v19]:fire(...)
		end)
	end

	StarterGui:RegisterGetCore("UseNewLuaChat", function(): boolean
		return true
	end)

	v:SetVisible(v3.Visible)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat))

	flag = true

	for _, v19 in pairs(v4) do
		pcall(function()
			StarterGui:SetCore("ChatMakeSystemMessage", v19)
		end)
	end
end)()

return ChatSelector
