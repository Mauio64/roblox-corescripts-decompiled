local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createAdUpsellEventStore = require(script.createAdUpsellEventStore)

return Signals.createComputed(function()
	return createAdUpsellEventStore()
end)
