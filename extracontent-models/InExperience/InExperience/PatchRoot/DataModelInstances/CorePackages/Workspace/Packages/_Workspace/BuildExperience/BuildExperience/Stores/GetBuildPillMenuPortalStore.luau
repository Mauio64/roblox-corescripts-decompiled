local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local createBuildPillMenuPortalStore = require(script.createBuildPillMenuPortalStore)

return Signals.createComputed(createBuildPillMenuPortalStore)
