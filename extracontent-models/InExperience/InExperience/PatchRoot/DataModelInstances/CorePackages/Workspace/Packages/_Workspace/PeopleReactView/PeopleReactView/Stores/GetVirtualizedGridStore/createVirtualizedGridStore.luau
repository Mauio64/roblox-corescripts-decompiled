local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Signals = require(parent.Signals)

local PeopleService = require(parent.PeopleService)

local fFlagFixVirtualizedGridNumItems = PeopleService.getService("Flags").FFlagFixVirtualizedGridNumItems

local defineFastInt = game:DefineFastInt("PeoplePageVirtualizedGridBuffer", 200)

local function createVirtualizedGridStore()
	local signal, v = Signals.createSignal(1)
	local signal2, v2 = Signals.createSignal(0)

	return {
		getMinVirtualizedIndex = signal,
		getMaxVirtualizedIndex = signal2,
		getNumVirtualizedItems = Signals.createComputed(function(p)
			return signal2(p) - signal(p) + 1
		end),
		calculateVirtualizedGridLimits = function(p: number, p2: number, _: number, p3: number, p4: number, p5: number)
			local v3 = math.floor((p - defineFastInt) / (p3 + p5)) * p4 + 1

			if not fFlagFixVirtualizedGridNumItems then
				v3 = math.max(1, v3)
			end

			local v4 = v3 + math.ceil((p2 + 2 * defineFastInt) / (p3 + p5)) * p4 - 1

			if fFlagFixVirtualizedGridNumItems then
				v3 = math.max(1, v3)
			end

			v(v3)
			v2(v4)
		end
	}
end

return createVirtualizedGridStore
