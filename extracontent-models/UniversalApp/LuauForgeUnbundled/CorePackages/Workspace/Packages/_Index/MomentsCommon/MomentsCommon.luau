local module = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MediaSurfaceContext")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/CaptureKind")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/FormFactor")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/MusicThumbnailIconSize")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionSize")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionType")

local module9 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/GradientBackdrop")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/MusicThumbnailIcon")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/Reaction")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/ScrollingGridView")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/OverlayDisplay")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/TextOverlay")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/TextOverlayDisplay")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/StickerOverlay")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/ReactionAssets")

local module18 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Performance")

local module19 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagEnableMomentTextGeneration")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsCreationSaveDraft")
local module21 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsNonInfiniteScroll")
local module22 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsStickerButton")
local module23 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsUseUploadPostAsync")
local module24 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsUseMomentsServiceForUpload")
local module25 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsFeedMediaLoadAttemptedEvent")
local module26 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsVideoPermissionContextFix")
local module27 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsEngagementMetricsFeature")
local module28 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentTextGenerationFilteredSignal")
local module29 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsCreationBackCta")
local module30 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayV2Redesign")
local module31 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsSmartVideoFill")
local module32 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsAudioSaveButton")
local module33 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsParentTimeLimit")
local module34 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayChipGrowAboveKeyboard")
local module35 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayEdgeClipFix")
local module36 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsCoachmarkPersistence")
local module37 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFIntMomentsCoachmarkMaxImpressions")
local module38 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFIntMomentsCoachmarkAutoDismissSeconds")

local function useMomentsGating(...)
	return require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useMomentsGating")(...)
end

return {
	Analytics = module,
	canRenderNativeMoments = function(data)
		return data.isTabEnabled or data.isFlyoutEntryEnabled and data.platformIntegrationEnabled
	end,
	Flags = {
		GetFFlagEnableMomentTextGeneration = module19,
		GetFFlagMomentsCreationSaveDraft = module20,
		GetFFlagMomentsNonInfiniteScroll = module21,
		GetFFlagMomentsStickerButton = module22,
		FFlagMomentsFeedMediaLoadAttemptedEvent = module25,
		FFlagMomentsVideoPermissionContextFix = module26,
		FFlagMomentsEngagementMetricsFeature = module27,
		FFlagMomentTextGenerationFilteredSignal = module28,
		FFlagMomentsCreationBackCta = module29,
		FFlagMomentsTextOverlayV2Redesign = module30,
		FFlagMomentsSmartVideoFill = module31,
		FFlagMomentsAudioSaveButton = module32,
		FFlagMomentsParentTimeLimit = module33,
		FFlagMomentsTextOverlayChipGrowAboveKeyboard = module34,
		FFlagMomentsTextOverlayEdgeClipFix = module35,
		GetFFlagMomentsUseUploadPostAsync = module23,
		GetFFlagMomentsUseMomentsServiceForUpload = module24,
		GetFFlagMomentsCoachmarkPersistence = module36,
		GetFIntMomentsCoachmarkMaxImpressions = module37,
		GetFIntMomentsCoachmarkAutoDismissSeconds = module38
	},
	Components = {
		GradientBackdrop = module9,
		MusicThumbnailIcon = module10,
		Reaction = module11,
		OverlayDisplay = module13,
		TextOverlay = module14,
		TextOverlayDisplay = module15,
		StickerOverlay = module16,
		ReactionAssets = module17
	},
	Enums = {
		CaptureKind = module3,
		FormFactor = module4,
		LoadingState = module5,
		MusicThumbnailIconSize = module6,
		ReactionSize = module7,
		ReactionType = module8
	},
	Hooks = {
		useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useDeviceInsets"),
		useFormFactor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useFormFactor"),
		useImageLoadingState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useImageLoadingState"),
		useIsMultiTouchActive = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useIsMultiTouchActive"),
		useMomentsGating = useMomentsGating,
		useScreenSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useScreenSize"),
		useStatusBarHeight = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useStatusBarHeight"),
		useTextOverlayPreviewGestures = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useTextOverlayPreviewGestures"),
		useToggleState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useToggleState")
	},
	ScrollingGridView = module12,
	Media = {
		createMediaPreloadCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/createMediaPreloadCoordinator"),
		mediaTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Telemetry/mediaTelemetry"),
		selectPreloadPolicy = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/selectPreloadPolicy"),
		MediaPreloadProvider = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MediaPreloadProvider"),
		MediaSurfaceContext = module2,
		MomentMediaView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MomentMediaView"),
		MomentMediaTile = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MomentMediaTile"),
		useMomentMediaController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/useMomentMediaController"),
		feedPlaybackSuspension = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/feedPlaybackSuspension"),
		reportModalCovering = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/reportModalCovering"),
		audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/audioDuckingFastInts")
	},
	Performance = module18,
	Stores = { GetMomentsCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Stores/GetMomentsCapabilities") },
	Utils = {
		clampOverlayPosition = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/clampOverlayPosition"),
		clampTextOverlayPosition = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/clampOverlayPosition"),
		getCropSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getCropSize"),
		getEasingNumberSequence = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getEasingNumberSequence"),
		getFitSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getFitSize"),
		getScale = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getScale"),
		getSmartFillScaleType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getSmartFillScaleType"),
		isStudio = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/isStudio"),
		logMomentsLayerExposure = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/logMomentsLayerExposure"),
		Oklab = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/Oklab")
	}
}
