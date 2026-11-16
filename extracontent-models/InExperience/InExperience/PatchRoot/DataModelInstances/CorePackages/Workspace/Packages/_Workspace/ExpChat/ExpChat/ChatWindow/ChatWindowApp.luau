local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local memoize = require(ExpChat.memoize)
local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore

local ui = script.Parent.UI
local ChatWindowMessageSource = require(ui.ChatWindow.ChatWindowMessageSource)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags2.FFlagExpChatUseChannelTabsStore
local GetChannelTabsStore

if FFlagExpChatUseChannelTabsStore then
	GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
else
	GetChannelTabsStore = nil
end

local defineFastFlag = game:DefineFastFlag("ExpChatMoveMessagesStoreToInit", false)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatMessagesStoreUseProxy = require(ExpChat.Flags.FFlagExpChatMessagesStoreUseProxy)

local function readByMessageIdAsTable(messagesStore, p)
	local selected

	if p then
		selected = messagesStore.getByMessageId(p)
	else
		selected = messagesStore.getByMessageId(false)
	end

	if not FFlagExpChatMessagesStoreUseProxy then
		return selected
	end

	local result = {}

	for k, v in selected do
		result[k] = v
	end

	return result
end

local v = Roact.Component:extend("ChatWindowApp")
v.defaultProps = {
	LayoutOrder = 1,
	messages = not FFlagExpChatEnableV2ChatWindow and {} or nil,
	size = UDim2.fromScale(1, 1)
}
local v2

if GetFFlagTextChatEnableUniverseChatTabs() then
	v2 = memoize(function(data, p, p2, p3)
		if not p then
			return list.map(data.windowMessagesInOrder, function(p4)
				return data.byMessageId[p4]
			end)
		end

		if FFlagExpChatGlobalTabDefault then
			if p2 and data.windowMessagesInOrderByTabId[p2.Name] and p3 ~= "RBXGlobal" then
				p3 = p2.Name
			end
		elseif p2 and data.windowMessagesInOrderByTabId[p2.Name] then
			p3 = p2.Name
		end

		if p3 then
			return list.map(data.windowMessagesInOrderByTabId[p3] or {}, function(p4)
				return data.byMessageId[p4]
			end)
		end

		return {}
	end)
else
	v2 = memoize(function(data, p, p2)
		if not p then
			return list.map(data.windowMessagesInOrder, function(p3)
				return data.byMessageId[p3]
			end)
		end

		if p2 then
			return list.map(data.windowMessagesInOrderByTabId[p2.Name] or {}, function(p3)
				return data.byMessageId[p3]
			end)
		end

		return {}
	end)
end

if not FFlagExpChatEnableV2ChatWindow then
	function v:init()
		self.MessagesStore = GetMessagesStore(false)
		self.disposeEffects = {}

		if defineFastFlag and self.MessagesStore then
			self.state = {
				messagesState = {
					byMessageId = readByMessageIdAsTable(self.MessagesStore),
					windowMessagesInOrder = self.MessagesStore.getWindowMessagesInOrder(false),
					windowMessagesInOrderByTabId = self.MessagesStore.getWindowMessagesInOrderByTabId(false)
				}
			}
		else
			self.state = { messagesState = nil }
		end
	end

	function v.didMount(object)
		if object.MessagesStore then
			local messagesState = not defineFastFlag
				and {
					byMessageId = readByMessageIdAsTable(object.MessagesStore),
					windowMessagesInOrder = object.MessagesStore.getWindowMessagesInOrder(false),
					windowMessagesInOrderByTabId = object.MessagesStore.getWindowMessagesInOrderByTabId(false)
				}

			if messagesState then
				object:setState({ messagesState = messagesState })
			end

			local effect = createEffect(function(p)
				local byMessageId = readByMessageIdAsTable(object.MessagesStore, p)
				local windowMessagesInOrder = object.MessagesStore.getWindowMessagesInOrder(p)
				local windowMessagesInOrderByTabId = object.MessagesStore.getWindowMessagesInOrderByTabId(p)

				if byMessageId or windowMessagesInOrder or windowMessagesInOrderByTabId then
					object:setState({
						messagesState = {
							byMessageId = byMessageId,
							windowMessagesInOrder = windowMessagesInOrder,
							windowMessagesInOrderByTabId = windowMessagesInOrderByTabId
						}
					})
				end
			end)

			table.insert(object.disposeEffects, effect)
		end
	end

	function v:willUnmount()
		if self.disposeEffects then
			for _, disposeEffect in ipairs(self.disposeEffects) do
				disposeEffect()
			end

			self.disposeEffects = {}
		end
	end
end

