local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withStyle = UIBlox.Core.Style.withStyle
local t = require(CorePackages.Packages.t)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local deviceType = RobloxAppEnums.DeviceType
local uiMode = RobloxAppEnums.UiMode
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local gameMediaImageType = require("@luauforge/bundled/cBc").GameMediaImageType
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local videoPlaybackCoordinator = require("@luauforge/bundled/gDL").VideoPlaybackCoordinator

local AppBlox = require("@game/CorePackages/Workspace/Packages/AppBlox")
local mediaGalleryPreview = AppBlox.MediaGalleryPreview
local mediaGalleryCarousel = AppBlox.MediaGalleryCarousel
local mediaGalleryFullScreen = AppBlox.MediaGalleryFullScreen
local crossFadeAnimatedView = AppBlox.CrossFadeAnimatedView
local mediaGalleryExpandableView = AppBlox.MediaGalleryExpandableView
local calcMediaGallerySizesFromWidth = AppBlox.calcMediaGallerySizesFromWidth

local module4 = require("@luauforge/deferred/gDM")
local openYouTubeVideoEvent = require("@luauforge/bundled/dzG").Events.openYouTubeVideoEvent
local module5 = require("@luauforge/bundled/fAJ")
local onNavigateBackWrapper = require("@luauforge/bundled/dXB").OnNavigateBackWrapper
local module6 = require("@luauforge/deferred/gDN")
local module7 = require("@luauforge/deferred/gDT")
local module8 = require("@luauforge/deferred/gDP")
local module9 = require("@luauforge/deferred/gDU")

local module10 = require("@luauforge/deferred/gDV")

local useMediaGalleryVideoAnalytics = require("@luauforge/deferred/gDW").useMediaGalleryVideoAnalytics

local module11 = require("@luauforge/deferred/gDI")
local module12 = require("@luauforge/deferred/gDX")

local getFFlagConsoleApplyTokenizationEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagConsoleApplyTokenizationEdp

local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpMediaGalleryRedesign = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesign

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpMediaGalleryHeightJitterFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryHeightJitterFix

local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo

local fFlagLuaAppEdpConsoleMediaGalleryVideoMute = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideoMute

local v5 = { view = "view", play = "play" }

local extended = Roact.PureComponent:extend("ExperienceMediaGallery")

local interface = t.interface
local v6 = {
	universeId = t.string,
	startIndex = 0,
	isFullscreen = 0,
	fullscreenShowIndex = 0,
	onPreviewActivated = 0,
	onThumbnailActivated = 0,
	deviceType = 0,
	tokens = 0,
	showYouTubeVideoFirst = 0,
	onSwipe = 0,
	onMediaGalleryMediaChanged = 0,
	initialWidth = 0,
	isOccluded = 0,
	uiMode = 0,
	isFullscreenState = 0,
	onSelectionGained = 0,
	mediaGalleryGainFocused = 0,
	expandableAreaHeightOffset = 0,
	nextIndex = 0,
	isCrossFade = 0,
	currentIndex = 0,
	setCurrentIndex = 0,
	setCrossFade = 0,
	toggleMuteSignal = 0,
	videoPlaybackCoordinator = 0,
	exitFullscreen = 0,
	selectedGameMediaEntries = 0,
	videoAnalytics = 0,
	placeId = 0,
	mediaGalleryRedesignEnabledIxp = 0,
	mediaGalleryVideoPreviewEnabledIxp = 0,
	shouldHydrateLegacyIxp = 0
}
local v7 = if fFlagLuaAppEdpMediaGalleryFullScreen then t.optional(t.number) else nil
v6.startIndex = v7
v6.isFullscreen = t.optional(t.boolean)
v6.fullscreenShowIndex = t.optional(t.integer)
v6.onPreviewActivated = t.optional(t.callback)
local v8 = if fFlagLuaAppDesktopMediaGalleryTelemetry then t.optional(t.callback) else nil
v6.onThumbnailActivated = v8
v6.deviceType = t.optional(t.string)
v6.tokens = t.optional(t.table)
v6.showYouTubeVideoFirst = t.optional(t.boolean)
v6.onSwipe = t.optional(t.callback)
local v9 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v6.onMediaGalleryMediaChanged = v9
local v10 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then t.optional(t.number) else nil
v6.initialWidth = v10

