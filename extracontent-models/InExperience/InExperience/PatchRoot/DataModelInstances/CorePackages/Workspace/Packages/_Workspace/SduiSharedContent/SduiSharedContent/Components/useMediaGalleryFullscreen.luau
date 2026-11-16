local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View

local AppBlox = require(parent.AppBlox)
local DetailsPageLayoutContext = AppBlox.DetailsPageLayout.DetailsPageLayoutContext

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendMediaGalleryFullscreenEvent = DiscoveryAnalytics.Events.sendMediaGalleryFullscreenEvent

require(parent.VideoUtils)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local MediaGallery = require(parent.MediaGallery)
local MediaGalleryCarousel = MediaGallery.MediaGalleryCarousel
local MediaGalleryConstants = MediaGallery.MediaGalleryConstants
local isValidIdentifier = MediaGallery.isValidIdentifier
local isYouTubeVideo = MediaGallery.isYouTubeVideo

local ITEM_ASPECT_RATIO = MediaGalleryConstants.ITEM_ASPECT_RATIO

local function useMediaGalleryFullscreen(data)
	local v = React.useContext(DetailsPageLayoutContext)
	local setFullscreenContent = v.setFullscreenContent
	local setOnExitFullscreenOverlay = v.setOnExitFullscreenOverlay

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(1)

	local ref = React.useRef(1)

	local ref2 = React.useRef(nil)
	local ref5 = useOnNavigateBack((React.useCallback(function()
		if ref2.current then
			ref2.current(ref.current)
		end
	end, {})))

	local onMediaChanged = React.useCallback(function(current: number, flag: boolean?)
		ref.current = current

		if data.onFullscreenMediaChanged then
			data.onFullscreenMediaChanged(current, flag)
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

	local v2 = React.useCallback(function(p: number)
		ref2.current = nil
		setState2(p)

		if setFullscreenContent then
			setFullscreenContent(nil)
		end

		if setOnExitFullscreenOverlay then
			setOnExitFullscreenOverlay(nil)
		end

		setState(false)
		local filteredItem = data.filteredItems[p]
		local v2 = filteredItem ~= nil
			and (isValidIdentifier(filteredItem.videoId) or isYouTubeVideo(filteredItem.assetTypeId))
		sendMediaGalleryFullscreenEvent(
			data.eventIngest,
			data.mediaGalleryAnalyticsContext,
			"mediaGalleryExitFullscreen",
			data.placeId,
			data.universeId,
			p,
			v2
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

	local v3 = React.useCallback(function()
		if ref2.current then
			ref2.current(ref.current)
		end
	end, {})

	return {
		isFullscreen = state,
		onFullscreenToggle = React.useCallback(function(current: number)
			if data.fullscreenEnabled == false or not setFullscreenContent then
				return
			end

			ref2.current = v2
			setState2(current)
			ref.current = current
			setState(true)

			if setOnExitFullscreenOverlay then
				setOnExitFullscreenOverlay(function()
					return v3
				end)
			end

			local binding, v4 = React.createBinding(UDim2.fromOffset(0, 0))

			local element = React.createElement(View, {
				tag = "size-full bg-surface-0",
				onAbsoluteSizeChanged = function(p)
					local x = p.AbsoluteSize.X
					local v5 = p.AbsoluteSize.Y

					local v6 = math.floor(v5 * ITEM_ASPECT_RATIO)

					if x < v6 then
						v5 = math.floor(x / ITEM_ASPECT_RATIO)
						v6 = x
					end

					v4(UDim2.fromOffset(v6, v5))
				end
			}, {
				MediaGallery = React.createElement(MediaGalleryCarousel, {
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
					onFullscreenToggle = v2,
					onMediaChanged = onMediaChanged,
					videoPlaybackCoordinator = data.videoPlaybackCoordinator,
					videoAnalytics = data.videoAnalytics,
					analyticsSourceId = data.universeId,
					cornerRadius = data.cornerRadius,
					overlay = data.overlay
				})
			})

			setFullscreenContent(React.createElement(
				FocusNavigableSurfaceWrapper,
				{ surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp, isIsolated = true },
				{
					NavigateBackFrame = React.createElement(
						"Frame",
						{
							ref = ref5,
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							[React.Tag] = SduiFocusTags.SuppressBindings
						},
						{ Content = element }
					)
				}
			))

			local filteredItem = data.filteredItems[current]
			local v5 = filteredItem ~= nil
				and (isValidIdentifier(filteredItem.videoId) or isYouTubeVideo(filteredItem.assetTypeId))
			sendMediaGalleryFullscreenEvent(
				data.eventIngest,
				data.mediaGalleryAnalyticsContext,
				"mediaGalleryEnterFullscreen",
				data.placeId,
				data.universeId,
				current,
				v5
			)
		end, {
			data.fullscreenEnabled,
			setFullscreenContent,
			setOnExitFullscreenOverlay,
			v3,
			data.filteredItems,
			data.universeId,
			v2,
			data.onYouTubeVideoPlay,
			data.videoPlaybackCoordinator,
			data.videoAnalytics,
			onMediaChanged,
			data.cornerRadius,
			data.overlay,
			data.eventIngest,
			data.placeId,
			data.mediaGalleryAnalyticsContext,
			ref5
		}),
		previewStartIndex = math.clamp(state2, 1, (math.max(1, #data.filteredItems)))
	}
end

return useMediaGalleryFullscreen
