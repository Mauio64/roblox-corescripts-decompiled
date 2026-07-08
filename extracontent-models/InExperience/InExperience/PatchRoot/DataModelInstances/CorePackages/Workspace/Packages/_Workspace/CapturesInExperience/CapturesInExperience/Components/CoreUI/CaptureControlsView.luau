local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CaptureService = game:GetService("CaptureService")
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Foundation = require(ParentParentParent.Foundation)
local IXPServiceWrapper = require(ParentParentParent.IXPServiceWrapper).IXPServiceWrapper
local Localization = require(ParentParentParent.Localization)
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Tooltip = Foundation.Tooltip
local View = Foundation.View
local VideoCaptureControl = require(ParentParent.Components.CoreUI.VideoCaptureControl)
local VoiceChatIndicator = require(ParentParent.Components.CoreUI.VoiceChatIndicator)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local TakeCapture = require(ParentParent.Thunks.TakeCapture)
local SnapDirection = require(ParentParent.Enums.SnapDirection)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useCaptureControlsController = require(ParentParent.Hooks.useCaptureControlsController)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local usePlayShutterSound = require(ParentParent.Hooks.usePlayShutterSound)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local useTopbarInset = require(ParentParent.Hooks.useTopbarInset)
local v33 = game:DefineFastFlag("CapturesLayerExposureLoggingEnabled", false)
local v34 = game:DefineFastFlag("DebugOverrideCaptureControlsVideoGuacPolicy", false)
local FStringSocialCaptureIXPLayer = require(ParentParentParent.SharedFlags).FStringSocialCaptureIXPLayer
local t1 = {
	[SnapDirection.Bottom] = PopoverSide.Top,
	[SnapDirection.Left] = PopoverSide.Right,
	[SnapDirection.Right] = PopoverSide.Left,
	[SnapDirection.Top] = PopoverSide.Bottom
}

