local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)

local VideoUtils = require(parent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)

local sendMediaGalleryMediaChanged = DiscoveryAnalytics.Events.sendMediaGalleryMediaChanged
local openYouTubeVideoEvent = DiscoveryAnalytics.Events.openYouTubeVideoEvent

local MediaGallery = require(parent.MediaGallery)
local MediaGalleryCarousel = MediaGallery.MediaGalleryCarousel
local isValidIdentifier = MediaGallery.isValidIdentifier
local isYouTubeVideo = MediaGallery.isYouTubeVideo
local openYouTubeVideoWithAgeCheck = MediaGallery.openYouTubeVideoWithAgeCheck
local useFilteredMediaItems = MediaGallery.useFilteredMediaItems
local useMediaGalleryVideoAnalytics = MediaGallery.useMediaGalleryVideoAnalytics

local useMediaGalleryFullscreen = require(script.Parent.useMediaGalleryFullscreen)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMomentVideo = SharedFlags.FFlagLuaAppEdpMomentVideo

local function SduiMediaGallery(props)
	local eventIngest = props.sduiContext.dependencies.eventIngest
	local appPage = props.sduiContext.appPage
	local universeId = props.universeId or ""
	local placeId = props.placeId
	local mediaGalleryAnalyticsContext = props.mediaGalleryAnalyticsContext or "ExperienceDetailsPage"

	local videoPlaybackCoordinator = React.useMemo(function()
		return VideoPlaybackCoordinator.new()
	end, {})
	local v

	if FFlagLuaAppEdpMomentVideo then
		v = React.useMemo(function()
			local result = table.create(#props.items)

			for k, item in props.items do
				local attributionComponentConfig = item.attributionComponentConfig

				if attributionComponentConfig == nil then
					result[k] = item
				else
					local clone = table.clone(item)
					clone.attributionComponent = React.createElement(
						getSduiComponentWrapper(attributionComponentConfig),
						{
							componentConfig = attributionComponentConfig,
							sduiContext = props.sduiContext,
							debugName = "SduiMediaGallery.AttributionComponent"
						}
					)

					result[k] = clone
				end
			end

			return result
		end, { props.items, props.sduiContext })
	end

	if not FFlagLuaAppEdpMomentVideo then
		v = props.items
	end

	local filteredItems = useFilteredMediaItems(v, universeId, appPage)

	local videoAnalytics = useMediaGalleryVideoAnalytics(universeId, placeId or "", filteredItems)

	local dispatch = props.sduiContext.dependencies.dispatch

	local onYouTubeVideoPlay = React.useCallback(function(p)
		openYouTubeVideoWithAgeCheck(p.videoHash, p.videoTitle, dispatch, function()
			openYouTubeVideoEvent(
				eventIngest,
				"gameDetailsAccordianImage",
				p.videoTitle,
				p.videoHash,
				universeId,
				"play"
			)
		end)
	end, { eventIngest, universeId, dispatch })

	local onMediaChanged = React.useCallback(function(p: number, flag: boolean?)
		local v2 = filteredItems[p]

		if not v2 then
			return
		end

		sendMediaGalleryMediaChanged(
			eventIngest,
			mediaGalleryAnalyticsContext,
			v2,
			universeId,
			flag,
			isYouTubeVideo(v2.assetTypeId),
			placeId
		)
	end, { filteredItems, eventIngest, universeId, placeId, mediaGalleryAnalyticsContext })

	local onFullscreenMediaChanged = React.useCallback(function(p: number, flag: boolean?)
		local v2 = filteredItems[p]

		if not v2 then
			return
		end

		sendMediaGalleryMediaChanged(eventIngest, "MediaGallerySnappingFull", v2, universeId, flag, nil, placeId)
	end, { filteredItems, eventIngest, universeId, placeId })

	local v2 = useMediaGalleryFullscreen({
		fullscreenEnabled = props.fullscreenEnabled,
		filteredItems = filteredItems,
		universeId = universeId,
		placeId = placeId,
		mediaGalleryAnalyticsContext = mediaGalleryAnalyticsContext,
		eventIngest = eventIngest,
		onYouTubeVideoPlay = onYouTubeVideoPlay,
		onFullscreenMediaChanged = onFullscreenMediaChanged,
		videoPlaybackCoordinator = videoPlaybackCoordinator,
		videoAnalytics = videoAnalytics,
		cornerRadius = props.cornerRadius,
		overlay = props.overlay
	})

	local items = React.useMemo(function()
		if #filteredItems > 0 then
			return filteredItems
		end

		local imageId = props.fallbackImageId

		if not imageId and isValidIdentifier(placeId) then
			imageId = `rbxthumb://type=GameThumbnail&id={placeId}&w=768&h=432`
		end

		if imageId then
			return {
				{ imageId = imageId }
			}
		end

		return filteredItems
	end, { filteredItems, props.fallbackImageId, placeId })

	React.useEffect(function()
		for _, v3 in filteredItems do
			if isYouTubeVideo(v3.assetTypeId) and v3.videoHash then
				openYouTubeVideoEvent(
					eventIngest,
					"gameDetailsAccordianImage",
					v3.videoTitle,
					v3.videoHash,
					universeId,
					"view"
				)
				break
			end
		end
	end, { eventIngest, filteredItems, universeId })

	local v3 = #items == 0

	local ref = React.useRef(false)
	local onMediaResolved = React.useCallback(function(mediaFound: boolean)
		if not ref.current and props.onFirstMediaResolved then
			ref.current = true
			props.onFirstMediaResolved(nil, nil, {
				metadata = { mediaFound = mediaFound }
			})
		end
	end, { props.onFirstMediaResolved })

	React.useEffect(function()
		if v3 and not ref.current and props.onFirstMediaResolved then
			onMediaResolved(false)
		end
	end, { v3, onMediaResolved, props.onFirstMediaResolved })

	if v3 then
		return nil
	end

	return React.createElement("Frame", {
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, {
		MediaGallery = React.createElement(MediaGalleryCarousel, {
			items = items,
			startIndex = v2.previewStartIndex,
			analyticsSourceId = universeId,
			itemPadding = props.itemPadding,
			aspectRatio = props.aspectRatio,
			autoAdvanceEnabled = props.autoAdvanceEnabled ~= false and not v2.isFullscreen,
			autoAdvanceIntervalSeconds = props.autoAdvanceIntervalSeconds,
			showPageIndicators = props.showPageIndicators,
			isMediaGalleryOccluded = v2.isFullscreen,
			autoplay = props.autoplay,
			muted = props.muted,
			looped = props.looped,
			showPlayButton = props.showPlayButton,
			showProgressBar = props.showProgressBar,
			showGradient = props.showGradient,
			gradientOverlayHeight = props.gradientOverlayHeight,
			onYouTubeVideoPlay = onYouTubeVideoPlay,
			onFullscreenToggle = v2.onFullscreenToggle,
			onMediaChanged = onMediaChanged,
			onMediaResolved = onMediaResolved,
			videoPlaybackCoordinator = videoPlaybackCoordinator,
			videoAnalytics = videoAnalytics,
			cornerRadius = props.cornerRadius,
			fullscreenEnabled = props.fullscreenEnabled,
			overlay = props.overlay,
			Size = UDim2.fromScale(1, 0),
			AnchorPoint = props.anchorPoint,
			Position = props.position
		})
	})
end

return React.memo(SduiMediaGallery)
