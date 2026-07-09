local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withStyle = UIBlox.Core.Style.withStyle
local t = require(CorePackages.Packages.t)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local UiMode = RobloxAppEnums.UiMode
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local VideoPlaybackCoordinator = require(CorePackages.Workspace.Packages.VideoUtils).VideoPlaybackCoordinator
local AppBlox = require(CorePackages.Workspace.Packages.AppBlox)
local MediaGalleryPreview = AppBlox.MediaGalleryPreview
local MediaGalleryCarousel = AppBlox.MediaGalleryCarousel
local MediaGalleryFullScreen = AppBlox.MediaGalleryFullScreen
local CrossFadeAnimatedView = AppBlox.CrossFadeAnimatedView
local MediaGalleryExpandableView = AppBlox.MediaGalleryExpandableView
local calcMediaGallerySizesFromWidth = AppBlox.calcMediaGallerySizesFromWidth
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OpenYouTubeVideo = require(Modules.LuaApp.Thunks.OpenYouTubeVideo)
local openYouTubeVideoEvent = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.openYouTubeVideoEvent
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local OnNavigateBackWrapper = require(CorePackages.Workspace.Packages.SduiSharedUtilities).OnNavigateBackWrapper
local MediaGallerySnapping = require(Modules.LuaApp.Components.ExperienceDetails.MediaGallerySnapping)
local MediaGallerySnappingFull = require(Modules.LuaApp.Components.ExperienceDetails.MediaGallerySnappingFull)
local useSelectedGameMediaEntries = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useSelectedGameMediaEntries)
local useMediaGalleryVideoAnalytics = require(CorePackages.Workspace.Packages.MediaGallery).useMediaGalleryVideoAnalytics
local FFlagExperienceDetailsTextUseTokens = require(script.Parent.Flags.FFlagExperienceDetailsTextUseTokens)
local FFlagEDPMediaAddLocalization10ft = require(script.Parent.Flags.FFlagEDPMediaAddLocalization10ft)
local GetFFlagConsoleApplyTokenizationEdp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagConsoleApplyTokenizationEdp
local FFlagLuaAppDesktopMediaGalleryTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDesktopMediaGalleryTelemetry
local FFlagLuaAppEdpMediaGalleryRedesign = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesign
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpMediaGalleryFullScreen = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpMediaGalleryHeightJitterFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryHeightJitterFix
local _ = {
	view = "view",
	play = "play"
}
local v54 = Roact.PureComponent:extend("ExperienceMediaGallery")

v54.validateProps = t.interface({
	universeId = t.string,
	startIndex = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t.optional(t.number),
	isFullscreen = t.optional(t.boolean),
	fullscreenShowIndex = t.optional(t.integer),
	onPreviewActivated = t.optional(t.callback),
	onThumbnailActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry then nil else t.optional(t.callback),
	deviceType = t.optional(t.string),
	tokens = t.optional(t.table),
	showYouTubeVideoFirst = t.optional(t.boolean),
	onSwipe = t.optional(t.callback),
	onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	initialWidth = if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else t.optional(t.number),
	isOccluded = if not FFlagLuaAppEdpMediaGalleryFullScreen or not FFlagLuaAppEdpMediaGalleryAutoAdvance and not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t.optional(t.boolean),
	uiMode = t.optional(t.string),
	isFullscreenState = t.optional(t.boolean),
	onSelectionGained = t.optional(t.callback),
	mediaGalleryGainFocused = t.optional(t.callback),
	expandableAreaHeightOffset = t.optional(t.number),
	nextIndex = t.optional(t.number),
	isCrossFade = t.optional(t.boolean),
	currentIndex = t.optional(t.number),
	setCurrentIndex = t.optional(t.callback),
	setCrossFade = t.optional(t.callback),
	exitFullscreen = t.optional(t.callback),
	selectedGameMediaEntries = t.optional(t.table),
	videoAnalytics = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t.optional(t.table),
	placeId = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t.optional(t.string),
	mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else t.optional(t.boolean),
	mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else t.optional(t.boolean),
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean)
})
v54.defaultProps = {
	isFullscreen = false,
	fullscreenShowIndex = 1,
	showYouTubeVideoFirst = true,
	isFullscreenState = false,
	nextIndex = 1,
	expandableAreaHeightOffset = not GetFFlagConsoleApplyTokenizationEdp() and 592 or nil
}

