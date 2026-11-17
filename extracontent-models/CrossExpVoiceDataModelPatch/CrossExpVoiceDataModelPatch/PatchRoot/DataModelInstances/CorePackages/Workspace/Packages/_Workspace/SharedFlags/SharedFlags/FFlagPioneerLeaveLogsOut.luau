local FFlagEnablePioneerPostAuthGameJoin = require(script.Parent.FFlagEnablePioneerPostAuthGameJoin)

return game:DefineFastFlag("PioneerLeaveLogsOut", false)
	and FFlagEnablePioneerPostAuthGameJoin
	and game:GetEngineFeature("ExperienceLeaveReasonEnabled")
	and game:GetEngineFeature("PioneerReturnToLuaAppOnReasonedLeave")
