local UserInputService = game:GetService("UserInputService")

local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local CursorType = Foundation.Enums.CursorType
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpMomentVideo = SharedFlags2.FFlagLuaAppEdpMomentVideo
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags3.FFlagLuaAppVideoPlayerTrimAndMusic

local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useLastInput = Responsive.useLastInput

local RoactUtils = require(parent.RoactUtils)
local useGamepadSupports = RoactUtils.Hooks.useGamepadSupports

local defineFastFlag = game:DefineFastFlag("LuaAppMediaGalleryGamepadSupportsPagingIcons", false)
local v

if FFlagLuaAppMediaGalleryGamepadSupport then
	v = { Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2 }
else
	v = { Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1 }
end

local v2 = { Enum.KeyCode.ButtonR3 }

local CollectionViews = require(parent.CollectionViews)
local CarouselScrollButtons = CollectionViews.CarouselScrollButtons

local VideoUtils = require(parent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local RoundIconButton = VideoUtils.RoundIconButton

local MediaPlayback = require(parent.MediaPlayback)
local enableAudioPlaybackInApp = MediaPlayback.enableAudioPlaybackInApp

local MediaGalleryPageIndicators = require(MediaGallery.MediaGalleryPageIndicators)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
require(MediaGallery.MediaGalleryTypes)
local MediaGalleryImageItem = require(MediaGallery.MediaGalleryImageItem)
local MediaGalleryVideoItem = require(MediaGallery.MediaGalleryVideoItem)
local isYouTubeVideo = require(MediaGallery.isYouTubeVideo)
local isValidIdentifier = require(MediaGallery.isValidIdentifier)

local useSnapScroll = require(MediaGallery.Hooks.useSnapScroll)
local useAutoAdvance = require(MediaGallery.Hooks.useAutoAdvance)
local useTouchDragScroll = require(MediaGallery.Hooks.useTouchDragScroll)
local useCarouselGamepadInput = require(MediaGallery.Hooks.useCarouselGamepadInput)
local isAudioPlaybackAllowedForDevice = require(MediaGallery.isAudioPlaybackAllowedForDevice)

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppVideoLoadFailureFallback = SharedFlags4.FFlagLuaAppVideoLoadFailureFallback

local SLIDING_WINDOW_SIZE = MediaGalleryConstants.SLIDING_WINDOW_SIZE

local function getVisibleIndices(count: number, currentIndex: number)
	local visibleIndices = {}

	for i = 1, SLIDING_WINDOW_SIZE do
		local v3 = currentIndex + i - math.floor(SLIDING_WINDOW_SIZE / 2) - 1

		if v3 >= 1 and v3 <= count then
			table.insert(visibleIndices, v3)
		end
	end

	return visibleIndices
end

local function MediaGalleryCarousel(props)
	local v3 = useTokens()
	local itemPadding = props.itemPadding or v3.Padding.Medium
	local aspectRatio = props.aspectRatio or MediaGalleryConstants.ITEM_ASPECT_RATIO
	local cornerRadius = props.cornerRadius or v3.Radius.Medium
	local count = #props.items

	local v4 = React.useMemo(function(): boolean
		for _, item in props.items do
			if isValidIdentifier(item.videoId) and not isYouTubeVideo(item.assetTypeId) then
				return true
			end
		end

		return false
	end, { props.items })

	React.useEffect(function()
		if v4 and isAudioPlaybackAllowedForDevice() then
			task.delay(0, enableAudioPlaybackInApp)
		end
	end, { v4 })

	local onScrollComplete = React.useCallback(function(p: number, flag: boolean?)
		if props.onMediaChanged then
			props.onMediaChanged(p, flag)
		end
	end, { props.onMediaChanged })

	local v5 = useSnapScroll({
		itemCount = count,
		itemPadding = itemPadding,
		springConfig = MediaGalleryConstants.SPRING_CONFIG,
		targetIndex = props.startIndex,
		onScrollComplete = onScrollComplete
	})

	local visibleIndices = getVisibleIndices(count, v5.currentIndex)

	local toggleVideoPlaybackSignal = React.useMemo(function()
		return Signal.new()
	end, {})
	local toggleMuteSignal = React.useMemo(function()
		return Signal.new()
	end, {})
	local state, setState = React.useState(true)

	local state2, setState2 = React.useState(false)

	local v6 = React.useMemo(function()
		return VideoPlaybackCoordinator.new()
	end, {})
	local videoPlaybackCoordinator = props.videoPlaybackCoordinator or v6

	local state3 = nil
	local v7 = nil
	local state4 = nil
	local v8 = nil
	local v9, v10

	if FFlagLuaAppMediaGalleryGamepadSupport then
		local setState3
		state3, setState3 = React.useState(false)
		v7 = setState3

		v9 = React.useCallback(function(flag: boolean)
			v7(flag)
		end, {})
		local setState4
		state4, setState4 = React.useState(false)
		v8 = setState4

		v10 = React.useCallback(function(flag: boolean)
			v8(flag)
		end, {})

		React.useEffect(function()
			if not state2 then
				v7(false)
				v8(false)
			end
		end, { state2 })
	end

	local scrollRight = React.useCallback(function()
		v5.scrollInDirection("Right", true)
	end, { v5.scrollInDirection })

	local v11 = useAutoAdvance({
		enabled = props.autoAdvanceEnabled ~= false,
		intervalSeconds = props.autoAdvanceIntervalSeconds,
		galleryRef = v5.scrollingFrameRef,
		isMediaGalleryOccluded = props.isMediaGalleryOccluded,
		isAutoAdvanceTimerSuspended = state2,
		scrollRight = scrollRight
	})

	local v12 = React.useCallback(function(p, p2)
		v11.resetProgress()
		v5.scrollInDirection(p, p2)
	end, { v11.resetProgress, v5.scrollInDirection })
	local v13

	if FFlagLuaAppVideoLoadFailureFallback then
		v13 = React.useCallback(function()
			v12("Right", true)
		end, { v12 })
	end

	local v14 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local size_200 = v3.Size.Size_200

	local v15 = if v14 then v3.Size.Size_400 else v3.Size.Size_700
	local gradientOverlayHeight = props.gradientOverlayHeight or size_200 + v15 + v3.Size.Size_1000

	local videoAnalyticsContext = React.useMemo(function()
		return {
			videoAnalyticsData = {
				source = props.analyticsSource or "MediaGallery",
				sourceId = props.analyticsSourceId or nil
			},
			getPlaybackSessionId = function()
				return videoPlaybackCoordinator.currentPlaybackSessionId
			end
		}
	end, { props.analyticsSource, props.analyticsSourceId, videoPlaybackCoordinator })
	local onFullscreenToggle

	if props.fullscreenEnabled == false then
		onFullscreenToggle = nil
	else
		onFullscreenToggle = props.onFullscreenToggle
	end

	local v16 = React.useCallback(function()
		if onFullscreenToggle then
			onFullscreenToggle(v5.currentIndex)
		end
	end, { onFullscreenToggle, v5.currentIndex })

	local v17 = useLastInput()
	local v18

	if FFlagLuaAppMediaGalleryGamepadSupport and AppCommonLib.isSpatial() then
		v18 = Responsive.Input.Pointer
	else
		v18 = v17
	end

	local v19 = v18 == Responsive.Input.Directional
	local v20

	if defineFastFlag then
		v20 = useGamepadSupports(v, v18)
	else
		v20 = false
	end

	local v21

	if defineFastFlag then
		v21 = v19 and v20
	else
		v21 = v19
	end

	local v22 = v18 == Responsive.Input.Pointer or defineFastFlag and not v20
	local v23

	if FFlagLuaAppMediaGalleryGamepadSupport then
		local v24 = useGamepadSupports(v2, v17)
		v23 = v19 and v24
	else
		v23 = false
	end

	local v24 = React.useCallback(function()
		v12("Left")
	end, { v12 })

	local v25 = React.useCallback(function()
		v12("Right")
	end, { v12 })

	local selectionImageObject = useCursor(CursorType.Invisible)

	local v26 = React.useCallback(function()
		if state2 then
			toggleVideoPlaybackSignal:fire()
		end
	end, { state2, toggleVideoPlaybackSignal })

	local v27 = {
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

	if not FFlagLuaAppMediaGalleryGamepadSupport then
		state3 = nil
	end

	v27.isVideoPlaying = state3

	if not FFlagLuaAppMediaGalleryGamepadSupport then
		state4 = nil
	end

	v27.isVideoReady = state4
	v27.isMuted = state
	v27.toggleMuteSignal = toggleMuteSignal
	v27.onFullscreenToggle = v16
	v27.scrollLeft = v24
	v27.scrollRight = v25
	local ref = useCarouselGamepadInput(v27)

	useTouchDragScroll(v5.scrollingFrameRef, v5.scrollInDirection)

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, itemPadding)
		})
	}

	for _, visibleIndice in visibleIndices do
		local item = props.items[visibleIndice]

		if not item then
			continue
		end

		local content

		if isValidIdentifier(item.videoId) and not isYouTubeVideo(item.assetTypeId) then
			local itemProps = {}
			itemProps.videoId = item.videoId
			local videoAccessContext

			if FFlagLuaAppEdpMomentVideo then
				videoAccessContext = item.videoAccessContext
			end

			itemProps.videoAccessContext = videoAccessContext
			local trimStartTime

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				trimStartTime = item.trimStartTime
			end

			itemProps.trimStartTime = trimStartTime
			local trimEndTime

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				trimEndTime = item.trimEndTime
			end

			itemProps.trimEndTime = trimEndTime
			local musicAssetId

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				musicAssetId = item.musicAssetId
			end

			itemProps.musicAssetId = musicAssetId
			local musicStartTime

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				musicStartTime = item.musicStartTime
			end

			itemProps.musicStartTime = musicStartTime
			local attributionComponent

			if FFlagLuaAppEdpMomentVideo then
				attributionComponent = item.attributionComponent
			end

			itemProps.attributionComponent = attributionComponent
			itemProps.thumbnail = item.imageId
			itemProps.Size = UDim2.fromScale(1, 1)
			itemProps.itemIndex = visibleIndice
			itemProps.overlay = item.overlay
			itemProps.currentIndex = v5.currentIndex
			itemProps.videoPlaybackCoordinator = videoPlaybackCoordinator
			itemProps.toggleVideoPlaybackSignal = toggleVideoPlaybackSignal
			itemProps.toggleMuteSignal = toggleMuteSignal
			itemProps.onVideoEnded = v11.onVideoEnded
			local onVideoLoadFailed

			if FFlagLuaAppVideoLoadFailureFallback then
				onVideoLoadFailed = v13
			end

			itemProps.onVideoLoadFailed = onVideoLoadFailed
			itemProps.onVideoProgressChanged = v11.onVideoProgressChanged
			itemProps.onMutedChanged = setState
			local onPlayingChanged

			if FFlagLuaAppMediaGalleryGamepadSupport then
				onPlayingChanged = v9
			end

			itemProps.onPlayingChanged = onPlayingChanged
			local onVideoReadyChanged

			if FFlagLuaAppMediaGalleryGamepadSupport then
				onVideoReadyChanged = v10
			end

			itemProps.onVideoReadyChanged = onVideoReadyChanged
			itemProps.setIsVideoActive = setState2
			itemProps.isFullscreen = props.isFullscreen
			itemProps.isMediaGalleryOccluded = props.isMediaGalleryOccluded
			itemProps.videoAnalytics = props.videoAnalytics
			itemProps.videoAnalyticsContext = videoAnalyticsContext
			itemProps.videoDwellTimeHundredthsSec = props.videoDwellTimeHundredthsSec
			itemProps.videoVisiblePercent = props.videoVisiblePercent
			itemProps.autoplay = props.autoplay
			itemProps.muted = props.muted
			itemProps.looped = props.looped
			itemProps.showPlayButton = props.showPlayButton
			itemProps.showProgressBar = props.showProgressBar
			itemProps.cornerRadius = cornerRadius
			local onMediaResolved

			if visibleIndice == 1 then
				onMediaResolved = props.onMediaResolved
			end

			itemProps.onMediaResolved = onMediaResolved

			if item.itemProps then
				for k, itemProp in item.itemProps do
					itemProps[k] = itemProp
				end
			end

			content = React.createElement(MediaGalleryVideoItem, itemProps)
		else
			local itemProps = {
				imageId = item.imageId,
				isYouTubeVideo = isYouTubeVideo(item.assetTypeId),
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
			local onMediaResolved

			if visibleIndice == 1 then
				onMediaResolved = props.onMediaResolved
			end

			itemProps.onMediaResolved = onMediaResolved

			if item.itemProps then
				for k, itemProp in item.itemProps do
					itemProps[k] = itemProp
				end
			end

			content = React.createElement(MediaGalleryImageItem, itemProps)
		end

		children["Item" .. visibleIndice] = React.createElement("Frame", {
			LayoutOrder = visibleIndice,
			Size = v5.absoluteSizeBinding:map(function(vector2: Vector2)
				return UDim2.new(1, 0, 0, vector2.X / aspectRatio)
			end),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, { Content = content })
	end

	local size_500 = v3.Size.Size_500
	local size_350 = v3.Size.Size_350

	local createElement = React.createElement
	local v28 = {
		BackgroundTransparency = 1,
		Size = props.Size or UDim2.fromScale(1, 1),
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		ref = ref,
		AutoButtonColor = false,
		Text = "",
		[React.Event.Activated] = v26,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}

	if not props.isFullscreen then
		selectionImageObject = nil
	end

	v28.SelectionImageObject = selectionImageObject
	v28.SelectionGroup = true
	local children2 = {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			Selectable = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = v5.absoluteSizeBinding:map(function(vector2: Vector2)
				return UDim2.new(1, 0, 0, vector2.X / aspectRatio)
			end),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasPosition = v5.canvasPosition,
			ScrollingEnabled = false,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ClipsDescendants = true,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v5.onAbsoluteSizeChanged,
			ref = v5.scrollingFrameRef
		}, children),
		PageIndicators = 0,
		ScrollButtons = 0,
		FullscreenButton = 0,
		CarouselOverlay = 0,
		SizeConstraint = 0
	}
	local pageIndicators

	if count > 1 and props.showPageIndicators ~= false and not props.isFullscreen then
		local createElement2 = React.createElement
		local v29 = {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v3.Size.Size_200),
			Position = UDim2.new(0.5, 0, 1, -v15),
			ZIndex = 2
		}

		local v30 = {
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
		local pageLeftGamepadIcon

		if v21 then
			local createElement3 = React.createElement
			local v31

			if FFlagLuaAppMediaGalleryGamepadSupport then
				v31 = Enum.KeyCode.ButtonL2
			else
				v31 = Enum.KeyCode.ButtonL1
			end

			pageLeftGamepadIcon = createElement3("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				Image = UserInputService:GetImageForKeyCode(v31),
				ImageTransparency = v5.currentIndex <= 1 and 0.5 or nil,
				Size = UDim2.fromOffset(size_500, size_500)
			})
		end

		v30.PageLeftGamepadIcon = pageLeftGamepadIcon

		v30.Indicators = React.createElement(MediaGalleryPageIndicators, {
			numberOfItems = count,
			startIndex = props.startIndex or 1,
			currentItemProgressBinding = v11.progressBinding,
			mediaGalleryScrolledSignal = v5.scrolledSignal,
			useSpring = true,
			springConfig = MediaGalleryConstants.SPRING_CONFIG
		})
		local pageRightGamepadIcon

		if v21 then
			local createElement3 = React.createElement
			local v31

			if FFlagLuaAppMediaGalleryGamepadSupport then
				v31 = Enum.KeyCode.ButtonR2
			else
				v31 = Enum.KeyCode.ButtonR1
			end

			pageRightGamepadIcon = createElement3("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Image = UserInputService:GetImageForKeyCode(v31),
				ImageTransparency = count <= v5.currentIndex and 0.5 or nil,
				Size = UDim2.fromOffset(size_500, size_500)
			})
		end

		v30.PageRightGamepadIcon = pageRightGamepadIcon
		pageIndicators = createElement2("Frame", v29, v30)
	end

	children2.PageIndicators = pageIndicators
	local scrollButtons

	if v22 and not props.isMediaGalleryOccluded then
		local createElement2 = React.createElement
		local v29 = {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, props.isFullscreen and 0 or v3.Size.Size_1000, 1, 0),
			buttonOffsetFromEdge = 0,
			ZIndex = 10,
			leftScrollingEnabled = 0,
			rightScrollingEnabled = 0,
			handleScrollLeft = 0,
			handleScrollRight = 0
		}
		local buttonOffsetFromEdge

		if props.isFullscreen then
			buttonOffsetFromEdge = v3.Size.Size_500
		end

		v29.buttonOffsetFromEdge = buttonOffsetFromEdge

		v29.leftScrollingEnabled = v5.currentIndex > 1
		v29.rightScrollingEnabled = v5.currentIndex < count
		v29.handleScrollLeft = v24
		v29.handleScrollRight = v25
		scrollButtons = createElement2(CarouselScrollButtons, v29)
	end

	children2.ScrollButtons = scrollButtons
	local fullscreenButton

	if onFullscreenToggle and not (FFlagLuaAppMediaGalleryGamepadSupport and v23) then
		fullscreenButton = React.createElement(RoundIconButton, {
			icon = props.isFullscreen and "two-arrows-to-center" or "two-arrows-from-center",
			onActivated = v16,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v3.Size.Size_500, 0, v3.Size.Size_500),
			ZIndex = 4,
			Selectable = false
		})
	end

	children2.FullscreenButton = fullscreenButton
	local carouselOverlay

	if props.overlay then
		carouselOverlay = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 15 },
			{ Overlay = props.overlay }
		)
	end

	children2.CarouselOverlay = carouselOverlay

	children2.SizeConstraint = React.createElement("UISizeConstraint", {
		MinSize = v5.absoluteSizeBinding:map(function(vector2: Vector2)
			return Vector2.new(0, vector2.X / aspectRatio)
		end)
	})
	return {
		Carousel = createElement("TextButton", v28, children2)
	}
end

return React.memo(MediaGalleryCarousel)
