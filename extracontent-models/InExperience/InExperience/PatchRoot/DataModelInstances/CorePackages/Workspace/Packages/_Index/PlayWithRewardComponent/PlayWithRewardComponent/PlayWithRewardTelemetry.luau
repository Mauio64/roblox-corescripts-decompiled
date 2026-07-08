local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	"addOSInfo",
	"addSessionInfo",
	"addSessionId"
}
local t2 = { "addOSInfo" }
local t3 = {
	eventName = "PlayWithRewardAdRequested",
	description = "        This is fired when a Play with Reward ad is requested.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdRequestedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t4 = {
	eventName = "PlayWithRewardAdReceived",
	description = "        This is fired when a Play with Reward ad is received.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdReceivedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t5 = {
	eventName = "PlayWithRewardBannerShown",
	description = "        This is fired when a Play with Reward banner is shown on an EDP.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardBannerShownTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		4,
		27
	}
}
local t6 = {
	eventName = "PlayWithRewardButtonClicked",
	description = "        This is fired when a Play with Reward button is clicked on an EDP.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardButtonClickedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t7 = {
	eventName = "PlayWithRewardAdPlaybackAttempted",
	description = "        This is fired when a Play with Reward ad starts playing.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdPlaybackAttemptedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t8 = {
	eventName = "PlayWithRewardAdPlaybackStopped",
	description = "        This is fired when a Play with Reward ad stops playing.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardAdPlaybackStoppedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t9 = {
	eventName = "PlayWithRewardGameJoinInitiated",
	description = "        This is fired when a Play with Reward game join is initiated from an EDP.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardGameJoinInitiatedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		25,
		9,
		24
	}
}
local t10 = {
	eventName = "PlayWithRewardBlackoutCurtain",
	description = "        This is fired when the Play with Reward blackout curtain state changes (shown or hidden).\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardBlackoutCurtainTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		4,
		3
	}
}
local t11 = {
	eventName = "PlayWithRewardShimmerShown",
	description = "        This is fired when the Play with Reward shimmer is shown.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardShimmerShownTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		4,
		28
	}
}
local t12 = {
	eventName = "PlayWithRewardCoachmark",
	description = "        This is fired when a Play with Reward coachmark is shown or dismissed on an EDP.\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("PlayWithRewardCoachmarkTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		4,
		21
	}
}
local t13 = {
	eventName = "PlayWithRewardAdRequestedCounter",
	description = "\t        Counter for PlayWithRewardAdRequested events.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t14 = {
	eventName = "PlayWithRewardAdReceivedCounter",
	description = "\t        Counter for PlayWithRewardAdReceived events with status.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t15 = {
	eventName = "PlayWithRewardBannerShownCounter",
	description = "\t        Counter for PlayWithRewardBannerShown events.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		4,
		27
	}
}
local t16 = {
	eventName = "PlayWithRewardButtonClickedCounter",
	description = "\t        Counter for PlayWithRewardButtonClicked events.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t17 = {
	eventName = "PlayWithRewardAdPlaybackAttemptedCounter",
	description = "\t        Counter for PlayWithRewardAdPlaybackAttempted events.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t18 = {
	eventName = "PlayWithRewardAdPlaybackStoppedCounter",
	description = "\t        Counter for PlayWithRewardAdPlaybackStopped events with status.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t19 = {
	eventName = "PlayWithRewardGameJoinInitiatedCounter",
	description = "\t        Counter for PlayWithRewardGameJoinInitiated events.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t20 = {
	eventName = "PlayWithRewardCoachmarkCounter",
	description = "\t        Counter for PlayWithRewardCoachmark events, split by action.\n\t    ",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		4,
		21
	}
}
local t21 = {
	eventName = "PlayWithRewardAdReceivedSuccessfully",
	description = "\t        Stats for successful PlayWithRewardAdReceived events.\n\t    ",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		25,
		9,
		24
	}
}
local t22 = {}

local function getCoachmarkCustomFields(s1: string, s2: string, s3: string, s4: string) -- line: 237
	return {
		action = s1,
		playWithRewardFlowId = s2,
		universeId = s3,
		productId = s4
	}
end

function t22.logPlayWithRewardAdRequested(s5: string, s6: string) -- line: 246
	-- upvalues: TelemetryService (copy), t3 (copy), t1 (copy), t13 (copy), t2 (copy)
	local t23 = {
		playWithRewardFlowId = s5,
		universeId = s6
	}

	TelemetryService:LogEvent(t3, {
		standardizedFields = t1,
		customFields = t23
	})
	TelemetryService:LogCounter(t13, {
		standardizedFields = t2,
		customFields = {}
	}, 1)