function v54.init(p1) -- line: 142
	-- upvalues: Roact (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), VideoPlaybackCoordinator (copy), calcMediaGallerySizesFromWidth (copy), memoize (copy), Cryo (copy), GameMediaImageType (copy), UiMode (copy), openYouTubeVideoEvent (copy)
	local v59, v60 = Roact.createBinding(0)

	p1.containerHeight = v59
	p1.updateContainerHeight = v60
	p1.containerSize = p1.containerHeight:map(function(p2) -- line: 144
		return UDim2.new(1, 0, 0, p2)
	end)
	p1.mediaGalleryVideoPreviewEnabled = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp or p1.props.mediaGalleryVideoPreviewEnabledIxp
	p1.videoPlaybackCoordinator = if not FFlagLuaAppEdpMediaGalleryVideoPreview or not p1.mediaGalleryVideoPreviewEnabled then nil else VideoPlaybackCoordinator.new()

	function p1.onResize(p3) -- line: 157
		-- upvalues: calcMediaGallerySizesFromWidth (copy), p1 (copy)
		local AbsoluteSizeX = p3.AbsoluteSize.X
		local YOffset = calcMediaGallerySizesFromWidth(AbsoluteSizeX, 5).contentSize.Y.Offset

		if YOffset ~= p1.containerHeight:getValue() then
			p1.updateContainerHeight(YOffset)
		end
	end

	p1.getItemsFromEntries = memoize(function(p4) -- line: 166
		-- upvalues: Cryo (copy), GameMediaImageType (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), p1 (copy)
		return Cryo.List.map(p4, function(p5) -- line: 167
			-- upvalues: GameMediaImageType (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), p1 (copy)
			return {
				imageId = p5.imageId,
				isYouTubeVideo = p5.mediaType == GameMediaImageType.YouTubeVideo,
				videoId = if not FFlagLuaAppEdpMediaGalleryVideoPreview or not p1.mediaGalleryVideoPreviewEnabled then nil else p5.videoId
			}
		end)
	end)

	function p1.performOpenYouTubeVideo(p6, p7) -- line: 178
		-- upvalues: p1 (copy)
		local guiService = p1.props.guiService
		local openYouTubeVideo = p1.props.openYouTubeVideo
		local eventIngest = p1.props.eventIngest
		local universeId = p1.props.universeId
		local youTubeVideoHash = p6.youTubeVideoHash
		local youTubeVideoTitle = p6.youTubeVideoTitle

		if youTubeVideoHash and (#youTubeVideoHash > 0 and youTubeVideoTitle and #youTubeVideoTitle > 0) then
			openYouTubeVideo(guiService, youTubeVideoHash, youTubeVideoTitle, p7, eventIngest, universeId, "play")
		end
	end
	function p1.openYouTubeVideoItem(p8) -- line: 199
		-- upvalues: p1 (copy)
		local openLeaveRobloxAlertUIBlox = p1.props.openLeaveRobloxAlertUIBlox
		local showYouTubeAgeAlert = p1.props.showYouTubeAgeAlert
		local v100 = p1.props.selectedGameMediaEntries[p8]

		if showYouTubeAgeAlert then
			openLeaveRobloxAlertUIBlox(function() -- line: 205
				-- upvalues: p1 (copy), v100 (copy)
				p1.performOpenYouTubeVideo(v100, "gameDetailsAccordianImage")
			end)

			return
		end

		p1.performOpenYouTubeVideo(v100, "gameDetailsAccordianImage")
	end

	if p1.props.uiMode == UiMode.TenFoot then
		p1.getConsoleItemsFromEntries = memoize(function(p9) -- line: 217
			-- upvalues: Cryo (copy), GameMediaImageType (copy)
			return Cryo.List.filter(p9, function(p10) -- line: 218
				-- upvalues: GameMediaImageType (copy)
				return p10.mediaType ~= GameMediaImageType.YouTubeVideo
			end)
		end)
	end

	function p1.logMediaItemsContainYouTubeVideo(s1: string) -- line: 224
		-- upvalues: p1 (copy), UiMode (copy), Cryo (copy), GameMediaImageType (copy), openYouTubeVideoEvent (copy)
		local eventIngest = p1.props.eventIngest
		local universeId = p1.props.universeId
		local v105 = if p1.props.uiMode ~= UiMode.TenFoot then p1.props.selectedGameMediaEntries else {}
		local v106 = Cryo.List.filter(v105, function(p11) -- line: 230
			-- upvalues: GameMediaImageType (copy)
			return p11.mediaType == GameMediaImageType.YouTubeVideo
		end)[1]

		if v106 then
			openYouTubeVideoEvent(eventIngest, s1, v106.youTubeVideoTitle, v106.youTubeVideoHash, universeId, "view")
		end
	end

	if not p1.props.isFullScreen then
		p1.logMediaItemsContainYouTubeVideo("gameDetailsAccordianImage")
	end
end
function v54.didUpdate(p12, p13, _) -- line: 251
	-- upvalues: Cryo (copy)
	if not p12.props.isFullScreen and not Cryo.List.equals(p13.selectedGameMediaEntries, p12.props.selectedGameMediaEntries) then
		p12.logMediaItemsContainYouTubeVideo("gameDetailsAccordianImage")
	end
end
function v54.renderWithLocalization(p15, p16) -- line: 260
	-- upvalues: UiMode (copy)
	local selectedGameMediaEntries = p15.props.selectedGameMediaEntries
	local v67 = if p15.props.uiMode ~= UiMode.TenFoot then p15.getItemsFromEntries(selectedGameMediaEntries) else p15.getConsoleItemsFromEntries(selectedGameMediaEntries)

	if #v67 <= 0 then
		return nil
	end

	return p15.props.isFullscreen and p15:renderFullscreen(v67) or p15:renderPreview(v67, p16)
end
function v54.render(p17) -- line: 274
	-- upvalues: FFlagEDPMediaAddLocalization10ft (copy), withLocalization (copy)
	if FFlagEDPMediaAddLocalization10ft then
		return withLocalization({
			titleText = "Feature.GameDetails.Heading.Media"
		})(function(p18) -- line: 278
			-- upvalues: p17 (copy)
			return p17:renderWithLocalization(p18)
		end)
	end

	return p17:renderWithLocalization()
end
function v54.renderPreview(p19, p20, p21) -- line: 286
	-- upvalues: FFlagLuaAppEdpMediaGalleryRedesign (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), DeviceType (copy), Roact (copy), MediaGalleryCarousel (copy), MediaGallerySnapping (copy), FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), UiMode (copy), CursorKind (copy), GetFFlagConsoleApplyTokenizationEdp (copy), withStyle (copy), OnNavigateBackWrapper (copy), MediaGalleryExpandableView (copy), FFlagEDPMediaAddLocalization10ft (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), MediaGalleryPreview (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy)
	local v72 = nil

	if FFlagLuaAppEdpMediaGalleryRedesign then
		v72 = not FFlagLuaAppEdpMediaGalleryRedesignIxp or p19.props.mediaGalleryRedesignEnabledIxp
	end

	if p19.props.deviceType == DeviceType.Tablet and (not FFlagLuaAppEdpMediaGalleryRedesign or not v72) then
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 100),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			[Roact.Change.AbsoluteSize] = p19.onResize
		}, {
			MediaGalleryCarousel = Roact.createElement(MediaGalleryCarousel, {
				items = p20,
				onPreviewActivated = p19.props.onPreviewActivated,
				onVideoPlayActivated = p19.openYouTubeVideoItem
			})
		})
	end

	if p19.props.deviceType == DeviceType.Phone and (not FFlagLuaAppEdpMediaGalleryRedesign or not v72) then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			MediaGallerySnapping = Roact.createElement(MediaGallerySnapping, {
				itemPadding = 8,
				showCounter = false,
				items = p20,
				initialWidth = if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else p19.props.initialWidth,
				borderRadius = UDim.new(0, 8),
				onSwipe = p19.props.onSwipe,
				onVideoPlayActivated = p19.openYouTubeVideoItem
			})
		})
	end

	if p19.props.uiMode == UiMode.TenFoot then
		local u73 = if not p19.props.isFullscreenState then CursorKind.RoundedRect else CursorKind.Invisible
		local v74 = if not GetFFlagConsoleApplyTokenizationEdp() or not p19.props.tokens then p19.props.expandableAreaHeightOffset else p19.props.tokens.expandableAreaHeightOffset

		return withStyle(function(p22) -- line: 343
			-- upvalues: Roact (copy), OnNavigateBackWrapper (copy), p19 (copy), MediaGalleryExpandableView (copy), p20 (copy), FFlagEDPMediaAddLocalization10ft (copy), p21 (copy), u73 (ref), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v74 (copy)
			return Roact.createElement(OnNavigateBackWrapper, {
				onNavigateBack = p19.props.exitFullscreen
			}, Roact.createElement(MediaGalleryExpandableView, {
				groupTransparency = 0,
				items = p20,
				titleText = if not FFlagEDPMediaAddLocalization10ft or not p21 then nil else p21.titleText,
				showCursor = not p19.props.isFullscreenState,
				selectionCursor = u73,
				styleProps = if not FFlagExperienceDetailsTextUseTokens then nil else {
					titleFont = if not FFlagRenameDeprecatedUIBloxTokens then p22.Tokens.Semantic.Typography.Header else p22.Tokens.Typography.HeadingSmall
				},
				exitFullscreen = not p19.props.isFullscreenState and function() -- line: 361
				end or p19.props.exitFullscreen,
				onActivated = p19.props.onPreviewActivated,
				onSelectionGained = function(p23) -- line: 363
					-- upvalues: p20 (copy), p19 (copy)
					local s2 = ""

					if p20[p23] then
						s2 = string.split(p20[p23].imageId, "=")[2]
					end

					p19.props.onSelectionGained(p23, s2)
				end,
				mediaGalleryGainFocused = p19.props.mediaGalleryGainFocused,
				expandableAreaHeightOffset = v74,
				animationConfig = if not p19.props.tokens then nil else p19.props.tokens.animationConfig
			}))
		end)
	end

	if FFlagLuaAppEdpMediaGalleryRedesign and v72 then
		return (Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			MediaGallery = Roact.createElement(MediaGallerySnapping, {
				itemPadding = 0,
				clipsNonCurrentItems = true,
				showCounter = false,
				items = p20,
				initialWidth = if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else p19.props.initialWidth,
				startIndex = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else p19.props.startIndex,
				borderRadius = UDim.new(0, 8),
				onSwipe = p19.props.onSwipe,
				onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p19.props.onMediaGalleryMediaChanged,
				onFullscreenToggleButtonActivated = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else p19.props.onPreviewActivated,
				isOccluded = if not FFlagLuaAppEdpMediaGalleryFullScreen or not FFlagLuaAppEdpMediaGalleryAutoAdvance and not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p19.props.isOccluded,
				onVideoPlayActivated = p19.openYouTubeVideoItem,
				videoPlaybackCoordinator = if not FFlagLuaAppEdpMediaGalleryVideoPreview or not p19.mediaGalleryVideoPreviewEnabled then nil else p19.videoPlaybackCoordinator,
				videoAnalytics = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p19.props.videoAnalytics,
				universeId = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p19.props.universeId,
				mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p19.props.mediaGalleryRedesignEnabledIxp,
				mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p19.props.mediaGalleryVideoPreviewEnabledIxp
			})
		}))
	end

	return (Roact.createElement("Frame", {
		Size = p19.containerSize,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[Roact.Change.AbsoluteSize] = p19.onResize
	}, {
		MediaGalleryPreview = Roact.createElement(MediaGalleryPreview, {
			numberOfThumbnails = 5,
			fullWidth = true,
			items = p20,
			onPreviewActivated = p19.props.onPreviewActivated,
			onThumbnailActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry then nil else p19.props.onThumbnailActivated,
			onVideoPlayActivated = p19.openYouTubeVideoItem
		})
	}))
