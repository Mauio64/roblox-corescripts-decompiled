local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createCharacterStore = require(script.createCharacterStore)

return Signals.createComputed(createCharacterStore)
