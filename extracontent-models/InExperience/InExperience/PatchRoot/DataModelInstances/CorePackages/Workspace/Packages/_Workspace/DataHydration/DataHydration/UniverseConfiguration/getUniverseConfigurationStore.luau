local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUniverseConfigurationStore = require(script.Parent.createUniverseConfigurationStore)

return Signals.createComputed(function()
	return createUniverseConfigurationStore()
end)
