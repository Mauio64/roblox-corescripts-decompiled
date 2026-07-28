local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local RoactRodux = require(AppChatParent.RoactUtils).Hooks.RoactRodux
local useSelector = RoactRodux.useSelector
local useStore = RoactRodux.useStore
local Constants = require(AppChat.Components.EventReceivers.Constants)

require(AppChat.Components.EventReceivers.PlatformChatConversationTypes)

local useRealtimePlatformChatConversation = require(AppChat.Components.EventReceivers.useRealtimePlatformChatConversation)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local MessageModel = require(AppChat.Models.MessageModel)

require(script.Parent.Types)

local SmartSuggestionActionHandler = require(script.Parent.SmartSuggestionActionHandler)
local fetchSmartSuggestions = require(script.Parent.fetchSmartSuggestions)
local createSmartSuggestionActionHandler = SmartSuggestionActionHandler.createSmartSuggestionActionHandler
local t1 = {}

local function getConversationMessages(p1, s1: string?) -- line: 47
	-- upvalues: getDeepValue (copy)
	if s1 == nil then
		return nil
	end

	local v23 = getDeepValue(p1, `ChatAppReducer.Conversations.{ s1 }`)

	if v23 == nil or v23.messages == nil then
		return nil
	end

	return v23.messages
end
local function getLatestUserMessageId(p2, s2: string?) -- line: 60
	-- upvalues: getDeepValue (copy), OrderedMap (copy), MessageModel (copy)
	local v26

	if s2 == nil then
		v26 = nil
	else
		local v27 = getDeepValue(p2, `ChatAppReducer.Conversations.{ s2 }`)

		v26 = if v27 ~= nil and v27.messages ~= nil then v27.messages else nil
	end

	if v26 == nil or v26.keys == nil or v26.values == nil then
		return nil
	end

	for i = OrderedMap.Length(v26), 1, -1 do
		local v29 = OrderedMap.GetByIndex(v26, i)

		if v29 and v29.senderType == MessageModel.SenderTypes.User then
			return v29.id
		end
	end

	return nil
end
local function isMessageCommitted(p3, s3: string, s4: string) -- line: 76
	-- upvalues: getDeepValue (copy), OrderedMap (copy)
	local v33

	if s3 == nil then
		v33 = nil
	else
		local v34 = getDeepValue(p3, `ChatAppReducer.Conversations.{ s3 }`)

		v33 = if v34 ~= nil and v34.messages ~= nil then v34.messages else nil
	end

	return v33 ~= nil and (v33.values ~= nil and OrderedMap.Get(v33, s4) ~= nil)
