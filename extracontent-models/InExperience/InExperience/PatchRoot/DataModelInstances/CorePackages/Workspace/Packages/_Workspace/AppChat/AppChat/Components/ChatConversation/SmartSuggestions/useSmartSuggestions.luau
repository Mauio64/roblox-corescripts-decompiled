local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local useCanAccessParty = require(AppChatParent.Squads.useCanAccessParty)
local RoactRodux = require(AppChatParent.RoactUtils).Hooks.RoactRodux
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
local t1 = {}

local function getConversationMessages(p1, s1: string?) -- line: 50
	-- upvalues: getDeepValue (copy)
	if s1 == nil then
		return nil
	end

	local v27 = getDeepValue(p1, `ChatAppReducer.Conversations.{ s1 }`)

	if v27 == nil or v27.messages == nil then
		return nil
	end

	return v27.messages
end
local function getLatestUserMessageId(p2, s2: string?) -- line: 63
	-- upvalues: getDeepValue (copy), OrderedMap (copy), MessageModel (copy)
	local v30

	if s2 == nil then
		v30 = nil
	else
		local v31 = getDeepValue(p2, `ChatAppReducer.Conversations.{ s2 }`)

		v30 = if v31 ~= nil and v31.messages ~= nil then v31.messages else nil
	end

	if v30 == nil or v30.keys == nil or v30.values == nil then
		return nil
	end

	for i = OrderedMap.Length(v30), 1, -1 do
		local v33 = OrderedMap.GetByIndex(v30, i)

		if v33 and v33.senderType == MessageModel.SenderTypes.User then
			return v33.id
		end
	end

	return nil
end
local function isMessageCommitted(p3, s3: string, s4: string) -- line: 79
	-- upvalues: getDeepValue (copy), OrderedMap (copy)
	local v37

	if s3 == nil then
		v37 = nil
	else
		local v38 = getDeepValue(p3, `ChatAppReducer.Conversations.{ s3 }`)

		v37 = if v38 ~= nil and v38.messages ~= nil then v38.messages else nil
	end

	return v37 ~= nil and (v37.values ~= nil and OrderedMap.Get(v37, s4) ~= nil)
