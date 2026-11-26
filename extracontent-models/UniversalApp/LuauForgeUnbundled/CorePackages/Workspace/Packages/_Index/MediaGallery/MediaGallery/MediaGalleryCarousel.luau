local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Foundation")
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local cursorType = Foundation.Enums.CursorType
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib")
local signal = AppCommonLib.Signal

local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppEdpMomentVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppEdpMomentVideo
local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useLastInput = Responsive.useLastInput

local fFlagLuaAppMediaGalleryHideScrollArrowsOnTouch = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryHideScrollArrowsOnTouch

local fFlagLuaAppMediaGalleryPageIndicatorOpacity = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryPageIndicatorOpacity

local useGamepadSupports = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/RoactUtils").Hooks.useGamepadSupports

local defineFastFlag = game:DefineFastFlag("LuaAppMediaGalleryGamepadSupportsPagingIcons", false)
local v5

if fFlagLuaAppMediaGalleryGamepadSupport then
	v5 = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 }
else
	v5 = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 }
end

local v6 = { Enum.KeyCode.ButtonR3 }

local carouselScrollButtons = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/CollectionViews").CarouselScrollButtons

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/VideoUtils")
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local roundIconButton = VideoUtils.RoundIconButton

local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/MediaPlayback").enableAudioPlaybackInApp

local MediaGalleryPageIndicators = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryPageIndicators")
local MediaGalleryConstants = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants")
require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")
local MediaGalleryImageItem = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryImageItem")
local MediaGalleryVideoItem = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryVideoItem")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/isYouTubeVideo")
local isValidIdentifier = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/isValidIdentifier")

local useSnapScroll = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useSnapScroll")
local useAutoAdvance = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useAutoAdvance")
local useTouchDragScroll = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useTouchDragScroll")
local useCarouselGamepadInput = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useCarouselGamepadInput")
local isAudioPlaybackAllowedForDevice = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/isAudioPlaybackAllowedForDevice")

local fFlagLuaAppVideoLoadFailureFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppVideoLoadFailureFallback

local SLIDING_WINDOW_SIZE = MediaGalleryConstants.SLIDING_WINDOW_SIZE

local function getVisibleIndices(count, currentIndex)
	local visibleIndices = {}

	for i = 1, SLIDING_WINDOW_SIZE do
		local v7 = currentIndex + i - math.floor(SLIDING_WINDOW_SIZE / 2) - 1

		if v7 >= 1 and v7 <= count then
			table.insert(visibleIndices, v7)
		end
	end

	return visibleIndices
end

