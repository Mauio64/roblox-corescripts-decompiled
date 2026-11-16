local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createDictationStateStore = require(script.createDictationStateStore)

return Signals.createComputed(createDictationStateStore)
