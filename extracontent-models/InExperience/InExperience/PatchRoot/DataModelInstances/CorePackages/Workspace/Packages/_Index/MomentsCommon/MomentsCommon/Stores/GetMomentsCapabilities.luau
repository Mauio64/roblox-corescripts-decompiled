local parent = script:FindFirstAncestor("MomentsCommon").Parent
local Signals = require(parent.Signals)
local createMomentsCapabilities = require(script.createMomentsCapabilities)

return Signals.createComputed(function(_)
	return createMomentsCapabilities()
end)
