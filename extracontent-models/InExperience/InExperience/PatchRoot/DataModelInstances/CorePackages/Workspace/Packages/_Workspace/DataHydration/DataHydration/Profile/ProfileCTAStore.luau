local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createProfileCTAStore = require(script.Parent.createProfileCTAStore)
local v4 = Signals.createComputed(createProfileCTAStore)

return {
	get = function() -- line: 11
		-- upvalues: v4 (copy)
		return v4(false)
	end
}