function v.render(p)
	local messages

	if not FFlagExpChatEnableV2ChatWindow then
		local messagesState = p.state.messagesState

		if messagesState then
			if GetFFlagTextChatEnableUniverseChatTabs() then
				messages = v2(
					messagesState,
					p.props.isChannelBarVisible,
					p.props.targetTextChannel,
					p.props.selectedChannelName
				)
			else
				messages = v2(messagesState, p.props.isChannelBarVisible, p.props.targetTextChannel)
			end
		else
			messages = {}
		end
	end

	local v3 = {
		LayoutOrder = p.props.LayoutOrder,
		messages = 0,
		size = 0,
		transparencyValue = 0,
		textTransparency = 0,
		onHovered = 0,
		onUnhovered = 0,
		verifiedUserIds = 0,
		activateWhisperMode = 0,
		resetTargetChannel = 0,
		visible = 0,
		onAbsoluteSizeChanged = 0,
		onAbsolutePositionChanged = 0,
		chatWindowSettings = 0,
		showTranslationButton = 0,
		targetTextChannel = 0,
		selectedChannelName = 0,
		scrollResetKey = 0,
		isChannelBarVisible = 0,
		onFocus = 0,
		onUnfocus = 0
	}

	if FFlagExpChatEnableV2ChatWindow then
		messages = nil
	end

	v3.messages = messages
	v3.size = p.props.size
	v3.transparencyValue = p.props.transparencyValue
	v3.textTransparency = p.props.textTransparency
	v3.onHovered = p.props.onHovered
	v3.onUnhovered = p.props.onUnhovered
	v3.verifiedUserIds = p.props.verifiedUserIds
	v3.activateWhisperMode = p.props.activateWhisperMode
	v3.resetTargetChannel = p.props.resetTargetChannel
	v3.visible = p.props.visible
	v3.onAbsoluteSizeChanged = p.props.onAbsoluteSizeChanged
	v3.onAbsolutePositionChanged = p.props.onAbsolutePositionChanged
	v3.chatWindowSettings = p.props.chatWindowSettings
	v3.showTranslationButton = p.props.showTranslationButton
	v3.targetTextChannel = p.props.targetTextChannel

	v3.selectedChannelName = p.props.selectedChannelName

	v3.scrollResetKey = p.props.selectedChannelName
	v3.isChannelBarVisible = p.props.isChannelBarVisible
	v3.onFocus = p.props.onFocus
	v3.onUnfocus = p.props.onUnfocus

	return Roact.createElement(ChatWindowMessageSource, v3)
end

local function haveSameTabNames(items, items2): boolean
	if items == items2 then
		return true
	end

	for k in items do
		if items2[k] == nil then
			return false
		end
	end

	for k in items2 do
		if items[k] == nil then
			return false
		end
	end

	return true
end

local memo = React.memo(v)

local function ChatWindowAppWithSignals(p)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(p2)
			return {
				allChannelTabs = channelTabsState.allChannelTabs,
				selectedTabName = channelTabsState.selectedTabName
			}
		end, function(p2, p3): boolean
			if p2.selectedTabName ~= p3.selectedTabName then
				return false
			end

			local allChannelTabs = p2.allChannelTabs
			local allChannelTabs2 = p3.allChannelTabs

			if allChannelTabs == allChannelTabs2 then
				return true
			end

			for k in allChannelTabs do
				if allChannelTabs2[k] == nil then
					return false
				end
			end

			for k in allChannelTabs2 do
				if allChannelTabs[k] == nil then
					return false
				end
			end

			return true
		end)
	end, {})
	local v4 = SignalsReact.useSignalState(v3)

	local roduxSelectedChannelName = p.roduxSelectedChannelName

	local selectedTabName = not (roduxSelectedChannelName and v4.allChannelTabs[roduxSelectedChannelName])
		and (v4.selectedTabName or "RBXGeneral")
		or roduxSelectedChannelName

	return React.createElement(memo, Cryo.Dictionary.union(p, {
		selectedChannelName = selectedTabName
	}))
end

local v3 = RoactRodux.connect(function(data)
	local selectedTabName

	if not FFlagExpChatUseChannelTabsStore then
		local channelTabs = data.ChannelTabs
		local selectedChannelName = data.TextChannels.selectedChannelName
		selectedTabName = not (selectedChannelName and channelTabs and channelTabs.allChannelTabs[selectedChannelName])
			and (channelTabs and channelTabs.selectedTabName or "RBXGeneral")
			or selectedChannelName
	end

	local v3 = {
		chatIntervention = data.ChatIntervention,
		verifiedUserIds = 0,
		targetTextChannel = 0,
		selectedChannelName = 0,
		roduxSelectedChannelName = 0
	}
	local verifiedUserIds

	if not FFlagEnableVerifiedBadgeStore then
		verifiedUserIds = data.VerifiedUsers
	end

	v3.verifiedUserIds = verifiedUserIds
	v3.targetTextChannel = data.TextChannels.targetTextChannel
	v3.selectedChannelName = selectedTabName
	local roduxSelectedChannelName

	if FFlagExpChatUseChannelTabsStore then
		roduxSelectedChannelName = data.TextChannels.selectedChannelName
	end

	v3.roduxSelectedChannelName = roduxSelectedChannelName
	return v3
end, function(_)
	return {
		onFocus = function()
			return GetTransparencyStore(false).setContextMenuOpen()
		end,
		onUnfocus = function()
			return GetTransparencyStore(false).clearContextMenuOpen()
		end
	}
end)

if FFlagExpChatUseChannelTabsStore then
	v = ChatWindowAppWithSignals
end

return v3(v)
