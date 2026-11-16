local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(parent.Signals)
local createIntegrationsStore = require(script.createIntegrationsStore)

return Signals.createComputed(createIntegrationsStore)
