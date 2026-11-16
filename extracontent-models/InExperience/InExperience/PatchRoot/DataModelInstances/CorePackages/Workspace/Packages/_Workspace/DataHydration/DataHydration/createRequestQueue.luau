local parent = script:FindFirstAncestor("DataHydration").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiReleaseSearchResultsPageState = SharedFlags.FFlagSduiReleaseSearchResultsPageState

local function createRequestQueue()
	local v = {}

	local v2 = 1

	local function remove(p: string)
		v[p] = nil
	end

	local function clear()
		table.clear(v)
		v2 = 1
	end

	local requestQueue = {
		push = function(p: string)
			if v[p] == nil then
				v[p] = v2
				v2 += 1
			end
		end,
		pop = function(p: number)
			local result = {}

			for k, _ in v do
				table.insert(result, k)
			end

			table.sort(result, function(a, b): boolean
				return v[a] < v[b]
			end)

			if not (p < #result) then
				table.clear(v)
				return result
			end

			local result2 = {}

			for i = 1, p do
				local v3 = result[i]
				table.insert(result2, v3)
				v[v3] = nil
			end

			return result2
		end,
		isEmpty = function(): boolean
			for _, _ in v do
				return false
			end

			return true
		end,
		hasItem = function(p: string): boolean
			return v[p] ~= nil
		end,
		remove = 0,
		clear = 0
	}

	if not FFlagSduiReleaseSearchResultsPageState then
		remove = nil
	end

	requestQueue.remove = remove
	requestQueue.clear = clear
	return requestQueue
end

return createRequestQueue
