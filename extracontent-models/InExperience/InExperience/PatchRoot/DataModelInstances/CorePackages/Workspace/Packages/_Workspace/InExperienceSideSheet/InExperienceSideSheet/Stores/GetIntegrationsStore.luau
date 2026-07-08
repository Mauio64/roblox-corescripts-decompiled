local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(Parent.Signals)
local createIntegrationsStore = require(script.createIntegrationsStore)

return Signals.createComputed(createIntegrationsStore)