end
local function useSmartSuggestions(s5: string, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 84
	-- upvalues: useCanAccessParty (copy), useStartPartySuggestion (copy), useStore (copy), React (copy), getLatestUserMessageId (copy), useSelector (copy), createSmartSuggestionActionHandler (copy), t1 (copy), Cryo (copy), SuggestionType (copy), fetchSmartSuggestions (copy), Constants (copy), getDeepValue (copy), OrderedMap (copy), useRealtimePlatformChatConversation (copy)
	local v42 = useCanAccessParty()
	local v43 = useStartPartySuggestion(s5, v42)
	local canStartParty = v43.canStartParty
	local startParty = v43.startParty
	local v46 = useStore()
	local v47 = React.useCallback(function(p6) -- line: 94
		-- upvalues: getLatestUserMessageId (copy), s5 (copy)
		return (getLatestUserMessageId(p6, s5))
	end, { s5 })
	local v48 = useSelector(v47)
	local v49 = React.useMemo(function() -- line: 98
		-- upvalues: createSmartSuggestionActionHandler (copy), p4 (copy), p5 (copy), startParty (copy)
		return createSmartSuggestionActionHandler({
			sendMessage = p4,
			sendGameLinkChatMessage = p5,
			startParty = startParty
		})
	end, {
		p4,
		p5,
		startParty
	})
	local v50, v51 = React.useState({})
	local v52, v53 = React.useState(t1)
	local v54 = React.useMemo(function() -- line: 108
		-- upvalues: Cryo (copy), v50 (copy), SuggestionType (copy), canStartParty (copy)
		return Cryo.List.filter(v50, function(p7) -- line: 109
			-- upvalues: SuggestionType (copy), canStartParty (copy)
			return p7.type ~= SuggestionType.StartParty or canStartParty
		end)
	end, {
		v50,
		canStartParty
	})
	local v55 = React.useRef({
		requestId = 0,
		pendingRealtimeNotification = nil,
		previousNewestUserMessageId = v48,
		newestMessageConversationId = s5
	})
	local v56 = React.useCallback(function() -- line: 124
		-- upvalues: s5 (copy), v55 (copy), fetchSmartSuggestions (copy), v51 (copy), v53 (copy), t1 (copy)
		if s5 == nil then
			return
		end

		local current = v55.current

		current.requestId = current.requestId + 1

		local requestId = v55.current.requestId

		fetchSmartSuggestions(s5):andThen(function(t2: {[any]: any}) -- line: 131
			-- upvalues: v55 (copy), requestId (copy), v51 (copy), v53 (copy), t1 (copy)
			if v55.current.requestId ~= requestId then
				return
			end

			v51(t2)
			v53(t1)
		end):catch(function() -- line: 138
		end)
	end, { s5 })

	React.useEffect(function() -- line: 145
		-- upvalues: v51 (copy), v53 (copy), t1 (copy), v56 (copy), v55 (copy)
		v51({})
		v53(t1)
		v56()

		return function() -- line: 149
			-- upvalues: v55 (copy)
			local current = v55.current

			current.requestId = current.requestId + 1
			v55.current.pendingRealtimeNotification = nil
		end
	end, {
		s5,
		v56
	})

	local v57 = React.useCallback(function(p8) -- line: 156
		-- upvalues: Constants (copy), s5 (copy), v46 (copy), getLatestUserMessageId (copy), getDeepValue (copy), OrderedMap (copy), v55 (copy), v56 (copy)
		if p8.Type ~= Constants.PlatformChatConversation.Types.ConversationSuggestionsGenerated then
			return
		end

		if s5 == nil or p8.ConversationId ~= s5 then
			return
		end

		local v63 = v46:getState()

		if getLatestUserMessageId(v63, s5) ~= p8.MessageId then
			local v64 = s5
			local MessageId = p8.MessageId
			local v66

			if v64 == nil then
				v66 = nil
			else
				local v67 = getDeepValue(v63, `ChatAppReducer.Conversations.{ v64 }`)

				v66 = if v67 ~= nil and v67.messages ~= nil then v67.messages else nil
			end

			if v66 ~= nil and (v66.values ~= nil and OrderedMap.Get(v66, MessageId) ~= nil) then
				return
			end

			v55.current.pendingRealtimeNotification = {
				conversationId = s5,
				messageId = p8.MessageId
			}

			return
		end

		if v55.current.newestMessageConversationId ~= s5 or v55.current.previousNewestUserMessageId ~= p8.MessageId then
			v55.current.pendingRealtimeNotification = {
				conversationId = s5,
				messageId = p8.MessageId
			}

			return
		end

		v56()
	end, {
		s5,
		v46,
		v56
	})

	useRealtimePlatformChatConversation(v57, { v57 })
	React.useEffect(function() -- line: 198
		-- upvalues: v55 (copy), v48 (copy), s5 (copy), v51 (copy), v53 (copy), t1 (copy), v56 (copy), v46 (copy), getDeepValue (copy), OrderedMap (copy)
		local previousNewestUserMessageId = v55.current.previousNewestUserMessageId
		local newestMessageConversationId = v55.current.newestMessageConversationId

		v55.current.previousNewestUserMessageId = v48
		v55.current.newestMessageConversationId = s5

		if previousNewestUserMessageId == v48 then
			return
		end

		if newestMessageConversationId ~= s5 then
			return
		end

		local current = v55.current

		current.requestId = current.requestId + 1
		v51({})
		v53(t1)

		local pendingRealtimeNotification = v55.current.pendingRealtimeNotification

		if pendingRealtimeNotification == nil or pendingRealtimeNotification.conversationId ~= s5 then
			return
		end

		if pendingRealtimeNotification.messageId == v48 then
			v55.current.pendingRealtimeNotification = nil
			v56()

			return
		end

		local v72 = v46:getState()
		local v73 = s5
		local messageId = pendingRealtimeNotification.messageId
		local v75

		if v73 == nil then
			v75 = nil
		else
			local v76 = getDeepValue(v72, `ChatAppReducer.Conversations.{ v73 }`)

			v75 = if v76 ~= nil and v76.messages ~= nil then v76.messages else nil
		end

		if v75 ~= nil and (v75.values ~= nil and OrderedMap.Get(v75, messageId) ~= nil) then
			v55.current.pendingRealtimeNotification = nil
		end
	end, {
		v48,
		s5,
		v46,
		v56
	})

	local v58 = React.useCallback(function(p9) -- line: 229
		-- upvalues: v53 (copy), Cryo (copy), v49 (copy), s5 (copy)
		v53(function(t3: {[any]: any}) -- line: 231
			-- upvalues: Cryo (copy), p9 (copy)
			return Cryo.Dictionary.join(t3, {
				[p9] = true
			})
		end)

		local v78 = v49(p9, s5)

		if typeof(v78) == "table" and typeof(v78.catch) == "function" then
			v78:catch(function() -- line: 238
				-- upvalues: v53 (copy), Cryo (copy), p9 (copy)
				v53(function(t4: {[any]: any}) -- line: 239
					-- upvalues: Cryo (copy), p9 (copy)
					return Cryo.Dictionary.join(t4, {
						[p9] = Cryo.None
					})
				end)
			end)
		end
	end, {
		v49,
		s5
	})

	return {
		suggestions = v54,
		hiddenSuggestions = v52,
		onActivated = v58
	}
end

return useSmartSuggestions
