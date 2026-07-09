local UserInputService = game:GetService("UserInputService")
local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local Foundation = require(MediaGalleryParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local CursorType = Foundation.Enums.CursorType
local Signal = require(MediaGalleryParent.AppCommonLib).Signal
local FFlagSduiExperienceDetailsSupport = require(MediaGalleryParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local Responsive = require(MediaGalleryParent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local v15 = game:DefineFastFlag("LuaAppEnableVRMediaGalleryScrollButtons", false)
local CarouselScrollButtons = require(MediaGalleryParent.CollectionViews).CarouselScrollButtons
local VideoUtils = require(MediaGalleryParent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local RoundIconButton = VideoUtils.RoundIconButton
local enableAudioPlaybackInApp = require(MediaGalleryParent.MediaPlayback).enableAudioPlaybackInApp
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
local SLIDING_WINDOW_SIZE = MediaGalleryConstants.SLIDING_WINDOW_SIZE

local function getVisibleIndices(n1: number, n2: number) -- line: 49
	-- upvalues: SLIDING_WINDOW_SIZE (copy)
	local t1 = {}

	for i = 1, SLIDING_WINDOW_SIZE do
		local v39 = n2 + i - math.floor(SLIDING_WINDOW_SIZE / 2) - 1

		if v39 >= 1 and v39 <= n1 then
			table.insert(t1, v39)
		end
	end

	return t1
end
local function MediaGalleryCarousel(t2: {[any]: any}) -- line: 112
	-- upvalues: useTokens (copy), MediaGalleryConstants (copy), React (copy), isValidIdentifier (copy), isYouTubeVideo (copy), isAudioPlaybackAllowedForDevice (copy), enableAudioPlaybackInApp (copy), useSnapScroll (copy), getVisibleIndices (copy), Signal (copy), VideoPlaybackCoordinator (copy), useAutoAdvance (copy), useBreakpointXOrSmaller (copy), Responsive (copy), useLastInput (copy), v15 (copy), useIsSpatial (copy), useCursor (copy), CursorType (copy), useCarouselGamepadInput (copy), useTouchDragScroll (copy), FFlagSduiExperienceDetailsSupport (copy), MediaGalleryVideoItem (copy), MediaGalleryImageItem (copy), UserInputService (copy), MediaGalleryPageIndicators (copy), CarouselScrollButtons (copy), RoundIconButton (copy)
	local v41 = useTokens()
	local v42 = t2.itemPadding or v41.Padding.Medium
	local v43 = t2.aspectRatio or MediaGalleryConstants.ITEM_ASPECT_RATIO
	local v44 = t2.cornerRadius or v41.Radius.Medium
	local v45 = #t2.items
	local v46 = React.useMemo(function() -- line: 119
		-- upvalues: t2 (copy), isValidIdentifier (copy), isYouTubeVideo (copy)
		for _, v91 in t2.items do
			if isValidIdentifier(v91.videoId) and not isYouTubeVideo(v91.assetTypeId) then
				return true
			end
		end

		return false
	end, { t2.items })

	React.useEffect(function() -- line: 128
		-- upvalues: v46 (copy), isAudioPlaybackAllowedForDevice (copy), enableAudioPlaybackInApp (copy)
		if v46 and isAudioPlaybackAllowedForDevice() then
			task.delay(0, enableAudioPlaybackInApp)
		end
	end, { v46 })

	local v47 = React.useCallback(function(n3: number, b1: boolean?) -- line: 134
		-- upvalues: t2 (copy)
		if t2.onMediaChanged then
			t2.onMediaChanged(n3, b1)
		end
	end, { t2.onMediaChanged })
	local v48 = useSnapScroll({
		itemCount = v45,
		itemPadding = v42,
		springConfig = MediaGalleryConstants.SPRING_CONFIG,
		targetIndex = t2.startIndex,
		onScrollComplete = v47
	})
	local v49 = getVisibleIndices(v45, v48.currentIndex)
	local v50 = React.useMemo(function() -- line: 151
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v51 = React.useMemo(function() -- line: 154
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v52, v53 = React.useState(true)
	local v54, v55 = React.useState(false)
	local v56 = React.useMemo(function() -- line: 161
		-- upvalues: VideoPlaybackCoordinator (copy)
		return VideoPlaybackCoordinator.new()
	end, {})
	local v57 = t2.videoPlaybackCoordinator or v56
	local v58 = React.useCallback(function() -- line: 166
		-- upvalues: v48 (copy)
		v48.scrollInDirection("Right", true)
	end, { v48.scrollInDirection })
	local v59 = useAutoAdvance({
		enabled = t2.autoAdvanceEnabled ~= false,
		intervalSeconds = t2.autoAdvanceIntervalSeconds,
		galleryRef = v48.scrollingFrameRef,
		isMediaGalleryOccluded = t2.isMediaGalleryOccluded,
		isAutoAdvanceTimerSuspended = v54,
		scrollRight = v58
	})
	local v60 = React.useCallback(function(p1, p2) -- line: 179
		-- upvalues: v59 (copy), v48 (copy)
		v59.resetProgress()
		v48.scrollInDirection(p1, p2)
	end, {
		v59.resetProgress,
		v48.scrollInDirection
	})
	local v61 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local Size_200 = v41.Size.Size_200
	local v63 = if not v61 then v41.Size.Size_700 else v41.Size.Size_400
	local v64 = t2.gradientOverlayHeight or Size_200 + v63 + v41.Size.Size_1000
	local v65 = React.useMemo(function() -- line: 193
		-- upvalues: t2 (copy), v57 (copy)
		local v96 = t2.analyticsSource or "MediaGallery"
		local analyticsSourceId = t2.analyticsSourceId

		return {
			videoAnalyticsData = {
				source = v96,
				sourceId = analyticsSourceId or nil
			},
			getPlaybackSessionId = function() -- line: 204
				-- upvalues: v57 (copy)
				return v57.currentPlaybackSessionId
			end
		}
	end, {
		t2.analyticsSource,
		t2.analyticsSourceId,
		v57
	})
	local v66 = if t2.fullscreenEnabled ~= false then t2.onFullscreenToggle else nil
	local v67 = React.useCallback(function() -- line: 212
		-- upvalues: v66 (copy), v48 (copy)
		if v66 then
			v66(v48.currentIndex)
		end
	end, {
		v66,
		v48.currentIndex
	})
	local v68 = useLastInput()
	local v69 = nil

	if v15 then
		v69 = useIsSpatial()
	end

	local v70 = v68 == Responsive.Input.Directional
	local v71 = v68 == Responsive.Input.Pointer or v15 and v69
	local v72 = React.useCallback(function() -- line: 227
		-- upvalues: v60 (copy)
		v60("Left")
	end, { v60 })
	local v73 = React.useCallback(function() -- line: 231
		-- upvalues: v60 (copy)
		v60("Right")
	end, { v60 })
	local v74 = useCursor(CursorType.Invisible)
	local v75 = React.useCallback(function() -- line: 237
		-- upvalues: v54 (copy), v50 (copy)
		if v54 then
			v50:fire()
		end
	end, {
		v54,
		v50
	})
	local v76 = useCarouselGamepadInput({
		isFullscreen = t2.isFullscreen,
		isVideoActive = v54,
		isMuted = v52,
		toggleMuteSignal = v51,
		onFullscreenToggle = v67,
		scrollLeft = v72,
		scrollRight = v73
	})

	useTouchDragScroll(v48.scrollingFrameRef, v48.scrollInDirection)

	local t3 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v42)
		})
	}

	for _, v79 in v49 do
		local v80 = t2.items[v79]

		if v80 then
			local v84

			if isValidIdentifier(v80.videoId) and not isYouTubeVideo(v80.assetTypeId) then
				local t4 = {
					videoId = v80.videoId,
					thumbnail = v80.imageId,
					Size = UDim2.fromScale(1, 1),
					itemIndex = v79,
					overlay = v80.overlay,
					currentIndex = v48.currentIndex,
					videoPlaybackCoordinator = v57,
					toggleVideoPlaybackSignal = v50,
					toggleMuteSignal = v51,
					onVideoEnded = v59.onVideoEnded,
					onVideoProgressChanged = v59.onVideoProgressChanged,
					onMutedChanged = v53,
					setIsVideoActive = v55,
					isFullscreen = t2.isFullscreen,
					isMediaGalleryOccluded = t2.isMediaGalleryOccluded,
					videoAnalytics = t2.videoAnalytics,
					videoAnalyticsContext = v65,
					videoDwellTimeHundredthsSec = t2.videoDwellTimeHundredthsSec,
					videoVisiblePercent = t2.videoVisiblePercent,
					autoplay = t2.autoplay,
					muted = t2.muted,
					looped = t2.looped,
					showPlayButton = t2.showPlayButton,
					showProgressBar = t2.showProgressBar,
					cornerRadius = v44,
					onMediaResolved = if not FFlagSduiExperienceDetailsSupport or v79 ~= 1 then nil else t2.onMediaResolved
				}

				if v80.itemProps then
					for v82, v83 in v80.itemProps do
						t4[v82] = v83
					end
				end

				v84 = React.createElement(MediaGalleryVideoItem, t4)
			else
				local t5 = {
					imageId = v80.imageId,
					isYouTubeVideo = isYouTubeVideo(v80.assetTypeId),
					videoHash = v80.videoHash,
					videoTitle = v80.videoTitle,
					Size = UDim2.fromScale(1, 1),
					itemIndex = v79,
					overlay = v80.overlay,
					cornerRadius = v44,
					showGradient = t2.showGradient,
					onYouTubeVideoPlay = t2.onYouTubeVideoPlay,
					gradientOverlayHeight = v64,
					onMediaResolved = if not FFlagSduiExperienceDetailsSupport or v79 ~= 1 then nil else t2.onMediaResolved
				}

				if v80.itemProps then
					for v86, v87 in v80.itemProps do
						t5[v86] = v87
					end
				end

				v84 = React.createElement(MediaGalleryImageItem, t5)
			end

			t3["Item" .. v79] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = v79,
				Size = v48.absoluteSizeBinding:map(function(vector2: Vector2) -- line: 333
					-- upvalues: v43 (copy)
					return UDim2.new(1, 0, 0, vector2.X / v43)
				end)
			}, {
				Content = v84
			})
		end
	end

	local Size_500 = v41.Size.Size_500
	local Size_350 = v41.Size.Size_350

	return {
		Carousel = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = t2.Size or UDim2.fromScale(1, 1),
			AnchorPoint = t2.AnchorPoint,
			Position = t2.Position,
			ref = v76,
			AutoButtonColor = false,
			Text = "",
			[React.Event.Activated] = v75,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionImageObject = if not t2.isFullscreen then nil else v74,
			SelectionGroup = true
		}, {
			ScrollingFrame = React.createElement("ScrollingFrame", {
				Selectable = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = v48.absoluteSizeBinding:map(function(vector2: Vector2) -- line: 363
					-- upvalues: v43 (copy)
					return UDim2.new(1, 0, 0, vector2.X / v43)
				end),
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasPosition = v48.canvasPosition,
				ScrollingEnabled = false,
				ScrollBarImageTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.X,
				ClipsDescendants = true,
				ZIndex = 1,
				[React.Change.AbsoluteSize] = v48.onAbsoluteSizeChanged,
				ref = v48.scrollingFrameRef
			}, t3),
			PageIndicators = if not (v45 > 1) or (t2.showPageIndicators == false or t2.isFullscreen) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromOffset(0, v41.Size.Size_200),
				Position = UDim2.new(0.5, 0, 1, -v63)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, Size_350),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				PageLeftGamepadIcon = if not v70 then nil else React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonL1),
					ImageTransparency = if not (v48.currentIndex <= 1) then nil else 0.5,
					Size = UDim2.fromOffset(Size_500, Size_500)
				}),
				Indicators = React.createElement(MediaGalleryPageIndicators, {
					useSpring = true,
					numberOfItems = v45,
					startIndex = t2.startIndex or 1,
					currentItemProgressBinding = v59.progressBinding,
					mediaGalleryScrolledSignal = v48.scrolledSignal,
					springConfig = MediaGalleryConstants.SPRING_CONFIG
				}),
				PageRightGamepadIcon = if not v70 then nil else React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonR1),
					ImageTransparency = if not (v45 <= v48.currentIndex) then nil else 0.5,
					Size = UDim2.fromOffset(Size_500, Size_500)
				})
			}),
			ScrollButtons = if not v71 or t2.isMediaGalleryOccluded then nil else React.createElement(CarouselScrollButtons, {
				ZIndex = 10,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.new(1, if not t2.isFullscreen then v41.Size.Size_1000 else 0, 1, 0),
				buttonOffsetFromEdge = if not t2.isFullscreen then nil else v41.Size.Size_500,
				leftScrollingEnabled = v48.currentIndex > 1,
				rightScrollingEnabled = v45 > v48.currentIndex,
				handleScrollLeft = v72,
				handleScrollRight = v73
			}),
			FullscreenButton = if not v66 then nil else React.createElement(RoundIconButton, {
				ZIndex = 4,
				Selectable = false,
				icon = not t2.isFullscreen and "two-arrows-from-center" or "two-arrows-to-center",
				onActivated = v67,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -v41.Size.Size_500, 0, v41.Size.Size_500)
			}),
			CarouselOverlay = if not t2.overlay then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 15,
				Size = UDim2.fromScale(1, 1)
			}, {
				Overlay = t2.overlay
			}),
			SizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = v48.absoluteSizeBinding:map(function(vector2: Vector2) -- line: 458
					-- upvalues: v43 (copy)
					return Vector2.new(0, vector2.X / v43)
				end)
			})
		})
	}
end

return React.memo(MediaGalleryCarousel)
