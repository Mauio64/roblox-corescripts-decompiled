local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local Roact = require(ExpChatParent.Roact)
local RoactRodux = require(ExpChatParent.RoactRodux)
local List = require(ExpChatParent.llama).List
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local memoize = require(ExpChat.memoize)
local createEffect = require(ExpChatParent.Signals).createEffect
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatTransparentFocusSupport = require(ExpChat.Flags.FFlagExpChatTransparentFocusSupport)
local FFlagEnableVerifiedBadgeStore = require(ExpChatParent.SharedFlags).FFlagEnableVerifiedBadgeStore
local UI = script.Parent.UI
local ChatWindow = require(UI.ChatWindow)
local ChatWindowMessageSource = require(UI.ChatWindow.ChatWindowMessageSource)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatWindowMessageSourceRefactor = SharedFlags.FFlagExpChatWindowMessageSourceRefactor
local v20 = game:DefineFastFlag("ExpChatMoveMessagesStoreToInit", false)
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local v23 = Roact.Component:extend("ChatWindowApp")

v23.defaultProps = {
	LayoutOrder = 1,
	messages = if not FFlagExpChatEnableV2ChatWindow then {} else nil,
	size = UDim2.fromScale(1, 1)
}

local u24 = if not GetFFlagTextChatEnableUniverseChatTabs() then memoize(function(p1, p2, p3) -- line: 58
	-- upvalues: List (copy)
	if not p2 then
		return List.map(p1.windowMessagesInOrder, function(p4) -- line: 60
			-- upvalues: p1 (copy)
			return p1.byMessageId[p4]
		end)
	end

	if p3 then
		return List.map(p1.windowMessagesInOrderByTabId[p3.Name] or {}, function(p5) -- line: 67
			-- upvalues: p1 (copy)
			return p1.byMessageId[p5]
		end)
	end

	return {}
end) else memoize(function(p6, p7, p8, p9) -- line: 38
	-- upvalues: List (copy)
	if not p7 then
		return List.map(p6.windowMessagesInOrder, function(p10) -- line: 40
			-- upvalues: p6 (copy)
			return p6.byMessageId[p10]
		end)
	end

	if p8 and p6.windowMessagesInOrderByTabId[p8.Name] then
		p9 = p8.Name
	end

	if p9 then
		return List.map(p6.windowMessagesInOrderByTabId[p9] or {}, function(p11) -- line: 49
			-- upvalues: p6 (copy)
			return p6.byMessageId[p11]
		end)
	end

	return {}
end)

if FFlagExpChatUseMessagesStore and not FFlagExpChatEnableV2ChatWindow then
	function v23.init(p12) -- line: 78
		-- upvalues: GetMessagesStore (copy), v20 (copy)
		p12.MessagesStore = GetMessagesStore(false)
		p12.disposeEffects = {}

		if v20 and p12.MessagesStore then
			p12.state = {
				messagesState = {
					byMessageId = p12.MessagesStore.getByMessageId(false),
					windowMessagesInOrder = p12.MessagesStore.getWindowMessagesInOrder(false),
					windowMessagesInOrderByTabId = p12.MessagesStore.getWindowMessagesInOrderByTabId(false)
				}
			}

			return
		end

		p12.state = {
			messagesState = nil
		}
	end
	function v23.didMount(p13) -- line: 97
		-- upvalues: v20 (copy), createEffect (copy)
		if p13.MessagesStore then
			if not v20 then
				local v34 = p13.MessagesStore.getByMessageId(false)
				local v35 = p13.MessagesStore.getWindowMessagesInOrder(false)
				local v36 = p13.MessagesStore.getWindowMessagesInOrderByTabId(false)
				local t1 = {
					byMessageId = v34,
					windowMessagesInOrder = v35,
					windowMessagesInOrderByTabId = v36
				}

				if t1 then
					p13:setState({
						messagesState = t1
					})
				end
			end

			local v38 = createEffect(function(p14) -- line: 118
				-- upvalues: p13 (copy)
				local v55 = p13.MessagesStore.getByMessageId(p14)
				local v56 = p13.MessagesStore.getWindowMessagesInOrder(p14)
				local v57 = p13.MessagesStore.getWindowMessagesInOrderByTabId(p14)

				if v55 or (v56 or v57) then
					p13:setState({
						messagesState = {
							byMessageId = v55,
							windowMessagesInOrder = v56,
							windowMessagesInOrderByTabId = v57
						}
					})
				end
			end)

			table.insert(p13.disposeEffects, v38)
		end
	end
	function v23.willUnmount(p15) -- line: 138
		if p15.disposeEffects then
			for _, v in ipairs(p15.disposeEffects) do
				v()
			end

			p15.disposeEffects = {}
		end
	end
