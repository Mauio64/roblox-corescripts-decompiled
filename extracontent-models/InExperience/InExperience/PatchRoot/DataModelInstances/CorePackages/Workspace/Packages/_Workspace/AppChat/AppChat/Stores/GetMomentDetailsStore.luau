local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createMomentDetailsStore = require(script.createMomentDetailsStore)

return Signals.createComputed(function(_)
	return createMomentDetailsStore()
end)
