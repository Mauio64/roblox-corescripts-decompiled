local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)

local useStore = RoactUtils.Hooks.RoactRodux.useStore
local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local emojiUnicodeToId = require(ExpChat.PresetChat.emojiUnicodeToId)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local FFlagExpChatBlockExpressionTrayFromRBXWhisper = require(ExpChat.Flags.FFlagExpChatBlockExpressionTrayFromRBXWhisper)

local v = ExpChatShared.Logger:new("ExpChat/PresetChat/useOnEmojiActivated")

local function getRBXGeneralChannel() -- 1 equivalent call inferred from this helper
	local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if rbxGeneral and rbxGeneral:IsA("TextChannel") then
		return rbxGeneral
	end

	return nil
end

local function useOnEmojiActivated(data)
	local v2 = useStore()
	local v3 = SignalsReact.useSignalState(GetMessagesStore(false).getCanLocalUserChat)
	local textChannel = data.textChannel
	local onSendChat = data.onSendChat
	local onSendGlobalChat = data.onSendGlobalChat
	local closePresetTray = data.closePresetTray

	local useCallback = React.useCallback
	local function fn(p: string)
		if FFlagExpChatPresetTrayDismissAnalytics then
			local presetChatStore = GetPresetChatStore(false)

			if presetChatStore.getIsTrayOpen(false) then
				presetChatStore.incrementPresetClickCount(emojiUnicodeToId(p))
			end
		end

		local v4 = GetFFlagTextChatEnableUniverseChatTabs() and selectSelectedTabName(v2:getState()) == "RBXGlobal"

		if v3 then
			if v4 and onSendGlobalChat then
				onSendGlobalChat(p)
			elseif onSendChat then
				if
					FFlagExpChatBlockExpressionTrayFromRBXWhisper
					and textChannel
					and string.find(textChannel.Name, "^RBXWhisper")
				then
					local rbxGeneralChannel = getRBXGeneralChannel() -- inferred equivalent call

					if rbxGeneralChannel then
						onSendChat(p, nil, nil, rbxGeneralChannel)
					else
						v:warning("Emoji activated on a whisper channel but there is no RBXGeneral; skipping send.")
					end
				else
					onSendChat(p)
				end
			else
				v:warning("Emoji activated but no chat send callback was provided; skipping send.")
			end
		else
			v:debug("Emoji activated but the local user can't chat; skipping send.")
		end

		closePresetTray()
	end

	local v4

	if FFlagExpChatBlockExpressionTrayFromRBXWhisper then
		v4 = textChannel or false
	else
		v4 = false
	end

	return useCallback(fn, {
		v2,
		v3,
		v4,
		onSendChat or false,
		onSendGlobalChat or false,
		closePresetTray
	})
end

return useOnEmojiActivated
