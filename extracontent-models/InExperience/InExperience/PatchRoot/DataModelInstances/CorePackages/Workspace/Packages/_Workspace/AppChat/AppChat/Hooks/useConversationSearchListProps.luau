local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Time = require(parent.Time)
local DateTime = Time.DateTime
local React = require(parent.React)
local SignalsExperimental = require(parent.SignalsExperimental)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore

local SocialLibraries = require(AppChat.SocialLibraries)
local RoactPaginator = SocialLibraries.RoactPaginator
local ConversationRoduxSeed = require(AppChat.Utils.ConversationRoduxSeed)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationViewModelStore = require(AppChat.Stores.GetConversationViewModelStore)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getLastMessageContent = require(AppChat.Conversations.getLastMessageContent)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)
local useConversationSearch = require(AppChat.Hooks.useConversationSearch)
local useChatSearchResultsTelemetry = require(AppChat.Hooks.useChatSearchResultsTelemetry)
local FFlagAppChatSearchSessionTelemetry = require(AppChat.Flags.FFlagAppChatSearchSessionTelemetry)

local FFlagAppChatDerivedConversationLatestActivity = require(AppChat.Flags.FFlagAppChatDerivedConversationLatestActivity)

local v = {}
local v2 = {}

local function toLuaDateTime(lastUpdated) -- 1 equivalent call inferred from this helper
	if typeof(lastUpdated) == "DateTime" then
		return DateTime.fromUnixTimestamp(lastUpdated.UnixTimestamp)
	end

	if type(lastUpdated) == "table" and typeof(lastUpdated.dateTime) == "DateTime" then
		return lastUpdated
	end

	return nil
end

local function getInboxRowFields(id: string)
	if GetConversationStore(false).getConversation(id, false) == nil then
		return nil, nil
	end

	local conversationViewModelStore = GetConversationViewModelStore(false)
	local v3 = conversationViewModelStore.getUnixTime(id)(false)
	local v4

	if v3 ~= nil then
		v4 = DateTime.fromUnixTimestamp(v3)
	end

	return v4, conversationViewModelStore.getSubtitle(id)(false)
end

local function buildSearchItemList(items, p: string?, flag: boolean)
	local searchItemList = {}

	for _, joined in items do
		if joined.otherParticipants == nil then
			joined = Cryo.Dictionary.join(joined, {
				otherParticipants = getOtherParticipants(joined, p)
			})
		end

		if not (flag or joined.conversationType ~= "MultiUserConversation") then
			continue
		end

		local luaDateTime = toLuaDateTime(joined.lastUpdated) -- inferred equivalent call
		local lastMessageContent = getLastMessageContent(joined) or ""

		if FFlagAppChatDerivedConversationLatestActivity then
			local inboxRowFields, v3 = getInboxRowFields(joined.id)
			lastMessageContent = v3 or lastMessageContent
			luaDateTime = inboxRowFields or luaDateTime
		end

		table.insert(searchItemList, Cryo.Dictionary.join(joined, {
			title = getConversationTitle(joined),
			lastMessageContent = lastMessageContent,
			shortRelativeTime = luaDateTime and getConversationTimestamp(luaDateTime),
			longRelativeTime = luaDateTime and luaDateTime:GetLongRelativeTime(),
			unixTime = luaDateTime and luaDateTime:GetUnixTimestamp(),
			isSearchResult = true
		}))
	end

	return searchItemList
end

local function useConversationSearchListProps(p: string?, flag: boolean, p2: string?, flag2: boolean, callback, p3: string?)
	local v3 = useConversationSearch(p, flag, p3)
	local v4 = useDispatch()
	local v5 = useStore()

	local navigateToConversation = React.useCallback(function(p4: string)
		local conversation = GetConversationStore(false).getConversation(p4, false)
		local state = v5:getState()
		local v6

		if conversation == nil then
			v6 = false
		else
			v6 = state.ChatAppReducer.Conversations[p4] == nil
		end

		if v6 or searchIntroducedConversationIds.has(p4) then
			SignalsExperimental.batch(function()
				if v6 then
					v4(ReceivedConversation(ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)))
				end

				searchIntroducedConversationIds.remove(p4)
			end)

			if not ConversationRoduxSeed.isFriendsPlaceholderConversationId(p4) then
				v4(fetchLatestConversationDetails(p4))
			end
		end

		if callback ~= nil then
			callback(p4)
		end
	end, { v4, callback, v5 })

	local itemList = React.useMemo(function()
		if v3.isActive then
			return buildSearchItemList(v3.items, p2, flag2)
		end

		return v
	end, { v3.isActive, v3.items, flag2, p2 })

	if FFlagAppChatSearchSessionTelemetry then
		useChatSearchResultsTelemetry(v3, #itemList)
	end

	if not v3.isActive then
		return false, v2
	end

	return true, {
		itemList = itemList,
		conversationsIsFetching = v3.isFetching,
		isSearchAwaitingResults = v3.isAwaitingResults,
		oldestConversationIsFetched = v3.nextCursor == nil,
		[RoactPaginator.loadNext] = function()
			v3.loadNext()
		end,
		isSearchActive = true,
		navigateToConversation = navigateToConversation
	}
end

return useConversationSearchListProps
