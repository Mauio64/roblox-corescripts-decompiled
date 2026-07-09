local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local VideoPlaybackCoordinator = require(Parent.VideoUtils).VideoPlaybackCoordinator

require(Parent.SduiCoreSystem)

local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local sendMediaGalleryMediaChanged = DiscoveryAnalytics.Events.sendMediaGalleryMediaChanged
local openYouTubeVideoEvent = DiscoveryAnalytics.Events.openYouTubeVideoEvent
local MediaGallery = require(Parent.MediaGallery)
local MediaGalleryCarousel = MediaGallery.MediaGalleryCarousel
local isValidIdentifier = MediaGallery.isValidIdentifier
local isYouTubeVideo = MediaGallery.isYouTubeVideo
local openYouTubeVideoWithAgeCheck = MediaGallery.openYouTubeVideoWithAgeCheck
local useFilteredMediaItems = MediaGallery.useFilteredMediaItems
local useMediaGalleryVideoAnalytics = MediaGallery.useMediaGalleryVideoAnalytics
local useMediaGalleryFullscreen = require(script.Parent.useMediaGalleryFullscreen)

local function SduiMediaGallery(t1: {[any]: any}) -- line: 70
	-- upvalues: React (copy), VideoPlaybackCoordinator (copy), useFilteredMediaItems (copy), useMediaGalleryVideoAnalytics (copy), openYouTubeVideoWithAgeCheck (copy), openYouTubeVideoEvent (copy), sendMediaGalleryMediaChanged (copy), isYouTubeVideo (copy), useMediaGalleryFullscreen (copy), isValidIdentifier (copy), MediaGalleryCarousel (copy)
	local eventIngest = t1.sduiContext.dependencies.eventIngest
	local appPage = t1.sduiContext.appPage
	local v19 = t1.universeId or ""
	local placeId = t1.placeId
	local v21 = t1.mediaGalleryAnalyticsContext or "ExperienceDetailsPage"
	local v22 = React.useMemo(function() -- line: 77
		-- upvalues: VideoPlaybackCoordinator (copy)
		return VideoPlaybackCoordinator.new()
	end, {})
	local v23 = useFilteredMediaItems(t1.items, v19, appPage)
	local v24 = useMediaGalleryVideoAnalytics(v19, placeId or "", v23)
	local dispatch = t1.sduiContext.dependencies.dispatch
	local v26 = React.useCallback(function(p1) -- line: 87
		-- upvalues: openYouTubeVideoWithAgeCheck (copy), dispatch (copy), openYouTubeVideoEvent (copy), eventIngest (copy), v19 (copy)
		openYouTubeVideoWithAgeCheck(p1.videoHash, p1.videoTitle, dispatch, function() -- line: 88
			-- upvalues: openYouTubeVideoEvent (copy), eventIngest (copy), p1 (copy), v19 (copy)
			openYouTubeVideoEvent(eventIngest, "gameDetailsAccordianImage", p1.videoTitle, p1.videoHash, v19, "play")
		end)
	end, {
		eventIngest,
		v19,
		dispatch
	})
	local v27 = React.useCallback(function(n1: number, b1: boolean?) -- line: 100
		-- upvalues: v23 (copy), sendMediaGalleryMediaChanged (copy), eventIngest (copy), v21 (copy), v19 (copy), isYouTubeVideo (copy), placeId (copy)
		local v37 = v23[n1]

		if not v37 then
			return
		end

		sendMediaGalleryMediaChanged(eventIngest, v21, v37, v19, b1, isYouTubeVideo(v37.assetTypeId), placeId)
	end, {
		v23,
		eventIngest,
		v19,
		placeId,
		v21
	})
	local v28 = React.useCallback(function(n2: number, b2: boolean?) -- line: 116
		-- upvalues: v23 (copy), sendMediaGalleryMediaChanged (copy), eventIngest (copy), v19 (copy), placeId (copy)
		local v40 = v23[n2]

		if not v40 then
			return
		end

		sendMediaGalleryMediaChanged(eventIngest, "MediaGallerySnappingFull", v40, v19, b2, nil, placeId)
	end, {
		v23,
		eventIngest,
		v19,
		placeId
	})
	local v29 = useMediaGalleryFullscreen({
		fullscreenEnabled = t1.fullscreenEnabled,
		filteredItems = v23,
		universeId = v19,
		placeId = placeId,
		mediaGalleryAnalyticsContext = v21,
		eventIngest = eventIngest,
		onYouTubeVideoPlay = v26,
		onFullscreenMediaChanged = v28,
		videoPlaybackCoordinator = v22,
		videoAnalytics = v24,
		cornerRadius = t1.cornerRadius,
		overlay = t1.overlay
	})
	local v30 = React.useMemo(function() -- line: 147
		-- upvalues: v23 (copy), t1 (copy), isValidIdentifier (copy), placeId (copy)
		if #v23 > 0 then
			return v23
		end

		local v41 = t1.fallbackImageId or (not isValidIdentifier(placeId) or `rbxthumb://type=GameThumbnail&id={ placeId }&w=768&h=432`)

		if v41 then
			return {{
				imageId = v41
			}}
		end

		return v23
	end, {
		v23,
		t1.fallbackImageId,
		placeId
	})

	React.useEffect(function() -- line: 161
		-- upvalues: v23 (copy), isYouTubeVideo (copy), openYouTubeVideoEvent (copy), eventIngest (copy), v19 (copy)
		for _, v43 in v23 do
			if isYouTubeVideo(v43.assetTypeId) and v43.videoHash then
				openYouTubeVideoEvent(eventIngest, "gameDetailsAccordianImage", v43.videoTitle, v43.videoHash, v19, "view")

				return
			end
		end
	end, {
		eventIngest,
		v23,
		v19
	})

	local v31 = #v30 == 0
	local v32 = React.useRef(false)
	local v33 = React.useCallback(function(b3: boolean) -- line: 180
		-- upvalues: v32 (copy), t1 (copy)
		if not v32.current and t1.onFirstMediaResolved then
			v32.current = true
			t1.onFirstMediaResolved(nil, nil, {
				metadata = {
					mediaFound = b3
				}
			})
		end
	end, { t1.onFirstMediaResolved })

	React.useEffect(function() -- line: 187
		-- upvalues: v31 (copy), v32 (copy), t1 (copy), v33 (copy)
		if v31 and (not v32.current and t1.onFirstMediaResolved) then
			v33(false)
		end
	end, {
		v31,
		v33,
		t1.onFirstMediaResolved
	})

	if v31 then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		MediaGallery = React.createElement(MediaGalleryCarousel, {
			items = v30,
			startIndex = v29.previewStartIndex,
			analyticsSourceId = v19,
			itemPadding = t1.itemPadding,
			aspectRatio = t1.aspectRatio,
			autoAdvanceEnabled = t1.autoAdvanceEnabled ~= false and not v29.isFullscreen,
			autoAdvanceIntervalSeconds = t1.autoAdvanceIntervalSeconds,
			showPageIndicators = t1.showPageIndicators,
			isMediaGalleryOccluded = v29.isFullscreen,
			autoplay = t1.autoplay,
			muted = t1.muted,
			looped = t1.looped,
			showPlayButton = t1.showPlayButton,
			showProgressBar = t1.showProgressBar,
			showGradient = t1.showGradient,
			gradientOverlayHeight = t1.gradientOverlayHeight,
			onYouTubeVideoPlay = v26,
			onFullscreenToggle = v29.onFullscreenToggle,
			onMediaChanged = v27,
			onMediaResolved = v33,
			videoPlaybackCoordinator = v22,
			videoAnalytics = v24,
			cornerRadius = t1.cornerRadius,
			fullscreenEnabled = t1.fullscreenEnabled,
			overlay = t1.overlay,
			Size = UDim2.fromScale(1, 0),
			AnchorPoint = t1.anchorPoint,
			Position = t1.position
		})
	})
end

return React.memo(SduiMediaGallery)
