local GetFFlagIsSquadEnabled = require(script.Parent.GetFFlagIsSquadEnabled)

return game:GetEngineFeature("PrivatePartyJoin") and (GetFFlagIsSquadEnabled() and game:DefineFastFlag("EnablePrivatePartyAcceptInvite", false))
