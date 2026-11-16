local parent = script:FindFirstAncestor("PeopleService").Parent

local Signals = require(parent.Signals)

function createPersonStore(person)
	local signal, setOrder = Signals.createSignal(0)

	return {
		getPerson = function()
			return person
		end,
		getOrder = signal,
		setOrder = setOrder
	}
end

return createPersonStore