return (CapturesPolicy.connect(function(p1) -- line: 226
	-- upvalues: CaptureService (copy), v34 (copy)
	return {
		hasVideoCaptureCapability = p1.hasVideoCaptureCapability() and CaptureService:CanCaptureVideo() or v34
	}
end)(function(t2: {[any]: any}) -- line: 65
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), useTokens (copy), useTopbarInset (copy), useSelector (copy), Constants (copy), useEffect (copy), v33 (copy), IXPServiceWrapper (copy), FStringSocialCaptureIXPLayer (copy), usePlayShutterSound (copy), React (copy), useCaptureControlsController (copy), EventNames (copy), useCallback (copy), SocialStopwatch (copy), TakeCapture (copy), View (copy), Foundation (copy), VideoCaptureControl (copy), t1 (copy), Tooltip (copy), PopoverAlign (copy), Icon (copy), VoiceChatIndicator (copy), FoundationImage (copy)
	local v38 = useAnalytics()
	local v39 = useDispatch()
	local v40 = useLocalization({
		captureScreenshot = "Feature.Captures.Title.CaptureScreenshotTooltip"
	})
	local v41 = useTokens()
	local v42 = useTopbarInset()
	local v43 = useSelector(function(p2) -- line: 75
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsActive
	end)
	local v44 = useSelector(function(p3) -- line: 79
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].IsVideoCaptureActive.status
	end)

	useEffect(function() -- line: 83
		-- upvalues: v33 (copy), v43 (copy), IXPServiceWrapper (copy), FStringSocialCaptureIXPLayer (copy)
		if v33 and v43 then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialCaptureIXPLayer)
		end
	end, { v43 })

	local v45 = usePlayShutterSound()
	local v46 = React.useMemo(function() -- line: 91
		-- upvalues: v42 (copy), v41 (copy)
		return Vector2.new(v42.Min.X - v41.Padding.Small, v42.Height - v41.Padding.XSmall - v41.Padding.XXSmall)
	end, {
		v42,
		v41
	})
	local v47 = useCaptureControlsController(v43, v46)
	local dragContainerRef = v47.dragContainerRef
	local dragDetectorRef = v47.dragDetectorRef
	local dragItemAnchorPointBinding = v47.dragItemAnchorPointBinding
	local dragItemPositionBinding = v47.dragItemPositionBinding
	local dragItemRef = v47.dragItemRef
	local isItemHorizontal = v47.isItemHorizontal
	local screenshotButtonRef = v47.screenshotButtonRef
	local snapDirection = v47.snapDirection

	useEffect(function() -- line: 109
		-- upvalues: v43 (copy), v38 (copy), EventNames (copy)
		if v43 then
			v38.fireEvent(EventNames.CapturesEntrypointViewed)
		end
	end, { v43 })

	local v56 = useCallback(function() -- line: 115
		-- upvalues: SocialStopwatch (copy), v38 (copy), EventNames (copy), v45 (copy), v39 (copy), TakeCapture (copy)
		if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureTaken) then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureTaken)
		end

		v38.fireEvent(EventNames.CapturesEntrypointActivated)
		v45()
		v39(TakeCapture())
	end, { v45 })

	return React.createElement(View, {
		tag = "padding-x-large padding-y-medium",
		Position = UDim2.fromOffset(0, -v42.Height),
		Size = UDim2.new(1, 0, 1, v42.Height),
		ZIndex = Constants.ZIndex.Entrypoint
	}, {
		PaddedContainer = React.createElement(View, {
			tag = "anchor-center-center position-center-center size-full",
			ref = dragContainerRef
		}, {
			CaptureControls = if not v43 then nil else React.createElement(View, {
				AnchorPoint = dragItemAnchorPointBinding:map(function(p4) -- line: 138
					return Vector2.new(p4.x, p4.y)
				end),
				onActivated = function() -- line: 141
				end,
				Position = dragItemPositionBinding:map(function(p5) -- line: 142
					return UDim2.fromOffset(p5.xOffset, p5.yOffset)
				end),
				ref = dragItemRef,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.None
				},
				tag = {
					["row auto-x padding-x-small padding-y-xsmall size-0-1100"] = isItemHorizontal,
					["col auto-y padding-y-small padding-x-xsmall size-1100-0"] = not isItemHorizontal,
					["align-x-center align-y-center bg-over-media-0 flex-evenly radius-circle"] = true
				}
			}, {
				DragDetector = React.createElement("UIDragDetector", {
					DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
					BoundingUI = dragContainerRef,
					ref = dragDetectorRef,
					ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				}),
				VideoCaptureControl = if not t2.hasVideoCaptureCapability then nil else React.createElement(VideoCaptureControl, {
					layoutOrder = 1,
					popoverSide = t1[snapDirection]
				}),
				ScreenshotCTA = if v44 then nil else React.createElement(View, {
					LayoutOrder = 2,
					tag = {
						["size-1200-1200"] = true,
						["anchor-center-center auto-xy clip position-center-center radius-circle"] = true
					},
					onActivated = v56,
					ref = screenshotButtonRef
				}, {
					ScreenshotIconWithTooltip = React.createElement(Tooltip, {
						align = PopoverAlign.Center,
						side = t1[snapDirection],
						title = v40.captureScreenshot
					}, React.createElement(View, {
						tag = "size-1200-1200"
					}, { React.createElement(Icon, {
						name = "icons/controls/screenCapture",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						style = v41.Color.Content.Emphasis
					}) }))
				}),
				VoiceChatIndicator = if not v44 then nil else React.createElement(VoiceChatIndicator, {
					layoutOrder = 3,
					popoverSide = t1[snapDirection]
				}),
				DragAffordance = React.createElement(View, {
					LayoutOrder = 4,
					tag = "anchor-center-center auto-xy padding-xxsmall position-center-center"
				}, {
					DragAffordanceIcon = React.createElement(FoundationImage, {
						Image = "component_assets/dragger_small",
						tag = "anchor-center-center content-muted position-center-center size-600-400",
						Rotation = not isItemHorizontal and 0 or 90
					})
				})
			})
		})
	})
end))
