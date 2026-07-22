local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUserSettingsStore = require(script.Parent.createUserSettingsStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createUserSettingsStore (copy)
	return createUserSettingsStore()
end)
