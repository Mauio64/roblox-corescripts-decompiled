local FFlagEnablePioneerPostAuthGameJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePioneerPostAuthGameJoin")

return game:DefineFastFlag("PioneerLeaveLogsOut", false)
	and FFlagEnablePioneerPostAuthGameJoin
	and game:GetEngineFeature("ExperienceLeaveReasonEnabled")
	and game:GetEngineFeature("PioneerReturnToLuaAppOnReasonedLeave")
