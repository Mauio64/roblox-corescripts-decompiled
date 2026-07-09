local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createPresenceStore = require(script.Parent.createPresenceStore)
local v4 = Signals.createComputed(createPresenceStore)

return {
	get = function() -- line: 11
		-- upvalues: v4 (copy)
		return v4(false)
	end
}
