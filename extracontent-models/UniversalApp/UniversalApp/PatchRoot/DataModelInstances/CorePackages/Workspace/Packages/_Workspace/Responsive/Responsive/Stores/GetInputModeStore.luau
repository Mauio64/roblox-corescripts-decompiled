local ParentParent = script.Parent.Parent.Parent
local Signals = require(ParentParent.Signals)
local createInputModeStore = require(script.createInputModeStore)

return Signals.createComputed(createInputModeStore)
