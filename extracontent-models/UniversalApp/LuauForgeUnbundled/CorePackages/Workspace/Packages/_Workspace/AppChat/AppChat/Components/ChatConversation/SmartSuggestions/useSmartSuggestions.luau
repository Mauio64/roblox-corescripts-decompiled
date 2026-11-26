local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local orderedMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").OrderedMap
local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/useCanAccessParty")

local roactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux
local useSelector = roactRodux.useSelector
local useStore = roactRodux.useStore

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/PlatformChatConversationTypes")

local useRealtimePlatformChatConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/useRealtimePlatformChatConversation")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local Types = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types")
local SmartSuggestionActionHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/SmartSuggestionActionHandler")
local fetchSmartSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/fetchSmartSuggestions")
local useStartPartySuggestion = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/useStartPartySuggestion")

local createSmartSuggestionActionHandler = SmartSuggestionActionHandler.createSmartSuggestionActionHandler
local suggestionType = Types.SuggestionType

local function getConversationMessages(p2, p3)
	if p3 == nil then
		return nil
	end

	local v5 = getDeepValue(p2, `ChatAppReducer.Conversations.{p3}`)

	if v5 == nil or v5.messages == nil then
		return nil
	end

	return v5.messages
end

local function getLatestUserMessageId(p2, newestMessageConversationId)
	local messages

	if newestMessageConversationId ~= nil then
		local v5 = getDeepValue(p2, `ChatAppReducer.Conversations.{newestMessageConversationId}`)

		if not (v5 == nil or v5.messages == nil) then
			messages = v5.messages
		end
	end

	if messages == nil or messages.keys == nil or messages.values == nil then
		return nil
	end

	for i = orderedMap.Length(messages), 1, -1 do
		local v5 = orderedMap.GetByIndex(messages, i)

		if v5 and v5.senderType == MessageModel.SenderTypes.User then
			return v5.id
		end
	end

	return nil
end

local function isMessageCommitted(p2, p3, p4): boolean
	local messages

	if p3 ~= nil then
		local v5 = getDeepValue(p2, `ChatAppReducer.Conversations.{p3}`)

		if not (v5 == nil or v5.messages == nil) then
			messages = v5.messages
		end
	end

	return messages ~= nil and messages.values ~= nil and orderedMap.Get(messages, p4) ~= nil
end

local function useSmartSuggestions(newestMessageConversationId, p2, p3)
	local v6 = useStartPartySuggestion(newestMessageConversationId, (useCanAccessParty()))
	local canStartParty = v6.canStartParty
	local startParty = v6.startParty
	local v7 = useStore()
	local v9 = useSelector((React.useCallback(function(p4)
		return getLatestUserMessageId(p4, newestMessageConversationId)
	end, { newestMessageConversationId })))
	local v10 = React.useMemo(function()
		return createSmartSuggestionActionHandler({
			sendMessage = p2,
			sendGameLinkChatMessage = p3,
			startParty = startParty
		})
	end, { p2, p3, startParty })

	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)
	local v11 = React.useMemo(function()
		return Cryo.List.filter(state, function(p4)
			return p4.type ~= suggestionType.StartParty or canStartParty
		end)
	end, { state, canStartParty })

	local ref = React.useRef({
		requestId = 0,
		pendingRealtimeNotification = nil,
		previousNewestUserMessageId = v9,
		newestMessageConversationId = newestMessageConversationId
	})

	local v12 = React.useCallback(function()
		if newestMessageConversationId == nil then
			return
		end

		ref.current.requestId += 1
		local requestId = ref.current.requestId
		fetchSmartSuggestions(newestMessageConversationId):andThen(function(p4)
			if ref.current.requestId ~= requestId then
				return
			end

			setState(p4)
			setState2(false)
		end):catch(function() end)
	end, { newestMessageConversationId })

	React.useEffect(function()
		setState({})
		setState2(false)
		v12()
		return function()
			ref.current.requestId += 1
			ref.current.pendingRealtimeNotification = nil
		end
	end, { newestMessageConversationId, v12 })

	local v13 = React.useCallback(function(data)
		if
			data.Type ~= Constants.PlatformChatConversation.Types.ConversationSuggestionsGenerated
			or (newestMessageConversationId == nil or data.ConversationId ~= newestMessageConversationId)
		then
			return
		end

		local state3 = v7:getState()
		local latestUserMessageId = getLatestUserMessageId(state3, newestMessageConversationId)

		if data.MessageId == latestUserMessageId then
			if
				ref.current.newestMessageConversationId == newestMessageConversationId
				and ref.current.previousNewestUserMessageId == data.MessageId
			then
				v12()
			else
				ref.current.pendingRealtimeNotification = {
					conversationId = newestMessageConversationId,
					messageId = data.MessageId
				}
			end
		else
			local v14 = newestMessageConversationId
			local messageId = data.MessageId
			local messages

			if v14 ~= nil then
				local v15 = getDeepValue(state3, `ChatAppReducer.Conversations.{v14}`)

				if not (v15 == nil or v15.messages == nil) then
					messages = v15.messages
				end
			end

			local v15

			if messages == nil or messages.values == nil then
				v15 = false
			else
				v15 = orderedMap.Get(messages, messageId) ~= nil
			end

			if v15 then
				return
			end

			ref.current.pendingRealtimeNotification = {
				conversationId = newestMessageConversationId,
				messageId = data.MessageId
			}
		end
	end, { newestMessageConversationId, v7, v12 })

	useRealtimePlatformChatConversation(v13, { v13 })

	React.useEffect(function()
		local previousNewestUserMessageId = ref.current.previousNewestUserMessageId
		local newestMessageConversationId2 = ref.current.newestMessageConversationId
		ref.current.previousNewestUserMessageId = v9
		ref.current.newestMessageConversationId = newestMessageConversationId

		if not (previousNewestUserMessageId ~= v9 and newestMessageConversationId2 == newestMessageConversationId) then
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

		if pendingRealtimeNotification.messageId == v9 then
			ref.current.pendingRealtimeNotification = nil
			v12()
		else
			local state3 = v7:getState()
			local v14 = newestMessageConversationId
			local messageId = pendingRealtimeNotification.messageId
			local messages

			if v14 ~= nil then
				local v15 = getDeepValue(state3, `ChatAppReducer.Conversations.{v14}`)

				if not (v15 == nil or v15.messages == nil) then
					messages = v15.messages
				end
			end

			local v15

			if messages == nil or messages.values == nil then
				v15 = false
			else
				v15 = orderedMap.Get(messages, messageId) ~= nil
			end

			if v15 then
				ref.current.pendingRealtimeNotification = nil
			end
		end
	end, { v9, newestMessageConversationId, v7, v12 })

	return {
		suggestions = v11,
		areSuggestionsDismissed = state2,
		onActivated = React.useCallback(function(p4)
			setState2(true)

			local v14 = v10(p4, newestMessageConversationId)

			if typeof(v14) == "table" and typeof(v14.catch) == "function" then
				v14:catch(function()
					setState2(false)
				end)
			end
		end, { v10, newestMessageConversationId })
	}
end

return useSmartSuggestions
