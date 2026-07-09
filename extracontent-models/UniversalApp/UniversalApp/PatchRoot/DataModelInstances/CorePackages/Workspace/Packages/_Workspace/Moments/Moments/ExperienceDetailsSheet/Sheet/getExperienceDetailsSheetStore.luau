local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createExperienceDetailsSheetStore = require(script.Parent.createExperienceDetailsSheetStore)

return Signals.createComputed(createExperienceDetailsSheetStore)