end
function v54.renderFullscreen(p24, p25) -- line: 439
	-- upvalues: withStyle (copy), UiMode (copy), Roact (copy), CrossFadeAnimatedView (copy), FFlagLuaAppEdpMediaGalleryRedesign (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), MediaGallerySnappingFull (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), MediaGalleryFullScreen (copy)
	return withStyle(function(p26) -- line: 440
		-- upvalues: p24 (copy), UiMode (copy), Roact (copy), CrossFadeAnimatedView (copy), p25 (copy), FFlagLuaAppEdpMediaGalleryRedesign (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), MediaGallerySnappingFull (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), MediaGalleryFullScreen (copy)
		if p24.props.uiMode == UiMode.TenFoot then
			return (Roact.createElement(CrossFadeAnimatedView, {
				overlayTransparency = 1,
				items = p25,
				crossAnim = {
					currentIndex = p24.props.currentIndex,
					nextIndex = p24.props.nextIndex,
					setCurrentIndex = p24.props.setCurrentIndex,
					isCrossFade = p24.props.isCrossFade,
					setCrossFade = p24.props.setCrossFade
				}
			}))
		end

		if FFlagLuaAppEdpMediaGalleryRedesign and (not FFlagLuaAppEdpMediaGalleryRedesignIxp or p24.props.mediaGalleryRedesignEnabledIxp) and FFlagLuaAppEdpMediaGalleryFullScreen then
			return Roact.createElement(MediaGallerySnappingFull, {
				items = p25,
				universeId = p24.props.universeId,
				rootPlaceId = p24.props.placeId,
				startIndex = p24.props.startIndex,
				exitFullscreen = p24.props.exitFullscreen,
				onVideoPlayActivated = p24.openYouTubeVideoItem,
				videoPlaybackCoordinator = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p24.videoPlaybackCoordinator,
				videoAnalytics = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p24.props.videoAnalytics,
				mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p24.props.mediaGalleryRedesignEnabledIxp,
				mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p24.props.mediaGalleryVideoPreviewEnabledIxp
			})
		end

		local Theme = p26.Theme

		return (Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.BackgroundMuted.Color,
			BackgroundTransparency = Theme.BackgroundMuted.Transparency
		}, {
			Fullscreen = Roact.createElement(MediaGalleryFullScreen, {
				items = p25,
				showIndex = p24.props.fullscreenShowIndex,
				onVideoPlayActivated = p24.openYouTubeVideoItem
			})
		}))
	end)
