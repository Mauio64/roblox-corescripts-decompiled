local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local Icon = Foundation.Icon
local PopoverAlign = Foundation.Enums.PopoverAlign
local Tooltip = Foundation.Tooltip
local View = Foundation.View
local RadialProgressBar = require(ParentParent.Components.CoreUI.RadialProgressBar)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local StartVideoCapture = require(ParentParent.Thunks.StartVideoCapture)
local StopVideoCapture = require(ParentParent.Thunks.StopVideoCapture)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local CaptureTriggerType = require(ParentParent.Enums.CaptureTriggerType)
local v25 = game:DefineFastInt("MaxVideoCaptureDurationSeconds", 30)

return function(t1: {[any]: any}) -- line: 44
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), useTokens (copy), useSelector (copy), Constants (copy), useCallback (copy), EventNames (copy), StopVideoCapture (copy), ReactOtter (copy), useEffect (copy), v25 (copy), StartVideoCapture (copy), React (copy), View (copy), Tooltip (copy), PopoverAlign (copy), Icon (copy), CaptureTriggerType (copy), Foundation (copy), RadialProgressBar (copy)
	local v27 = useAnalytics()
	local v28 = useDispatch()
	local v29 = useLocalization({
		captureVideo = "Feature.Captures.Title.CaptureVideoTooltip",
		videoCaptureInProgressTitle = "Feature.Captures.Title.VideoCaptureInProgressTooltip"
	})
	local v30 = useTokens()
	local v31 = useSelector(function(p1) -- line: 53
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsVideoCaptureActive.status
	end)
	local v32 = useSelector(function(p2) -- line: 57
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsVideoCaptureActive.triggerType
	end)
	local v33 = useCallback(function() -- line: 61
		-- upvalues: v31 (copy), v27 (copy), EventNames (copy), v28 (copy), StopVideoCapture (copy)
		if not v31 then
			return
		end

		v27.fireEvent(EventNames.CapturesEntrypointVideoDeactivatedAutomatically)
		v28(StopVideoCapture())
	end, { v31 })
	local v34, v35 = ReactOtter.useAnimatedBinding(0, v33)

	useEffect(function() -- line: 73
		-- upvalues: v31 (copy), v35 (copy), ReactOtter (copy), v25 (copy)
		if v31 then
			v35(ReactOtter.ease(1, {
				duration = v25,
				easingStyle = Enum.EasingStyle.Linear
			}))

			return
		end

		v35(ReactOtter.instant(0))
	end, {
		v35,
		v31
	})

	local v36 = useCallback(function() -- line: 84
		-- upvalues: v31 (copy), v27 (copy), EventNames (copy), v28 (copy), StartVideoCapture (copy)
		if v31 then
			return
		end

		v27.fireEvent(EventNames.CapturesEntrypointVideoActivated)
		v28(StartVideoCapture())
	end, { v31 })
	local v37 = useCallback(function() -- line: 94
		-- upvalues: v31 (copy), v27 (copy), EventNames (copy), v28 (copy), StopVideoCapture (copy)
		if not v31 then
			return
		end

		v27.fireEvent(EventNames.CapturesEntrypointVideoDeactivated)
		v28(StopVideoCapture())
	end, { v31 })

	return React.createElement(React.Fragment, nil, {
		VideoCaptureStartCTA = if v31 then nil else React.createElement(View, {
			LayoutOrder = t1.layoutOrder,
			onActivated = v36,
			tag = {
				["size-1200-1200"] = true,
				["anchor-center-center auto-xy clip position-center-center radius-circle"] = true
			}
		}, {
			StartIconWithTooltip = React.createElement(Tooltip, {
				align = PopoverAlign.Center,
				side = t1.popoverSide,
				title = v29.captureVideo
			}, React.createElement(View, {
				tag = "size-1200-1200"
			}, {
				Icon = React.createElement(Icon, {
					name = "icons/controls/screenRecord_alt",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					style = v30.Color.Content.Emphasis
				})
			}))
		}),
		VideoCaptureDisabledStartCTA = if not v31 or v32 ~= CaptureTriggerType.LegacyCapture then nil else React.createElement(View, {
			tag = "anchor-center-center auto-xy clip position-center-center radius-circle",
			LayoutOrder = t1.layoutOrder
		}, {
			StartIconWithTooltip = React.createElement(Tooltip, {
				align = PopoverAlign.Center,
				side = t1.popoverSide,
				title = v29.videoCaptureInProgressTitle
			}, React.createElement(Icon, {
				name = "icons/controls/screenRecord_alt",
				style = v30.Color.Content.Muted
			}))
		}),
		VideoCaptureActiveView = if not v31 or v32 ~= CaptureTriggerType.UserCapture and v32 ~= CaptureTriggerType.DeveloperCapture then nil else React.createElement(View, {
			tag = "anchor-center-center clip position-center-center radius-circle size-900-900 padding-xxsmall",
			LayoutOrder = t1.layoutOrder
		}, {
			VideoCaptureStopCTA = if v32 ~= CaptureTriggerType.UserCapture then nil else React.createElement(View, {
				tag = "anchor-center-center bg-over-media-300 col flex-evenly position-center-center size-700-700 radius-circle",
				onActivated = v37
			}, {
				VideoCaptureStopIcon = React.createElement(Icon, {
					name = "icons/controls/mediaStop_small",
					size = Foundation.Enums.IconSize.Small,
					style = v30.Color.System.Alert
				})
			}),
			VideoCaptureActiveIndicator = if v32 ~= CaptureTriggerType.DeveloperCapture then nil else React.createElement(View, {
				tag = "anchor-center-center col flex-evenly position-center-center size-700-700 radius-circle"
			}, {
				VideoCaptureIndicatorIcon = React.createElement(View, {
					tag = "anchor-center-center bg-alert position-center-center size-300-300 radius-circle"
				})
			}),
			ProgressBar = React.createElement(RadialProgressBar, {
				progress = v34
			})
		})
	})
end
