local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local Requests = require(script.Parent.Requests)
require(script.Parent.FriendsRecommendationsStoreTypes)
local ContextType = require(script.Parent.Enums.ContextType)

local FFlagShowClassmatesOnPYMK = require(parent.SharedFlags.FFlagShowClassmatesOnPYMK)

local set = {
	[ContextType.None] = true,
	[ContextType.MutualFriends] = true,
	[ContextType.Frequents] = true,
	[ContextType.Contacts] = true
}

if FFlagShowClassmatesOnPYMK then
	set[ContextType.Classmates] = true
end

local function resolveTargetUserId() -- 1 equivalent call inferred from this helper
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
	local contactId

	if data.contactId and data.contactId ~= "" then
		contactId = data.contactId
	end

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
	local contextType

	if data.contextType and set[data.contextType] then
		contextType = data.contextType
	end

	recommendation.contextProps = {
		contextType = contextType,
		mutualFriendsCount = data.mutualFriendsCount or data.mutualFriendsList and #data.mutualFriendsList or nil
	}
	return recommendation
end

local function createFriendsRecommendationsStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(p: string, _)
			return Requests.GetFriendsRecommendations(resolveTargetUserId(), p):andThen(function(p2) -- inferred equivalent call
				local mapped

				if p2.data then
					mapped = Cryo.List.map(p2.data, normalizeRecommendation)
				end

				if mapped then
					table.sort(mapped, function(a, b): boolean
						return (a.rank or 0) < (b.rank or 0)
					end)
				end

				return { data = mapped, recommendationRequestId = p2.recommendationRequestId }
			end)
		end
	})

	return {
		getFriendsRecommendations = function(p: string, p2)
			if p2 and p2.skipFetch then
				return dataResolver.getCachedItem(p)
			end

			if p2 and p2.forceFetch and not dataResolver.isRequestInQueueOrInFlight(p) then
				dataResolver.fetchItem(p)
			end

			return dataResolver.getAndFetchItem(p)
		end,
		refreshFriendsRecommendations = function(p: string)
			return dataResolver.fetchItem(p)
		end,
		removeFriendsRecommendationByUserId = function(p: string, p2: string)
			local data = dataResolver.getCachedItem(p).data(false)

			if data == nil or data.data == nil then
				return
			end

			local v = {}

			for _, v2 in data.data do
				if v2.id ~= p2 then
					table.insert(v, v2)
				end
			end

			dataCache.replaceItem(p, {
				data = v,
				recommendationRequestId = data.recommendationRequestId
			})
		end,
		clear = function()
			dataResolver.clear()
		end,
		dispose = function()
			dataResolver.dispose()
		end
	}
end

return createFriendsRecommendationsStore