local v11 = if fFlagLuaAppEdpMediaGalleryFullScreen and (fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryVideoPreview) then t.optional(t.boolean) else nil
v6.isOccluded = v11

v6.uiMode = t.optional(t.string)

v6.isFullscreenState = t.optional(t.boolean)
v6.onSelectionGained = t.optional(t.callback)
v6.mediaGalleryGainFocused = t.optional(t.callback)
v6.expandableAreaHeightOffset = t.optional(t.number)
v6.nextIndex = t.optional(t.number)
v6.isCrossFade = t.optional(t.boolean)
v6.currentIndex = t.optional(t.number)
v6.setCurrentIndex = t.optional(t.callback)
v6.setCrossFade = t.optional(t.callback)
local v12 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then t.optional(t.table) else nil
v6.toggleMuteSignal = v12
local v13 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then t.optional(t.table) else nil
v6.videoPlaybackCoordinator = v13
v6.exitFullscreen = t.optional(t.callback)

v6.selectedGameMediaEntries = t.optional(t.table)
local v14 = if fFlagLuaAppEdpMediaGalleryVideoPreview then t.optional(t.table) else nil
v6.videoAnalytics = v14
local v15 = if fFlagLuaAppEdpMediaGalleryFullScreen then t.optional(t.string) else nil
v6.placeId = v15

local v16 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then t.optional(t.boolean) else nil
v6.mediaGalleryRedesignEnabledIxp = v16

local v17 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then t.optional(t.boolean) else nil
v6.mediaGalleryVideoPreviewEnabledIxp = v17

local v18 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v6.shouldHydrateLegacyIxp = v18
extended.validateProps = interface(v6)

extended.defaultProps = {
	isFullscreen = false,
	fullscreenShowIndex = 1,
	showYouTubeVideoFirst = true,
	isFullscreenState = false,
	expandableAreaHeightOffset = not getFFlagConsoleApplyTokenizationEdp() and 592 or nil,
	nextIndex = 1
}

function extended:init()
	local binding, v19 = Roact.createBinding(0)
	self.containerHeight = binding
	self.updateContainerHeight = v19
	self.containerSize = self.containerHeight:map(function(p2)
		return UDim2.new(1, 0, 0, p2)
	end)

	if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then
		self.state = { isFocusedItemVideo = false }
	end

	local v20 = if fFlagLuaAppEdpMediaGalleryVideoPreview then not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp or self.props.mediaGalleryVideoPreviewEnabledIxp else nil
	self.mediaGalleryVideoPreviewEnabled = v20
	local v21

	if fFlagLuaAppEdpConsoleMediaGalleryVideo and self.props.videoPlaybackCoordinator then
		v21 = self.props.videoPlaybackCoordinator
	elseif fFlagLuaAppEdpMediaGalleryVideoPreview and self.mediaGalleryVideoPreviewEnabled then
		v21 = videoPlaybackCoordinator.new()
	end

	self.videoPlaybackCoordinator = v21

	function self.onResize(p2)
		local offset = calcMediaGallerySizesFromWidth(p2.AbsoluteSize.X, 5).contentSize.Y.Offset

		if offset ~= self.containerHeight:getValue() then
			self.updateContainerHeight(offset)
		end
	end

	self.getItemsFromEntries = memoize(function(p2)
		return Cryo.List.map(p2, function(data)
			local v22 = {
				imageId = data.imageId,
				isYouTubeVideo = data.mediaType == gameMediaImageType.YouTubeVideo,
				videoId = 0
			}
			local v23 = if fFlagLuaAppEdpMediaGalleryVideoPreview and self.mediaGalleryVideoPreviewEnabled then data.videoId else nil
			v22.videoId = v23
			return v22
		end)
	end)

	function self.performOpenYouTubeVideo(p2, p3)
		local guiService = self.props.guiService
		local openYouTubeVideo = self.props.openYouTubeVideo
		local eventIngest = self.props.eventIngest
		local universeId = self.props.universeId
		local youTubeVideoHash = p2.youTubeVideoHash
		local youTubeVideoTitle = p2.youTubeVideoTitle

		if youTubeVideoHash and #youTubeVideoHash > 0 and youTubeVideoTitle and #youTubeVideoTitle > 0 then
			openYouTubeVideo(
				guiService,
				youTubeVideoHash,
				youTubeVideoTitle,
				p3,
				eventIngest,
				universeId,
				"play"
			)
		end
	end

	function self.openYouTubeVideoItem(p2)
		local openLeaveRobloxAlertUIBlox = self.props.openLeaveRobloxAlertUIBlox
		local showYouTubeAgeAlert = self.props.showYouTubeAgeAlert

		local selectedGameMediaEntry = self.props.selectedGameMediaEntries[p2]
		local function fn()
			self.performOpenYouTubeVideo(selectedGameMediaEntry, "gameDetailsAccordianImage")
		end

		if showYouTubeAgeAlert then
			openLeaveRobloxAlertUIBlox(fn)
		else
			self.performOpenYouTubeVideo(selectedGameMediaEntry, "gameDetailsAccordianImage")
		end
	end

	if self.props.uiMode == uiMode.TenFoot then
		self.getConsoleItemsFromEntries = memoize(function(p2)
			return Cryo.List.filter(p2, function(p3): boolean
				return p3.mediaType ~= gameMediaImageType.YouTubeVideo
			end)
		end)
	end

	function self.logMediaItemsContainYouTubeVideo(p2)
		local eventIngest = self.props.eventIngest
		local universeId = self.props.universeId
		local v22 = self.props.uiMode == uiMode.TenFoot and {} or self.props.selectedGameMediaEntries

		local v23 = Cryo.List.filter(v22, function(p3): boolean
			return p3.mediaType == gameMediaImageType.YouTubeVideo
		end)[1]

		if v23 then
			openYouTubeVideoEvent(
				eventIngest,
				p2,
				v23.youTubeVideoTitle,
				v23.youTubeVideoHash,
				universeId,
				"view"
			)
		end
	end

	if not self.props.isFullScreen then
		self.logMediaItemsContainYouTubeVideo("gameDetailsAccordianImage")
	end
