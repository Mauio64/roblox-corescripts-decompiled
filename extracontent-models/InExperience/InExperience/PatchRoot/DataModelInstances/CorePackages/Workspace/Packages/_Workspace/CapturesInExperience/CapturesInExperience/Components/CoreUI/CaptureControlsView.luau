local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CaptureService = game:GetService("CaptureService")

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local Foundation = require(parent2.Foundation)
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local Localization = require(parent2.Localization)
local SocialStopwatch = require(parent2.SocialStopwatch)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Image = Foundation.Image
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Tooltip = Foundation.Tooltip
local View = Foundation.View

local GalleryButtonContent = require(parent.Components.CoreUI.GalleryButtonContent)
local VideoCaptureControl = require(parent.Components.CoreUI.VideoCaptureControl)
local VoiceChatIndicator = require(parent.Components.CoreUI.VoiceChatIndicator)

local CapturesContext = require(parent.Context.CapturesContext)
local CapturesPolicy = require(parent.App.CapturesPolicy)
local CarouselOpened = require(parent.Actions.CarouselOpened)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local GetLatestCaptureStore = require(parent.Stores.GetLatestCaptureStore)
local TakeCapture = require(parent.Thunks.TakeCapture)

local findCaptureIndex = require(parent.Utils.findCaptureIndex)

local SnapDirection = require(parent.Enums.SnapDirection)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useCaptureControlsController = require(parent.Hooks.useCaptureControlsController)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local usePlayShutterSound = require(parent.Hooks.usePlayShutterSound)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLatestCapture = require(parent.Hooks.useLatestCapture)
local useSystemMenuDetection = require(parent.Hooks.useSystemMenuDetection)
local useTokens = Foundation.Hooks.useTokens
local useTopbarInset = require(parent.Hooks.useTopbarInset)

local defineFastFlag = game:DefineFastFlag("DebugOverrideCaptureControlsVideoGuacPolicy", false)
local SharedFlags = require(parent2.SharedFlags)
local FStringSocialCaptureIXPLayer = SharedFlags.FStringSocialCaptureIXPLayer
local FFlagCapturesControlsUseBuilderIcons = require(parent.Flags.FFlagCapturesControlsUseBuilderIcons)
local FFlagCapturesControlsGalleryButton = require(parent.Flags.FFlagCapturesControlsGalleryButton)

local name = not FFlagCapturesControlsUseBuilderIcons and "icons/controls/screenCapture" or IconName.FrameCameraCenter
local large

if FFlagCapturesControlsUseBuilderIcons then
	large = IconSize.Large
else
	large = nil
end

local v = {
	[SnapDirection.Bottom] = PopoverSide.Top,
	[SnapDirection.Left] = PopoverSide.Right,
	[SnapDirection.Right] = PopoverSide.Left,
	[SnapDirection.Top] = PopoverSide.Bottom
}

