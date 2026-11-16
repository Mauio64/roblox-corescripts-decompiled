local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local v = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

local flag = false
local v2 = Players.ClassicChat
local v3 = Players.BubbleChat

local ChatUtil = require(RobloxGui.Modules.ChatUtil)

local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar

local transparencyStore = ExpChat.Stores.GetTransparencyStore(false)

local function shouldForceLegacyChatToBeHidden() -- 3 equivalent calls inferred from this helper
	v = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

	return if getFFlagExpChatAlwaysRunTCS() then v else false
end

local NewChat = {}

local v4 = { Visible = true, MessageCount = 0, TopbarEnabled = true, CoreGuiEnabled = true }

local v5 = { ["ChatWindow"] = nil, GetCore = nil, SetCore = nil }

local eventConnections = {}

local v6 = {}

local function FindInCollectionByKeyAndType(p, p2, className) -- 21 equivalent calls inferred from this helper
	if p and p[p2] and p[p2]:IsA(className) then
		return p[p2]
	end

	return nil
end

local function DispatchEvent(p, ...): boolean
	local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.ChatWindow, p, "BindableEvent") -- inferred equivalent call

	if not findInCollectionByKeyAndType then
		return false
	end

	findInCollectionByKeyAndType:Fire(...)
	return true
end

local function AttemptInvokeFunction(p, ...)
	local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.ChatWindow, p, "BindableFunction") -- inferred equivalent call

	if findInCollectionByKeyAndType then
		return true, findInCollectionByKeyAndType:Invoke()
	end

	return false, nil
end

local function DoConnectGetCore(p)
	StarterGui:RegisterGetCore(p, function(p2)
		local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.GetCore, p, "BindableFunction") -- inferred equivalent call
		local v7

		if findInCollectionByKeyAndType then
			return (findInCollectionByKeyAndType:Invoke(p2))
		end

		return v7
	end)
end

function NewChat.ToggleVisibility(_)
	v4.Visible = not v4.Visible

	if shouldForceLegacyChatToBeHidden() then -- inferred equivalent call
		NewChat.VisibilityStateChanged:fire(v4.Visible)
	elseif not DispatchEvent("ToggleVisibility") then
		NewChat.VisibilityStateChanged:fire(v4.Visible)
	end

	if not FFlagExpChatWindowSyncUnibar then
		ExpChat.Events.ChatTopBarButtonActivated(v4.Visible)
	end

	if v4.Visible then
		transparencyStore.resetAllTransparency()
	end

	NewChat.ChatWindowToggled:fire(v4.Visible)
end

function NewChat:SetVisible(visible)
	v4.Visible = visible

	if not FFlagExpChatWindowSyncUnibar then
		ExpChat.Events.ChatTopBarButtonActivated(v4.Visible)
	end

	if v4.Visible then
		transparencyStore.resetAllTransparency()
	end

	NewChat.ChatWindowToggled:fire(v4.Visible)

	if shouldForceLegacyChatToBeHidden() then -- inferred equivalent call
		DispatchEvent("SetVisible", false)
		NewChat.VisibilityStateChanged:fire(false)
	elseif not DispatchEvent("SetVisible", v4.Visible) then
		NewChat.VisibilityStateChanged:fire(v4.Visible)
	end
end

function NewChat.FocusChatBar(_)
	DispatchEvent("FocusChatBar")

	ExpChat.Events.ChatTopBarFocusActivated()
end

function NewChat.FocusSelectChatBar(_, callback, p)
	if FFlagEnableConsoleExpControls then
		ExpChat.Events.ChatTopBarFocusSelect(callback, p)
	end
end

function NewChat.EnterWhisperState(_, p)
	return DispatchEvent("EnterWhisperState", p)
end

function NewChat.GetVisibility(_)
	local v7, v8 = AttemptInvokeFunction("GetVisibility")

	return if v7 then v8 else v4.Visible
end

function NewChat.GetMessageCount(_)
	local v7, v8 = AttemptInvokeFunction("GetMessageCount")

	return if v7 then v8 else v4.MessageCount
end

function NewChat:TopbarEnabledChanged(topbarEnabled)
	v4.TopbarEnabled = topbarEnabled
	DispatchEvent("TopbarEnabledChanged", v4.TopbarEnabled)
end

function NewChat.IsFocused(_, p)
	local v7, v8 = AttemptInvokeFunction("IsFocused", p)
	return if v7 then v8 else false
end

function NewChat.ClassicChatEnabled(_)
	return v2
end

function NewChat.IsBubbleChatOnly(_)
	return v3 and not v2
end