end

function v23.render(p16) -- line: 148
	-- upvalues: FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u24 (ref), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatWindowMessageSourceRefactor (copy), Roact (copy), ChatWindowMessageSource (copy), ChatWindow (copy)
	local v43 = nil

	if not FFlagExpChatEnableV2ChatWindow then
		if FFlagExpChatUseMessagesStore then
			local messagesState = p16.state.messagesState

			v43 = if not messagesState then {} else if not GetFFlagTextChatEnableUniverseChatTabs() then u24(messagesState, p16.props.isChannelBarVisible, p16.props.targetTextChannel) else u24(messagesState, p16.props.isChannelBarVisible, p16.props.targetTextChannel, p16.props.selectedChannelName)
		else
			v43 = if not GetFFlagTextChatEnableUniverseChatTabs() then u24(p16.props.messages, p16.props.isChannelBarVisible, p16.props.targetTextChannel) else u24(p16.props.messages, p16.props.isChannelBarVisible, p16.props.targetTextChannel, p16.props.selectedChannelName)
		end
	end

	local t2 = {
		LayoutOrder = p16.props.LayoutOrder,
		messages = if not FFlagExpChatEnableV2ChatWindow then v43 else nil,
		size = p16.props.size,
		transparencyValue = p16.props.transparencyValue,
		textTransparency = p16.props.textTransparency,
		onHovered = p16.props.onHovered,
		onUnhovered = p16.props.onUnhovered,
		mutedUserIds = if not FFlagExpChatUseMessagesStore then p16.props.mutedUserIds else nil,
		verifiedUserIds = p16.props.verifiedUserIds,
		activateWhisperMode = p16.props.activateWhisperMode,
		resetTargetChannel = p16.props.resetTargetChannel,
		visible = p16.props.visible,
		onAbsoluteSizeChanged = p16.props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = p16.props.onAbsolutePositionChanged,
		chatWindowSettings = p16.props.chatWindowSettings,
		showTranslationButton = p16.props.showTranslationButton,
		targetTextChannel = p16.props.targetTextChannel,
		selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() and not FFlagExpChatChannelTabRefactor then nil else p16.props.selectedChannelName,
		scrollResetKey = if not FFlagExpChatChannelTabRefactor then nil else p16.props.selectedChannelName,
		isChannelBarVisible = p16.props.isChannelBarVisible,
		onFocus = p16.props.onFocus,
		onUnfocus = p16.props.onUnfocus
	}

	if FFlagExpChatWindowMessageSourceRefactor then
		return Roact.createElement(ChatWindowMessageSource, t2)
	end

	return Roact.createElement(ChatWindow, t2)
end

return RoactRodux.connect(function(p17) -- line: 221
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), FFlagEnableVerifiedBadgeStore (copy)
	local v47 = nil

	if GetFFlagTextChatEnableUniverseChatTabs() or FFlagExpChatChannelTabRefactor then
		local selectedChannelName = p17.TextChannels.selectedChannelName

		v47 = if not selectedChannelName or (not p17.ChannelTabs or not p17.ChannelTabs.allChannelTabs[selectedChannelName]) then not p17.ChannelTabs and "RBXGeneral" or (p17.ChannelTabs.selectedTabName or "RBXGeneral") else selectedChannelName
	end

	return {
		chatIntervention = p17.ChatIntervention,
		messages = if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatUseMessagesStore then p17.Messages else nil,
		mutedUserIds = if not FFlagExpChatUseMessagesStore then p17.MutedUsers else nil,
		verifiedUserIds = if not FFlagEnableVerifiedBadgeStore then p17.VerifiedUsers else nil,
		targetTextChannel = p17.TextChannels.targetTextChannel,
		selectedChannelName = v47
	}
end, function(_) -- line: 242
	-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
	return {
		onFocus = function() -- line: 244
			-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
			if FFlagExpChatTransparentFocusSupport then
				return GetTransparencyStore(false).setContextMenuOpen()
			end

			return GetTransparencyStore(false).setTextboxFocus()
		end,
		onUnfocus = function() -- line: 252
			-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
			if FFlagExpChatTransparentFocusSupport then
				return GetTransparencyStore(false).clearContextMenuOpen()
			end

			return GetTransparencyStore(false).clearTextboxFocus()
		end
	}
end)(v23)
