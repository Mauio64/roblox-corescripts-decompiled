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
local FFlagExpChatMessagesStoreUseProxy = require(ExpChat.Flags.FFlagExpChatMessagesStoreUseProxy)

local function readByMessageIdAsTable(p1, p2) -- line: 30
	-- upvalues: FFlagExpChatMessagesStoreUseProxy (copy)
	local v29 = if not p2 then p1.getByMessageId(false) else p1.getByMessageId(p2)

	if FFlagExpChatMessagesStoreUseProxy then
		local t1 = {}

		for v31, v32 in v29 do
			t1[v31] = v32
		end

		return t1
	end

	return v29
end

local v25 = Roact.Component:extend("ChatWindowApp")

v25.defaultProps = {
	LayoutOrder = 1,
	messages = if not FFlagExpChatEnableV2ChatWindow then {} else nil,
	size = UDim2.fromScale(1, 1)
}

local u26 = if not GetFFlagTextChatEnableUniverseChatTabs() then memoize(function(p3, p4, p5) -- line: 73
	-- upvalues: List (copy)
	if not p4 then
		return List.map(p3.windowMessagesInOrder, function(p6) -- line: 75
			-- upvalues: p3 (copy)
			return p3.byMessageId[p6]
		end)
	end

	if p5 then
		return List.map(p3.windowMessagesInOrderByTabId[p5.Name] or {}, function(p7) -- line: 82
			-- upvalues: p3 (copy)
			return p3.byMessageId[p7]
		end)
	end

	return {}
end) else memoize(function(p8, p9, p10, p11) -- line: 53
	-- upvalues: List (copy)
	if not p9 then
		return List.map(p8.windowMessagesInOrder, function(p12) -- line: 55
			-- upvalues: p8 (copy)
			return p8.byMessageId[p12]
		end)
	end

	if p10 and p8.windowMessagesInOrderByTabId[p10.Name] then
		p11 = p10.Name
	end

	if p11 then
		return List.map(p8.windowMessagesInOrderByTabId[p11] or {}, function(p13) -- line: 64
			-- upvalues: p8 (copy)
			return p8.byMessageId[p13]
		end)
	end

	return {}
end)

if FFlagExpChatUseMessagesStore and not FFlagExpChatEnableV2ChatWindow then
	function v25.init(p14) -- line: 93
		-- upvalues: GetMessagesStore (copy), v20 (copy), readByMessageIdAsTable (copy)
		p14.MessagesStore = GetMessagesStore(false)
		p14.disposeEffects = {}

		if v20 and p14.MessagesStore then
			p14.state = {
				messagesState = {
					byMessageId = readByMessageIdAsTable(p14.MessagesStore),
					windowMessagesInOrder = p14.MessagesStore.getWindowMessagesInOrder(false),
					windowMessagesInOrderByTabId = p14.MessagesStore.getWindowMessagesInOrderByTabId(false)
				}
			}

			return
		end

		p14.state = {
			messagesState = nil
		}
	end
	function v25.didMount(p15) -- line: 112
		-- upvalues: v20 (copy), readByMessageIdAsTable (copy), createEffect (copy)
		if p15.MessagesStore then
			if not v20 then
				local v42 = readByMessageIdAsTable(p15.MessagesStore)
				local v43 = p15.MessagesStore.getWindowMessagesInOrder(false)
				local v44 = p15.MessagesStore.getWindowMessagesInOrderByTabId(false)
				local t2 = {
					byMessageId = v42,
					windowMessagesInOrder = v43,
					windowMessagesInOrderByTabId = v44
				}

				if t2 then
					p15:setState({
						messagesState = t2
					})
				end
			end

			local v46 = createEffect(function(p16) -- line: 133
				-- upvalues: readByMessageIdAsTable (copy), p15 (copy)
				local v63 = readByMessageIdAsTable(p15.MessagesStore, p16)
				local v64 = p15.MessagesStore.getWindowMessagesInOrder(p16)
				local v65 = p15.MessagesStore.getWindowMessagesInOrderByTabId(p16)

				if v63 or (v64 or v65) then
					p15:setState({
						messagesState = {
							byMessageId = v63,
							windowMessagesInOrder = v64,
							windowMessagesInOrderByTabId = v65
						}
					})
				end
			end)

			table.insert(p15.disposeEffects, v46)
		end
	end
	function v25.willUnmount(p17) -- line: 153
		if p17.disposeEffects then
			for _, v in ipairs(p17.disposeEffects) do
				v()
			end

			p17.disposeEffects = {}
		end
	end
