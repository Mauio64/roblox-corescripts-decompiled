local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Signals = require(DataHydrationParent.Signals)
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.BadgesTypes)

local requestRemoveBadge = require(script.Parent.requestRemoveBadge)
local BadgesUrlBuilder = require(script.Parent.BadgesUrlBuilder)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local function createBadgeInfoStore() -- line: 26
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), Signals (copy), requestRemoveBadge (copy), logResponseError (copy), BadgesUrlBuilder (copy), DiscoveryEventErrorLogger (copy)
	local v13 = createDataCache()
	local v14 = createDataResolver({
		cache = v13,
		fetchFn = function(_: {[any]: any}) -- line: 30
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	return {
		getBadgeInfo = v14.getCachedItem,
		getBadgeInfos = v14.getCachedItems,
		updateBadges = v13.updateItems,
		removeBadge = function(s1: string) -- line: 37
			-- upvalues: Signals (copy), v13 (copy), requestRemoveBadge (copy), logResponseError (copy), BadgesUrlBuilder (copy), DiscoveryEventErrorLogger (copy)
			local v17, v18 = Signals.createSignal(nil)
			local v19 = v13.getItem(s1).data(false)
			local v20 = if not v19 then nil else v19.isEarnedByUser

			if v20 == true then
				v13.updateItem(s1, {
					isEarnedByUser = false
				})
			end

			requestRemoveBadge(s1):andThen(function() -- line: 56
				-- upvalues: v18 (copy)
				v18({
					type = "success"
				})
			end):catch(function(p1) -- line: 61
				-- upvalues: v19 (copy), v13 (copy), s1 (copy), v20 (copy), v18 (copy), logResponseError (copy), BadgesUrlBuilder (copy), DiscoveryEventErrorLogger (copy)
				if v19 then
					v13.updateItem(s1, {
						isEarnedByUser = v20
					})
				end

				local v22 = if type(p1) ~= "table" or not p1.StatusCode then nil else p1.StatusCode
				local v23 = if type(p1) ~= "table" or not p1.StatusMessage then if type(p1) ~= "string" then nil else p1 else p1.StatusMessage

				v18({
					type = "error",
					errorType = "NetworkError",
					statusCode = v22,
					statusMessage = v23
				})
				logResponseError(BadgesUrlBuilder.BADGE_REMOVE_URL, {
					StatusCode = v22
				})
				DiscoveryEventErrorLogger.reportError("removeBadge", "Error removing badge", {
					method = "DELETE",
					badgeId = s1,
					statusCode = v22,
					statusMessage = v23
				})
			end)

			return v17
		end,
		clear = v14.clear,
		dispose = v14.dispose
	}
end

return createBadgeInfoStore
