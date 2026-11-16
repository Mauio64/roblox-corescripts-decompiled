local frozen = table.freeze({
	InExperience = "InExperience",
	DeferredJoin = "DeferredJoin"
})

local frozen2 = table.freeze({
	TiltLoadingScreen = "TiltLoadingScreen",
	LoadingScreenView = "LoadingScreenView"
})

local frozen3 = table.freeze({
	Cancelled = "cancelled",
	VRHandoff = "vr_handoff",
	Unmounted = "unmounted",
	Replaced = "replaced",
	InitializationFailed = "initialization_failed"
})

local frozen4 = table.freeze({
	Completed = "completed",
	InstrumentationError = "instrumentation_error"
})

local frozen5 = table.freeze({
	NormalReady = "NormalReady",
	DeveloperOverride = "DeveloperOverride"
})

local frozen6 = table.freeze({
	Title = "Title",
	Creator = "Creator",
	Thumbnail = "Thumbnail"
})

local frozen7 = table.freeze({
	ScreenVisible = "ScreenVisible",
	ContentVisible = "ContentVisible",
	DismissRequested = "DismissRequested",
	DismissGateReleased = "DismissGateReleased",
	DismissStarted = "DismissStarted",
	ScreenHidden = "ScreenHidden"
})

return table.freeze({
	Host = frozen,
	Page = frozen2,
	DismissSource = frozen5,
	ContentId = frozen6,
	Milestone = frozen7,
	AbortReason = frozen3,
	Outcome = frozen4,
	CATEGORY = "ExperienceLoading",
	EVENT_NAME = "ExperienceLoadingScreen"
})
