local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createVoiceStore = require(script.createVoiceStore)

return Signals.createComputed(createVoiceStore)
