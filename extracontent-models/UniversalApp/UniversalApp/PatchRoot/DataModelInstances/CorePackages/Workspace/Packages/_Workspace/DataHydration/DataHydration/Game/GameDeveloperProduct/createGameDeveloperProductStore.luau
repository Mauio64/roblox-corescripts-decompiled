local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local FFlagSduiDevStoreSeeAllSupport = require(DataHydrationParent.SharedFlags).FFlagSduiDevStoreSeeAllSupport
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.GameDeveloperProductStoreTypes)

local fetchGameDeveloperProductStatuses = require(script.Parent.fetchGameDeveloperProductStatuses)

local function buildStatusesKey(s1: string, s2: string) -- line: 27
	return s1 .. "|" .. s2
end
local function createGameDeveloperProductStore() -- line: 31
	-- upvalues: createDataCache (copy), FFlagSduiDevStoreSeeAllSupport (copy), createDataResolver (copy), logResponseError (copy), DiscoveryEventErrorLogger (copy), Promise (copy), fetchGameDeveloperProductStatuses (copy)
	local v15 = createDataCache()
	local u16 = nil
	local u17 = nil

	if FFlagSduiDevStoreSeeAllSupport then
		u16 = createDataCache()
		u17 = createDataResolver({
			supportsMultiGet = false,
			cache = u16,
			logError = function(p1) -- line: 41
				-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy)
				local v19 = if type(p1) ~= "table" or not p1.StatusCode then nil else p1.StatusCode

				logResponseError("developer-products/v1/game-transactions", {
					StatusCode = v19
				})
				DiscoveryEventErrorLogger.reportError("GameDeveloperProductStore", "Failed to fetch developer product statuses", {
					err = tostring(p1)
				})
			end,
			fetchFn = function(s3: string, p2) -- line: 50
				-- upvalues: Promise (copy), fetchGameDeveloperProductStatuses (copy), v15 (copy)
				local v22, v23 = string.match(s3, "^(.-)|(.+)$")

				if v22 == nil or v23 == nil then
					return Promise.reject("Invalid developer product statuses key: " .. tostring(s3))
				end

				return fetchGameDeveloperProductStatuses.fetch(v22, v23):andThen(function(p3) -- line: 57
					-- upvalues: p2 (copy), v15 (copy)
					local t1 = {}

					for v28, v29 in p3.counts do
						t1[v28] = {
							pendingReceiptCount = v29
						}
					end

					local v30 = p2 and p2.data(false)

					if v30 and v30.counts then
						for v31 in v30.counts do
							if p3.counts[v31] == nil then
								t1[v31] = {
									pendingReceiptCount = 0
								}
							end
						end
					end

					if next(t1) ~= nil then
						v15.updateItems(t1)
					end

					return p3
				end)
			end
		})
	end

	return {
		getGameDeveloperProductInfo = v15.getItem,
		updateGameDeveloperProductInfos = v15.updateItems,
		fetchStatuses = function(s4: string, s5: string) -- line: 102
			-- upvalues: u17 (ref)
			if u17 then
				u17.fetchItem(s4 .. "|" .. s5)
			end
		end,
		clear = function() -- line: 82
			-- upvalues: u16 (ref), u17 (ref), v15 (copy)
			if u16 then
				u16.clear()
			end

			if u17 then
				u17.clear()
			end

			v15.clear()
		end,
		dispose = function() -- line: 92
			-- upvalues: u17 (ref), v15 (copy)
			if u17 then
				u17.dispose()
			end

			v15.dispose()
		end
	}
end

return createGameDeveloperProductStore
