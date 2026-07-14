local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)

require(DataHydration.DataHydrationTypes)

local function createMutationLayer() -- line: 10
	-- upvalues: Signals (copy), Cryo (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}

	local function getOrCreateMutationSignal(s1: string) -- line: 18
		-- upvalues: t1 (copy), t2 (copy), Signals (copy)
		if not t1[s1] then
			local v12 = t1
			local v13 = t2
			local v14, v15 = Signals.createSignal(nil)

			v12[s1] = v14
			v13[s1] = v15
		end

		return t1[s1], t2[s1]
	end

	return {
		set = function(s2: string, p1) -- line: 30
			-- upvalues: t1 (copy), t2 (copy), Signals (copy), Cryo (copy)
			if not t1[s2] then
				local v18 = t1
				local v19 = t2
				local v20, v21 = Signals.createSignal(nil)

				v18[s2] = v20
				v19[s2] = v21
			end

			local v22 = t1[s2]
			local v23 = t2[s2]
			local v24 = v22(false)

			if type(v24) == "table" and type(p1) == "table" then
				v23((Cryo.Dictionary.union(v24, p1)))

				return
			end

			v23(p1)
		end,
		clear = function(s3: string) -- line: 40
			-- upvalues: t2 (copy), t4 (ref)
			if t2[s3] then
				t2[s3](nil)
			end

			t4[s3] = nil
		end,
		has = function(s4: string) -- line: 47
			-- upvalues: t1 (copy)
			if not t1[s4] then
				return false
			end

			return t1[s4](false) ~= nil
		end,
		get = function(s5: string) -- line: 57
			-- upvalues: t1 (copy)
			if not t1[s5] then
				return nil
			end

			return t1[s5](false)
		end,
		markCommitted = function(s6: string) -- line: 65
			-- upvalues: t1 (copy), t4 (ref)
			if if t1[s6] then t1[s6](false) ~= nil else false then
				t4[s6] = true
			end
		end,
		isCommitted = function(s7: string) -- line: 71
			-- upvalues: t4 (ref)
			return t4[s7] == true
		end,
		drainCommitted = function(t5: {[any]: any}, p2: ((...any) -> ...any)) -- line: 77
			-- upvalues: t4 (ref), t1 (copy), t2 (copy)
			for _, v33 in t5 do
				if t4[v33] then
					local v34 = t1[v33] and t1[v33](false) or nil

					if v34 ~= nil then
						p2(v33, v34)
					end

					if t2[v33] then
						t2[v33](nil)
					end

					t4[v33] = nil
				end
			end
		end,
		getMergedResult = function(s8: string, p3) -- line: 97
			-- upvalues: t3 (ref), t1 (copy), t2 (copy), Signals (copy), Cryo (copy)
			if t3[s8] then
				return t3[s8]
			end

			if not t1[s8] then
				local v37 = t1
				local v38 = t2
				local v39, v40 = Signals.createSignal(nil)

				v37[s8] = v39
				v38[s8] = v40
			end

			local v41 = t1[s8]
			local _ = t2[s8]

			t3[s8] = {
				data = Signals.createComputed(function(p4) -- line: 104
					-- upvalues: v41 (copy), p3 (copy), Cryo (copy)
					local v46 = v41(p4)
					local v47 = p3.data(p4)

					if v46 == nil then
						return v47
					end

					if type(v46) ~= "table" then
						return v46
					end

					local v48 = if type(v47) ~= "table" then {} else v47

					return (Cryo.Dictionary.join(v48, v46))
				end),
				status = p3.status
			}

			return t3[s8]
		end,
		clearAll = function() -- line: 127
			-- upvalues: t2 (copy), t4 (ref), t3 (ref)
			for _, v44 in t2 do
				v44(nil)
			end

			t4 = {}
			t3 = {}
		end
	}
end

return createMutationLayer