end

function extended.didUpdate(p2, p3, p4)
	if not (p2.props.isFullScreen or Cryo.List.equals(
		p3.selectedGameMediaEntries,
		p2.props.selectedGameMediaEntries
	)) then
		p2.logMediaItemsContainYouTubeVideo("gameDetailsAccordianImage")
	end
end

function extended:renderWithLocalization(p2)
	local selectedGameMediaEntries = self.props.selectedGameMediaEntries
	local v19

	if self.props.uiMode == uiMode.TenFoot then
		v19 = self.getConsoleItemsFromEntries(selectedGameMediaEntries)
	else
		v19 = self.getItemsFromEntries(selectedGameMediaEntries)
	end

	if #v19 <= 0 then
		return nil
	end

	return self.props.isFullscreen and self:renderFullscreen(v19) or self:renderPreview(v19, p2)
end

function extended:render()
	if module12 then
		return withLocalization({ titleText = "Feature.GameDetails.Heading.Media" })(function(p2)
			return self:renderWithLocalization(p2)
		end)
	end

	return self:renderWithLocalization()
end

function extended:renderPreview(p2, p3)
	local v19

	if fFlagLuaAppEdpMediaGalleryRedesign then
		v19 = not fFlagLuaAppEdpMediaGalleryRedesignIxp or self.props.mediaGalleryRedesignEnabledIxp
	end

	if self.props.deviceType == deviceType.Tablet and not (fFlagLuaAppEdpMediaGalleryRedesign and v19) then
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 100),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			[Roact.Change.AbsoluteSize] = self.onResize
		}, {
			MediaGalleryCarousel = Roact.createElement(mediaGalleryCarousel, {
				items = p2,
				onPreviewActivated = self.props.onPreviewActivated,
				onVideoPlayActivated = self.openYouTubeVideoItem
			})
		})
	elseif
		self.props.deviceType == deviceType.Phone
		and not (fFlagLuaAppEdpMediaGalleryRedesign and v19)
	then
		local createElement = Roact.createElement
		local v21 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local createElement2 = Roact.createElement
		local v24 = {
			items = p2,
			initialWidth = 0,
			itemPadding = 8,
			borderRadius = 0,
			showCounter = false,
			onSwipe = 0,
			onVideoPlayActivated = 0
		}

		local v25 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then self.props.initialWidth else nil
		v24.initialWidth = v25

		v24.borderRadius = UDim.new(0, 8)

		v24.onSwipe = self.props.onSwipe
		v24.onVideoPlayActivated = self.openYouTubeVideoItem
		return createElement("Frame", v21, {
			MediaGallerySnapping = createElement2(module6, v24)
		})
	elseif self.props.uiMode == uiMode.TenFoot then
		local v20 = if self.props.isFullscreenState then cursorKind.Invisible else cursorKind.RoundedRect
		local expandableAreaHeightOffset

		if getFFlagConsoleApplyTokenizationEdp() and self.props.tokens then
			expandableAreaHeightOffset = self.props.tokens.expandableAreaHeightOffset
		else
			expandableAreaHeightOffset = self.props.expandableAreaHeightOffset
		end

		return withStyle(function(p4)
			local v21 = {
				items = p2,
				titleText = 0,
				showCursor = 0,
				selectionCursor = 0,
				styleProps = 0,
				exitFullscreen = 0,
				onActivated = 0,
				onSelectionGained = 0,
				mediaGalleryGainFocused = 0,
				groupTransparency = 0,
				expandableAreaHeightOffset = 0,
				animationConfig = 0
			}

			local v22 = if module12 and p3 then p3.titleText else nil
			v21.titleText = v22
			v21.showCursor = not self.props.isFullscreenState
			v21.selectionCursor = v20
			v21.styleProps = module11 and {
				titleFont = p4.Tokens.Typography.HeadingSmall
			} or nil

			v21.exitFullscreen = not self.props.isFullscreenState and function() end
				or self.props.exitFullscreen
			v21.onActivated = self.props.onPreviewActivated
			function v21.onSelectionGained(p5)
				local v23, videoId, imageId

				if p2[p5] then
					v23 = string.split(p2[p5].imageId, "=")[2]

					if fFlagLuaAppEdpConsoleMediaGalleryVideo then
						videoId = p2[p5].videoId
					end

					if fFlagLuaAppEdpConsoleMediaGalleryVideo then
						imageId = p2[p5].imageId
					end
				else
					v23 = ""
				end

				local onSelectionGained = self.props.onSelectionGained
				local v24 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then videoId else nil

				if not fFlagLuaAppEdpConsoleMediaGalleryVideo then
					imageId = nil
				end

				onSelectionGained(p5, v23, v24, imageId)

				if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then
					local v25 = videoId ~= nil

					if self.state.isFocusedItemVideo ~= v25 then
						self:setState({ isFocusedItemVideo = v25 })
					end
				end
			end
			v21.mediaGalleryGainFocused = self.props.mediaGalleryGainFocused

			v21.expandableAreaHeightOffset = expandableAreaHeightOffset
			local v23 = if self.props.tokens then self.props.tokens.animationConfig else nil
			v21.animationConfig = v23

			if fFlagLuaAppEdpConsoleMediaGalleryVideo and fFlagLuaAppEdpConsoleMediaGalleryVideoMute then
				return Roact.createElement(
					onNavigateBackWrapper,
					{ onNavigateBack = self.props.exitFullscreen },
					Roact.createElement(module9, {
						toggleMuteSignal = self.props.toggleMuteSignal,
						enabled = self.state.isFocusedItemVideo,
						render = function(p5)
							return Roact.createElement(
								mediaGalleryExpandableView,
								Cryo.Dictionary.union(v21, { rootRef = p5 })
							)
						end
					})
				)
			end

			return Roact.createElement(
				onNavigateBackWrapper,
				{ onNavigateBack = self.props.exitFullscreen },
				Roact.createElement(mediaGalleryExpandableView, v21)
			)
		end)
	elseif fFlagLuaAppEdpMediaGalleryRedesign and v19 then
		local createElement = Roact.createElement
		local v21 = {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local createElement2 = Roact.createElement
		local v24 = {
			items = p2,
			initialWidth = 0,
			startIndex = 0,
			itemPadding = 0,
			borderRadius = 0,
			clipsNonCurrentItems = true,
			showCounter = false,
			onSwipe = 0,
			onMediaGalleryMediaChanged = 0,
			onFullscreenToggleButtonActivated = 0,
			isOccluded = 0,
			onVideoPlayActivated = 0,
			videoPlaybackCoordinator = 0,
			videoAnalytics = 0,
			universeId = 0,
			mediaGalleryRedesignEnabledIxp = 0,
			mediaGalleryVideoPreviewEnabledIxp = 0
		}

		local v25 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then self.props.initialWidth else nil
		v24.initialWidth = v25
		local v26 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.props.startIndex else nil
		v24.startIndex = v26

		v24.borderRadius = UDim.new(0, 8)

		v24.onSwipe = self.props.onSwipe

		local v27 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryMediaChanged else nil
		v24.onMediaGalleryMediaChanged = v27

		local v28 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.props.onPreviewActivated else nil
		v24.onFullscreenToggleButtonActivated = v28

		local v29 = if fFlagLuaAppEdpMediaGalleryFullScreen and (fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryVideoPreview) then self.props.isOccluded else nil
		v24.isOccluded = v29

		v24.onVideoPlayActivated = self.openYouTubeVideoItem

		local v30 = if fFlagLuaAppEdpMediaGalleryVideoPreview and self.mediaGalleryVideoPreviewEnabled then self.videoPlaybackCoordinator else nil
		v24.videoPlaybackCoordinator = v30

		local v31 = if fFlagLuaAppEdpMediaGalleryVideoPreview then self.props.videoAnalytics else nil
		v24.videoAnalytics = v31
		local v32 = if fFlagLuaAppEdpMediaGalleryVideoPreview then self.props.universeId else nil
		v24.universeId = v32

		local v33 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
		v24.mediaGalleryRedesignEnabledIxp = v33

		local v34 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
		v24.mediaGalleryVideoPreviewEnabledIxp = v34
		return (createElement("Frame", v21, {
			MediaGallery = createElement2(module6, v24)
		}))
	else
		local createElement = Roact.createElement
		local onResizesByAbsoluteSize = {
			Size = self.containerSize,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Change.AbsoluteSize] = self.onResize
		}

		local createElement2 = Roact.createElement
		local v23 = {
			items = p2,
			numberOfThumbnails = 5,
			onPreviewActivated = self.props.onPreviewActivated,
			onThumbnailActivated = 0,
			onVideoPlayActivated = 0,
			fullWidth = true
		}

		local v24 = if fFlagLuaAppDesktopMediaGalleryTelemetry then self.props.onThumbnailActivated else nil
		v23.onThumbnailActivated = v24

		v23.onVideoPlayActivated = self.openYouTubeVideoItem
		return (createElement("Frame", onResizesByAbsoluteSize, {
			MediaGalleryPreview = createElement2(mediaGalleryPreview, v23)
		}))
	end
