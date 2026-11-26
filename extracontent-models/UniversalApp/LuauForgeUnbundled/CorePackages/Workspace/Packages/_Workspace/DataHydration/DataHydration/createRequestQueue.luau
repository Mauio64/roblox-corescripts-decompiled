local fFlagSduiReleaseSearchResultsPageState = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagSduiReleaseSearchResultsPageState

local function createRequestQueue()
	local v5 = {}

	local v6 = 1

	local function remove(p2)
		v5[p2] = nil
	end

	local function clear()
		table.clear(v5)
		v6 = 1
	end

	local requestQueue = {
		push = function(p2)
			if v5[p2] == nil then
				v5[p2] = v6
				v6 += 1
			end
		end,
		pop = function(p2)
			local result = {}

			for k, v7 in v5 do
				table.insert(result, k)
			end

			table.sort(result, function(a, b): boolean
				return v5[a] < v5[b]
			end)

			if not (p2 < #result) then
				table.clear(v5)
				return result
			end

			local result2 = {}

			for i = 1, p2 do
				local v7 = result[i]
				table.insert(result2, v7)
				v5[v7] = nil
			end

			return result2
		end,
		isEmpty = function(): boolean
			for k, v7 in v5 do
				return false
			end

			return true
		end,
		hasItem = function(p2): boolean
			return v5[p2] ~= nil
		end,
		remove = 0,
		clear = 0
	}

	if not fFlagSduiReleaseSearchResultsPageState then
		remove = nil
	end

	requestQueue.remove = remove
	requestQueue.clear = clear
	return requestQueue
end

return createRequestQueue
