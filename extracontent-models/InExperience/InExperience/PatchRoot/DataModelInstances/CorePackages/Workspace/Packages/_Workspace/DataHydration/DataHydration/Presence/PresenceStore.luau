local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPresenceStore = require(script.Parent.createPresenceStore)

local computed = Signals.createComputed(createPresenceStore)

return {
	get = function()
		return computed(false)
	end
}
