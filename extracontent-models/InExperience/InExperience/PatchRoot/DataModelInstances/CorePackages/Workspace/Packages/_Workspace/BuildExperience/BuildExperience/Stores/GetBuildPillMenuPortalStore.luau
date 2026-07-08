local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createBuildPillMenuPortalStore = require(script.createBuildPillMenuPortalStore)

return Signals.createComputed(createBuildPillMenuPortalStore)
