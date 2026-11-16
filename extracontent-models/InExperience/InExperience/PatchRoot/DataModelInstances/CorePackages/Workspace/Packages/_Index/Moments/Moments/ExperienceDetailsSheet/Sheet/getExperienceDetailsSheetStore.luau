local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createExperienceDetailsSheetStore = require(script.Parent.createExperienceDetailsSheetStore)

return Signals.createComputed(createExperienceDetailsSheetStore)
