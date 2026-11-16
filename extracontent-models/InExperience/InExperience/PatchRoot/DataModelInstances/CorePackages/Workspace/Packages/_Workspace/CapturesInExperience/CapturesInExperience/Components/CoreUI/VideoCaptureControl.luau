local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)
local RoactUtils = require(parent2.RoactUtils)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local Tooltip = Foundation.Tooltip
local View = Foundation.View

local RadialProgressBar = require(parent.Components.CoreUI.RadialProgressBar)

local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local StartVideoCapture = require(parent.Thunks.StartVideoCapture)
local StopVideoCapture = require(parent.Thunks.StopVideoCapture)
local isEligibleForMoments = require(parent.Utils.isEligibleForMoments)
local logCaptureEndLayerExposure = require(parent.Utils.logCaptureEndLayerExposure)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens

local CaptureTriggerType = require(parent.Enums.CaptureTriggerType)

local defineFastInt = game:DefineFastInt("MaxVideoCaptureDurationSeconds", 30)
local FFlagCapturesControlsUseBuilderIcons = require(parent.Flags.FFlagCapturesControlsUseBuilderIcons)
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)

local FIntMomentsInExperienceMinCaptureSeconds = require(parent.Flags.FIntMomentsInExperienceMinCaptureSeconds)

local name = not FFlagCapturesControlsUseBuilderIcons and "icons/controls/screenRecord_alt" or IconName.FrameVideoCamera
local large

if FFlagCapturesControlsUseBuilderIcons then
	large = IconSize.Large
else
	large = nil
end

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useLocalization({
		captureVideo = "Feature.Captures.Title.CaptureVideoTooltip",
		videoCaptureInProgressTitle = "Feature.Captures.Title.VideoCaptureInProgressTooltip"
	})

	local v4 = useTokens()

	local v5 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsVideoCaptureActive.status
	end)

	local v6 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsVideoCaptureActive.triggerType
	end)
	local v7

	if FFlagMomentsCaptureEndIxpEnabled then
		v7 = useSelector(function(p2)
			return p2[Constants.RoduxKey].MomentsEligibility
		end)
	else
		v7 = nil
	end

	local v8

	if FFlagMomentsCaptureEndIxpEnabled then
		v8 = useRef(nil)
	else
		v8 = nil
	end

	if FFlagMomentsCaptureEndIxpEnabled then
		useEffect(function()
			local v9 = v8
			local current

			if v5 then
				current = os.clock()
			end

			v9.current = current
		end, { v5 })
	end

	local function shouldLogCaptureEndExposure() -- 2 equivalent calls inferred from this helper
		local current = v8.current

		local v9 = isEligibleForMoments(v7)

		if v9 then
			if current == nil then
				return false
			end

			return FIntMomentsInExperienceMinCaptureSeconds <= os.clock() - current
		end

		return v9
	end

	local v9 = useCallback(function()
		if not v5 then
			return
		end

		v.fireEvent(EventNames.CapturesEntrypointVideoDeactivatedAutomatically)

		v2(StopVideoCapture())

		if
			FFlagMomentsCaptureEndIxpEnabled
			and v6 == CaptureTriggerType.UserCapture
			and shouldLogCaptureEndExposure() -- inferred equivalent call
		then
			logCaptureEndLayerExposure()
		end
	end, FFlagMomentsCaptureEndIxpEnabled and { v5, v6, v7 } or { v5 })

	local progress, v10 = ReactOtter.useAnimatedBinding(0, v9)

	useEffect(function()
		if v5 then
			v10(ReactOtter.ease(1, {
				duration = defineFastInt,
				easingStyle = Enum.EasingStyle.Linear
			}))
		else
			v10(ReactOtter.instant(0))
		end
	end, { v10, v5 })

	local onActivated = useCallback(function()
		if v5 then
			return
		end

		v.fireEvent(EventNames.CapturesEntrypointVideoActivated)

		v2(StartVideoCapture())
	end, { v5 })

	local onActivated2 = useCallback(function()
		if not v5 then
			return
		end

		v.fireEvent(EventNames.CapturesEntrypointVideoDeactivated)

		v2(StopVideoCapture())

		if FFlagMomentsCaptureEndIxpEnabled and shouldLogCaptureEndExposure() then -- inferred equivalent call
			logCaptureEndLayerExposure()
		end
	end, FFlagMomentsCaptureEndIxpEnabled and { v5, v7 } or { v5 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local videoCaptureStartCTA

	if not v5 then
		videoCaptureStartCTA = React.createElement(View, {
			LayoutOrder = p.layoutOrder,
			onActivated = onActivated,
			tag = {
				["size-1200-1200"] = true,
				["anchor-center-center auto-xy clip position-center-center radius-circle"] = true
			}
		}, {
			StartIconWithTooltip = React.createElement(
				Tooltip,
				{ align = PopoverAlign.Center, side = p.popoverSide, title = v3.captureVideo },
				React.createElement(View, { tag = "size-1200-1200" }, {
					Icon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = name,
						size = large,
						style = v4.Color.Content.Emphasis
					})
				})
			)
		})
	end

	local videoCaptureDisabledStartCTA

	if v5 and v6 == CaptureTriggerType.LegacyCapture then
		videoCaptureDisabledStartCTA = React.createElement(
			View,
			{
				LayoutOrder = p.layoutOrder,
				tag = "anchor-center-center auto-xy clip position-center-center radius-circle"
			},
			{
				StartIconWithTooltip = React.createElement(
					Tooltip,
					{
						align = PopoverAlign.Center,
						side = p.popoverSide,
						title = v3.videoCaptureInProgressTitle
					},
					React.createElement(Icon, {
						name = name,
						size = large,
						style = v4.Color.Content.Muted
					})
				)
			}
		)
	end

	local videoCaptureActiveView

	if v5 and (v6 == CaptureTriggerType.UserCapture or v6 == CaptureTriggerType.DeveloperCapture) then
		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = p.layoutOrder,
			tag = "anchor-center-center clip position-center-center radius-circle size-900-900 padding-xxsmall"
		}
		local videoCaptureStopCTA

		if v6 == CaptureTriggerType.UserCapture then
			videoCaptureStopCTA = React.createElement(
				View,
				{
					tag = "anchor-center-center bg-over-media-300 col flex-evenly position-center-center size-700-700 radius-circle",
					onActivated = onActivated2
				},
				{
					VideoCaptureStopIcon = React.createElement(Icon, {
						name = "icons/controls/mediaStop_small",
						size = Foundation.Enums.IconSize.Small,
						style = v4.Color.System.Alert
					})
				}
			)
		end

		local videoCaptureActiveIndicator

		if v6 == CaptureTriggerType.DeveloperCapture then
			videoCaptureActiveIndicator = React.createElement(
				View,
				{
					tag = "anchor-center-center col flex-evenly position-center-center size-700-700 radius-circle"
				},
				{
					VideoCaptureIndicatorIcon = React.createElement(View, {
						tag = "anchor-center-center bg-alert position-center-center size-300-300 radius-circle"
					})
				}
			)
		end

		videoCaptureActiveView = createElement2(View, v11, {
			VideoCaptureStopCTA = videoCaptureStopCTA,
			VideoCaptureActiveIndicator = videoCaptureActiveIndicator,
			ProgressBar = React.createElement(RadialProgressBar, { progress = progress })
		})
	end

	return createElement(fragment, nil, {
		VideoCaptureStartCTA = videoCaptureStartCTA,
		VideoCaptureDisabledStartCTA = videoCaptureDisabledStartCTA,
		VideoCaptureActiveView = videoCaptureActiveView
	})
end
