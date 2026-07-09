local TextKeys = require(script.Parent.TextKeys)

return {
	APP_STORAGE_VALUE = "true",
	PAGE_MAX_CONTENT_WIDTH = 440,
	FeatureAvailable = {
		APP_STORAGE_KEY = "SchoolEntryTooltipSeen",
		ENGINE_FEATURE_NAME = "SchoolEntryTooltipSeenStorageKey",
		TITLE = TextKeys.FeatureAvailableTooltipTitle,
		BODY = TextKeys.FeatureAvailableTooltipBody
	},
	SchoolIsLive = {
		APP_STORAGE_KEY = "SchoolEntryLiveTooltipSeen",
		ENGINE_FEATURE_NAME = "SchoolEntryLiveTooltipSeenStorageKey",
		TITLE = TextKeys.SchoolIsLiveTooltipTitle,
		BODY = TextKeys.SchoolIsLiveTooltipBody
	},
	Waitlist = {
		MAX_CONTENT_WIDTH = 576,
		DIMMED_GROUP_TRANSPARENCY = 0.7,
		MEDIA_WIDTH = 100,
		MEDIA_HEIGHT = 100
	}
}
