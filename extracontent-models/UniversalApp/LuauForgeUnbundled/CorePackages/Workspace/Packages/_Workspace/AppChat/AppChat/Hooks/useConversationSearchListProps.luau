local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useStore

local roactPaginator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").RoactPaginator
local ConversationRoduxSeed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/ConversationRoduxSeed")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local fetchLatestConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local getConversationTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationTimestamp")
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local getLastMessageContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getLastMessageContent")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local searchIntroducedConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/searchIntroducedConversationIds")
local useConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationSearch")
local useChatSearchResultsTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatSearchResultsTelemetry")
local FFlagAppChatSearchSessionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSearchSessionTelemetry")

local FFlagAppChatDerivedConversationLatestActivity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDerivedConversationLatestActivity")

local v5 = {}
local v6 = {}

local function toLuaDateTime(value)
	if typeof(value) == "DateTime" then
		return dateTime.fromUnixTimestamp(value.UnixTimestamp)
	end

	if type(value) == "table" and typeof(value.dateTime) == "DateTime" then
		return value
	end

	return nil
end

local function getInboxRowFields(id)
	if GetConversationStore(false).getConversation(id, false) == nil then
		return nil, nil
	end

	local v7 = GetConversationViewModelStore(false)
	local v8 = v7.getUnixTime(id)(false)
	return if v8 ~= nil then dateTime.fromUnixTimestamp(v8) else nil, v7.getSubtitle(id)(false)
end

local function buildSearchItemList(items, p2, p3)
	local searchItemList = {}

	for k, joined in items do
		if joined.otherParticipants == nil then
			joined = Cryo.Dictionary.join(joined, {
				otherParticipants = getOtherParticipants(joined, p2)
			})
		end

		if not (p3 or joined.conversationType ~= "MultiUserConversation") then
			continue
		end

		local v7 = joined.lastUpdated

		if typeof(v7) == "DateTime" then
			v7 = dateTime.fromUnixTimestamp(v7.UnixTimestamp)
		elseif type(v7) ~= "table" or typeof(v7.dateTime) ~= "DateTime" then
			v7 = nil
		end

		local v8 = getLastMessageContent(joined) or ""

		if FFlagAppChatDerivedConversationLatestActivity then
			local inboxRowFields, v9 = getInboxRowFields(joined.id)
			v8 = v9 or v8
			v7 = inboxRowFields or v7
		end

		table.insert(searchItemList, Cryo.Dictionary.join(joined, {
			title = getConversationTitle(joined),
			lastMessageContent = v8,
			shortRelativeTime = v7 and getConversationTimestamp(v7),
			longRelativeTime = v7 and v7:GetLongRelativeTime(),
			unixTime = v7 and v7:GetUnixTimestamp(),
			isSearchResult = true
		}))
	end

	return searchItemList
end

local function useConversationSearchListProps(p2, p3, p4, p5, callback, p6)
	local v7 = useConversationSearch(p2, p3, p6)
	local v8 = useDispatch()
	local v9 = useStore()

	local v10 = React.useCallback(function(p7)
		local conversation = GetConversationStore(false).getConversation(p7, false)
		local state = v9:getState()
		local v11 = not (conversation == nil) and state.ChatAppReducer.Conversations[p7] == nil

		if v11 or searchIntroducedConversationIds.has(p7) then
			SignalsExperimental.batch(function()
				if v11 then
					v8(ReceivedConversation(ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)))
				end

				searchIntroducedConversationIds.remove(p7)
			end)

			if not ConversationRoduxSeed.isFriendsPlaceholderConversationId(p7) then
				v8(fetchLatestConversationDetails(p7))
			end
		end

		if callback ~= nil then
			callback(p7)
		end
	end, { v8, callback, v9 })

	local v11 = React.useMemo(function()
		if v7.isActive then
			return buildSearchItemList(v7.items, p4, p5)
		end

		return v5
	end, { v7.isActive, v7.items, p5, p4 })

	if FFlagAppChatSearchSessionTelemetry then
		useChatSearchResultsTelemetry(v7, #v11)
	end

	if not v7.isActive then
		return false, v6
	end

	return true, {
		itemList = v11,
		conversationsIsFetching = v7.isFetching,
		isSearchAwaitingResults = v7.isAwaitingResults,
		oldestConversationIsFetched = v7.nextCursor == nil,
		[roactPaginator.loadNext] = function()
			v7.loadNext()
		end,
		isSearchActive = true,
		navigateToConversation = v10
	}
end

return useConversationSearchListProps
