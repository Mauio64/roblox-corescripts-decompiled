local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)
local Http = require(parent.Http)
local Url = Http.Url

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.CommunityUserMembershipStoreTypes)
local requestJoinCommunity = require(script.Parent.requestJoinCommunity)

local formatted = `{Url.GROUPS_URL}v1/groups/`

local function createCommunityUserMembershipStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end,
		supportsMutations = true
	})

	local function applyOptimisticMembership(p: string)
		local signal, v = Signals.createSignal(nil)

		dataResolver.setMutation(p, { canJoin = false })

		return signal, function(p2)
			if p2 and p2.type == "error" then
				dataResolver.clearMutation(p)
			else
				dataResolver.commitMutation(p)
			end

			v(p2)
		end
	end

	local function joinCommunity(communityId: string)
		local v, v2 = applyOptimisticMembership(communityId)

		requestJoinCommunity(communityId):andThen(function()
			v2({ type = "success" })
		end):catch(function(statusMessage)
			local statusCode

			if type(statusMessage) == "table" and statusMessage.StatusCode then
				statusCode = statusMessage.StatusCode
			end

			if type(statusMessage) == "table" and statusMessage.StatusMessage then
				statusMessage = statusMessage.StatusMessage
			elseif type(statusMessage) ~= "string" then
				statusMessage = nil
			end

			v2({ type = "error", statusCode = statusCode, statusMessage = statusMessage })

			logResponseError(formatted, { StatusCode = statusCode })
			DiscoveryEventErrorLogger.reportError("joinCommunity", "Error joining community", {
				communityId = communityId,
				statusCode = statusCode,
				method = "POST",
				statusMessage = statusMessage
			})
		end)

		return v
	end

	return {
		getMembership = dataResolver.getOptimisticCachedItem,
		getMemberships = dataResolver.getOptimisticCachedItems,
		updateMembership = dataCache.updateItem,
		updateMemberships = dataCache.updateItems,
		joinCommunity = joinCommunity,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createCommunityUserMembershipStore
