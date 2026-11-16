local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local Requests = require(DataHydration.Presence.Requests)
require(script.Parent.Requests.MultiGetPresenceByUserIds)
local normalizePresenceRawData = require(script.Parent.normalizePresenceRawData)

local FFlagProfileCTAHydratePresenceFromMetadata = require(DataHydration.Flags.FFlagProfileCTAHydratePresenceFromMetadata)

local defineFastInt = game:DefineFastInt("PresenceStorePollingTtlSec", 60)
local defineFastInt2 = game:DefineFastInt("RTEPresenceStorePollingTtlSec", 0)

game:DefineFastInt("PresenceStoreProcessDelaySec", 1)
local function getFIntPresenceStoreProcessDelaySec() -- 1 equivalent call inferred from this helper
	return game:GetFastInt("PresenceStoreProcessDelaySec")
end

local function createPresenceStore()
	local dataCache = createDataCache(defineFastInt)

	local dataCache2 = createDataCache(not (defineFastInt2 > 0) and 1e999 or defineFastInt2)
	local v = {}
	local v2 = {}

	local dataResolver = createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = getFIntPresenceStoreProcessDelaySec(), -- inferred equivalent call
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			return Requests.MultiGetPresenceByUserIds(keys):andThen(function(p2)
				local presenceRawDatasById = {}

				for _, v3 in p2 and p2.responseBody and p2.responseBody.userPresences or {} do
					local presenceRawData = normalizePresenceRawData(v3)

					if presenceRawData then
						presenceRawDatasById[presenceRawData.id] = presenceRawData
					end
				end

				return presenceRawDatasById
			end)
		end
	})

	local function disposeLockAwarePresenceEffects() -- 2 equivalent calls inferred from this helper
		for _, v3 in v2 do
			v3()
		end

		table.clear(v2)
	end

	return {
		GetPresenceByUserId = function(p: string, p2)
			if p2 and p2.skipFetch == true then
				return dataResolver.getCachedItem(p)
			end

			if v2[p] == nil then
				v2[p] = Signals.createEffect(function(p3)
					local item, _ = dataCache2.getItem(p)
					local cachedItem = dataResolver.getCachedItem(p)

					if item.data(p3) == true and cachedItem ~= nil then
						return
					end

					dataResolver.getAndFetchItem(p)
				end)
			end

			return dataResolver.getCachedItem(p)
		end,
		UpdateUserPresence = function(p: string, p2, p3)
			if FFlagProfileCTAHydratePresenceFromMetadata and p3 and p3.isRealtimeUnknown then
				dataCache.replaceItem(p, p2)
				return
			end

			dataCache.replaceItem(p, p2)

			local v3 = p3 and p3.isUpdatedRealtime == true and true or false
			dataCache2.replaceItem(p, v3)
			v[p] = v3
		end,
		RefreshPresenceByUserId = function(p: string)
			dataResolver.fetchItem(p)
		end,
		clear = function()
			disposeLockAwarePresenceEffects() -- inferred equivalent call
			dataCache2.clear()
			dataResolver.clear()
		end,
		dispose = function()
			disposeLockAwarePresenceEffects() -- inferred equivalent call
			dataCache2.dispose()
			dataResolver.dispose()
		end
	}
end

return createPresenceStore
