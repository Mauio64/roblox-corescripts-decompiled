local BuildExperience = script:FindFirstAncestor("BuildExperience")

local FFlagBuildWithGroups = require(BuildExperience.Flags.FFlagBuildWithGroups)

return game:DefineFastFlag("BuildExperienceCursorSearchPages", false) and FFlagBuildWithGroups
