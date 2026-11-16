local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.BadgesTypes)
local requestRemoveBadge = require(script.Parent.requestRemoveBadge)
local BadgesUrlBuilder = require(script.Parent.BadgesUrlBuilder)

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local function createBadgeInfoStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	local function removeBadge(badgeId: string)
		local signal, v = Signals.createSignal(nil)

		local data = dataCache.getItem(badgeId).data(false)
		local isEarnedByUser

		if data then
			isEarnedByUser = data.isEarnedByUser
		else
			isEarnedByUser = nil
		end

		if isEarnedByUser == true then
			dataCache.updateItem(badgeId, { isEarnedByUser = false })
		end

		requestRemoveBadge(badgeId):andThen(function()
			v({ type = "success" })
		end):catch(function(statusMessage)
			if data then
				dataCache.updateItem(badgeId, { isEarnedByUser = isEarnedByUser })
			end

			local statusCode

			if type(statusMessage) == "table" and statusMessage.StatusCode then
				statusCode = statusMessage.StatusCode
			end

			if type(statusMessage) == "table" and statusMessage.StatusMessage then
				statusMessage = statusMessage.StatusMessage
			elseif type(statusMessage) ~= "string" then
				statusMessage = nil
			end

			v({
				type = "error",
				errorType = "NetworkError",
				statusCode = statusCode,
				statusMessage = statusMessage
			})

			logResponseError(BadgesUrlBuilder.BADGE_REMOVE_URL, { StatusCode = statusCode })

			DiscoveryEventErrorLogger.reportError("removeBadge", "Error removing badge", {
				badgeId = badgeId,
				statusCode = statusCode,
				method = "DELETE",
				statusMessage = statusMessage
			})
		end)

		return signal
	end

	return {
		getBadgeInfo = dataResolver.getCachedItem,
		getBadgeInfos = dataResolver.getCachedItems,
		updateBadges = dataCache.updateItems,
		removeBadge = removeBadge,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createBadgeInfoStore
