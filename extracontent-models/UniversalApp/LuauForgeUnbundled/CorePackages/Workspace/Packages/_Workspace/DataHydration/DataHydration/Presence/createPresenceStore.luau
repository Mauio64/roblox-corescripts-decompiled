local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Requests/MultiGetPresenceByUserIds")
local normalizePresenceRawData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/normalizePresenceRawData")

local FFlagProfileCTAHydratePresenceFromMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagProfileCTAHydratePresenceFromMetadata")

local defineFastInt = game:DefineFastInt("PresenceStorePollingTtlSec", 60)
local defineFastInt2 = game:DefineFastInt("RTEPresenceStorePollingTtlSec", 0)

game:DefineFastInt("PresenceStoreProcessDelaySec", 1)
local function getFIntPresenceStoreProcessDelaySec()
	return game:GetFastInt("PresenceStoreProcessDelaySec")
end

local function createPresenceStore()
	local v5 = createDataCache(defineFastInt)

	local v6 = createDataCache(not (defineFastInt2 > 0) and 1e999 or defineFastInt2)
	local v7 = {}
	local v8 = {}
	local v9 = createDataResolver({
		cache = v5,
		queueProcessDelaySec = game:GetFastInt("PresenceStoreProcessDelaySec"),
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			return Requests.MultiGetPresenceByUserIds(keys):andThen(function(p3)
				local result = {}

				for k, v10 in p3 and p3.responseBody and p3.responseBody.userPresences or {} do
					local v11 = normalizePresenceRawData(v10)

					if v11 then
						result[v11.id] = v11
					end
				end

				return result
			end)
		end
	})

	local function disposeLockAwarePresenceEffects()
		for k, v10 in v8 do
			v10()
		end

		table.clear(v8)
	end

	return {
		GetPresenceByUserId = function(p2, p3)
			if p3 and p3.skipFetch == true then
				return v9.getCachedItem(p2)
			end

			if v8[p2] == nil then
				v8[p2] = Signals.createEffect(function(p4)
					local item, v10 = v6.getItem(p2)
					local cachedItem = v9.getCachedItem(p2)

					if item.data(p4) == true and cachedItem ~= nil then
						return
					end

					v9.getAndFetchItem(p2)
				end)
			end

			return v9.getCachedItem(p2)
		end,
		UpdateUserPresence = function(p2, p3, p4)
			if FFlagProfileCTAHydratePresenceFromMetadata and p4 and p4.isRealtimeUnknown then
				v5.replaceItem(p2, p3)
				return
			end

			v5.replaceItem(p2, p3)

			local v10 = p4 and p4.isUpdatedRealtime == true and true or false
			v6.replaceItem(p2, v10)
			v7[p2] = v10
		end,
		RefreshPresenceByUserId = function(p2)
			v9.fetchItem(p2)
		end,
		clear = function()
			for k, v10 in v8 do
				v10()
			end

			table.clear(v8)

			v6.clear()
			v9.clear()
		end,
		dispose = function()
			for k, v10 in v8 do
				v10()
			end

			table.clear(v8)

			v6.dispose()
			v9.dispose()
		end
	}
end

return createPresenceStore
