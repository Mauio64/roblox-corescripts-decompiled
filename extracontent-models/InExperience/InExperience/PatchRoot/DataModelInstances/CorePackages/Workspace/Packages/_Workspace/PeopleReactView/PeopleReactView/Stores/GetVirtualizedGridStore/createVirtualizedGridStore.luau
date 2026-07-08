local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Signals = require(Parent.Signals)
local FFlagFixVirtualizedGridNumItems = require(Parent.PeopleService).getService("Flags").FFlagFixVirtualizedGridNumItems
local v4 = game:DefineFastInt("PeoplePageVirtualizedGridBuffer", 200)

local function createVirtualizedGridStore() -- line: 28
	-- upvalues: Signals (copy), v4 (copy), FFlagFixVirtualizedGridNumItems (copy)
	local v6, v7 = Signals.createSignal(1)
	local v8, v9 = Signals.createSignal(0)
	local v10 = Signals.createComputed(function(p1) -- line: 32
		-- upvalues: v8 (copy), v6 (copy)
		return v8(p1) - v6(p1) + 1
	end)

	return {
		getMinVirtualizedIndex = v6,
		getMaxVirtualizedIndex = v8,
		getNumVirtualizedItems = v10,
		calculateVirtualizedGridLimits = function(n1: number, n2: number, _: number, n4: number, n5: number, n6: number) -- line: 38
			-- upvalues: v4 (copy), FFlagFixVirtualizedGridNumItems (copy), v7 (copy), v9 (copy)
			local v18 = math.floor((n1 - v4) / (n4 + n6)) * n5 + 1

			if not FFlagFixVirtualizedGridNumItems then
				v18 = math.max(1, v18)
			end

			local v19 = v18 + math.ceil((n2 + 2 * v4) / (n4 + n6)) * n5 - 1

			if FFlagFixVirtualizedGridNumItems then
				v18 = math.max(1, v18)
			end

			v7(v18)
			v9(v19)
		end
	}
end

return createVirtualizedGridStore
