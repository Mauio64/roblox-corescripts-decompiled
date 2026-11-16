local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local videoPlaybackCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/VideoUtils").VideoPlaybackCoordinator

local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").getSduiComponentWrapper

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics")

local sendMediaGalleryMediaChanged = DiscoveryAnalytics.Events.sendMediaGalleryMediaChanged
local openYouTubeVideoEvent = DiscoveryAnalytics.Events.openYouTubeVideoEvent

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/MediaGallery")
local mediaGalleryCarousel = module3.MediaGalleryCarousel
local isValidIdentifier = module3.isValidIdentifier
local isYouTubeVideo = module3.isYouTubeVideo
local openYouTubeVideoWithAgeCheck = module3.openYouTubeVideoWithAgeCheck
local useFilteredMediaItems = module3.useFilteredMediaItems
local useMediaGalleryVideoAnalytics = module3.useMediaGalleryVideoAnalytics

local useMediaGalleryFullscreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useMediaGalleryFullscreen")

local fFlagLuaAppEdpMomentVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppEdpMomentVideo

local function SduiMediaGallery(props)
	local eventIngest = props.sduiContext.dependencies.eventIngest
	local appPage = props.sduiContext.appPage
	local universeId = props.universeId or ""
	local placeId = props.placeId
	local mediaGalleryAnalyticsContext = props.mediaGalleryAnalyticsContext or "ExperienceDetailsPage"

	local v5 = React.useMemo(function()
		return videoPlaybackCoordinator.new()
	end, {})
	local v6

	if fFlagLuaAppEdpMomentVideo then
		v6 = React.useMemo(function()
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

	if not fFlagLuaAppEdpMomentVideo then
		v6 = props.items
	end

	local v8 = useFilteredMediaItems(v6, universeId, appPage)

	local v9 = useMediaGalleryVideoAnalytics(universeId, placeId or "", v8)

	local dispatch = props.sduiContext.dependencies.dispatch

	local v10 = React.useCallback(function(p2)
		openYouTubeVideoWithAgeCheck(p2.videoHash, p2.videoTitle, dispatch, function()
			openYouTubeVideoEvent(
				eventIngest,
				"gameDetailsAccordianImage",
				p2.videoTitle,
				p2.videoHash,
				universeId,
				"play"
			)
		end)
	end, { eventIngest, universeId, dispatch })

	local v11 = React.useCallback(function(p2, p3)
		local v12 = v8[p2]

		if not v12 then
			return
		end

		sendMediaGalleryMediaChanged(
			eventIngest,
			mediaGalleryAnalyticsContext,
			v12,
			universeId,
			p3,
			isYouTubeVideo(v12.assetTypeId),
			placeId
		)
	end, { v8, eventIngest, universeId, placeId, mediaGalleryAnalyticsContext })

	local v12 = React.useCallback(function(p2, p3)
		local v13 = v8[p2]

		if not v13 then
			return
		end

		sendMediaGalleryMediaChanged(
			eventIngest,
			"MediaGallerySnappingFull",
			v13,
			universeId,
			p3,
			nil,
			placeId
		)
	end, { v8, eventIngest, universeId, placeId })

	local v13 = useMediaGalleryFullscreen({
		fullscreenEnabled = props.fullscreenEnabled,
		filteredItems = v8,
		universeId = universeId,
		placeId = placeId,
		mediaGalleryAnalyticsContext = mediaGalleryAnalyticsContext,
		eventIngest = eventIngest,
		onYouTubeVideoPlay = v10,
		onFullscreenMediaChanged = v12,
		videoPlaybackCoordinator = v5,
		videoAnalytics = v9,
		cornerRadius = props.cornerRadius,
		overlay = props.overlay
	})

	local v14 = React.useMemo(function()
		if #v8 > 0 then
			return v8
		end

		local v15 = props.fallbackImageId

		if not v15 and isValidIdentifier(placeId) then
			v15 = `rbxthumb://type=GameThumbnail&id={placeId}&w=768&h=432`
		end

		if v15 then
			return {
				{ imageId = v15 }
			}
		end

		return v8
	end, { v8, props.fallbackImageId, placeId })

	React.useEffect(function()
		for k, v15 in v8 do
			if isYouTubeVideo(v15.assetTypeId) and v15.videoHash then
				openYouTubeVideoEvent(
					eventIngest,
					"gameDetailsAccordianImage",
					v15.videoTitle,
					v15.videoHash,
					universeId,
					"view"
				)
				break
			end
		end
	end, { eventIngest, v8, universeId })

	local v15 = #v14 == 0

	local ref = React.useRef(false)
	local v16 = React.useCallback(function(p2)
		if not ref.current and props.onFirstMediaResolved then
			ref.current = true
			props.onFirstMediaResolved(nil, nil, {
				metadata = { mediaFound = p2 }
			})
		end
	end, { props.onFirstMediaResolved })

	React.useEffect(function()
		if v15 and not ref.current and props.onFirstMediaResolved then
			v16(false)
		end
	end, { v15, v16, props.onFirstMediaResolved })

	if v15 then
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
		MediaGallery = React.createElement(mediaGalleryCarousel, {
			items = v14,
			startIndex = v13.previewStartIndex,
			analyticsSourceId = universeId,
			itemPadding = props.itemPadding,
			aspectRatio = props.aspectRatio,
			autoAdvanceEnabled = props.autoAdvanceEnabled ~= false and not v13.isFullscreen,
			autoAdvanceIntervalSeconds = props.autoAdvanceIntervalSeconds,
			showPageIndicators = props.showPageIndicators,
			isMediaGalleryOccluded = v13.isFullscreen,
			autoplay = props.autoplay,
			muted = props.muted,
			looped = props.looped,
			showPlayButton = props.showPlayButton,
			showProgressBar = props.showProgressBar,
			showGradient = props.showGradient,
			gradientOverlayHeight = props.gradientOverlayHeight,
			onYouTubeVideoPlay = v10,
			onFullscreenToggle = v13.onFullscreenToggle,
			onMediaChanged = v11,
			onMediaResolved = v16,
			videoPlaybackCoordinator = v5,
			videoAnalytics = v9,
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
