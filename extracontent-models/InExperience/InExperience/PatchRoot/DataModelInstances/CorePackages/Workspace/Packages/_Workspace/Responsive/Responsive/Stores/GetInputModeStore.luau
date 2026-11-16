local parent = script.Parent.Parent.Parent
local Signals = require(parent.Signals)
local createInputModeStore = require(script.createInputModeStore)

return Signals.createComputed(createInputModeStore)
