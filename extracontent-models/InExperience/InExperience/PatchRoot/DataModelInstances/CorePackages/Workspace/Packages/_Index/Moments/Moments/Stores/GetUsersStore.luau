local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createUsersStore = require(script.createUsersStore)

return Signals.createComputed(function(_) -- line: 7
	-- upvalues: createUsersStore (copy)
	return createUsersStore()
end)