return (CapturesPolicy.connect(function(p)
	return {
		hasVideoCaptureCapability = p.hasVideoCaptureCapability() and CaptureService:CanCaptureVideo() or defineFastFlag
	}
end)(function(p)
	local v2 = useAnalytics()
	local v3 = useDispatch()
	local v4 = useLocalization({
		captureScreenshot = "Feature.Captures.Title.CaptureScreenshotTooltip",
		gallery = FFlagCapturesControlsGalleryButton and "Feature.Captures.Title.Gallery" or nil
	})

	local v5 = useTokens()
	local openGallery

	if FFlagCapturesControlsGalleryButton then
		openGallery = React.useContext(CapturesContext).openGallery
	else
		openGallery = nil
	end

	local v6

	if FFlagCapturesControlsGalleryButton then
		v6 = useSystemMenuDetection()
	else
		v6 = false
	end

	local latestCapture

	if FFlagCapturesControlsGalleryButton then
		latestCapture = useLatestCapture()
	else
		latestCapture = nil
	end

	local v7

	if FFlagCapturesControlsGalleryButton then
		v7 = useSelector(function(p2)
			return p2[Constants.RoduxKey].Captures
		end)
	else
		v7 = nil
	end

	local v8 = useTopbarInset()

	local v9 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsActive
	end)

	local v10 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsVideoCaptureActive.status
	end)

	useEffect(function()
		if v9 then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialCaptureIXPLayer)
		end
	end, { v9 })

	local v11 = usePlayShutterSound()

	local v12 = useCaptureControlsController(v9, (React.useMemo(function()
		return Vector2.new(v8.Min.X - v5.Padding.Small, v8.Height - v5.Padding.XSmall - v5.Padding.XXSmall)
	end, { v8, v5 })))

	local dragContainerRef = v12.dragContainerRef
	local dragDetectorRef = v12.dragDetectorRef
	local dragItemAnchorPointBinding = v12.dragItemAnchorPointBinding
	local dragItemPositionBinding = v12.dragItemPositionBinding
	local dragItemRef = v12.dragItemRef
	local isItemHorizontal = v12.isItemHorizontal
	local screenshotButtonRef = v12.screenshotButtonRef
	local snapDirection = v12.snapDirection

	useEffect(function()
		if v9 then
			v2.fireEvent(EventNames.CapturesEntrypointViewed)
		end
	end, { v9 })

	local onActivated = useCallback(function()
		if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureTaken) then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureTaken)
		end

		v2.fireEvent(EventNames.CapturesEntrypointActivated)

		v11()
		v3(TakeCapture())
	end, { v11 })
	local onActivated2

	if FFlagCapturesControlsGalleryButton then
		onActivated2 = useCallback(function()
			local latestCaptureFilePath = GetLatestCaptureStore(false).getLatestCaptureFilePath(false)

			if not openGallery() or latestCapture == nil or v7 == nil then
				return
			end

			local captureIndex = findCaptureIndex(v7, latestCapture, latestCaptureFilePath)

			if captureIndex then
				v2.fireEvent(EventNames.CapturesCarouselOpened)
				v3(CarouselOpened(captureIndex))
			end
		end, { openGallery, latestCapture, v7, v2.fireEvent, v3 })
	end

	local galleryButtonContent

	if FFlagCapturesControlsGalleryButton then
		galleryButtonContent = React.createElement(GalleryButtonContent, {
			latestCapture = latestCapture
		})
	end

	local createElement = React.createElement
	local v13 = {
		Position = UDim2.fromOffset(0, -v8.Height),
		Size = UDim2.new(1, 0, 1, v8.Height),
		tag = "padding-x-large padding-y-medium",
		ZIndex = Constants.ZIndex.Entrypoint
	}

	local createElement2 = React.createElement
	local captureControls

	if v9 then
		local createElement3 = React.createElement
		local v14 = {
			AnchorPoint = dragItemAnchorPointBinding:map(function(p2)
				return Vector2.new(p2.x, p2.y)
			end),
			onActivated = function() end,
			Position = dragItemPositionBinding:map(function(p2)
				return UDim2.fromOffset(p2.xOffset, p2.yOffset)
			end),
			ref = dragItemRef,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = {
				["row auto-x padding-x-small padding-y-xsmall size-0-1100"] = isItemHorizontal,
				["col auto-y padding-y-small padding-x-xsmall size-1100-0"] = not isItemHorizontal,
				["align-x-center align-y-center bg-over-media-0 flex-evenly radius-circle"] = true
			}
		}

		local v15 = {
			DragDetector = React.createElement("UIDragDetector", {
				DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
				BoundingUI = dragContainerRef,
				ref = dragDetectorRef,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
			}),
			VideoCaptureControl = 0,
			ScreenshotCTA = 0,
			GalleryCTA = 0,
			VoiceChatIndicator = 0,
			DragAffordance = 0
		}
		local videoCaptureControl

		if p.hasVideoCaptureCapability then
			videoCaptureControl = React.createElement(VideoCaptureControl, {
				layoutOrder = 1,
				popoverSide = v[snapDirection]
			})
		end

		v15.VideoCaptureControl = videoCaptureControl
		local screenshotCTA

		if not v10 then
			screenshotCTA = React.createElement(View, {
				LayoutOrder = 2,
				tag = {
					["size-1200-1200"] = true,
					["anchor-center-center auto-xy clip position-center-center radius-circle"] = true
				},
				onActivated = onActivated,
				ref = screenshotButtonRef
			}, {
				ScreenshotIconWithTooltip = React.createElement(
					Tooltip,
					{
						align = PopoverAlign.Center,
						side = v[snapDirection],
						title = v4.captureScreenshot
					},
					React.createElement(View, { tag = "size-1200-1200" }, { React.createElement(Icon, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							name = name,
							size = large,
							style = v5.Color.Content.Emphasis
						}) })
				)
			})
		end

		v15.ScreenshotCTA = screenshotCTA
		local galleryCTA

		if FFlagCapturesControlsGalleryButton and openGallery and not v10 then
			local createElement4 = React.createElement
			local galleryTooltip

			if not v6 then
				galleryTooltip = React.createElement(
					Tooltip,
					{ align = PopoverAlign.Center, side = v[snapDirection], title = v4.gallery },
					React.createElement(View, { tag = "size-1200-1200" })
				)
			end

			galleryCTA = createElement4(
				View,
				{
					LayoutOrder = 3,
					tag = "position-center-center anchor-center-center size-1200-1200 auto-xy radius-circle clip",
					testId = "--social-captures-controls-gallery-button",
					onActivated = onActivated2
				},
				{ GalleryButtonContent = galleryButtonContent, GalleryTooltip = galleryTooltip }
			)
		end

		v15.GalleryCTA = galleryCTA
		local voiceChatIndicator

		if v10 then
			voiceChatIndicator = React.createElement(VoiceChatIndicator, {
				layoutOrder = FFlagCapturesControlsGalleryButton and 4 or 3,
				popoverSide = v[snapDirection]
			})
		end

		v15.VoiceChatIndicator = voiceChatIndicator

		local createElement4 = React.createElement
		local dragAffordanceIcon

		if FFlagCapturesControlsUseBuilderIcons then
			dragAffordanceIcon = React.createElement(Icon, {
				name = IconName.SixDotsTwoColumnGrid,
				Rotation = isItemHorizontal and 0 or 90,
				style = v5.Color.Content.Muted,
				tag = "position-center-center anchor-center-center"
			})
		else
			dragAffordanceIcon = React.createElement(Image, {
				Image = "component_assets/dragger_small",
				Rotation = isItemHorizontal and 90 or 0,
				tag = "anchor-center-center content-muted position-center-center size-600-400"
			})
		end

		v15.DragAffordance = createElement4(View, {
			LayoutOrder = FFlagCapturesControlsGalleryButton and 5 or 4,
			tag = "anchor-center-center auto-xy padding-xxsmall position-center-center"
		}, { DragAffordanceIcon = dragAffordanceIcon })
		captureControls = createElement3(View, v14, v15)
	end

	return createElement(View, v13, {
		PaddedContainer = createElement2(
			View,
			{
				ref = dragContainerRef,
				tag = "anchor-center-center position-center-center size-full"
			},
			{ CaptureControls = captureControls }
		)
	})
end))
