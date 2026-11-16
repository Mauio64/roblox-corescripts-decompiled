local Squads = script:FindFirstAncestor("Squads")

local dependencies = require(Squads.dependencies)

return dependencies.SocialExperiments.SquadCoordinationUIChangesExperimentation.getPartyCoordinationUiChangesEnabled()
