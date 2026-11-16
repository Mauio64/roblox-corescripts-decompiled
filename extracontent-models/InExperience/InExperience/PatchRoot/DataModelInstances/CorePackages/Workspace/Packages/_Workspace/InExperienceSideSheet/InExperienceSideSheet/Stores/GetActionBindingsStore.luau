local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(parent.Signals)
local createActionBindingsStore = require(script.createActionBindingsStore)

return Signals.createComputed(createActionBindingsStore)