end

function extended:renderFullscreen(p2)
	return withStyle(function(p3)
		if self.props.uiMode == uiMode.TenFoot then
			local element = Roact.createElement(crossFadeAnimatedView, {
				items = p2,
				crossAnim = {
					currentIndex = self.props.currentIndex,
					nextIndex = self.props.nextIndex,
					setCurrentIndex = self.props.setCurrentIndex,
					isCrossFade = self.props.isCrossFade,
					setCrossFade = self.props.setCrossFade
				},
				overlayTransparency = 1
			})

			if not fFlagLuaAppEdpConsoleMediaGalleryVideo then
				return element
			end

			local v19 = p2 and p2[self.props.currentIndex]
			local v20 = p2 and p2[self.props.nextIndex]
			local v21

			if v19 == nil or v19.videoId == nil then
				v21 = false
			else
				local v22 = self.props.isCrossFade

				if v22 then
					v22 = not (v20 == nil) and v20.videoId == nil
				end

				v21 = not v22
			end

			local createFragment = Roact.createFragment
			local v23

			if v21 then
				local createElement = Roact.createElement
				local v25 = {
					video = v19.videoId,
					thumbnail = v19.imageId,
					Size = UDim2.fromScale(1, 1),
					cornerRadius = 0,
					ZIndex = 2,
					itemIndex = self.props.currentIndex,
					isFullscreen = true,
					videoAnalytics = self.props.videoAnalytics,
					universeId = self.props.universeId,
					hideMuteButton = not fFlagLuaAppEdpConsoleMediaGalleryVideoMute or nil,
					toggleMuteSignal = 0,
					videoPlaybackCoordinator = 0
				}

				local v26 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.props.toggleMuteSignal else nil
				v25.toggleMuteSignal = v26

				v25.videoPlaybackCoordinator = self.videoPlaybackCoordinator
				v23 = createElement(module8, v25)
			end

			return createFragment({ CrossFade = element, Video = v23 })
		else
			if
				not fFlagLuaAppEdpMediaGalleryRedesign
				or fFlagLuaAppEdpMediaGalleryRedesignIxp and not self.props.mediaGalleryRedesignEnabledIxp
				or not fFlagLuaAppEdpMediaGalleryFullScreen
			then
				local theme = p3.Theme
				return Roact.createElement(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = theme.BackgroundMuted.Color,
						BackgroundTransparency = theme.BackgroundMuted.Transparency,
						BorderSizePixel = 0
					},
					{
						Fullscreen = Roact.createElement(mediaGalleryFullScreen, {
							items = p2,
							showIndex = self.props.fullscreenShowIndex,
							onVideoPlayActivated = self.openYouTubeVideoItem
						})
					}
				)
			end

			local createElement = Roact.createElement
			local v20 = {
				items = p2,
				universeId = self.props.universeId,
				rootPlaceId = self.props.placeId,
				startIndex = self.props.startIndex,
				exitFullscreen = self.props.exitFullscreen,
				onVideoPlayActivated = self.openYouTubeVideoItem,
				videoPlaybackCoordinator = 0,
				videoAnalytics = 0,
				mediaGalleryRedesignEnabledIxp = 0,
				mediaGalleryVideoPreviewEnabledIxp = 0
			}

			local v21 = if fFlagLuaAppEdpMediaGalleryVideoPreview then self.videoPlaybackCoordinator else nil
			v20.videoPlaybackCoordinator = v21

			local v22 = if fFlagLuaAppEdpMediaGalleryVideoPreview then self.props.videoAnalytics else nil
			v20.videoAnalytics = v22

			local v23 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
			v20.mediaGalleryRedesignEnabledIxp = v23

			local v24 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v20.mediaGalleryVideoPreviewEnabledIxp = v24
			return createElement(module7, v20)
		end
	end)
