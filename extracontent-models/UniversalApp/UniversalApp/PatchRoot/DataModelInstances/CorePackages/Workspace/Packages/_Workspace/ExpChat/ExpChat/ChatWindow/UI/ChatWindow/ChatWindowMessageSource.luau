local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local useStableSignal = require(ExpChatParent.ChatUIPrimitives).Hooks.useStableSignal
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local ChatWindow = require(script.Parent.ChatWindow)
local createMessageChildren = require(script.Parent.createMessageChildren)
local useV2MessagePool = require(ExpChat.ChatWindow.UI.BottomLockedScrollViewV3.useV2MessagePool)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)
local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local function ChatWindowMessageSource(t1: {[any]: any}) -- line: 67
	-- upvalues: useStableSignal (copy), React (copy), getFFlagChatWindowUseCallbackOptimizations (copy), GetMessagesStore (copy), FFlagExpChatEnableV2ChatWindow (copy), useV2MessagePool (copy), FFlagExpChatRewriteInline (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), createMessageChildren (copy), ChatWindow (copy), Dictionary (copy)
	local v17, v18 = useStableSignal({})
	local v19 = React.useRef(nil)
	local v20 = React.useCallback(function(p1) -- line: 72
		-- upvalues: t1 (copy)
		t1.resetTargetChannel()

		local num = tonumber(p1.userId)

		if num then
			t1.activateWhisperMode(num)
		end
	end, if not getFFlagChatWindowUseCallbackOptimizations() then nil else {
		t1.resetTargetChannel,
		t1.activateWhisperMode
	})
	local v21 = GetMessagesStore(false)
	local v22 = React.useBinding(0)
	local v23 = t1.textTransparency or v22
	local children = nil

	if FFlagExpChatEnableV2ChatWindow then
		children = useV2MessagePool({
			enabled = true,
			visible = t1.visible,
			messagesStore = v21,
			textTransparency = v23,
			chatWindowSettings = t1.chatWindowSettings or {},
			isSpatialUIEnabled = t1.isSpatialUIEnabled or false,
			onTextMessageLabelButtonActivated = v20,
			targetTextChannel = t1.targetTextChannel,
			isChannelBarVisible = t1.isChannelBarVisible,
			showTranslationButton = t1.showTranslationButton or false,
			chatWindowTransparencyBindable = if not FFlagExpChatRewriteInline then nil else t1.transparencyValue,
			selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() then nil else t1.selectedChannelName
		}).children
	end

	local v25 = React.useMemo(function() -- line: 109
		-- upvalues: FFlagExpChatEnableV2ChatWindow (copy), createMessageChildren (copy), t1 (copy), v23 (copy), v20 (copy)
		if FFlagExpChatEnableV2ChatWindow then
			return nil
		end

		return createMessageChildren({
			messages = t1.messages or {},
			verifiedUserIds = t1.verifiedUserIds or {},
			textTransparency = v23,
			transparencyValue = t1.transparencyValue,
			chatWindowSettings = t1.chatWindowSettings,
			showTranslationButton = t1.showTranslationButton or false,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onTextMessageLabelButtonActivated = v20
		})
	end, {
		t1.messages,
		t1.verifiedUserIds,
		v23,
		t1.transparencyValue,
		t1.chatWindowSettings,
		t1.showTranslationButton,
		t1.isSpatialUIEnabled,
		v20
	})
	local v26 = if not FFlagExpChatEnableV2ChatWindow then v25 else children

	if v26 ~= v19.current then
		v18(v26 or {})
		v19.current = v26
	end

	return React.createElement(ChatWindow, Dictionary.join(t1, {
		messageComponentsSignal = v17
	}))
end

return ChatWindowMessageSource