end

local v55 = RoactRodux.connect(nil, function(p27) -- line: 497
	-- upvalues: OpenCentralOverlayForLeaveRobloxAlert (copy), OpenYouTubeVideo (copy)
	return {
		openLeaveRobloxAlertUIBlox = function(p28) -- line: 499
			-- upvalues: p27 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			return p27(OpenCentralOverlayForLeaveRobloxAlert(p28))
		end,
		openYouTubeVideo = function(p29, p30, p31, p32, p33, p34, p35) -- line: 502
			-- upvalues: p27 (copy), OpenYouTubeVideo (copy)
			return p27((OpenYouTubeVideo(p29, p30, p31, p32, p33, p34, p35)))
		end
	}
end)(v54)
local v56 = RoactServices.connect({
	guiService = AppGuiService,
	eventIngest = AppEventIngestService
})(v55)
local v57 = RoactAppPolicy.connect(function(p36, _) -- line: 531
	return {
		showYouTubeAgeAlert = p36.getShowYouTubeAgeAlert()
	}
end)(v56)

return function(p38) -- line: 538
	-- upvalues: FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), useSelector (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameInfosReducer (copy), useSelectedGameMediaEntries (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), useMediaGalleryVideoAnalytics (copy), Roact (copy), v57 (copy), Cryo (copy)
	local v81 = if not FFlagLuaAppEdpMediaGalleryVideoPreview and not FFlagLuaAppEdpMediaGalleryFullScreen then nil else useSelector(function(p39) -- line: 540
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p38 (copy), GameInfosReducer (copy)
		local v120 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p38.shouldHydrateLegacyIxp) then p39.GameDetails[p38.universeId] else p39.GameDetailsV2[p38.universeId]
		local v121 = p39.Personalization[GameInfosReducer.key][p38.universeId]

		return v120 and v120.rootPlaceId or v121 and v121.placeId
	end)
	local v82 = useSelectedGameMediaEntries(p38.universeId, if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v81, p38.showYouTubeVideoFirst or true, if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p38.mediaGalleryVideoPreviewEnabledIxp, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p38.shouldHydrateLegacyIxp)
	local v83 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else useMediaGalleryVideoAnalytics(p38.universeId, v81, v82)

	return Roact.createElement(v57, Cryo.Dictionary.join(p38, {
		selectedGameMediaEntries = v82,
		videoAnalytics = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v83,
		placeId = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v81
	}))
end
