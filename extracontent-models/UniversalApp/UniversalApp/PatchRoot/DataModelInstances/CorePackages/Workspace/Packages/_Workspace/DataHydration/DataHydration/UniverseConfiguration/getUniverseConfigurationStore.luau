local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUniverseConfigurationStore = require(script.Parent.createUniverseConfigurationStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createUniverseConfigurationStore (copy)
	return createUniverseConfigurationStore()
end)
