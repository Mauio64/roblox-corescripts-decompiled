local Analytics = require(script.Analytics)
local MediaSurfaceContext = require(script.Media.Components.MediaSurfaceContext)
require(script.Media.MediaTypes)

local CaptureKind = require(script.Enums.CaptureKind)
local FormFactor = require(script.Enums.FormFactor)
local LoadingState = require(script.Enums.LoadingState)
local MusicThumbnailIconSize = require(script.Enums.MusicThumbnailIconSize)
local ReactionSize = require(script.Enums.ReactionSize)
local ReactionType = require(script.Enums.ReactionType)

local GradientBackdrop = require(script.Components.GradientBackdrop)
local MusicThumbnailIcon = require(script.Components.MusicThumbnailIcon)
local Reaction = require(script.Components.Reaction.Reaction)
local ScrollingGridView = require(script.Components.ScrollingGridView)
local OverlayDisplay = require(script.Components.OverlayDisplay)
local TextOverlay = require(script.Components.TextOverlay)
local TextOverlayDisplay = require(script.Components.TextOverlayDisplay)
local StickerOverlay = require(script.Components.StickerOverlay)
local ReactionAssets = require(script.Components.Reaction.ReactionAssets)

local Performance = require(script.Performance)

local GetFFlagEnableMomentTextGeneration = require(script.Flags.GetFFlagEnableMomentTextGeneration)
local GetFFlagMomentsCreationSaveDraft = require(script.Flags.GetFFlagMomentsCreationSaveDraft)
local GetFFlagMomentsNonInfiniteScroll = require(script.Flags.GetFFlagMomentsNonInfiniteScroll)
local GetFFlagMomentsStickerButton = require(script.Flags.GetFFlagMomentsStickerButton)
local GetFFlagMomentsUseUploadPostAsync = require(script.Flags.GetFFlagMomentsUseUploadPostAsync)
local GetFFlagMomentsUseMomentsServiceForUpload = require(script.Flags.GetFFlagMomentsUseMomentsServiceForUpload)
return {
	Analytics = Analytics,
	canRenderNativeMoments = function(data)
		return data.isTabEnabled or data.isFlyoutEntryEnabled and data.platformIntegrationEnabled
	end,
	Flags = {
		GetFFlagEnableMomentTextGeneration = GetFFlagEnableMomentTextGeneration,
		GetFFlagMomentsCreationSaveDraft = GetFFlagMomentsCreationSaveDraft,
		GetFFlagMomentsNonInfiniteScroll = GetFFlagMomentsNonInfiniteScroll,
		GetFFlagMomentsStickerButton = GetFFlagMomentsStickerButton,
		FFlagMomentsFeedMediaLoadAttemptedEvent = require(script.Flags.FFlagMomentsFeedMediaLoadAttemptedEvent),
		FFlagMomentsVideoPermissionContextFix = require(script.Flags.FFlagMomentsVideoPermissionContextFix),
		FFlagMomentsEngagementMetricsFeature = require(script.Flags.FFlagMomentsEngagementMetricsFeature),
		FFlagMomentTextGenerationFilteredSignal = require(script.Flags.FFlagMomentTextGenerationFilteredSignal),
		FFlagMomentsCreationBackCta = require(script.Flags.FFlagMomentsCreationBackCta),
		FFlagMomentsTextOverlayV2Redesign = require(script.Flags.FFlagMomentsTextOverlayV2Redesign),
		FFlagMomentsSmartVideoFill = require(script.Flags.FFlagMomentsSmartVideoFill),
		FFlagMomentsAudioSaveButton = require(script.Flags.FFlagMomentsAudioSaveButton),
		FFlagMomentsTextOverlayChipGrowAboveKeyboard = require(script.Flags.FFlagMomentsTextOverlayChipGrowAboveKeyboard),
		FFlagMomentsTextOverlayEdgeClipFix = require(script.Flags.FFlagMomentsTextOverlayEdgeClipFix),
		GetFFlagMomentsUseUploadPostAsync = GetFFlagMomentsUseUploadPostAsync,
		GetFFlagMomentsUseMomentsServiceForUpload = GetFFlagMomentsUseMomentsServiceForUpload,
		GetFFlagMomentsCoachmarkPersistence = require(script.Flags.GetFFlagMomentsCoachmarkPersistence),
		GetFIntMomentsCoachmarkMaxImpressions = require(script.Flags.GetFIntMomentsCoachmarkMaxImpressions),
		GetFIntMomentsCoachmarkAutoDismissSeconds = require(script.Flags.GetFIntMomentsCoachmarkAutoDismissSeconds)
	},
	Components = {
		GradientBackdrop = GradientBackdrop,
		MusicThumbnailIcon = MusicThumbnailIcon,
		Reaction = Reaction,
		OverlayDisplay = OverlayDisplay,
		TextOverlay = TextOverlay,
		TextOverlayDisplay = TextOverlayDisplay,
		StickerOverlay = StickerOverlay,
		ReactionAssets = ReactionAssets
	},
	Enums = {
		CaptureKind = CaptureKind,
		FormFactor = FormFactor,
		LoadingState = LoadingState,
		MusicThumbnailIconSize = MusicThumbnailIconSize,
		ReactionSize = ReactionSize,
		ReactionType = ReactionType
	},
	Hooks = {
		useDeviceInsets = require(script.Hooks.useDeviceInsets),
		useFormFactor = require(script.Hooks.useFormFactor),
		useImageLoadingState = require(script.Hooks.useImageLoadingState),
		useIsMultiTouchActive = require(script.Hooks.useIsMultiTouchActive),
		useMomentsGating = function(...)
			local useMomentsGating = require(script.Hooks.useMomentsGating)
			return useMomentsGating(...)
		end,
		useScreenSize = require(script.Hooks.useScreenSize),
		useStatusBarHeight = require(script.Hooks.useStatusBarHeight),
		useTextOverlayPreviewGestures = require(script.Hooks.useTextOverlayPreviewGestures),
		useToggleState = require(script.Hooks.useToggleState)
	},
	ScrollingGridView = ScrollingGridView,
	Media = {
		createMediaPreloadCoordinator = require(script.Media.createMediaPreloadCoordinator),
		mediaTelemetry = require(script.Media.Telemetry.mediaTelemetry),
		selectPreloadPolicy = require(script.Media.Preload.selectPreloadPolicy),
		MediaPreloadProvider = require(script.Media.Components.MediaPreloadProvider),
		MediaSurfaceContext = MediaSurfaceContext,
		MomentMediaView = require(script.Media.Components.MomentMediaView),
		MomentMediaTile = require(script.Media.Components.MomentMediaTile),
		useMomentMediaController = require(script.Media.Components.useMomentMediaController),
		feedPlaybackSuspension = require(script.Media.feedPlaybackSuspension),
		reportModalCovering = require(script.Media.reportModalCovering),
		audioDuckingFastInts = require(script.Media.audioDuckingFastInts)
	},
	Performance = Performance,
	Stores = {
		GetMomentsCapabilities = require(script.Stores.GetMomentsCapabilities)
	},
	Utils = {
		clampOverlayPosition = require(script.Utils.clampOverlayPosition),
		clampTextOverlayPosition = require(script.Utils.clampOverlayPosition),
		getCropSize = require(script.Utils.getCropSize),
		getEasingNumberSequence = require(script.Utils.getEasingNumberSequence),
		getFitSize = require(script.Utils.getFitSize),
		getScale = require(script.Utils.getScale),
		getSmartFillScaleType = require(script.Utils.getSmartFillScaleType),
		isStudio = require(script.Utils.isStudio),
		logMomentsLayerExposure = require(script.Utils.logMomentsLayerExposure),
		Oklab = require(script.Utils.Oklab)
	},
	["jest.config"] = script["jest.config"]
}