end

local v19 = RoactRodux.connect(nil, function(callback)
	return {
		openLeaveRobloxAlertUIBlox = function(p2)
			return callback(module5(p2))
		end,
		openYouTubeVideo = function(p2, p3, p4, p5, p6, p7, p8)
			return callback(module4(p2, p3, p4, p5, p6, p7, p8))
		end
	}
end)(extended)

local v20 = roactServices.connect({
	guiService = appGuiService,
	eventIngest = appEventIngestService
})(v19)

local v21 = roactAppPolicy.connect(function(p2, p3)
	return { showYouTubeAgeAlert = p2.getShowYouTubeAgeAlert() }
end)(v20)

return function(props)
	local v22 = GameHydrationReact.useGameInfo(props.universeId)
	local rootPlaceId = v22 and v22.rootPlaceId
	local v23

	if fFlagLuaAppEdpMediaGalleryVideoPreview or fFlagLuaAppEdpMediaGalleryFullScreen then
		v23 = useSelector(function(p2)
			local v24 = p2.GameDetailsV2[props.universeId]
			return v24 and v24.rootPlaceId
		end)
	end

	local v24 = v23 or rootPlaceId

	local universeId = props.universeId
	local v26 = if fFlagLuaAppEdpMediaGalleryVideoPreview then v24 else nil
	local showYouTubeVideoFirst = props.showYouTubeVideoFirst or true
	local mediaGalleryVideoPreviewEnabledIxp

	if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		mediaGalleryVideoPreviewEnabledIxp = props.mediaGalleryVideoPreviewEnabledIxp
	end

	local v27 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then props.shouldHydrateLegacyIxp else nil
	local v28 = module10(universeId, v26, showYouTubeVideoFirst, mediaGalleryVideoPreviewEnabledIxp, v27)
	local v29

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v29 = useMediaGalleryVideoAnalytics(props.universeId, v24, v28)
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if fFlagLuaAppEdpConsoleMediaGalleryVideo and props.videoAnalytics then
		v29 = props.videoAnalytics
	elseif not fFlagLuaAppEdpMediaGalleryVideoPreview then
		v29 = nil
	end

	if not fFlagLuaAppEdpMediaGalleryFullScreen then
		v24 = nil
	end

	return createElement(
		v21,
		join(props, {
			selectedGameMediaEntries = v28,
			videoAnalytics = v29,
			placeId = v24
		})
	)
end
