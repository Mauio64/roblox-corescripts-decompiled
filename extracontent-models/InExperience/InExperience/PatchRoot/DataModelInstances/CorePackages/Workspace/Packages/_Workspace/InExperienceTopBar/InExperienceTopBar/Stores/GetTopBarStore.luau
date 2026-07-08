local Parent = script:FindFirstAncestor("InExperienceTopBar").Parent
local Signals = require(Parent.Signals)
local createTopBarStore = require(script.createTopBarStore)

return Signals.createComputed(createTopBarStore)
