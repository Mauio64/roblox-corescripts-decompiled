local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("PlayWithRewardComponent").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiPlayWithRewardRefactor = SharedFlags.FFlagSduiPlayWithRewardRefactor

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }
local standardizedFields2 = { "addOSInfo" }

local v = {
	eventName = "PlayWithRewardAdRequested",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdRequestedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 9, 28 },
	description = "        This is fired when a Play with Reward ad is requested.\n    "
}

local v2 = {
	eventName = "PlayWithRewardAdReceived",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdReceivedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 9, 30 },
	description = "        This is fired when a Play with Reward ad is received.\n    "
}

local v3 = {
	eventName = "PlayWithRewardBannerShown",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardBannerShownTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 4, 27 },
	description = "        This is fired when a Play with Reward banner is shown on an EDP.\n    "
}

local v4 = {
	eventName = "PlayWithRewardButtonClicked",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardButtonClickedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 25, 9, 24 },
	description = "        This is fired when a Play with Reward button is clicked on an EDP.\n    "
}

local v5 = {
	eventName = "PlayWithRewardAdPlaybackAttempted",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdPlaybackAttemptedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 25, 9, 24 },
	description = "        This is fired when a Play with Reward ad starts playing.\n    "
}

local v6 = {
	eventName = "PlayWithRewardAdPlaybackStopped",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdPlaybackStoppedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 25, 9, 24 },
	description = "        This is fired when a Play with Reward ad stops playing.\n    "
}

local v7 = {
	eventName = "PlayWithRewardGameJoinInitiated",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardGameJoinInitiatedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 25, 9, 24 },
	description = "        This is fired when a Play with Reward game join is initiated from an EDP.\n    "
}

local v8 = {
	eventName = "PlayWithRewardBlackoutCurtain",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardBlackoutCurtainTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 4, 3 },
	description = "        This is fired when the Play with Reward blackout curtain state changes (shown or hidden).\n    "
}

local v9 = {
	eventName = "PlayWithRewardShimmerShown",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardShimmerShownTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 4, 28 },
	description = "        This is fired when the Play with Reward shimmer is shown.\n    "
}

local v10 = {
	eventName = "PlayWithRewardCoachmark",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("PlayWithRewardCoachmarkTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 4, 21 },
	description = "        This is fired when a Play with Reward coachmark is shown or dismissed on an EDP.\n    "
}

local v11 = {
	eventName = "PlayWithRewardAdRequestedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardAdRequested events.\n\t    "
}

local v12 = {
	eventName = "PlayWithRewardAdReceivedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardAdReceived events with status.\n\t    "
}

local v13 = {
	eventName = "PlayWithRewardBannerShownCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 4, 27 },
	description = "\t        Counter for PlayWithRewardBannerShown events.\n\t    "
}

local v14 = {
	eventName = "PlayWithRewardButtonClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardButtonClicked events.\n\t    "
}

local v15 = {
	eventName = "PlayWithRewardAdPlaybackAttemptedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardAdPlaybackAttempted events.\n\t    "
}

local v16 = {
	eventName = "PlayWithRewardAdPlaybackStoppedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardAdPlaybackStopped events with status.\n\t    "
}

local v17 = {
	eventName = "PlayWithRewardGameJoinInitiatedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Counter for PlayWithRewardGameJoinInitiated events.\n\t    "
}

local v18 = {
	eventName = "PlayWithRewardCoachmarkCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 4, 21 },
	description = "\t        Counter for PlayWithRewardCoachmark events, split by action.\n\t    "
}

local v19 = {
	eventName = "PlayWithRewardAdReceivedSuccessfully",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 25, 9, 24 },
	description = "\t        Stats for successful PlayWithRewardAdReceived events.\n\t    "
}

local function getCoachmarkCustomFields(action: string, playWithRewardFlowId: string, universeId: string, productId: string) -- 1 equivalent call inferred from this helper
	return {
		action = action,
		playWithRewardFlowId = playWithRewardFlowId,
		universeId = universeId,
		productId = productId
	}
end

local PlayWithRewardTelemetry = {}

