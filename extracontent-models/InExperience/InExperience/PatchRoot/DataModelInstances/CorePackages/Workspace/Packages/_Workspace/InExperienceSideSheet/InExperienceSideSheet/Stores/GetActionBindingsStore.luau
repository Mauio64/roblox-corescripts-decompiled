local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(Parent.Signals)
local createActionBindingsStore = require(script.createActionBindingsStore)

return Signals.createComputed(createActionBindingsStore)
