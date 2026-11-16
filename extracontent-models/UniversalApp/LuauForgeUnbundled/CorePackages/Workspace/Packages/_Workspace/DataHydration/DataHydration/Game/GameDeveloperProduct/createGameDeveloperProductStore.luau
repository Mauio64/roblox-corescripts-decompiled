local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local fFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local fFlagEnableHomeGameItemOwnershipUpdate = SharedFlags.FFlagEnableHomeGameItemOwnershipUpdate
local fFlagEnableSearchGameItemOwnershipUpdate = SharedFlags.FFlagEnableSearchGameItemOwnershipUpdate

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct/GameDeveloperProductStoreTypes")
local fetchGameDeveloperProductStatuses = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct/fetchGameDeveloperProductStatuses")

local function buildStatusesKey(p2, p3)
	return p2 .. "|" .. p3
end

local function createGameDeveloperProductStore()
	local v5 = createDataCache()
	local v6, v7

	if
		fFlagSduiDevStoreSeeAllSupport
		or fFlagEnableHomeGameItemOwnershipUpdate
		or fFlagEnableSearchGameItemOwnershipUpdate
	then
		v6 = createDataCache()
		v7 = createDataResolver({
			cache = v6,
			supportsMultiGet = false,
			logError = function(p2)
				local v8 = if type(p2) == "table" and p2.StatusCode then p2.StatusCode else nil
				logResponseError("game-transactions/v1/receipts", { StatusCode = v8 })
				discoveryEventErrorLogger.reportError(
					"GameDeveloperProductStore",
					"Failed to fetch developer product statuses",
					{ err = tostring(p2) }
				)
			end,
			fetchFn = function(value, p2)
				local v8, v9 = string.match(value, "^(.-)|(.+)$")

				if v8 == nil or v9 == nil then
					return Promise.reject("Invalid developer product statuses key: " .. tostring(value))
				end

				return fetchGameDeveloperProductStatuses.fetch(v8, v9):andThen(function(p3)
					local v10 = {}

					for k, count in p3.counts do
						v10[k] = { pendingReceiptCount = count }
					end

					local v11 = p2 and p2.data(false)

					if v11 and v11.counts then
						for k in v11.counts do
							if p3.counts[k] == nil then
								v10[k] = { pendingReceiptCount = 0 }
							end
						end
					end

					if next(v10) ~= nil then
						v5.updateItems(v10)
					end

					return p3
				end)
			end
		})
	else
		v6 = nil
		v7 = nil
	end

	return {
		getGameDeveloperProductInfo = v5.getItem,
		updateGameDeveloperProductInfos = v5.updateItems,
		fetchStatuses = function(p2, p3)
			if v7 then
				v7.fetchItem(p2 .. "|" .. p3)
			end
		end,
		clear = function()
			if v6 then
				v6.clear()
			end

			if v7 then
				v7.clear()
			end

			v5.clear()
		end,
		dispose = function()
			if v7 then
				v7.dispose()
			end

			v5.dispose()
		end
	}
end

return createGameDeveloperProductStore
