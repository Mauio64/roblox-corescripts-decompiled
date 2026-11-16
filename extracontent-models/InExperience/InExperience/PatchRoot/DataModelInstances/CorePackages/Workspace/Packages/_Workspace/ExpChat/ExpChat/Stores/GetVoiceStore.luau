local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createVoiceStore = require(script.createVoiceStore)

return Signals.createComputed(createVoiceStore)
