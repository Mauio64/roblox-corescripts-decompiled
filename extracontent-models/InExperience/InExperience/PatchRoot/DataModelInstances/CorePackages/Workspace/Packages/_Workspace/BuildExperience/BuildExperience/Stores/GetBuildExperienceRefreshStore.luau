local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createBuildExperienceRefreshStore = require(script.createBuildExperienceRefreshStore)

return Signals.createComputed(createBuildExperienceRefreshStore)