end
local function useSmartSuggestions(s5: string, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 81
	-- upvalues: useStore (copy), React (copy), getLatestUserMessageId (copy), useSelector (copy), createSmartSuggestionActionHandler (copy), t1 (copy), fetchSmartSuggestions (copy), Constants (copy), getDeepValue (copy), OrderedMap (copy), useRealtimePlatformChatConversation (copy), Cryo (copy)
	local v38 = useStore()
	local v39 = React.useCallback(function(p6) -- line: 87
		-- upvalues: getLatestUserMessageId (copy), s5 (copy)
		return (getLatestUserMessageId(p6, s5))
	end, { s5 })
	local v40 = useSelector(v39)
	local v41 = React.useMemo(function() -- line: 91
		-- upvalues: createSmartSuggestionActionHandler (copy), p4 (copy), p5 (copy)
		return createSmartSuggestionActionHandler({
			sendMessage = p4,
			sendGameLinkChatMessage = p5
		})
	end, {
		p4,
		p5
	})
	local v42, v43 = React.useState({})
	local v44, v45 = React.useState(t1)
	local v46 = React.useRef({
		requestId = 0,
		pendingRealtimeNotification = nil,
		previousNewestUserMessageId = v40,
		newestMessageConversationId = s5
	})
	local v47 = React.useCallback(function() -- line: 111
		-- upvalues: s5 (copy), v46 (copy), fetchSmartSuggestions (copy), v43 (copy), v45 (copy), t1 (copy)
		if s5 == nil then
			return
		end

		local current = v46.current

		current.requestId = current.requestId + 1

		local requestId = v46.current.requestId

		fetchSmartSuggestions(s5):andThen(function(t2: {[any]: any}) -- line: 118
			-- upvalues: v46 (copy), requestId (copy), v43 (copy), v45 (copy), t1 (copy)
			if v46.current.requestId ~= requestId then
				return
			end

			v43(t2)
			v45(t1)
		end):catch(function() -- line: 125
		end)
	end, { s5 })

	React.useEffect(function() -- line: 132
		-- upvalues: v43 (copy), v45 (copy), t1 (copy), v47 (copy), v46 (copy)
		v43({})
		v45(t1)
		v47()

		return function() -- line: 136
			-- upvalues: v46 (copy)
			local current = v46.current

			current.requestId = current.requestId + 1
			v46.current.pendingRealtimeNotification = nil
		end
	end, {
		s5,
		v47
	})

	local v48 = React.useCallback(function(p7) -- line: 143
		-- upvalues: Constants (copy), s5 (copy), v38 (copy), getLatestUserMessageId (copy), getDeepValue (copy), OrderedMap (copy), v46 (copy), v47 (copy)
		if p7.Type ~= Constants.PlatformChatConversation.Types.ConversationSuggestionsGenerated then
			return
		end

		if s5 == nil or p7.ConversationId ~= s5 then
			return
		end

		local v54 = v38:getState()

		if getLatestUserMessageId(v54, s5) ~= p7.MessageId then
			local v55 = s5
			local MessageId = p7.MessageId
			local v57

			if v55 == nil then
				v57 = nil
			else
				local v58 = getDeepValue(v54, `ChatAppReducer.Conversations.{ v55 }`)

				v57 = if v58 ~= nil and v58.messages ~= nil then v58.messages else nil
			end

			if v57 ~= nil and (v57.values ~= nil and OrderedMap.Get(v57, MessageId) ~= nil) then
				return
			end

			v46.current.pendingRealtimeNotification = {
				conversationId = s5,
				messageId = p7.MessageId
			}

			return
		end

		if v46.current.newestMessageConversationId ~= s5 or v46.current.previousNewestUserMessageId ~= p7.MessageId then
			v46.current.pendingRealtimeNotification = {
				conversationId = s5,
				messageId = p7.MessageId
			}

			return
		end

		v47()
	end, {
		s5,
		v38,
		v47
	})

	useRealtimePlatformChatConversation(v48, { v48 })
	React.useEffect(function() -- line: 185
		-- upvalues: v46 (copy), v40 (copy), s5 (copy), v43 (copy), v45 (copy), t1 (copy), v47 (copy), v38 (copy), getDeepValue (copy), OrderedMap (copy)
		local previousNewestUserMessageId = v46.current.previousNewestUserMessageId
		local newestMessageConversationId = v46.current.newestMessageConversationId

		v46.current.previousNewestUserMessageId = v40
		v46.current.newestMessageConversationId = s5

		if previousNewestUserMessageId == v40 then
			return
		end

		if newestMessageConversationId ~= s5 then
			return
		end

		local current = v46.current

		current.requestId = current.requestId + 1
		v43({})
		v45(t1)

		local pendingRealtimeNotification = v46.current.pendingRealtimeNotification

		if pendingRealtimeNotification == nil or pendingRealtimeNotification.conversationId ~= s5 then
			return
		end

		if pendingRealtimeNotification.messageId == v40 then
			v46.current.pendingRealtimeNotification = nil
			v47()

			return
		end

		local v63 = v38:getState()
		local v64 = s5
		local messageId = pendingRealtimeNotification.messageId
		local v66

		if v64 == nil then
			v66 = nil
		else
			local v67 = getDeepValue(v63, `ChatAppReducer.Conversations.{ v64 }`)

			v66 = if v67 ~= nil and v67.messages ~= nil then v67.messages else nil
		end

		if v66 ~= nil and (v66.values ~= nil and OrderedMap.Get(v66, messageId) ~= nil) then
			v46.current.pendingRealtimeNotification = nil
		end
	end, {
		v40,
		s5,
		v38,
		v47
	})

	local v49 = React.useCallback(function(p8) -- line: 216
		-- upvalues: v45 (copy), Cryo (copy), v41 (copy), s5 (copy)
		v45(function(t3: {[any]: any}) -- line: 218
			-- upvalues: Cryo (copy), p8 (copy)
			return Cryo.Dictionary.join(t3, {
				[p8] = true
			})
		end)

		local v69 = v41(p8, s5)

		if typeof(v69) == "table" and typeof(v69.catch) == "function" then
			v69:catch(function() -- line: 225
				-- upvalues: v45 (copy), Cryo (copy), p8 (copy)
				v45(function(t4: {[any]: any}) -- line: 226
					-- upvalues: Cryo (copy), p8 (copy)
					return Cryo.Dictionary.join(t4, {
						[p8] = Cryo.None
					})
				end)
			end)
		end
	end, {
		v41,
		s5
	})

	return {
		suggestions = v42,
		hiddenSuggestions = v44,
		onActivated = v49
	}
end

return useSmartSuggestions
