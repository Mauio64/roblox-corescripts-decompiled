local GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagIsSquadEnabled")
return game:DefineFastFlag("EnablePartyNudgeV1_DEV", false) and GetFFlagIsSquadEnabled()
