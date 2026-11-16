local GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagIsSquadEnabled")

return game:GetEngineFeature("PrivatePartyJoin")
	and GetFFlagIsSquadEnabled()
	and game:DefineFastFlag("EnablePrivatePartyAcceptInvite", false)
