local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local Signals = require(Parent.Signals)
local createLoadingScreenStore = require(script.Parent.createLoadingScreenStore)

return Signals.createComputed(createLoadingScreenStore)
