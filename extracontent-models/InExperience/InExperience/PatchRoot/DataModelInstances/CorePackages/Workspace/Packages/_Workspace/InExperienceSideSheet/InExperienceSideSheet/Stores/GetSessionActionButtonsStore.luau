local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(parent.Signals)
local createSessionActionButtonsStore = require(script.createSessionActionButtonsStore)

return Signals.createComputed(createSessionActionButtonsStore)
