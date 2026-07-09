local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createTrustedConnectionsStore = require(script.Parent.createTrustedConnectionsStore)
local v4 = Signals.createComputed(createTrustedConnectionsStore)

return {
	get = function() -- line: 11
		-- upvalues: v4 (copy)
		return v4(false)
	end
}
