local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CommunityUserMembership/CommunityUserMembershipStoreTypes")
local requestJoinCommunity = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CommunityUserMembership/requestJoinCommunity")

local formatted = `{url.GROUPS_URL}v1/groups/`

local function createCommunityUserMembershipStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end,
		supportsMutations = true
	})

	local function applyOptimisticMembership(p2)
		local signal, v7 = Signals.createSignal(nil)

		v6.setMutation(p2, { canJoin = false })

		return signal, function(p3)
			if p3 and p3.type == "error" then
				v6.clearMutation(p2)
			else
				v6.commitMutation(p2)
			end

			v7(p3)
		end
	end

	local function joinCommunity(p2)
		local v7, v8 = applyOptimisticMembership(p2)

		requestJoinCommunity(p2):andThen(function()
			v8({ type = "success" })
		end):catch(function(value)
			local statusCode = if type(value) == "table" and value.StatusCode then value.StatusCode else nil

			if type(value) == "table" and value.StatusMessage then
				value = value.StatusMessage
			elseif type(value) ~= "string" then
				value = nil
			end

			v8({ type = "error", statusCode = statusCode, statusMessage = value })

			logResponseError(formatted, { StatusCode = statusCode })
			discoveryEventErrorLogger.reportError("joinCommunity", "Error joining community", {
				communityId = p2,
				statusCode = statusCode,
				method = "POST",
				statusMessage = value
			})
		end)

		return v7
	end

	return {
		getMembership = v6.getOptimisticCachedItem,
		getMemberships = v6.getOptimisticCachedItems,
		updateMembership = v5.updateItem,
		updateMemberships = v5.updateItems,
		joinCommunity = joinCommunity,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createCommunityUserMembershipStore
