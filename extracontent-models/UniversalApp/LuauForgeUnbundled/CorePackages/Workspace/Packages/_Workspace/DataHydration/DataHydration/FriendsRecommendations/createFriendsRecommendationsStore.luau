local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/FriendsRecommendationsStoreTypes")
local ContextType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/Enums/ContextType")

local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags/FFlagShowClassmatesOnPYMK")

local set = {
	[ContextType.None] = true,
	[ContextType.MutualFriends] = true,
	[ContextType.Frequents] = true,
	[ContextType.Contacts] = true
}

if FFlagShowClassmatesOnPYMK then
	set[ContextType.Classmates] = true
end

local function resolveTargetUserId()
	local currentUserId = localUserIdStore.getCurrentUserId(false)

	if currentUserId ~= "" then
		return currentUserId
	end

	local localPlayerUserId = getLocalPlayerUserId()

	if localPlayerUserId then
		return (tostring(localPlayerUserId))
	end

	return ""
end

local function normalizeRecommendation(data)
	local contactId = if data.contactId and data.contactId ~= "" then data.contactId else nil
	local recommendation = {
		id = tostring(contactId or data.id),
		rank = data.rank or 0,
		hasIncomingFriendRequest = data.friendRequest and true or false,
		type = contactId and "Contact" or "User",
		contactProps = {
			contactId = contactId,
			displayName = data.displayName,
			thumbnailEntities = data.thumbnailEntities
		},
		contextProps = 0
	}

	local v6 = if data.contextType and set[data.contextType] then data.contextType else nil
	recommendation.contextProps = {
		contextType = v6,
		mutualFriendsCount = data.mutualFriendsCount or data.mutualFriendsList and #data.mutualFriendsList or nil
	}
	return recommendation
end

local function createFriendsRecommendationsStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			local getFriendsRecommendations = Requests.GetFriendsRecommendations
			local v7 = localUserIdStore.getCurrentUserId(false)

			if v7 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v7 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			return getFriendsRecommendations(v7, p2):andThen(function(p4)
				local mapped = if p4.data then Cryo.List.map(p4.data, normalizeRecommendation) else nil

				if mapped then
					table.sort(mapped, function(a, b): boolean
						return (a.rank or 0) < (b.rank or 0)
					end)
				end

				return {
					data = mapped,
					recommendationRequestId = p4.recommendationRequestId
				}
			end)
		end
	})

	return {
		getFriendsRecommendations = function(p2, p3)
			if p3 and p3.skipFetch then
				return v6.getCachedItem(p2)
			end

			if p3 and p3.forceFetch and not v6.isRequestInQueueOrInFlight(p2) then
				v6.fetchItem(p2)
			end

			return v6.getAndFetchItem(p2)
		end,
		refreshFriendsRecommendations = function(p2)
			return v6.fetchItem(p2)
		end,
		removeFriendsRecommendationByUserId = function(p2, p3)
			local data = v6.getCachedItem(p2).data(false)

			if data == nil or data.data == nil then
				return
			end

			local v7 = {}

			for k, v8 in data.data do
				if v8.id ~= p3 then
					table.insert(v7, v8)
				end
			end

			v5.replaceItem(p2, {
				data = v7,
				recommendationRequestId = data.recommendationRequestId
			})
		end,
		clear = function()
			v6.clear()
		end,
		dispose = function()
			v6.dispose()
		end
	}
end

return createFriendsRecommendationsStore
