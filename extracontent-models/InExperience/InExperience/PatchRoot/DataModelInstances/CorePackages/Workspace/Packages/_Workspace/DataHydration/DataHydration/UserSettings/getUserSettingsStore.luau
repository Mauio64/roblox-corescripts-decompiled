local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUserSettingsStore = require(script.Parent.createUserSettingsStore)

return Signals.createComputed(createUserSettingsStore)
