local TelemetryService = game:GetService("TelemetryService")

local fFlagSduiPlayWithRewardRefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/SharedFlags").FFlagSduiPlayWithRewardRefactor

local v5 = { "addOSInfo", "addSessionInfo", "addSessionId" }
local v6 = { "addOSInfo" }

local v7 = {
	eventName = "PlayWithRewardAdRequested",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardAdRequestedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 9, 28 },
	description = "\t        This is fired when a Play with Reward ad is requested.\n\t    "
}

local v8 = {
	eventName = "PlayWithRewardAdReceived",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardAdReceivedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 9, 30 },
	description = "\t        This is fired when a Play with Reward ad is received.\n\t    "
}

local v9 = {
	eventName = "PlayWithRewardBannerShown",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardBannerShownTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 4, 27 },
	description = "\t        This is fired when a Play with Reward banner is shown on an EDP.\n\t    "
}

local v10 = {
	eventName = "PlayWithRewardButtonClicked",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardButtonClickedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 25, 9, 24 },
	description = "\t        This is fired when a Play with Reward button is clicked on an EDP.\n\t    "
}

local v11 = {
	eventName = "PlayWithRewardAdPlaybackAttempted",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardAdPlaybackAttemptedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 25, 9, 24 },
	description = "\t        This is fired when a Play with Reward ad starts playing.\n\t    "
}

local v12 = {
	eventName = "PlayWithRewardAdPlaybackStopped",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardAdPlaybackStoppedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 25, 9, 24 },
	description = "\t        This is fired when a Play with Reward ad stops playing.\n\t    "
}

local v13 = {
	eventName = "PlayWithRewardGameJoinInitiated",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardGameJoinInitiatedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 25, 9, 24 },
	description = "\t        This is fired when a Play with Reward game join is initiated from an EDP.\n\t    "
}

local v14 = {
	eventName = "PlayWithRewardBlackoutCurtain",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardBlackoutCurtainTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 4, 3 },
	description = "\t        This is fired when the Play with Reward blackout curtain state changes (shown or hidden).\n\t    "
}

local v15 = {
	eventName = "PlayWithRewardShimmerShown",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardShimmerShownTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 4, 28 },
	description = "\t        This is fired when the Play with Reward shimmer is shown.\n\t    "
}

local v16 = {
	eventName = "PlayWithRewardCoachmark",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"PlayWithRewardCoachmarkTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 4, 21 },
	description = "\t        This is fired when a Play with Reward coachmark is shown or dismissed on an EDP.\n\t    "
}

local v17 = {
	eventName = "PlayWithRewardAdRequestedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardAdRequested events.\n\t\t    "
}

local v18 = {
	eventName = "PlayWithRewardAdReceivedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardAdReceived events with status.\n\t\t    "
}

local v19 = {
	eventName = "PlayWithRewardBannerShownCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 4, 27 },
	description = "\t\t        Counter for PlayWithRewardBannerShown events.\n\t\t    "
}

local v20 = {
	eventName = "PlayWithRewardButtonClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardButtonClicked events.\n\t\t    "
}

local v21 = {
	eventName = "PlayWithRewardAdPlaybackAttemptedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardAdPlaybackAttempted events.\n\t\t    "
}

local v22 = {
	eventName = "PlayWithRewardAdPlaybackStoppedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardAdPlaybackStopped events with status.\n\t\t    "
}

local v23 = {
	eventName = "PlayWithRewardGameJoinInitiatedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Counter for PlayWithRewardGameJoinInitiated events.\n\t\t    "
}

local v24 = {
	eventName = "PlayWithRewardCoachmarkCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 4, 21 },
	description = "\t\t        Counter for PlayWithRewardCoachmark events, split by action.\n\t\t    "
}

local v25 = {
	eventName = "PlayWithRewardAdReceivedSuccessfully",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 25, 9, 24 },
	description = "\t\t        Stats for successful PlayWithRewardAdReceived events.\n\t\t    "
}

