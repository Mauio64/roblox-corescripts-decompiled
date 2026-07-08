local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)
local SignalsExperimental = require(DataHydrationParent.SignalsExperimental)
local DataStatus = require(DataHydration.DataHydrationTypes).DataStatus
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local v9 = game:DefineFastFlag("LuaAppDataCacheBatch", false)
local FFlagLuaAppDataHydrationSanitizeItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationSanitizeItem
local v11 = game:DefineFastInt("LuaAppDefaultDataTtlSec", 3600)
local v12 = game:DefineFastInt("LuaAppDefaultFailedDataTtlSec", 60)

local function createDataCache(n1: number?, n2: number?, p1) -- line: 27
	-- upvalues: v11 (copy), v12 (copy), FFlagLuaAppDataHydrationSanitizeItem (copy), Signals (copy), DataStatus (copy), v9 (copy), SignalsExperimental (copy), Cryo (copy), getLocalPlayerUserId (copy), Players (copy)
	local v17 = n1 or v11
	local v18 = n2 or v12
	local v19 = if not FFlagLuaAppDataHydrationSanitizeItem or not p1 then nil else p1.sanitizeItem
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}

	local function getOrCreateSignals(s1: string) -- line: 39
		-- upvalues: t1 (ref), t2 (ref), Signals (copy), t3 (ref), DataStatus (copy)
		if t1[s1] == nil or t2[s1] == nil then
			t1[s1] = {}

			local v30 = t1[s1]
			local v31 = t2
			local v32, v33 = Signals.createSignal(nil)

			v30.data = v32
			v31[s1] = v33

			local v34 = t1[s1]
			local v35 = t3
			local v36, v37 = Signals.createSignal(DataStatus.NotReady)

			v34.status = v36
			v35[s1] = v37
		end

		return t1[s1], t2[s1]
	end
	local function getItem(s2: string, p2: ((...any) -> ...any)?) -- line: 51
		-- upvalues: getOrCreateSignals (copy), t4 (ref), DataStatus (copy)
		local v40 = getOrCreateSignals(s2)
		local v41 = true

		if t4[s2] and os.clock() < t4[s2] then
			local v42 = v40.data(false)
			local v43 = v40.status(false)

			if v42 ~= nil or v43 == DataStatus.Failed then
				if p2 then
					return v40, (p2(v42))
				end

				v41 = false
			end
		end

		return v40, v41
	end
	local function clear() -- line: 213
		-- upvalues: t4 (ref), t1 (ref), t2 (ref), t3 (ref)
		t4 = {}
		t1 = {}
		t2 = {}
		t3 = {}
	end

	local u27 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 221
		-- upvalues: getLocalPlayerUserId (copy), u27 (ref), clear (copy)
		local v89 = getLocalPlayerUserId()

		if v89 ~= u27 then
			u27 = v89
			clear()
		end
	end)

	return {
		getItem = getItem,
		getItems = function(t5: {[any]: any}, p3: ((...any) -> ...any)?) -- line: 73
			-- upvalues: getItem (copy)
			local t6 = {}
			local t7 = {}

			if not t5 then
				return t6, t7
			end

			for _, v49 in t5 do
				local v50, v51 = getItem(v49, p3)

				t6[v49] = v50
				t7[v49] = v51
			end

			return t6, t7
		end,
		updateItems = function(t8: {[any]: any}) -- line: 115
			-- upvalues: v17 (copy), v9 (copy), getOrCreateSignals (copy), Cryo (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v60 = os.clock() + v17

			if v9 then
				local function batchUpdate() -- line: 119
					-- upvalues: t8 (copy), getOrCreateSignals (copy), Cryo (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), v60 (copy)
					for v94, v95 in t8 do
						local v96, v97 = getOrCreateSignals(v94)
						local v98 = v96.data(false)
						local v99 = if not v98 or (type(v98) ~= "table" or type(v95) ~= "table") then v95 else Cryo.Dictionary.union(v98, v95)

						v97(if not v19 then v99 else v19(v99))
						t3[v94](DataStatus.Ready)
						t4[v94] = v60
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for v62, v63 in t8 do
				local v64, v65 = getOrCreateSignals(v62)
				local v66 = v64.data(false)
				local v67 = if not v66 or (type(v66) ~= "table" or type(v63) ~= "table") then v63 else Cryo.Dictionary.union(v66, v63)

				v65(if not v19 then v67 else v19(v67))
				t3[v62](DataStatus.Ready)
				t4[v62] = v60
			end
		end,
		updateItem = function(s3: string, p4) -- line: 153
			-- upvalues: getOrCreateSignals (copy), Cryo (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), v17 (copy)
			local v70, v71 = getOrCreateSignals(s3)
			local v72 = v70.data(false)
			local v73 = if not v72 or (type(v72) ~= "table" or type(p4) ~= "table") then p4 else Cryo.Dictionary.union(v72, p4)

			v71(if not v19 then v73 else v19(v73))
			t3[s3](DataStatus.Ready)
			t4[s3] = os.clock() + v17
		end,
		replaceItems = function(t9: {[any]: any}) -- line: 92
			-- upvalues: v17 (copy), v9 (copy), getOrCreateSignals (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v53 = os.clock() + v17

			if v9 then
				local function batchUpdate() -- line: 96
					-- upvalues: t9 (copy), getOrCreateSignals (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), v53 (copy)
					for v90, v91 in t9 do
						local _, v93 = getOrCreateSignals(v90)

						v93(if not v19 then v91 else v19(v91))
						t3[v90](DataStatus.Ready)
						t4[v90] = v53
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for v55, v56 in t9 do
				local _, v58 = getOrCreateSignals(v55)

				v58(if not v19 then v56 else v19(v56))
				t3[v55](DataStatus.Ready)
				t4[v55] = v53
			end
		end,
		replaceItem = function(s4: string, p5) -- line: 167
			-- upvalues: getOrCreateSignals (copy), v19 (copy), t3 (ref), DataStatus (copy), t4 (ref), v17 (copy)
			local _, v77 = getOrCreateSignals(s4)

			v77(if not v19 then p5 else v19(p5))
			t3[s4](DataStatus.Ready)
			t4[s4] = os.clock() + v17
		end,
		markItemsAsFailed = function(t10: {[any]: any}) -- line: 191
			-- upvalues: v18 (copy), v9 (copy), t3 (ref), DataStatus (copy), t4 (ref), SignalsExperimental (copy)
			local v85 = os.clock() + v18

			if v9 then
				local function batchUpdate() -- line: 194
					-- upvalues: t10 (copy), t3 (ref), DataStatus (copy), t4 (ref), v85 (copy)
					for _, v101 in t10 do
						if t3[v101] then
							t3[v101](DataStatus.Failed)
						end

						t4[v101] = v85
					end
				end

				SignalsExperimental.batch(batchUpdate)

				return
			end

			for _, v88 in t10 do
				if t3[v88] then
					t3[v88](DataStatus.Failed)
				end

				t4[v88] = v85
			end
		end,
		resetFailedItem = function(s5: string) -- line: 178
			-- upvalues: t1 (ref), DataStatus (copy), t3 (ref)
			local v79 = t1[s5]

			if v79 and v79.status(false) == DataStatus.Failed then
				t3[s5](DataStatus.NotReady)
			end
		end,
		resetFailedItems = function(t11: {[any]: any}) -- line: 185
			-- upvalues: t1 (ref), DataStatus (copy), t3 (ref)
			for _, v82 in t11 do
				local v83 = t1[v82]

				if v83 and v83.status(false) == DataStatus.Failed then
					t3[v82](DataStatus.NotReady)
				end
			end
		end,
		clear = clear,
		dispose = function() -- line: 229
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
