local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createEditsStore()
	local signal, v = createSignal({})

	return {
		getMap = signal,
		setCommitted = function(p: string, p2)
			local clone = table.clone(signal(false))
			clone[p] = p2
			v(clone)
		end,
		clear = function()
			v({})
		end
	}
end

return createEditsStore
