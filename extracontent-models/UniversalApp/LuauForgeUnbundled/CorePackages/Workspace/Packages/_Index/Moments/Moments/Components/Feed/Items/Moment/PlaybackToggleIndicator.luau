local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local playbackToggleIndicatorMachine = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/playbackToggleIndicatorMachine")
local useIsPlaying = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsPlaying")

local fFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local useSignalState = SignalsReact.useSignalState

local icon = Foundation.Icon
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences

local v5 = { frequency = 4, dampingRatio = 1 }
local v6 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function defaultSchedule(p2, callback)
	local thread = task.delay(p2 / 1000, callback)
	return function()
		task.cancel(thread)
	end
end

local function PlaybackToggleIndicator(p2)
	local controller = MomentContext.useMoment().controller
	local v7 = useTokens()
	local reducedMotion = usePreferences().reducedMotion

	local state, setState = React.useState(false)
	local v8, v9 = ReactOtter.useAnimatedBinding(0)

	local v10 = useIsPlaying()
	local v11

	if fFlagMomentsAutoplayAmpPolicy then
		v11 = React.useMemo(function()
			return Signals.createComputed(function(p3)
				if controller == nil then
					return "Idle"
				end

				return controller.getState(p3).readiness
			end)
		end, { controller })
	end

	local v12 = if fFlagMomentsAutoplayAmpPolicy then useSignalState(v11) else nil

	local ref = React.useRef(nil)
	function ref.current(p3)
		local v13

		if reducedMotion then
			v13 = ReactOtter.instant(p3 == "enter" and 1 or 0)
		else
			v13 = if p3 == "enter" then ReactOtter.spring(1, v5) else ReactOtter.ease(0, v6)
		end

		v9(v13)
	end

	local ref2 = React.useRef(nil)
	ref2.current = p2.scheduleOverride or defaultSchedule

	local v13 = React.useMemo(function()
		return playbackToggleIndicatorMachine({ dwellMs = 800, exitDurationMs = 150 }, {
			schedule = function(p3, p4)
				return ref2.current(p3, p4)
			end,
			setMounted = setState,
			animate = function(p3)
				ref.current(p3)
			end
		})
	end, {})

	React.useEffect(function()
		return function()
			v13.dispose()
		end
	end, { v13 })

	React.useEffect(function()
		if controller == nil then
			return
		end

		local v14 = nil
		return (Signals.createEffect(function(p3)
			local userToggleNonce = controller.getUserToggleNonce(p3)

			if v14 == nil then
				v14 = userToggleNonce
				return
			end

			if userToggleNonce == v14 then
				return
			end

			v14 = userToggleNonce
			v13.notifyUserToggle()
		end))
	end, { controller, v13 })

	local v14 = if fFlagMomentsAutoplayAmpPolicy then v12 == "Ready" and not v10 else nil

	if not (state or fFlagMomentsAutoplayAmpPolicy and v14) then
		return nil
	end

	local mapped = v8:map(function(p3)
		if fFlagMomentsAutoplayAmpPolicy and v14 then
			return 1
		end

		return 0.75 + 0.25 * p3
	end)

	local mapped2 = v8:map(function(p3)
		if fFlagMomentsAutoplayAmpPolicy and v14 then
			return 0
		end

		return 1 - p3
	end)

	local createElement = React.createElement
	local v16 = {
		tag = "position-center-center anchor-center-center",
		Size = UDim2.fromOffset(64, 64),
		BackgroundTransparency = 1,
		scale = mapped,
		ZIndex = 3
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v23 = if v10 then iconName.PauseLarge else iconName.PlayLarge
	return createElement(view, v16, {
		Circle = createElement2(
			view,
			{
				tag = "row align-x-center align-y-center size-full radius-circle clip bg-over-media-0",
				GroupTransparency = mapped2
			},
			{
				Glyph = createElement3(icon, {
					name = v23,
					size = iconSize.Large,
					style = v7.Color.Content.Emphasis
				})
			}
		)
	})
end

return PlaybackToggleIndicator
