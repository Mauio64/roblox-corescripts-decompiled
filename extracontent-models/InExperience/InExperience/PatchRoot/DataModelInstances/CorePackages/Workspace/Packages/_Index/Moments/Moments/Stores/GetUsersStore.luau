local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createUsersStore = require(script.createUsersStore)

return Signals.createComputed(function(_)
	return createUsersStore()
end)