end

function v25.render(p18) -- line: 163
	-- upvalues: FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u26 (ref), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatWindowMessageSourceRefactor (copy), Roact (copy), ChatWindowMessageSource (copy), ChatWindow (copy)
	local v51 = nil

	if not FFlagExpChatEnableV2ChatWindow then
		if FFlagExpChatUseMessagesStore then
			local messagesState = p18.state.messagesState

			v51 = if not messagesState then {} else if not GetFFlagTextChatEnableUniverseChatTabs() then u26(messagesState, p18.props.isChannelBarVisible, p18.props.targetTextChannel) else u26(messagesState, p18.props.isChannelBarVisible, p18.props.targetTextChannel, p18.props.selectedChannelName)
		else
			v51 = if not GetFFlagTextChatEnableUniverseChatTabs() then u26(p18.props.messages, p18.props.isChannelBarVisible, p18.props.targetTextChannel) else u26(p18.props.messages, p18.props.isChannelBarVisible, p18.props.targetTextChannel, p18.props.selectedChannelName)
		end
	end

	local t3 = {
		LayoutOrder = p18.props.LayoutOrder,
		messages = if not FFlagExpChatEnableV2ChatWindow then v51 else nil,
		size = p18.props.size,
		transparencyValue = p18.props.transparencyValue,
		textTransparency = p18.props.textTransparency,
		onHovered = p18.props.onHovered,
		onUnhovered = p18.props.onUnhovered,
		mutedUserIds = if not FFlagExpChatUseMessagesStore then p18.props.mutedUserIds else nil,
		verifiedUserIds = p18.props.verifiedUserIds,
		activateWhisperMode = p18.props.activateWhisperMode,
		resetTargetChannel = p18.props.resetTargetChannel,
		visible = p18.props.visible,
		onAbsoluteSizeChanged = p18.props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = p18.props.onAbsolutePositionChanged,
		chatWindowSettings = p18.props.chatWindowSettings,
		showTranslationButton = p18.props.showTranslationButton,
		targetTextChannel = p18.props.targetTextChannel,
		selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() and not FFlagExpChatChannelTabRefactor then nil else p18.props.selectedChannelName,
		scrollResetKey = if not FFlagExpChatChannelTabRefactor then nil else p18.props.selectedChannelName,
		isChannelBarVisible = p18.props.isChannelBarVisible,
		onFocus = p18.props.onFocus,
		onUnfocus = p18.props.onUnfocus
	}

	if FFlagExpChatWindowMessageSourceRefactor then
		return Roact.createElement(ChatWindowMessageSource, t3)
	end

	return Roact.createElement(ChatWindow, t3)
end

return RoactRodux.connect(function(p19) -- line: 236
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), FFlagEnableVerifiedBadgeStore (copy)
	local v55 = nil

	if GetFFlagTextChatEnableUniverseChatTabs() or FFlagExpChatChannelTabRefactor then
		local selectedChannelName = p19.TextChannels.selectedChannelName

		v55 = if not selectedChannelName or (not p19.ChannelTabs or not p19.ChannelTabs.allChannelTabs[selectedChannelName]) then not p19.ChannelTabs and "RBXGeneral" or (p19.ChannelTabs.selectedTabName or "RBXGeneral") else selectedChannelName
	end

	return {
		chatIntervention = p19.ChatIntervention,
		messages = if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatUseMessagesStore then p19.Messages else nil,
		mutedUserIds = if not FFlagExpChatUseMessagesStore then p19.MutedUsers else nil,
		verifiedUserIds = if not FFlagEnableVerifiedBadgeStore then p19.VerifiedUsers else nil,
		targetTextChannel = p19.TextChannels.targetTextChannel,
		selectedChannelName = v55
	}
end, function(_) -- line: 257
	-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
	return {
		onFocus = function() -- line: 259
			-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
			if FFlagExpChatTransparentFocusSupport then
				return GetTransparencyStore(false).setContextMenuOpen()
			end

			return GetTransparencyStore(false).setTextboxFocus()
		end,
		onUnfocus = function() -- line: 267
			-- upvalues: FFlagExpChatTransparentFocusSupport (copy), GetTransparencyStore (copy)
			if FFlagExpChatTransparentFocusSupport then
				return GetTransparencyStore(false).clearContextMenuOpen()
			end

			return GetTransparencyStore(false).clearTextboxFocus()
		end
	}
end)(v25)
