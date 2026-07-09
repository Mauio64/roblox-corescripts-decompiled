local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createPublishGameSheetStore = require(script.createPublishGameSheetStore)

return Signals.createComputed(createPublishGameSheetStore)
