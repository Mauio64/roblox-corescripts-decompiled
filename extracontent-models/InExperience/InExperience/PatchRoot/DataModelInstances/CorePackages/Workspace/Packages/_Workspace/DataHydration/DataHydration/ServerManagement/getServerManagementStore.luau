local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createServerManagementStore = require(script.Parent.createServerManagementStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createServerManagementStore (copy)
	return createServerManagementStore()
end)
