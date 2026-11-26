local module = require("@luauforge/deferred/ekv")

return {
	APP_STORAGE_VALUE = "true",
	FeatureAvailable = {
		APP_STORAGE_KEY = "SchoolEntryTooltipSeen",
		ENGINE_FEATURE_NAME = "SchoolEntryTooltipSeenStorageKey",
		TITLE = module.FeatureAvailableTooltipTitle,
		BODY = module.FeatureAvailableTooltipBody
	},
	SchoolIsLive = {
		APP_STORAGE_KEY = "SchoolEntryLiveTooltipSeen",
		ENGINE_FEATURE_NAME = "SchoolEntryLiveTooltipSeenStorageKey",
		TITLE = module.SchoolIsLiveTooltipTitle,
		BODY = module.SchoolIsLiveTooltipBody
	},
	SchoolRewardDialog = {
		APP_STORAGE_KEY = "SchoolRewardDialogSeen",
		ENGINE_FEATURE_NAME = "SchoolRewardDialogSeenStorageKey",
		HERO_HEIGHT = 180
	},
	Waitlist = {
		MAX_CONTENT_WIDTH = 576,
		DIMMED_GROUP_TRANSPARENCY = 0.7,
		MIN_HEIGHT = 132,
		MEDIA_ASPECT_RATIO = 0.8,
		ALUMNI_PICTOGRAM_WIDTH = 268,
		ALUMNI_PICTOGRAM_HEIGHT = 151,
		ALUMNI_PICTOGRAM_OFFSET_X = -75,
		ALUMNI_PICTOGRAM_OFFSET_Y = -10,
		SHARE_BUTTON_MIN_WIDTH = 68
	},
	PAGE_MAX_CONTENT_WIDTH = 440,
	MemberList = {
		ALL_YEARS = "allYears",
		PAGE_LIMIT = 25,
		EmptyState = {
			ASSET_KEY = "pictograms/collaborators",
			IMAGE_HEIGHT = 180,
			IMAGE_WIDTH = 320
		}
	},
	Analytics = { WIRE_EVENT_NAME = "SchoolsInteraction" }
}
