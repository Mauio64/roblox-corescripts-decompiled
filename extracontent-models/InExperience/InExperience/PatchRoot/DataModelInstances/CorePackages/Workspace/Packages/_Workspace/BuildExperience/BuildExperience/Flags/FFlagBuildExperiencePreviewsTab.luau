local BuildExperience = script:FindFirstAncestor("BuildExperience")

local FFlagBuildWithGroups = require(BuildExperience.Flags.FFlagBuildWithGroups)

return game:DefineFastFlag("BuildExperiencePreviewsTab5", false) and FFlagBuildWithGroups
