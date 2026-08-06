local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

require(script.Parent.PrivatePlaytestersStoreTypes)

local function createPlayersGetterCache() -- line: 26
	-- upvalues: Signals (copy)
	local t1 = {}

	return {
		getFor = function(p1) -- line: 29
			-- upvalues: t1 (copy), Signals (copy)
			local v6 = t1[p1]

			if v6 ~= nil then
				return v6
			end

			local v7 = Signals.createComputed(function(p2) -- line: 34
				-- upvalues: p1 (copy)
				return p1(p2) or {}
			end)

			t1[p1] = v7

			return v7
		end,
		clear = function() -- line: 41
			-- upvalues: t1 (copy)
			table.clear(t1)
		end
	}
end

return createPlayersGetterCache