function PlayWithRewardTelemetry.logPlayWithRewardAdRequested(playWithRewardFlowId: string, universeId: string, experimentUiVariant: string?)
	if not FFlagSduiPlayWithRewardRefactor then
		experimentUiVariant = nil
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			experimentUiVariant = experimentUiVariant
		}
	})

	TelemetryService:LogCounter(v11, { standardizedFields = standardizedFields2, customFields = {} }, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardAdReceived(playWithRewardFlowId: string, universeId: string, isSuccessful: boolean, adAvailabilityResult: string?, fetchLatencyMs: number, productId: string?, experimentUiVariant: string?)
	if not FFlagSduiPlayWithRewardRefactor then
		experimentUiVariant = nil
	end

	TelemetryService:LogEvent(v2, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			isSuccessful = isSuccessful,
			adAvailabilityResult = adAvailabilityResult,
			fetchLatencyMs = fetchLatencyMs,
			productId = productId,
			experimentUiVariant = experimentUiVariant
		}
	})

	TelemetryService:LogCounter(v12, {
		standardizedFields = standardizedFields2,
		customFields = { isSuccessful = isSuccessful, adAvailabilityResult = adAvailabilityResult }
	}, 1)

	if isSuccessful then
		TelemetryService:LogStat(v19, {
			standardizedFields = standardizedFields2,
			customFields = { adAvailabilityResult = adAvailabilityResult }
		}, fetchLatencyMs)
	end
end

function PlayWithRewardTelemetry.logPlayWithRewardBannerShown(playWithRewardFlowId: string, universeId: string, showState: string, productId: string, experimentUiVariant: string)
	TelemetryService:LogEvent(v3, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			showState = showState,
			productId = productId,
			experimentUiVariant = experimentUiVariant
		}
	})

	TelemetryService:LogCounter(v13, { standardizedFields = standardizedFields2, customFields = {} }, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardButtonClicked(playWithRewardFlowId: string, universeId: string, productId: string)
	TelemetryService:LogEvent(v4, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			productId = productId
		}
	})

	TelemetryService:LogCounter(v14, { standardizedFields = standardizedFields2, customFields = {} }, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackAttempted(playWithRewardFlowId: string, universeId: string, productId: string)
	TelemetryService:LogEvent(v5, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			productId = productId
		}
	})

	TelemetryService:LogCounter(v15, { standardizedFields = standardizedFields2, customFields = {} }, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackStopped(playWithRewardFlowId: string, universeId: string, adPlaybackStatus: string, productId: string)
	TelemetryService:LogEvent(v6, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			adPlaybackStatus = adPlaybackStatus,
			productId = productId
		}
	})

	TelemetryService:LogCounter(v16, {
		standardizedFields = standardizedFields2,
		customFields = { adPlaybackStatus = adPlaybackStatus }
	}, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(playWithRewardFlowId: string, universeId: string, productId: string)
	TelemetryService:LogEvent(v7, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			productId = productId
		}
	})

	TelemetryService:LogCounter(v17, { standardizedFields = standardizedFields2, customFields = {} }, 1)
end

function PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(playWithRewardFlowId: string, universeId: string, action: string, productId: string)
	TelemetryService:LogEvent(v8, {
		standardizedFields = standardizedFields,
		customFields = {
			playWithRewardFlowId = playWithRewardFlowId,
			universeId = universeId,
			action = action,
			productId = productId
		}
	})
end

function PlayWithRewardTelemetry.logPlayWithRewardShimmerShown(playWithRewardFlowId: string, universeId: string)
	TelemetryService:LogEvent(v9, {
		standardizedFields = standardizedFields,
		customFields = { playWithRewardFlowId = playWithRewardFlowId, universeId = universeId }
	})
end

function PlayWithRewardTelemetry.logPlayWithRewardCoachmark(action: string, playWithRewardFlowId: string, universeId: string, productId: string)
	TelemetryService:LogEvent(v10, {
		standardizedFields = standardizedFields,
		customFields = getCoachmarkCustomFields(action, playWithRewardFlowId, universeId, productId) -- inferred equivalent call
	})

	TelemetryService:LogCounter(v18, {
		standardizedFields = standardizedFields2,
		customFields = { action = action }
	}, 1)
end

return PlayWithRewardTelemetry