local function getCoachmarkCustomFields(p2, p3, p4, p5)
	return { action = p2, playWithRewardFlowId = p3, universeId = p4, productId = p5 }
end

return {
	logPlayWithRewardAdRequested = function(p2, p3, experimentUiVariant)
		if not fFlagSduiPlayWithRewardRefactor then
			experimentUiVariant = nil
		end

		TelemetryService:LogEvent(v7, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				experimentUiVariant = experimentUiVariant
			}
		})

		TelemetryService:LogCounter(v17, { standardizedFields = v6, customFields = {} }, 1)
	end,
	logPlayWithRewardAdReceived = function(p2, p3, p4, p5, p6, p7, experimentUiVariant)
		if not fFlagSduiPlayWithRewardRefactor then
			experimentUiVariant = nil
		end

		TelemetryService:LogEvent(v8, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				isSuccessful = p4,
				adAvailabilityResult = p5,
				fetchLatencyMs = p6,
				productId = p7,
				experimentUiVariant = experimentUiVariant
			}
		})

		TelemetryService:LogCounter(v18, {
			standardizedFields = v6,
			customFields = { isSuccessful = p4, adAvailabilityResult = p5 }
		}, 1)

		if p4 then
			TelemetryService:LogStat(v25, {
				standardizedFields = v6,
				customFields = { adAvailabilityResult = p5 }
			}, p6)
		end
	end,
	logPlayWithRewardBannerShown = function(p2, p3, p4, p5, p6)
		TelemetryService:LogEvent(v9, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				showState = p4,
				productId = p5,
				experimentUiVariant = p6
			}
		})

		TelemetryService:LogCounter(v19, { standardizedFields = v6, customFields = {} }, 1)
	end,
	logPlayWithRewardButtonClicked = function(p2, p3, p4)
		TelemetryService:LogEvent(v10, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				productId = p4
			}
		})

		TelemetryService:LogCounter(v20, { standardizedFields = v6, customFields = {} }, 1)
	end,
	logPlayWithRewardAdPlaybackAttempted = function(p2, p3, p4)
		TelemetryService:LogEvent(v11, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				productId = p4
			}
		})

		TelemetryService:LogCounter(v21, { standardizedFields = v6, customFields = {} }, 1)
	end,
	logPlayWithRewardAdPlaybackStopped = function(p2, p3, p4, p5)
		TelemetryService:LogEvent(v12, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				adPlaybackStatus = p4,
				productId = p5
			}
		})

		TelemetryService:LogCounter(v22, {
			standardizedFields = v6,
			customFields = { adPlaybackStatus = p4 }
		}, 1)
	end,
	logPlayWithRewardGameJoinInitiated = function(p2, p3, p4)
		TelemetryService:LogEvent(v13, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				productId = p4
			}
		})

		TelemetryService:LogCounter(v23, { standardizedFields = v6, customFields = {} }, 1)
	end,
	logPlayWithRewardBlackoutCurtainAction = function(p2, p3, p4, p5)
		TelemetryService:LogEvent(v14, {
			standardizedFields = v5,
			customFields = {
				playWithRewardFlowId = p2,
				universeId = p3,
				action = p4,
				productId = p5
			}
		})
	end,
	logPlayWithRewardShimmerShown = function(p2, p3)
		TelemetryService:LogEvent(v15, {
			standardizedFields = v5,
			customFields = { playWithRewardFlowId = p2, universeId = p3 }
		})
	end,
	logPlayWithRewardCoachmark = function(p2, p3, p4, p5)
		TelemetryService:LogEvent(v16, {
			standardizedFields = v5,
			customFields = {
				action = p2,
				playWithRewardFlowId = p3,
				universeId = p4,
				productId = p5
			}
		})

		TelemetryService:LogCounter(v24, {
			standardizedFields = v6,
			customFields = { action = p2 }
		}, 1)
	end
}
