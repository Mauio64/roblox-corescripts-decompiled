local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local AppCommonLib = require(parent.AppCommonLib)
local OrderedMap = AppCommonLib.OrderedMap
local useCanAccessParty = require(parent.Squads.useCanAccessParty)

local RoactUtils = require(parent.RoactUtils)
local RoactRodux = RoactUtils.Hooks.RoactRodux
local useSelector = RoactRodux.useSelector
local useStore = RoactRodux.useStore

local Constants = require(AppChat.Components.EventReceivers.Constants)
require(AppChat.Components.EventReceivers.PlatformChatConversationTypes)

local useRealtimePlatformChatConversation = require(AppChat.Components.EventReceivers.useRealtimePlatformChatConversation)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local MessageModel = require(AppChat.Models.MessageModel)
local Types = require(script.Parent.Types)
local SmartSuggestionActionHandler = require(script.Parent.SmartSuggestionActionHandler)
local fetchSmartSuggestions = require(script.Parent.fetchSmartSuggestions)
local useStartPartySuggestion = require(script.Parent.useStartPartySuggestion)

local createSmartSuggestionActionHandler = SmartSuggestionActionHandler.createSmartSuggestionActionHandler
local SuggestionType = Types.SuggestionType

local function getConversationMessages(p, p2: string?) -- 2 equivalent calls inferred from this helper
	if p2 == nil then
		return nil
	end

	local deepValue = getDeepValue(p, `ChatAppReducer.Conversations.{p2}`)

	if deepValue == nil or deepValue.messages == nil then
		return nil
	end

	return deepValue.messages
end

local function getLatestUserMessageId(p, newestMessageConversationId: string?)
	local conversationMessages = getConversationMessages(p, newestMessageConversationId) -- inferred equivalent call

	if conversationMessages == nil or conversationMessages.keys == nil or conversationMessages.values == nil then
		return nil
	end

	for i = OrderedMap.Length(conversationMessages), 1, -1 do
		local v = OrderedMap.GetByIndex(conversationMessages, i)

		if v and v.senderType == MessageModel.SenderTypes.User then
			return v.id
		end
	end

	return nil
end

local function isMessageCommitted(p, newestMessageConversationId: string, messageId: string): boolean -- 2 equivalent calls inferred from this helper
	local conversationMessages = getConversationMessages(p, newestMessageConversationId) -- inferred equivalent call
	return conversationMessages ~= nil
		and conversationMessages.values ~= nil
		and OrderedMap.Get(conversationMessages, messageId) ~= nil
end

local function useSmartSuggestions(newestMessageConversationId: string, sendMessage, sendGameLinkChatMessage)
	local v = useStartPartySuggestion(newestMessageConversationId, (useCanAccessParty()))
	local canStartParty = v.canStartParty
	local startParty = v.startParty
	local v2 = useStore()
	local previousNewestUserMessageId2 = useSelector((React.useCallback(function(p)
		return getLatestUserMessageId(p, newestMessageConversationId)
	end, { newestMessageConversationId })))
	local v3 = React.useMemo(function()
		return createSmartSuggestionActionHandler({
			sendMessage = sendMessage,
			sendGameLinkChatMessage = sendGameLinkChatMessage,
			startParty = startParty
		})
	end, { sendMessage, sendGameLinkChatMessage, startParty })

	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)
	local suggestions = React.useMemo(function()
		return Cryo.List.filter(state, function(p)
			return p.type ~= SuggestionType.StartParty or canStartParty
		end)
	end, { state, canStartParty })

	local ref = React.useRef({
		requestId = 0,
		pendingRealtimeNotification = nil,
		previousNewestUserMessageId = previousNewestUserMessageId2,
		newestMessageConversationId = newestMessageConversationId
	})

	local v4 = React.useCallback(function()
		if newestMessageConversationId == nil then
			return
		end

		ref.current.requestId += 1
		local requestId = ref.current.requestId
		fetchSmartSuggestions(newestMessageConversationId):andThen(function(p)
			if ref.current.requestId ~= requestId then
				return
			end

			setState(p)
			setState2(false)
		end):catch(function() end)
	end, { newestMessageConversationId })

	React.useEffect(function()
		setState({})
		setState2(false)
		v4()
		return function()
			ref.current.requestId += 1
			ref.current.pendingRealtimeNotification = nil
		end
	end, { newestMessageConversationId, v4 })

	local v5 = React.useCallback(function(data)
		if
			data.Type ~= Constants.PlatformChatConversation.Types.ConversationSuggestionsGenerated
			or (newestMessageConversationId == nil or data.ConversationId ~= newestMessageConversationId)
		then
			return
		end

		local state3 = v2:getState()
		local latestUserMessageId = getLatestUserMessageId(state3, newestMessageConversationId)

		if data.MessageId == latestUserMessageId then
			if
				ref.current.newestMessageConversationId == newestMessageConversationId
				and ref.current.previousNewestUserMessageId == data.MessageId
			then
				v4()
			else
				ref.current.pendingRealtimeNotification = {
					conversationId = newestMessageConversationId,
					messageId = data.MessageId
				}
			end
		else
			if isMessageCommitted(state3, newestMessageConversationId, data.MessageId) then -- inferred equivalent call
				return
			end

			ref.current.pendingRealtimeNotification = {
				conversationId = newestMessageConversationId,
				messageId = data.MessageId
			}
		end
	end, { newestMessageConversationId, v2, v4 })

	useRealtimePlatformChatConversation(v5, { v5 })

	React.useEffect(function()
		local previousNewestUserMessageId = ref.current.previousNewestUserMessageId
		local newestMessageConversationId2 = ref.current.newestMessageConversationId
		ref.current.previousNewestUserMessageId = previousNewestUserMessageId2
		ref.current.newestMessageConversationId = newestMessageConversationId

		if not (previousNewestUserMessageId ~= previousNewestUserMessageId2 and newestMessageConversationId2 == newestMessageConversationId) then
			return
		end

		ref.current.requestId += 1
		setState({})
		setState2(false)

		local pendingRealtimeNotification = ref.current.pendingRealtimeNotification

		if
			pendingRealtimeNotification == nil
			or pendingRealtimeNotification.conversationId ~= newestMessageConversationId
		then
			return
		end

		if pendingRealtimeNotification.messageId == previousNewestUserMessageId2 then
			ref.current.pendingRealtimeNotification = nil
			v4()
		elseif isMessageCommitted(v2:getState(), newestMessageConversationId, pendingRealtimeNotification.messageId) then -- inferred equivalent call
			ref.current.pendingRealtimeNotification = nil
		end
	end, { previousNewestUserMessageId2, newestMessageConversationId, v2, v4 })

	return {
		suggestions = suggestions,
		areSuggestionsDismissed = state2,
		onActivated = React.useCallback(function(p)
			setState2(true)

			local v6 = v3(p, newestMessageConversationId)

			if typeof(v6) == "table" and typeof(v6.catch) == "function" then
				v6:catch(function()
					setState2(false)
				end)
			end
		end, { v3, newestMessageConversationId })
	}
end

return useSmartSuggestions
