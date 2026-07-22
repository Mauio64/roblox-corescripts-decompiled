local Analytics = require(script.Analytics)

require(script.Media.MediaTypes)

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
local Performance = require(script.Performance)
local ArgusExperiment = require(script.Flags.ArgusExperiment)
local GetFFlagMomentsAnalyticsProducerPrereqs = require(script.Flags.GetFFlagMomentsAnalyticsProducerPrereqs)
local GetFFlagMomentsStickerButton = require(script.Flags.GetFFlagMomentsStickerButton)
local GetFFlagMomentsAnalyticsSchemaIdentity = require(script.Flags.GetFFlagMomentsAnalyticsSchemaIdentity)
local FFlagMomentsFeedHealthAnalytics = require(script.Flags.FFlagMomentsFeedHealthAnalytics)
local t1 = {
	useDeviceInsets = require(script.Hooks.useDeviceInsets),
	useFormFactor = require(script.Hooks.useFormFactor),
	useImageLoadingState = require(script.Hooks.useImageLoadingState),
	useMomentsGating = function(...) -- line: 71
		return require(script.Hooks.useMomentsGating)(...)
	end,
	useScreenSize = require(script.Hooks.useScreenSize),
	useStatusBarHeight = require(script.Hooks.useStatusBarHeight),
	useToggleState = require(script.Hooks.useToggleState)
}

return {
	Analytics = Analytics,
	Flags = {
		ArgusExperiment = ArgusExperiment,
		GetFFlagMomentsAnalyticsProducerPrereqs = GetFFlagMomentsAnalyticsProducerPrereqs,
		GetFFlagMomentsStickerButton = GetFFlagMomentsStickerButton,
		GetFFlagMomentsAnalyticsSchemaIdentity = GetFFlagMomentsAnalyticsSchemaIdentity,
		FFlagMomentsFeedHealthAnalytics = FFlagMomentsFeedHealthAnalytics
	},
	Components = {
		GradientBackdrop = GradientBackdrop,
		MusicThumbnailIcon = MusicThumbnailIcon,
		Reaction = Reaction,
		OverlayDisplay = OverlayDisplay,
		TextOverlay = TextOverlay,
		TextOverlayDisplay = TextOverlayDisplay
	},
	Enums = {
		FormFactor = FormFactor,
		LoadingState = LoadingState,
		MusicThumbnailIconSize = MusicThumbnailIconSize,
		ReactionSize = ReactionSize,
		ReactionType = ReactionType
	},
	Hooks = t1,
	ScrollingGridView = ScrollingGridView,
	Media = {
		createMediaPreloadCoordinator = require(script.Media.createMediaPreloadCoordinator),
		mediaTelemetry = require(script.Media.Telemetry.mediaTelemetry),
		selectPreloadPolicy = require(script.Media.Preload.selectPreloadPolicy),
		MediaPreloadProvider = require(script.Media.Components.MediaPreloadProvider),
		MomentMediaView = require(script.Media.Components.MomentMediaView),
		MomentMediaTile = require(script.Media.Components.MomentMediaTile),
		useMomentMediaController = require(script.Media.Components.useMomentMediaController),
		feedPlaybackSuspension = require(script.Media.feedPlaybackSuspension)
	},
	Performance = Performance,
	Utils = {
		clampOverlayPosition = require(script.Utils.clampOverlayPosition),
		clampTextOverlayPosition = require(script.Utils.clampOverlayPosition),
		getCropSize = require(script.Utils.getCropSize),
		getEasingNumberSequence = require(script.Utils.getEasingNumberSequence),
		getFitSize = require(script.Utils.getFitSize),
		getScale = require(script.Utils.getScale),
		isStudio = require(script.Utils.isStudio),
		Oklab = require(script.Utils.Oklab)
	},
	["jest.config"] = script["jest.config"]
}
