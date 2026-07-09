local Parent = script:FindFirstAncestor("PeopleService").Parent
local Signals = require(Parent.Signals)

function createPersonStore(p1) -- line: 14
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(0)

	return {
		getPerson = function() -- line: 18
			-- upvalues: p1 (copy)
			return p1
		end,
		getOrder = v4,
		setOrder = v5
	}
end

return createPersonStore
