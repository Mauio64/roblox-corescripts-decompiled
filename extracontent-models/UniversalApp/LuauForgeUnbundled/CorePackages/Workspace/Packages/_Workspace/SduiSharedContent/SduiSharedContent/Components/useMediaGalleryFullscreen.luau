local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").View

local detailsPageLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox").DetailsPageLayout.DetailsPageLayoutContext

local sendMediaGalleryFullscreenEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics").Events.sendMediaGalleryFullscreenEvent

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/VideoUtils")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities")
local sduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/MediaGallery")
local mediaGalleryCarousel = module4.MediaGalleryCarousel
local mediaGalleryConstants = module4.MediaGalleryConstants
local isValidIdentifier = module4.isValidIdentifier
local isYouTubeVideo = module4.isYouTubeVideo

local ITEM_ASPECT_RATIO = mediaGalleryConstants.ITEM_ASPECT_RATIO

local function useMediaGalleryFullscreen(data)
	local v5 = React.useContext(detailsPageLayoutContext)
	local setFullscreenContent = v5.setFullscreenContent
	local setOnExitFullscreenOverlay = v5.setOnExitFullscreenOverlay

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(1)

	local ref = React.useRef(1)

	local ref2 = React.useRef(nil)
	local v7 = useOnNavigateBack((React.useCallback(function()
		if ref2.current then
			ref2.current(ref.current)
		end
	end, {})))

	local v8 = React.useCallback(function(current, p2)
		ref.current = current

		if data.onFullscreenMediaChanged then
			data.onFullscreenMediaChanged(current, p2)
		end
	end, { data.onFullscreenMediaChanged })

	local ref3 = React.useRef(setFullscreenContent)
	ref3.current = setFullscreenContent
	local ref4 = React.useRef(setOnExitFullscreenOverlay)
	ref4.current = setOnExitFullscreenOverlay

	React.useEffect(function()
		return function()
			if ref3.current then
				ref3.current(nil)
			end

			if ref4.current then
				ref4.current(nil)
			end
		end
	end, {})

	local v9 = React.useCallback(function(p2)
		ref2.current = nil
		setState2(p2)

		if setFullscreenContent then
			setFullscreenContent(nil)
		end

		if setOnExitFullscreenOverlay then
			setOnExitFullscreenOverlay(nil)
		end

		setState(false)
		local filteredItem = data.filteredItems[p2]
		local v10 = filteredItem ~= nil
			and (isValidIdentifier(filteredItem.videoId) or isYouTubeVideo(filteredItem.assetTypeId))
		sendMediaGalleryFullscreenEvent(
			data.eventIngest,
			data.mediaGalleryAnalyticsContext,
			"mediaGalleryExitFullscreen",
			data.placeId,
			data.universeId,
			p2,
			v10
		)
	end, {
		setFullscreenContent,
		setOnExitFullscreenOverlay,
		data.filteredItems,
		data.eventIngest,
		data.placeId,
		data.universeId,
		data.mediaGalleryAnalyticsContext
	})

	local v10 = React.useCallback(function()
		if ref2.current then
			ref2.current(ref.current)
		end
	end, {})

	return {
		isFullscreen = state,
		onFullscreenToggle = React.useCallback(function(current)
			if data.fullscreenEnabled == false or not setFullscreenContent then
				return
			end

			ref2.current = v9
			setState2(current)
			ref.current = current
			setState(true)

			if setOnExitFullscreenOverlay then
				setOnExitFullscreenOverlay(function()
					return v10
				end)
			end

			local binding, v11 = React.createBinding(UDim2.fromOffset(0, 0))

			local element = React.createElement(view, {
				tag = "size-full bg-surface-0",
				onAbsoluteSizeChanged = function(p2)
					local x = p2.AbsoluteSize.X
					local v12 = p2.AbsoluteSize.Y

					local v13 = math.floor(v12 * ITEM_ASPECT_RATIO)

					if x < v13 then
						v12 = math.floor(x / ITEM_ASPECT_RATIO)
						v13 = x
					end

					v11(UDim2.fromOffset(v13, v12))
				end
			}, {
				MediaGallery = React.createElement(mediaGalleryCarousel, {
					items = data.filteredItems,
					Size = binding,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					itemPadding = 0,
					startIndex = current,
					isFullscreen = true,
					showGradient = false,
					showPlayButton = true,
					showProgressBar = true,
					onYouTubeVideoPlay = data.onYouTubeVideoPlay,
					onFullscreenToggle = v9,
					onMediaChanged = v8,
					videoPlaybackCoordinator = data.videoPlaybackCoordinator,
					videoAnalytics = data.videoAnalytics,
					analyticsSourceId = data.universeId,
					cornerRadius = data.cornerRadius,
					overlay = data.overlay
				})
			})

			setFullscreenContent(React.createElement(
				focusNavigableSurfaceWrapper,
				{
					surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
					isIsolated = true
				},
				{
					NavigateBackFrame = React.createElement(
						"Frame",
						{
							ref = v7,
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							[React.Tag] = sduiFocusTags.SuppressBindings
						},
						{ Content = element }
					)
				}
			))

			local filteredItem = data.filteredItems[current]
			local v16 = filteredItem ~= nil
				and (isValidIdentifier(filteredItem.videoId) or isYouTubeVideo(filteredItem.assetTypeId))
			sendMediaGalleryFullscreenEvent(
				data.eventIngest,
				data.mediaGalleryAnalyticsContext,
				"mediaGalleryEnterFullscreen",
				data.placeId,
				data.universeId,
				current,
				v16
			)
		end, {
			data.fullscreenEnabled,
			setFullscreenContent,
			setOnExitFullscreenOverlay,
			v10,
			data.filteredItems,
			data.universeId,
			v9,
			data.onYouTubeVideoPlay,
			data.videoPlaybackCoordinator,
			data.videoAnalytics,
			v8,
			data.cornerRadius,
			data.overlay,
			data.eventIngest,
			data.placeId,
			data.mediaGalleryAnalyticsContext,
			v7
		}),
		previewStartIndex = math.clamp(state2, 1, (math.max(1, #data.filteredItems)))
	}
end

return useMediaGalleryFullscreen
