local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View
local DetailsPageLayoutContext = require(Parent.AppBlox).DetailsPageLayout.DetailsPageLayoutContext
local sendMediaGalleryFullscreenEvent = require(Parent.DiscoveryAnalytics).Events.sendMediaGalleryFullscreenEvent

require(Parent.VideoUtils)

local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local MediaGallery = require(Parent.MediaGallery)
local MediaGalleryCarousel = MediaGallery.MediaGalleryCarousel
local MediaGalleryConstants = MediaGallery.MediaGalleryConstants
local isValidIdentifier = MediaGallery.isValidIdentifier
local isYouTubeVideo = MediaGallery.isYouTubeVideo
local ITEM_ASPECT_RATIO = MediaGalleryConstants.ITEM_ASPECT_RATIO

local function useMediaGalleryFullscreen(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), DetailsPageLayoutContext (copy), useOnNavigateBack (copy), isValidIdentifier (copy), isYouTubeVideo (copy), sendMediaGalleryFullscreenEvent (copy), View (copy), ITEM_ASPECT_RATIO (copy), MediaGalleryCarousel (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), SduiFocusTags (copy)
	local v20 = React.useContext(DetailsPageLayoutContext)
	local setFullscreenContent = v20.setFullscreenContent
	local setOnExitFullscreenOverlay = v20.setOnExitFullscreenOverlay
	local v23, v24 = React.useState(false)
	local v25, v26 = React.useState(1)
	local v27 = React.useRef(1)
	local v28 = React.useRef(nil)
	local v29 = React.useCallback(function() -- line: 68
		-- upvalues: v28 (copy), v27 (copy)
		if v28.current then
			v28.current(v27.current)
		end
	end, {})
	local v30 = useOnNavigateBack(v29)
	local v31 = React.useCallback(function(n1: number, b1: boolean?) -- line: 75
		-- upvalues: v27 (copy), t1 (copy)
		v27.current = n1

		if t1.onFullscreenMediaChanged then
			t1.onFullscreenMediaChanged(n1, b1)
		end
	end, { t1.onFullscreenMediaChanged })
	local v32 = React.useRef(setFullscreenContent)

	v32.current = setFullscreenContent

	local v33 = React.useRef(setOnExitFullscreenOverlay)

	v33.current = setOnExitFullscreenOverlay
	React.useEffect(function() -- line: 87
		-- upvalues: v32 (copy), v33 (copy)
		return function() -- line: 88
			-- upvalues: v32 (copy), v33 (copy)
			if v32.current then
				v32.current(nil)
			end

			if v33.current then
				v33.current(nil)
			end
		end
	end, {})

	local v34 = React.useCallback(function(n2: number) -- line: 99
		-- upvalues: v28 (copy), v26 (copy), setFullscreenContent (copy), setOnExitFullscreenOverlay (copy), v24 (copy), t1 (copy), isValidIdentifier (copy), isYouTubeVideo (copy), sendMediaGalleryFullscreenEvent (copy)
		v28.current = nil
		v26(n2)

		if setFullscreenContent then
			setFullscreenContent(nil)
		end

		if setOnExitFullscreenOverlay then
			setOnExitFullscreenOverlay(nil)
		end

		v24(false)

		local v41 = t1.filteredItems[n2]
		local v42 = v41 ~= nil and (isValidIdentifier(v41.videoId) or isYouTubeVideo(v41.assetTypeId))

		sendMediaGalleryFullscreenEvent(t1.eventIngest, t1.mediaGalleryAnalyticsContext, "mediaGalleryExitFullscreen", t1.placeId, t1.universeId, n2, v42)
	end, {
		setFullscreenContent,
		setOnExitFullscreenOverlay,
		t1.filteredItems,
		t1.eventIngest,
		t1.placeId,
		t1.universeId,
		t1.mediaGalleryAnalyticsContext
	})
	local v35 = React.useCallback(function() -- line: 132
		-- upvalues: v28 (copy), v27 (copy)
		if v28.current then
			v28.current(v27.current)
		end
	end, {})
	local v36 = React.useCallback(function(n3: number) -- line: 139
		-- upvalues: t1 (copy), setFullscreenContent (copy), v28 (copy), v34 (copy), v26 (copy), v27 (copy), v24 (copy), setOnExitFullscreenOverlay (copy), v35 (copy), React (copy), View (copy), ITEM_ASPECT_RATIO (copy), MediaGalleryCarousel (copy), v31 (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), v30 (copy), SduiFocusTags (copy), isValidIdentifier (copy), isYouTubeVideo (copy), sendMediaGalleryFullscreenEvent (copy)
		if t1.fullscreenEnabled == false or not setFullscreenContent then
			return
		end

		v28.current = v34
		v26(n3)
		v27.current = n3
		v24(true)

		if setOnExitFullscreenOverlay then
			setOnExitFullscreenOverlay(function() -- line: 148
				-- upvalues: v35 (copy)
				return v35
			end)
		end

		local v44, v45 = React.createBinding(UDim2.fromOffset(0, 0))
		local v46 = React.createElement(View, {
			tag = "size-full bg-surface-0",
			onAbsoluteSizeChanged = function(p1) -- line: 157
				-- upvalues: ITEM_ASPECT_RATIO (copy), v45 (copy)
				local AbsoluteSizeX = p1.AbsoluteSize.X
				local AbsoluteSizeY = p1.AbsoluteSize.Y
				local v52 = math.floor(AbsoluteSizeY * ITEM_ASPECT_RATIO)

				if AbsoluteSizeX < v52 then
					v52 = AbsoluteSizeX
					AbsoluteSizeY = math.floor(v52 / ITEM_ASPECT_RATIO)
				end

				v45(UDim2.fromOffset(v52, AbsoluteSizeY))
			end
		}, {
			MediaGallery = React.createElement(MediaGalleryCarousel, {
				itemPadding = 0,
				isFullscreen = true,
				showGradient = false,
				showPlayButton = true,
				showProgressBar = true,
				items = t1.filteredItems,
				Size = v44,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				startIndex = n3,
				onYouTubeVideoPlay = t1.onYouTubeVideoPlay,
				onFullscreenToggle = v34,
				onMediaChanged = v31,
				videoPlaybackCoordinator = t1.videoPlaybackCoordinator,
				videoAnalytics = t1.videoAnalytics,
				analyticsSourceId = t1.universeId,
				cornerRadius = t1.cornerRadius,
				overlay = t1.overlay
			})
		})

		setFullscreenContent(React.createElement(FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			NavigateBackFrame = React.createElement("Frame", {
				ref = v30,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[React.Tag] = SduiFocusTags.SuppressBindings
			}, {
				Content = v46
			})
		}))

		local v47 = t1.filteredItems[n3]
		local v48 = v47 ~= nil and (isValidIdentifier(v47.videoId) or isYouTubeVideo(v47.assetTypeId))

		sendMediaGalleryFullscreenEvent(t1.eventIngest, t1.mediaGalleryAnalyticsContext, "mediaGalleryEnterFullscreen", t1.placeId, t1.universeId, n3, v48)
	end, {
		t1.fullscreenEnabled,
		setFullscreenContent,
		setOnExitFullscreenOverlay,
		v35,
		t1.filteredItems,
		t1.universeId,
		v34,
		t1.onYouTubeVideoPlay,
		t1.videoPlaybackCoordinator,
		t1.videoAnalytics,
		v31,
		t1.cornerRadius,
		t1.overlay,
		t1.eventIngest,
		t1.placeId,
		t1.mediaGalleryAnalyticsContext,
		v30
	})
	local v37 = math.clamp(v25, 1, (math.max(1, #t1.filteredItems)))

	return {
		isFullscreen = v23,
		onFullscreenToggle = v36,
		previewStartIndex = v37
	}
end

return useMediaGalleryFullscreen
