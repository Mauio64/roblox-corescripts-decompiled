local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createTrustedConnectionsStore = require(script.Parent.createTrustedConnectionsStore)

local computed = Signals.createComputed(createTrustedConnectionsStore)

return {
	get = function()
		return computed(false)
	end
}
