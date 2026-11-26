local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local function createMutationLayer()
	local v5 = {}
	local v6 = {}
	local v7 = {}

	local v8 = {}

	local function getOrCreateMutationSignal(p2)
		if v5[p2] then
			return v5[p2], v6[p2]
		end

		local v9 = v5
		local v10 = v6
		local signal, v11 = Signals.createSignal(nil)
		v9[p2] = signal
		v10[p2] = v11

		return v5[p2], v6[p2]
	end

	return {
		set = function(p2, p3)
			if not v5[p2] then
				local v9 = v5
				local v10 = v6
				local signal, v11 = Signals.createSignal(nil)
				v9[p2] = signal
				v10[p2] = v11
			end

			local v9 = v5[p2]
			local v10 = v6[p2]

			local v11 = v9(false)

			if type(v11) == "table" and type(p3) == "table" then
				v10(Cryo.Dictionary.union(v11, p3))
			else
				v10(p3)
			end
		end,
		clear = function(p2)
			if v6[p2] then
				v6[p2](nil)
			end

			v8[p2] = nil
		end,
		has = function(p2): boolean
			if v5[p2] then
				return v5[p2](false) ~= nil
			end

			return false
		end,
		get = function(p2)
			if v5[p2] then
				return v5[p2](false)
			end

			return nil
		end,
		markCommitted = function(p2)
			local v9 = if v5[p2] then v5[p2](false) ~= nil else false

			if v9 then
				v8[p2] = true
			end
		end,
		isCommitted = function(p2): boolean
			return v8[p2] == true
		end,
		drainCommitted = function(items, callback)
			for k, item in items do
				if not v8[item] then
					continue
				end

				local v9 = if v5[item] then v5[item](false) or nil else nil

				if v9 ~= nil then
					callback(item, v9)
				end

				if v6[item] then
					v6[item](nil)
				end

				v8[item] = nil
			end
		end,
		getMergedResult = function(p2, p3)
			if v7[p2] then
				return v7[p2]
			end

			if not v5[p2] then
				local v9 = v5
				local v10 = v6
				local signal, v11 = Signals.createSignal(nil)
				v9[p2] = signal
				v10[p2] = v11
			end

			local v9 = v5[p2]
			local v10 = v6[p2]

			local computed = Signals.createComputed(function(p4)
				local v11 = v9(p4)
				local data = p3.data(p4)

				if v11 == nil then
					return data
				end

				if type(v11) ~= "table" then
					return v11
				end

				local v12 = type(data) ~= "table" and {} or data
				return Cryo.Dictionary.join(v12, v11)
			end)

			v7[p2] = { data = computed, status = p3.status }

			return v7[p2]
		end,
		clearAll = function()
			for k, v9 in v6 do
				v9(nil)
			end

			v8 = {}
			v7 = {}
		end
	}
end

return createMutationLayer