function NewChat.IsDisabled(_): boolean
	return not (v3 or v2)
end

function SetInitialChatTypes(p)
	if flag then
		return
	end

	flag = true

	local bubbleChatEnabled = p.BubbleChatEnabled
	local classicChatEnabled = p.ClassicChatEnabled

	if type(bubbleChatEnabled) == "boolean" then
		v3 = bubbleChatEnabled
	end

	if type(classicChatEnabled) == "boolean" then
		v2 = classicChatEnabled
	end

	if not (v2 or v3) then
		NewChat.ChatDisabled:fire()
	end

	if v3 and not v2 then
		NewChat.BubbleChatOnlySet:fire()
	end
end

NewChat.ChatBarFocusChanged = ChatUtil.Signal()
NewChat.VisibilityStateChanged = ChatUtil.Signal()
NewChat.ChatWindowToggled = ChatUtil.Signal()
NewChat.MessagesChanged = ChatUtil.Signal()

NewChat.BubbleChatOnlySet = ChatUtil.Signal()
NewChat.ChatDisabled = ChatUtil.Signal()

local Chat = game:GetService("Chat")
Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function()
	if Chat.IsAutoMigrated and not DispatchEvent("SetVisible", false) then
		NewChat.VisibilityStateChanged:fire(false)
	end
end)

StarterGui.CoreGuiChangedSignal:connect(function(p, coreGuiEnabled)
	if p == Enum.CoreGuiType.All or p == Enum.CoreGuiType.Chat then
		v4.CoreGuiEnabled = coreGuiEnabled
		DispatchEvent("CoreGuiEnabled", v4.CoreGuiEnabled)
	end
end)

GuiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
GuiService.SpecialKeyPressed:connect(function(p, p2)
	if GuiService.MenuIsOpen then
		return
	end

	if not shouldForceLegacyChatToBeHidden() then -- inferred equivalent call
		DispatchEvent("SpecialKeyPressed", p, p2)
	end
end)

function DoConnectSetCore(p)
	StarterGui:RegisterSetCore(p, function(p2)
		local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.SetCore, p, "BindableEvent") -- inferred equivalent call

		if findInCollectionByKeyAndType then
			findInCollectionByKeyAndType:Fire(p2)
			return
		end

		if v6[p] == nil then
			v6[p] = {}
		end

		table.insert(v6[p], p2)
	end)
end

DoConnectSetCore("ChatMakeSystemMessage")
DoConnectSetCore("ChatWindowPosition")
DoConnectSetCore("ChatWindowSize")
DoConnectSetCore("ChatBarDisabled")
local v7 = "ChatWindowPosition"
StarterGui:RegisterGetCore("ChatWindowPosition", function(p)
	local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.GetCore, v7, "BindableFunction") -- inferred equivalent call
	local v8

	if findInCollectionByKeyAndType then
		return (findInCollectionByKeyAndType:Invoke(p))
	end

	return v8
end)
local v8 = "ChatWindowSize"
StarterGui:RegisterGetCore("ChatWindowSize", function(p)
	local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.GetCore, v8, "BindableFunction") -- inferred equivalent call
	local v9

	if findInCollectionByKeyAndType then
		return (findInCollectionByKeyAndType:Invoke(p))
	end

	return v9
end)
local v9 = "ChatBarDisabled"
StarterGui:RegisterGetCore("ChatBarDisabled", function(p)
	local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(v5.GetCore, v9, "BindableFunction") -- inferred equivalent call
	local v10

	if findInCollectionByKeyAndType then
		return (findInCollectionByKeyAndType:Invoke(p))
	end

	return v10
end)

