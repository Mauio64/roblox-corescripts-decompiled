local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useStableSignal = ChatUIPrimitives.Hooks.useStableSignal
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

local ChatWindow = require(script.Parent.ChatWindow)
local createMessageChildren = require(script.Parent.createMessageChildren)
local useV2MessagePool = require(ExpChat.ChatWindow.UI.BottomLockedScrollViewV3.useV2MessagePool)

local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)

local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local isGlobalChatMessage = require(ExpChat.isGlobalChatMessage)

local function ChatWindowMessageSource(props)
	local messageComponentsSignal, v = useStableSignal({})
	local ref = React.useRef(nil)

	local onTextMessageLabelButtonActivated = React.useCallback(function(p)
		if isGlobalChatMessage(p) then
			return
		end

		props.resetTargetChannel()

		local userId = tonumber(p.userId)

		if userId then
			props.activateWhisperMode(userId)
		end
	end, getFFlagChatWindowUseCallbackOptimizations() and { props.resetTargetChannel, props.activateWhisperMode } or nil)

	local messagesStore = GetMessagesStore(false)
	local v2 = React.useBinding(0)
	local textTransparency = props.textTransparency or v2
	local children

	if FFlagExpChatEnableV2ChatWindow then
		local v3 = {
			enabled = true,
			visible = props.visible,
			messagesStore = messagesStore,
			textTransparency = textTransparency,
			chatWindowSettings = props.chatWindowSettings or {},
			isSpatialUIEnabled = props.isSpatialUIEnabled or false,
			onTextMessageLabelButtonActivated = onTextMessageLabelButtonActivated,
			targetTextChannel = props.targetTextChannel,
			isChannelBarVisible = props.isChannelBarVisible,
			showTranslationButton = props.showTranslationButton or false,
			chatWindowTransparencyBindable = 0,
			selectedChannelName = 0
		}
		local chatWindowTransparencyBindable

		if FFlagExpChatRewriteInline then
			chatWindowTransparencyBindable = props.transparencyValue
		end

		v3.chatWindowTransparencyBindable = chatWindowTransparencyBindable
		local selectedChannelName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedChannelName = props.selectedChannelName
		end

		v3.selectedChannelName = selectedChannelName
		children = useV2MessagePool(v3).children
	end

	local current = React.useMemo(function()
		if FFlagExpChatEnableV2ChatWindow then
			return nil
		end

		return createMessageChildren({
			messages = props.messages or {},
			verifiedUserIds = props.verifiedUserIds or {},
			textTransparency = textTransparency,
			transparencyValue = props.transparencyValue,
			chatWindowSettings = props.chatWindowSettings,
			showTranslationButton = props.showTranslationButton or false,
			isSpatialUIEnabled = props.isSpatialUIEnabled,
			onTextMessageLabelButtonActivated = onTextMessageLabelButtonActivated
		})
	end, {
		props.messages,
		props.verifiedUserIds,
		textTransparency,
		props.transparencyValue,
		props.chatWindowSettings,
		props.showTranslationButton,
		props.isSpatialUIEnabled,
		onTextMessageLabelButtonActivated
	})

	if FFlagExpChatEnableV2ChatWindow then
		current = children
	end

	if ref.current ~= current then
		v(current or {})
		ref.current = current
	end

	return React.createElement(
		ChatWindow,
		dictionary.join(props, { messageComponentsSignal = messageComponentsSignal })
	)
end

return ChatWindowMessageSource
