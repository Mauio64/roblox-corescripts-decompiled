local parent = script:FindFirstAncestor("InExperienceTopBar").Parent
local Signals = require(parent.Signals)
local createTopBarStore = require(script.createTopBarStore)

return Signals.createComputed(createTopBarStore)
