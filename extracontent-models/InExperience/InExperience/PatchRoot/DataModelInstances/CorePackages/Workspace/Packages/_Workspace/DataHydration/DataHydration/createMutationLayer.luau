local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

require(DataHydration.DataHydrationTypes)

local function createMutationLayer()
	local signals = {}
	local v = {}
	local v2 = {}

	local v3 = {}

	local function getOrCreateMutationSignal(p: string) -- 2 equivalent calls inferred from this helper
		if not signals[p] then
			local signal, v4 = Signals.createSignal(nil)
			signals[p] = signal
			v[p] = v4
		end

		return signals[p], v[p]
	end

	local function has(p: string): boolean -- 1 equivalent call inferred from this helper
		if signals[p] then
			return signals[p](false) ~= nil
		end

		return false
	end

	return {
		set = function(p: string, p2)
			local mutationSignal, v4 = getOrCreateMutationSignal(p) -- inferred equivalent call
			local v5 = mutationSignal(false)

			if type(v5) == "table" and type(p2) == "table" then
				v4((Cryo.Dictionary.union(v5, p2)))
			else
				v4(p2)
			end
		end,
		clear = function(p: string)
			if v[p] then
				v[p](nil)
			end

			v3[p] = nil
		end,
		has = has,
		get = function(p: string)
			if signals[p] then
				return signals[p](false)
			end

			return nil
		end,
		markCommitted = function(p: string)
			if has(p) then -- inferred equivalent call
				v3[p] = true
			end
		end,
		isCommitted = function(p: string): boolean
			return v3[p] == true
		end,
		drainCommitted = function(items, callback)
			for _, item in items do
				if not v3[item] then
					continue
				end

				local v4

				if signals[item] then
					v4 = signals[item](false) or nil
				end

				if v4 ~= nil then
					callback(item, v4)
				end

				if v[item] then
					v[item](nil)
				end

				v3[item] = nil
			end
		end,
		getMergedResult = function(p: string, p2)
			if v2[p] then
				return v2[p]
			end

			local mutationSignal = getOrCreateMutationSignal(p) -- inferred equivalent call
			local computed = Signals.createComputed(function(p3)
				local v4 = mutationSignal(p3)
				local data = p2.data(p3)

				if v4 == nil then
					return data
				end

				if type(v4) ~= "table" then
					return v4
				end

				local v5 = type(data) ~= "table" and {} or data
				return (Cryo.Dictionary.join(v5, v4))
			end)

			v2[p] = { data = computed, status = p2.status }

			return v2[p]
		end,
		clearAll = function()
			for _, v4 in v do
				v4(nil)
			end

			v3 = {}
			v2 = {}
		end
	}
end

return createMutationLayer
