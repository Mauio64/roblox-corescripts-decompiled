local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)
local Requests = require(DataHydration.Presence.Requests)

require(script.Parent.Requests.MultiGetPresenceByUserIds)

local normalizePresenceRawData = require(script.Parent.normalizePresenceRawData)
local v9 = game:DefineFastInt("PresenceStorePollingTtlSec", 60)
local v10 = game:DefineFastInt("RTEPresenceStorePollingTtlSec", 0)

game:DefineFastInt("PresenceStoreProcessDelaySec", 1)

local function getFIntPresenceStoreProcessDelaySec() -- line: 48
	return game:GetFastInt("PresenceStoreProcessDelaySec")
end
local function createPresenceStore() -- line: 52
	-- upvalues: createDataCache (copy), v9 (copy), v10 (copy), createDataResolver (copy), Cryo (copy), Requests (copy), normalizePresenceRawData (copy), Signals (copy)
	local v13 = createDataCache(v9)
	local v14 = createDataCache(not (v10 > 0) and 1e999 or v10)
	local t1 = {}
	local t2 = {}
	local v17 = createDataResolver({
		cache = v13,
		queueProcessDelaySec = game:GetFastInt("PresenceStoreProcessDelaySec"),
		fetchFn = function(t3: {[any]: any}) -- line: 86
			-- upvalues: Cryo (copy), Requests (copy), normalizePresenceRawData (copy)
			local v20 = Cryo.Dictionary.keys(t3)

			return Requests.MultiGetPresenceByUserIds(v20):andThen(function(p1) -- line: 88
				-- upvalues: normalizePresenceRawData (copy)
				local t4 = {}

				for _, v37 in p1 and (not not p1.responseBody and p1.responseBody.userPresences) or {} do
					local v38 = normalizePresenceRawData(v37)

					if v38 then
						t4[v38.id] = v38
					end
				end

				return t4
			end)
		end
	})

	local function disposeLockAwarePresenceEffects() -- line: 143
		-- upvalues: t2 (copy)
		for _, v29 in t2 do
			v29()
		end

		table.clear(t2)
	end

	return {
		GetPresenceByUserId = function(s1: string, t5: {[any]: any}?) -- line: 106
			-- upvalues: v17 (copy), t2 (copy), Signals (copy), v14 (copy)
			if t5 and t5.skipFetch == true then
				return v17.getCachedItem(s1)
			end

			if t2[s1] == nil then
				t2[s1] = Signals.createEffect(function(p2) -- line: 112
					-- upvalues: v14 (copy), s1 (copy), v17 (copy)
					local v40, _ = v14.getItem(s1)
					local v42 = v17.getCachedItem(s1)

					if v40.data(p2) == true and v42 ~= nil then
						return
					end

					v17.getAndFetchItem(s1)
				end)
			end

			return v17.getCachedItem(s1)
		end,
		UpdateUserPresence = function(s2: string, p3, t6: {[any]: any}?) -- line: 127
			-- upvalues: v13 (copy), v14 (copy), t1 (copy)
			v13.replaceItem(s2, p3)

			local v26 = not not t6 and (t6.isUpdatedRealtime == true or false)

			v14.replaceItem(s2, v26)
			t1[s2] = v26
		end,
		RefreshPresenceByUserId = function(s3: string) -- line: 139
			-- upvalues: v17 (copy)
			v17.fetchItem(s3)
		end,
		clear = function() -- line: 150
			-- upvalues: t2 (copy), v14 (copy), v17 (copy)
			for _, v31 in t2 do
				v31()
			end

			table.clear(t2)
			v14.clear()
			v17.clear()
		end,
		dispose = function() -- line: 156
			-- upvalues: t2 (copy), v14 (copy), v17 (copy)
			for _, v33 in t2 do
				v33()
			end

			table.clear(t2)
			v14.dispose()
			v17.dispose()
		end
	}
end

return createPresenceStore
