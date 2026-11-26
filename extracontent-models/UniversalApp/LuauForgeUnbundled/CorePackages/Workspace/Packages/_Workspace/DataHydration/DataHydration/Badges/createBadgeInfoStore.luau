local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges/BadgesTypes")
local requestRemoveBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges/requestRemoveBadge")
local BadgesUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges/BadgesUrlBuilder")

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local function createBadgeInfoStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	local function removeBadge(p2)
		local signal, v7 = Signals.createSignal(nil)

		local data = v5.getItem(p2).data(false)
		local isEarnedByUser = if data then data.isEarnedByUser else nil

		if isEarnedByUser == true then
			v5.updateItem(p2, { isEarnedByUser = false })
		end

		requestRemoveBadge(p2):andThen(function()
			v7({ type = "success" })
		end):catch(function(value)
			if data then
				v5.updateItem(p2, { isEarnedByUser = isEarnedByUser })
			end

			local statusCode = if type(value) == "table" and value.StatusCode then value.StatusCode else nil

			if type(value) == "table" and value.StatusMessage then
				value = value.StatusMessage
			elseif type(value) ~= "string" then
				value = nil
			end

			v7({
				type = "error",
				errorType = "NetworkError",
				statusCode = statusCode,
				statusMessage = value
			})

			logResponseError(BadgesUrlBuilder.BADGE_REMOVE_URL, { StatusCode = statusCode })

			discoveryEventErrorLogger.reportError("removeBadge", "Error removing badge", {
				badgeId = p2,
				statusCode = statusCode,
				method = "DELETE",
				statusMessage = value
			})
		end)

		return signal
	end

	return {
		getBadgeInfo = v6.getCachedItem,
		getBadgeInfos = v6.getCachedItems,
		updateBadges = v5.updateItems,
		removeBadge = removeBadge,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createBadgeInfoStore
