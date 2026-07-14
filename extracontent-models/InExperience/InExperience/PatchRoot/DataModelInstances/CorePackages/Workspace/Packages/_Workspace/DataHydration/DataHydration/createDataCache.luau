local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)
local SignalsExperimental = require(DataHydrationParent.SignalsExperimental)
local DataStatus = require(DataHydration.DataHydrationTypes).DataStatus
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local v9 = game:DefineFastFlag("LuaAppDataCacheBatch", false)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagLuaAppDataHydrationSanitizeItem = SharedFlags.FFlagLuaAppDataHydrationSanitizeItem
local FFlagLuaAppDataHydrationOptimisticMutationLayer = SharedFlags.FFlagLuaAppDataHydrationOptimisticMutationLayer
local v13 = game:DefineFastInt("LuaAppDefaultDataTtlSec", 3600)
local v14 = game:DefineFastInt("LuaAppDefaultFailedDataTtlSec", 60)

local function createDataCache(n1: number?, n2: number?, p1) -- line: 29
	-- upvalues: v13 (copy), v14 (copy), FFlagLuaAppDataHydrationSanitizeItem (copy), Signals (copy), DataStatus (copy), v9 (copy), SignalsExperimental (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), Cryo (copy), getLocalPlayerUserId (copy), Players (copy)
	local v19 = n1 or v13
	local v20 = n2 or v14
	local v21 = if not FFlagLuaAppDataHydrationSanitizeItem or not p1 then nil else p1.sanitizeItem
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}

	local function getOrCreateSignals(s1: string) -- line: 41
		-- upvalues: t1 (ref), t2 (ref), Signals (copy), t3 (ref), DataStatus (copy)
		if t1[s1] == nil or t2[s1] == nil then
			t1[s1] = {}

			local v32 = t1[s1]
			local v33 = t2
			local v34, v35 = Signals.createSignal(nil)

			v32.data = v34
			v33[s1] = v35

			local v36 = t1[s1]
			local v37 = t3
			local v38, v39 = Signals.createSignal(DataStatus.NotReady)

			v36.status = v38
			v37[s1] = v39
		end

		return t1[s1], t2[s1]
	end
	local function getItem(s2: string, p2: ((...any) -> ...any)?) -- line: 53
		-- upvalues: getOrCreateSignals (copy), t4 (ref), DataStatus (copy)
		local v42 = getOrCreateSignals(s2)
		local v43 = true

		if t4[s2] and os.clock() < t4[s2] then
			local v44 = v42.data(false)
			local v45 = v42.status(false)

			if v44 ~= nil or v45 == DataStatus.Failed then
				if p2 then
					return v42, (p2(v44))
				end

				v43 = false
			end
		end

		return v42, v43
	end
	local function clear() -- line: 221
		-- upvalues: t4 (ref), t1 (ref), t2 (ref), t3 (ref)
		t4 = {}
		t1 = {}
		t2 = {}
		t3 = {}
	end

	local u29 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 229
		-- upvalues: getLocalPlayerUserId (copy), u29 (ref), clear (copy)
		local v91 = getLocalPlayerUserId()

		if v91 ~= u29 then
			u29 = v91
			clear()
		end
	end)

	return {
		getItem = getItem,
		getItems = function(t5: {[any]: any}, p3: ((...any) -> ...any)?) -- line: 75
			-- upvalues: getItem (copy)
			local t6 = {}
			local t7 = {}

			if not t5 then
				return t6, t7
			end

			for _, v51 in t5 do
				local v52, v53 = getItem(v51, p3)

				t6[v51] = v52
				t7[v51] = v53
			end

			return t6, t7
		end,
		updateItems = function(t8: {[any]: any}) -- line: 117
			-- upvalues: v19 (copy), v9 (copy), getOrCreateSignals (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), Cryo (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v62 = os.clock() + v19

			if v9 then
				local function batchUpdate() -- line: 121
					-- upvalues: t8 (copy), getOrCreateSignals (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), Cryo (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), v62 (copy)
					for v96, v97 in t8 do
						local v98, v99 = getOrCreateSignals(v96)
						local v100 = v98.data(false)
						local v101 = if not v100 or (type(v100) ~= "table" or type(v97) ~= "table") then v97 else if not FFlagLuaAppDataHydrationOptimisticMutationLayer then Cryo.Dictionary.union(v100, v97) else Cryo.Dictionary.join(v100, v97)

						v99(if not v21 then v101 else v21(v101))
						t3[v96](DataStatus.Ready)
						t4[v96] = v62
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for v64, v65 in t8 do
				local v66, v67 = getOrCreateSignals(v64)
				local v68 = v66.data(false)
				local v69 = if not v68 or (type(v68) ~= "table" or type(v65) ~= "table") then v65 else if not FFlagLuaAppDataHydrationOptimisticMutationLayer then Cryo.Dictionary.union(v68, v65) else Cryo.Dictionary.join(v68, v65)

				v67(if not v21 then v69 else v21(v69))
				t3[v64](DataStatus.Ready)
				t4[v64] = v62
			end
		end,
		updateItem = function(s3: string, p4) -- line: 159
			-- upvalues: getOrCreateSignals (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), Cryo (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), v19 (copy)
			local v72, v73 = getOrCreateSignals(s3)
			local v74 = v72.data(false)
			local v75 = if not v74 or (type(v74) ~= "table" or type(p4) ~= "table") then p4 else if not FFlagLuaAppDataHydrationOptimisticMutationLayer then Cryo.Dictionary.union(v74, p4) else Cryo.Dictionary.join(v74, p4)

			v73(if not v21 then v75 else v21(v75))
			t3[s3](DataStatus.Ready)
			t4[s3] = os.clock() + v19
		end,
		replaceItems = function(t9: {[any]: any}) -- line: 94
			-- upvalues: v19 (copy), v9 (copy), getOrCreateSignals (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v55 = os.clock() + v19

			if v9 then
				local function batchUpdate() -- line: 98
					-- upvalues: t9 (copy), getOrCreateSignals (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), v55 (copy)
					for v92, v93 in t9 do
						local _, v95 = getOrCreateSignals(v92)

						v95(if not v21 then v93 else v21(v93))
						t3[v92](DataStatus.Ready)
						t4[v92] = v55
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for v57, v58 in t9 do
				local _, v60 = getOrCreateSignals(v57)

				v60(if not v21 then v58 else v21(v58))
				t3[v57](DataStatus.Ready)
				t4[v57] = v55
			end
		end,
		replaceItem = function(s4: string, p5) -- line: 175
			-- upvalues: getOrCreateSignals (copy), v21 (copy), t3 (ref), DataStatus (copy), t4 (ref), v19 (copy)
			local _, v79 = getOrCreateSignals(s4)

			v79(if not v21 then p5 else v21(p5))
			t3[s4](DataStatus.Ready)
			t4[s4] = os.clock() + v19
		end,
		markItemsAsFailed = function(t10: {[any]: any}) -- line: 199
			-- upvalues: v20 (copy), v9 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v87 = os.clock() + v20

			if v9 then
				local function batchUpdate() -- line: 202
					-- upvalues: t10 (copy), t3 (ref), DataStatus (copy), t4 (ref), v87 (copy)
					for _, v103 in t10 do
						if t3[v103] then
							t3[v103](DataStatus.Failed)
						end

						t4[v103] = v87
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for _, v90 in t10 do
				if t3[v90] then
					t3[v90](DataStatus.Failed)
				end

				t4[v90] = v87
			end
		end,
		resetFailedItem = function(s5: string) -- line: 186
			-- upvalues: t1 (ref), DataStatus (copy), t3 (ref)
			local v81 = t1[s5]

			if v81 and v81.status(false) == DataStatus.Failed then
				t3[s5](DataStatus.NotReady)
			end
		end,
		resetFailedItems = function(t11: {[any]: any}) -- line: 193
			-- upvalues: t1 (ref), DataStatus (copy), t3 (ref)
			for _, v84 in t11 do
				local v85 = t1[v84]

				if v85 and v85.status(false) == DataStatus.Failed then
					t3[v84](DataStatus.NotReady)
				end
			end
		end,
		clear = clear,
		dispose = function() -- line: 237
			-- upvalues: connection (ref), clear (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			clear()
		end
	}
end

return createDataCache