local function MediaGalleryCarousel(props)
	local v7 = useTokens()
	local itemPadding = props.itemPadding or v7.Padding.Medium
	local aspectRatio = props.aspectRatio or MediaGalleryConstants.ITEM_ASPECT_RATIO
	local cornerRadius = props.cornerRadius or v7.Radius.Medium
	local count = #props.items

	local v8 = React.useMemo(function(): boolean
		for k, item in props.items do
			if isValidIdentifier(item.videoId) and not module10(item.assetTypeId) then
				return true
			end
		end

		return false
	end, { props.items })

	React.useEffect(function()
		if v8 and isAudioPlaybackAllowedForDevice() then
			task.delay(0, enableAudioPlaybackInApp)
		end
	end, { v8 })

	local v9 = React.useCallback(function(p2, p3)
		if props.onMediaChanged then
			props.onMediaChanged(p2, p3)
		end
	end, { props.onMediaChanged })

	local v10 = useSnapScroll({
		itemCount = count,
		itemPadding = itemPadding,
		springConfig = MediaGalleryConstants.SPRING_CONFIG,
		targetIndex = props.startIndex,
		onScrollComplete = v9
	})

	local visibleIndices = getVisibleIndices(count, v10.currentIndex)

	local v11 = React.useMemo(function()
		return signal.new()
	end, {})
	local v12 = React.useMemo(function()
		return signal.new()
	end, {})
	local state, setState = React.useState(true)

	local state2, setState2 = React.useState(false)

	local v13 = React.useMemo(function()
		return videoPlaybackCoordinator.new()
	end, {})
	local videoPlaybackCoordinator2 = props.videoPlaybackCoordinator or v13

	local state3 = nil
	local v14 = nil
	local state4 = nil
	local v15 = nil
	local v16, v17

	if fFlagLuaAppMediaGalleryGamepadSupport then
		local setState3
		state3, setState3 = React.useState(false)
		v14 = setState3

		v16 = React.useCallback(function(p2)
			v14(p2)
		end, {})
		local setState4
		state4, setState4 = React.useState(false)
		v15 = setState4

		v17 = React.useCallback(function(p2)
			v15(p2)
		end, {})

		React.useEffect(function()
			if not state2 then
				v14(false)
				v15(false)
			end
		end, { state2 })
	end

	local v18 = React.useCallback(function()
		v10.scrollInDirection("Right", true)
	end, { v10.scrollInDirection })

	local v19 = useAutoAdvance({
		enabled = props.autoAdvanceEnabled ~= false,
		intervalSeconds = props.autoAdvanceIntervalSeconds,
		galleryRef = v10.scrollingFrameRef,
		isMediaGalleryOccluded = props.isMediaGalleryOccluded,
		isAutoAdvanceTimerSuspended = state2,
		scrollRight = v18
	})

	local v20 = React.useCallback(function(p2, p3)
		v19.resetProgress()
		v10.scrollInDirection(p2, p3)
	end, { v19.resetProgress, v10.scrollInDirection })
	local v21

	if fFlagLuaAppVideoLoadFailureFallback then
		v21 = React.useCallback(function()
			v20("Right", true)
		end, { v20 })
	end

	local v22 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local size_200 = v7.Size.Size_200

	local v23 = if v22 then v7.Size.Size_400 else v7.Size.Size_700
	local gradientOverlayHeight = props.gradientOverlayHeight or size_200 + v23 + v7.Size.Size_1000

	local v24 = React.useMemo(function()
		return {
			videoAnalyticsData = {
				source = props.analyticsSource or "MediaGallery",
				sourceId = props.analyticsSourceId or nil
			},
			getPlaybackSessionId = function()
				return videoPlaybackCoordinator2.currentPlaybackSessionId
			end
		}
	end, { props.analyticsSource, props.analyticsSourceId, videoPlaybackCoordinator2 })

	local onFullscreenToggle = if props.fullscreenEnabled ~= false then props.onFullscreenToggle else nil

	local v25 = React.useCallback(function()
		if onFullscreenToggle then
			onFullscreenToggle(v10.currentIndex)
		end
	end, { onFullscreenToggle, v10.currentIndex })

	local v26 = useLastInput()
	local v27

	if fFlagLuaAppMediaGalleryGamepadSupport and AppCommonLib.isSpatial() then
		v27 = Responsive.Input.Pointer
	else
		v27 = v26
	end

	local v28 = v27 == Responsive.Input.Directional

	local v29 = if defineFastFlag then useGamepadSupports(v5, v27) else false
	local v30 = if defineFastFlag then v28 and v29 else v28
	local v31

	if fFlagLuaAppMediaGalleryHideScrollArrowsOnTouch then
		v31 = v27 == Responsive.Input.Pointer
			or v27 == Responsive.Input.Touch and props.isFullscreen == true
			or defineFastFlag and v28 and not v29
	else
		v31 = v27 == Responsive.Input.Pointer or defineFastFlag and not v29
	end

	local v32

	if fFlagLuaAppMediaGalleryGamepadSupport then
		local v33 = useGamepadSupports(v6, v26)
		v32 = v28 and v33
	else
		v32 = false
	end

	local v33 = React.useCallback(function()
		v20("Left")
	end, { v20 })

	local v34 = React.useCallback(function()
		v20("Right")
	end, { v20 })

	local v35 = useCursor(cursorType.Invisible)

	local v36 = React.useCallback(function()
		if state2 then
			v11:fire()
		end
	end, { state2, v11 })

	local v38 = {
		isFullscreen = props.isFullscreen,
		isVideoActive = state2,
		isVideoPlaying = 0,
		isVideoReady = 0,
		isMuted = 0,
		toggleMuteSignal = 0,
		onFullscreenToggle = 0,
		scrollLeft = 0,
		scrollRight = 0
	}

	if not fFlagLuaAppMediaGalleryGamepadSupport then
		state3 = nil
	end

	v38.isVideoPlaying = state3

	if not fFlagLuaAppMediaGalleryGamepadSupport then
		state4 = nil
	end

	v38.isVideoReady = state4
	v38.isMuted = state
	v38.toggleMuteSignal = v12
	v38.onFullscreenToggle = v25
	v38.scrollLeft = v33
	v38.scrollRight = v34
	local v39 = useCarouselGamepadInput(v38)

	local scrollingFrameRef = v10.scrollingFrameRef

	local v41 = if fFlagLuaAppMediaGalleryHideScrollArrowsOnTouch then v20 else v10.scrollInDirection
	useTouchDragScroll(scrollingFrameRef, v41)

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, itemPadding)
		})
	}

	for k, visibleIndice in visibleIndices do
		local item = props.items[visibleIndice]

		if not item then
			continue
		end

		local v42

		if isValidIdentifier(item.videoId) and not module10(item.assetTypeId) then
			local itemProps = {}
			itemProps.videoId = item.videoId
			local v43 = if fFlagLuaAppEdpMomentVideo then item.videoAccessContext else nil
			itemProps.videoAccessContext = v43
			local v44 = if fFlagLuaAppVideoPlayerTrimAndMusic then item.trimStartTime else nil
			itemProps.trimStartTime = v44
			local v45 = if fFlagLuaAppVideoPlayerTrimAndMusic then item.trimEndTime else nil
			itemProps.trimEndTime = v45
			local v46 = if fFlagLuaAppVideoPlayerTrimAndMusic then item.musicAssetId else nil
			itemProps.musicAssetId = v46
			local v47 = if fFlagLuaAppVideoPlayerTrimAndMusic then item.musicStartTime else nil
			itemProps.musicStartTime = v47
			local v48 = if fFlagLuaAppEdpMomentVideo then item.attributionComponent else nil
			itemProps.attributionComponent = v48
			itemProps.thumbnail = item.imageId
			itemProps.Size = UDim2.fromScale(1, 1)
			itemProps.itemIndex = visibleIndice
			itemProps.overlay = item.overlay
			itemProps.currentIndex = v10.currentIndex
			itemProps.videoPlaybackCoordinator = videoPlaybackCoordinator2
			itemProps.toggleVideoPlaybackSignal = v11
			itemProps.toggleMuteSignal = v12
			itemProps.onVideoEnded = v19.onVideoEnded
			itemProps.onVideoLoadFailed = if fFlagLuaAppVideoLoadFailureFallback then v21 else nil
			itemProps.onVideoProgressChanged = v19.onVideoProgressChanged
			itemProps.onMutedChanged = setState
			itemProps.onPlayingChanged = if fFlagLuaAppMediaGalleryGamepadSupport then v16 else nil
			itemProps.onVideoReadyChanged = if fFlagLuaAppMediaGalleryGamepadSupport then v17 else nil
			itemProps.setIsVideoActive = setState2
			itemProps.isFullscreen = props.isFullscreen
			itemProps.isMediaGalleryOccluded = props.isMediaGalleryOccluded
			itemProps.videoAnalytics = props.videoAnalytics
			itemProps.videoAnalyticsContext = v24
			itemProps.videoDwellTimeHundredthsSec = props.videoDwellTimeHundredthsSec
			itemProps.videoVisiblePercent = props.videoVisiblePercent
			itemProps.autoplay = props.autoplay
			itemProps.muted = props.muted
			itemProps.looped = props.looped
			itemProps.showPlayButton = props.showPlayButton
			itemProps.showProgressBar = props.showProgressBar
			itemProps.cornerRadius = cornerRadius
			local v52 = if visibleIndice == 1 then props.onMediaResolved else nil
			itemProps.onMediaResolved = v52

			if item.itemProps then
				for k2, itemProp in item.itemProps do
					itemProps[k2] = itemProp
				end
			end

			v42 = React.createElement(MediaGalleryVideoItem, itemProps)
		else
			local itemProps = {
				imageId = item.imageId,
				isYouTubeVideo = module10(item.assetTypeId),
				videoHash = item.videoHash,
				videoTitle = item.videoTitle,
				Size = UDim2.fromScale(1, 1),
				itemIndex = visibleIndice,
				overlay = item.overlay,
				cornerRadius = cornerRadius,
				showGradient = props.showGradient,
				onYouTubeVideoPlay = props.onYouTubeVideoPlay,
				gradientOverlayHeight = gradientOverlayHeight,
				onMediaResolved = 0
			}

			local v43 = if visibleIndice == 1 then props.onMediaResolved else nil
			itemProps.onMediaResolved = v43

			if item.itemProps then
				for k2, itemProp in item.itemProps do
					itemProps[k2] = itemProp
				end
			end

			v42 = React.createElement(MediaGalleryImageItem, itemProps)
		end

		children["Item" .. visibleIndice] = React.createElement("Frame", {
			LayoutOrder = visibleIndice,
			Size = v10.absoluteSizeBinding:map(function(p2)
				return UDim2.new(1, 0, 0, p2.X / aspectRatio)
			end),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, { Content = v42 })
	end

	local size_500 = v7.Size.Size_500
	local size_350 = v7.Size.Size_350

	local createElement = React.createElement
	local v44 = {
		BackgroundTransparency = 1,
		Size = props.Size or UDim2.fromScale(1, 1),
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		ref = v39,
		AutoButtonColor = false,
		Text = "",
		[React.Event.Activated] = v36,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}

	if not props.isFullscreen then
		v35 = nil
	end

	v44.SelectionImageObject = v35
	v44.SelectionGroup = true
	local children2 = {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			Selectable = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = v10.absoluteSizeBinding:map(function(p2)
				return UDim2.new(1, 0, 0, p2.X / aspectRatio)
			end),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasPosition = v10.canvasPosition,
			ScrollingEnabled = false,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ClipsDescendants = true,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v10.onAbsoluteSizeChanged,
			ref = v10.scrollingFrameRef
		}, children),
		PageIndicators = 0,
		ScrollButtons = 0,
		FullscreenButton = 0,
		CarouselOverlay = 0,
		SizeConstraint = 0
	}
	local v45

	if count > 1 and props.showPageIndicators ~= false and not props.isFullscreen then
		local createElement3 = React.createElement
		local v47 = {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v7.Size.Size_200),
			Position = UDim2.new(0.5, 0, 1, -v23),
			ZIndex = 2
		}

		local v48 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, size_350),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PageLeftGamepadIcon = 0,
			Indicators = 0,
			PageRightGamepadIcon = 0
		}
		local v49

		if v30 then
			local createElement4 = React.createElement
			local v53

			if fFlagLuaAppMediaGalleryGamepadSupport then
				v53 = Enum.KeyCode.ButtonL2
			else
				v53 = Enum.KeyCode.ButtonL1
			end

			v49 = createElement4("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				Image = UserInputService:GetImageForKeyCode(v53),
				ImageTransparency = v10.currentIndex <= 1 and 0.5 or nil,
				Size = UDim2.fromOffset(size_500, size_500)
			})
		end

		v48.PageLeftGamepadIcon = v49

		local createElement4 = React.createElement
		local v51 = {
			numberOfItems = count,
			startIndex = props.startIndex or 1,
			currentItemProgressBinding = 0,
			mediaGalleryScrolledSignal = 0,
			useSpring = true,
			springConfig = 0
		}

		local v52 = if not fFlagLuaAppMediaGalleryPageIndicatorOpacity or props.autoAdvanceEnabled ~= false or not not state2 then v19.progressBinding else nil
		v51.currentItemProgressBinding = v52

		v51.mediaGalleryScrolledSignal = v10.scrolledSignal

		v51.springConfig = MediaGalleryConstants.SPRING_CONFIG
		v48.Indicators = createElement4(MediaGalleryPageIndicators, v51)
		local v53

		if v30 then
			local createElement5 = React.createElement
			local v57

			if fFlagLuaAppMediaGalleryGamepadSupport then
				v57 = Enum.KeyCode.ButtonR2
			else
				v57 = Enum.KeyCode.ButtonR1
			end

			v53 = createElement5("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Image = UserInputService:GetImageForKeyCode(v57),
				ImageTransparency = count <= v10.currentIndex and 0.5 or nil,
				Size = UDim2.fromOffset(size_500, size_500)
			})
		end

		v48.PageRightGamepadIcon = v53
		v45 = createElement3("Frame", v47, v48)
	end

	children2.PageIndicators = v45
	local v46

	if v31 and not props.isMediaGalleryOccluded then
		local createElement3 = React.createElement
		local v48 = {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, props.isFullscreen and 0 or v7.Size.Size_1000, 1, 0),
			buttonOffsetFromEdge = 0,
			ZIndex = 10,
			leftScrollingEnabled = 0,
			rightScrollingEnabled = 0,
			handleScrollLeft = 0,
			handleScrollRight = 0
		}
		local v49 = if props.isFullscreen then v7.Size.Size_500 else nil
		v48.buttonOffsetFromEdge = v49

		v48.leftScrollingEnabled = v10.currentIndex > 1
		v48.rightScrollingEnabled = v10.currentIndex < count
		v48.handleScrollLeft = v33
		v48.handleScrollRight = v34
		v46 = createElement3(carouselScrollButtons, v48)
	end

	children2.ScrollButtons = v46

	local v47 = if onFullscreenToggle and not (fFlagLuaAppMediaGalleryGamepadSupport and v32) then React.createElement(roundIconButton, {
		icon = props.isFullscreen and "two-arrows-to-center" or "two-arrows-from-center",
		onActivated = v25,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v7.Size.Size_500, 0, v7.Size.Size_500),
		ZIndex = 4,
		Selectable = false
	}) else nil
	children2.FullscreenButton = v47

	local v48 = if props.overlay then React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 15 },
		{ Overlay = props.overlay }
	) else nil
	children2.CarouselOverlay = v48

	children2.SizeConstraint = React.createElement("UISizeConstraint", {
		MinSize = v10.absoluteSizeBinding:map(function(p2)
			return Vector2.new(0, p2.X / aspectRatio)
		end)
	})
	return {
		Carousel = createElement("TextButton", v44, children2)
	}
end

return React.memo(MediaGalleryCarousel)