end
function t22.logPlayWithRewardAdReceived(s7: string, s8: string, b1: boolean, s9: string?, n1: number, s10: string?) -- line: 266
	-- upvalues: TelemetryService (copy), t4 (copy), t1 (copy), t14 (copy), t2 (copy), t21 (copy)
	local t24 = {
		playWithRewardFlowId = s7,
		universeId = s8,
		isSuccessful = b1,
		adAvailabilityResult = s9,
		fetchLatencyMs = n1,
		productId = s10
	}

	TelemetryService:LogEvent(t4, {
		standardizedFields = t1,
		customFields = t24
	})
	TelemetryService:LogCounter(t14, {
		standardizedFields = t2,
		customFields = {
			isSuccessful = b1,
			adAvailabilityResult = s9
		}
	}, 1)

	if b1 then
		TelemetryService:LogStat(t21, {
			standardizedFields = t2,
			customFields = {
				adAvailabilityResult = s9
			}
		}, n1)
	end
end
function t22.logPlayWithRewardBannerShown(s11: string, s12: string, s13: string, s14: string, s15: string) -- line: 309
	-- upvalues: TelemetryService (copy), t5 (copy), t1 (copy), t15 (copy), t2 (copy)
	local t25 = {
		playWithRewardFlowId = s11,
		universeId = s12,
		showState = s13,
		productId = s14,
		experimentUiVariant = s15
	}

	TelemetryService:LogEvent(t5, {
		standardizedFields = t1,
		customFields = t25
	})
	TelemetryService:LogCounter(t15, {
		standardizedFields = t2,
		customFields = {}
	}, 1)
end
function t22.logPlayWithRewardButtonClicked(s16: string, s17: string, s18: string) -- line: 338
	-- upvalues: TelemetryService (copy), t6 (copy), t1 (copy), t16 (copy), t2 (copy)
	local t26 = {
		playWithRewardFlowId = s16,
		universeId = s17,
		productId = s18
	}

	TelemetryService:LogEvent(t6, {
		standardizedFields = t1,
		customFields = t26
	})
	TelemetryService:LogCounter(t16, {
		standardizedFields = t2,
		customFields = {}
	}, 1)
end
function t22.logPlayWithRewardAdPlaybackAttempted(s19: string, s20: string, s21: string) -- line: 359
	-- upvalues: TelemetryService (copy), t7 (copy), t1 (copy), t17 (copy), t2 (copy)
	local t27 = {
		playWithRewardFlowId = s19,
		universeId = s20,
		productId = s21
	}

	TelemetryService:LogEvent(t7, {
		standardizedFields = t1,
		customFields = t27
	})
	TelemetryService:LogCounter(t17, {
		standardizedFields = t2,
		customFields = {}
	}, 1)
end
function t22.logPlayWithRewardAdPlaybackStopped(s22: string, s23: string, s24: string, s25: string) -- line: 384
	-- upvalues: TelemetryService (copy), t8 (copy), t1 (copy), t18 (copy), t2 (copy)
	local t28 = {
		playWithRewardFlowId = s22,
		universeId = s23,
		adPlaybackStatus = s24,
		productId = s25
	}

	TelemetryService:LogEvent(t8, {
		standardizedFields = t1,
		customFields = t28
	})
	TelemetryService:LogCounter(t18, {
		standardizedFields = t2,
		customFields = {
			adPlaybackStatus = s24
		}
	}, 1)
end
function t22.logPlayWithRewardGameJoinInitiated(s26: string, s27: string, s28: string) -- line: 411
	-- upvalues: TelemetryService (copy), t9 (copy), t1 (copy), t19 (copy), t2 (copy)
	local t29 = {
		playWithRewardFlowId = s26,
		universeId = s27,
		productId = s28
	}

	TelemetryService:LogEvent(t9, {
		standardizedFields = t1,
		customFields = t29
	})
	TelemetryService:LogCounter(t19, {
		standardizedFields = t2,
		customFields = {}
	}, 1)
end
function t22.logPlayWithRewardBlackoutCurtainAction(s29: string, s30: string, s31: string, s32: string) -- line: 436
	-- upvalues: TelemetryService (copy), t10 (copy), t1 (copy)
	local t30 = {
		playWithRewardFlowId = s29,
		universeId = s30,
		action = s31,
		productId = s32
	}

	TelemetryService:LogEvent(t10, {
		standardizedFields = t1,
		customFields = t30
	})
end
function t22.logPlayWithRewardShimmerShown(s33: string, s34: string) -- line: 455
	-- upvalues: TelemetryService (copy), t11 (copy), t1 (copy)
	local t31 = {
		playWithRewardFlowId = s33,
		universeId = s34
	}

	TelemetryService:LogEvent(t11, {
		standardizedFields = t1,
		customFields = t31
	})
end
function t22.logPlayWithRewardCoachmark(s35: string, s36: string, s37: string, s38: string) -- line: 467
	-- upvalues: TelemetryService (copy), t12 (copy), t1 (copy), t20 (copy), t2 (copy)
	local t32 = {
		action = s35,
		playWithRewardFlowId = s36,
		universeId = s37,
		productId = s38
	}

	TelemetryService:LogEvent(t12, {
		standardizedFields = t1,
		customFields = t32
	})
	TelemetryService:LogCounter(t20, {
		standardizedFields = t2,
		customFields = {
			action = s35
		}
	}, 1)
end

return t22