local function RegisterCoreGuiConnections(data)
	if type(data) == "table" then
		local chatWindow = data.ChatWindow
		local setCore = data.SetCore
		local getCore = data.GetCore

		if type(chatWindow) == "table" then
			for _, v10 in pairs(eventConnections) do
				v10:disconnect()
			end

			if type(chatWindow.ChatTypes) == "table" then
				SetInitialChatTypes(chatWindow.ChatTypes)
			end

			eventConnections = {}
			v5.ChatWindow = {}

			local chatWindow2 = v5.ChatWindow
			chatWindow2.ToggleVisibility = FindInCollectionByKeyAndType(chatWindow, "ToggleVisibility", "BindableEvent") -- inferred equivalent call
			local chatWindow3 = v5.ChatWindow
			chatWindow3.SetVisible = FindInCollectionByKeyAndType(chatWindow, "SetVisible", "BindableEvent") -- inferred equivalent call
			local chatWindow4 = v5.ChatWindow
			chatWindow4.FocusChatBar = FindInCollectionByKeyAndType(chatWindow, "FocusChatBar", "BindableEvent") -- inferred equivalent call
			local chatWindow5 = v5.ChatWindow
			chatWindow5.EnterWhisperState = FindInCollectionByKeyAndType( -- inferred equivalent call
				chatWindow,
				"EnterWhisperState",
				"BindableEvent"
			)
			local chatWindow6 = v5.ChatWindow
			chatWindow6.TopbarEnabledChanged = FindInCollectionByKeyAndType( -- inferred equivalent call
				chatWindow,
				"TopbarEnabledChanged",
				"BindableEvent"
			)
			local chatWindow7 = v5.ChatWindow
			chatWindow7.IsFocused = FindInCollectionByKeyAndType(chatWindow, "IsFocused", "BindableFunction") -- inferred equivalent call
			local chatWindow8 = v5.ChatWindow
			chatWindow8.SpecialKeyPressed = FindInCollectionByKeyAndType( -- inferred equivalent call
				chatWindow,
				"SpecialKeyPressed",
				"BindableEvent"
			)

			local function DoConnect(p)
				local chatWindow9 = v5.ChatWindow
				chatWindow9[p] = FindInCollectionByKeyAndType(chatWindow, p, "BindableEvent") -- inferred equivalent call

				if v5.ChatWindow[p] then
					local eventConnection = v5.ChatWindow[p].Event:connect(function(...)
						NewChat[p]:fire(...)
					end)
					table.insert(eventConnections, eventConnection)
				end
			end

			DoConnect("ChatBarFocusChanged")
			DoConnect("VisibilityStateChanged")
			DoConnect("ChatWindowToggled")
			DoConnect("MessagesChanged")

			local chatWindow9 = v5.ChatWindow
			chatWindow9.MessagePosted = FindInCollectionByKeyAndType(chatWindow, "MessagePosted", "BindableEvent") -- inferred equivalent call

			if v5.ChatWindow.MessagePosted then
				local eventConnection = v5.ChatWindow.MessagePosted.Event:connect(function(p)
					local Players2 = game:GetService("Players")
					Players2:Chat(p)
				end)
				table.insert(eventConnections, eventConnection)
			end

			NewChat:SetVisible(v4.Visible)
			NewChat:TopbarEnabledChanged(v4.TopbarEnabled)
			local coreGuiEnabled = FindInCollectionByKeyAndType(chatWindow, "CoreGuiEnabled", "BindableEvent") -- inferred equivalent call

			if coreGuiEnabled then
				v5.ChatWindow.CoreGuiEnabled = coreGuiEnabled
				coreGuiEnabled:Fire(v4.CoreGuiEnabled)
			end
		else
			error("Table 'ChatWindow' must be provided!")
		end

		if type(setCore) == "table" and type(getCore) == "table" then
			v5.SetCore = {}
			v5.GetCore = {}

			local function addSetCore(p)
				local findInCollectionByKeyAndType = FindInCollectionByKeyAndType(setCore, p, "BindableEvent") -- inferred equivalent call

				if findInCollectionByKeyAndType then
					v5.SetCore[p] = findInCollectionByKeyAndType

					if v6[p] then
						for _, v10 in pairs(v6[p]) do
							findInCollectionByKeyAndType:Fire(v10)
						end

						v6[p] = nil
					end
				end
			end

			addSetCore("ChatMakeSystemMessage")
			addSetCore("ChatWindowPosition")
			addSetCore("ChatWindowSize")
			addSetCore("ChatBarDisabled")

			local getCore2 = v5.GetCore
			getCore2.ChatWindowPosition = FindInCollectionByKeyAndType( -- inferred equivalent call
				getCore,
				"ChatWindowPosition",
				"BindableFunction"
			)
			local getCore3 = v5.GetCore
			getCore3.ChatWindowSize = FindInCollectionByKeyAndType(getCore, "ChatWindowSize", "BindableFunction") -- inferred equivalent call
			local getCore4 = v5.GetCore
			getCore4.ChatBarDisabled = FindInCollectionByKeyAndType(getCore, "ChatBarDisabled", "BindableFunction") -- inferred equivalent call
		elseif type(setCore) ~= "nil" or type(getCore) ~= "nil" then
			error("Both 'SetCore' and 'GetCore' must be tables if provided!")
		end
	end
end

ExpChat.listenToDispatch(function(p)
	if p.type == "FocusChatHotKeyActivated" then
		NewChat:SetVisible(true)
	end
end)

StarterGui:RegisterSetCore("CoreGuiChatConnections", RegisterCoreGuiConnections)

return NewChat
