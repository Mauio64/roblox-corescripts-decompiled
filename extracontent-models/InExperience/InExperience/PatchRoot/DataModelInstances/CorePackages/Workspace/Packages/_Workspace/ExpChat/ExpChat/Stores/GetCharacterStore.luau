local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createCharacterStore = require(script.createCharacterStore)

return Signals.createComputed(createCharacterStore)
