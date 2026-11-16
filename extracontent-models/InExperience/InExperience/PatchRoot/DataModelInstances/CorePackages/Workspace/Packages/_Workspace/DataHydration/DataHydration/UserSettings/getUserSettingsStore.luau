local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUserSettingsStore = require(script.Parent.createUserSettingsStore)

return Signals.createComputed(function()
	return createUserSettingsStore()
end)
