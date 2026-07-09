local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createBuildExperienceRefreshStore = require(script.createBuildExperienceRefreshStore)

return Signals.createComputed(createBuildExperienceRefreshStore)
