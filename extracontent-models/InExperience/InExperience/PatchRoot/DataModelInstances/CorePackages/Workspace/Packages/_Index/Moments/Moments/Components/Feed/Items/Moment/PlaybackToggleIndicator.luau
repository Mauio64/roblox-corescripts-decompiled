local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MomentContext = require(script.Parent.MomentContext)
local playbackToggleIndicatorMachine = require(script.Parent.playbackToggleIndicatorMachine)
local useIsPlaying = require(Moments.Hooks.useIsPlaying)

local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local useSignalState = SignalsReact.useSignalState

local Icon = Foundation.Icon
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences

local v = { frequency = 4, dampingRatio = 1 }
local v2 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function defaultSchedule(p: number, callback)
	local thread = task.delay(p / 1000, callback)
	return function()
		task.cancel(thread)
	end
end

local function PlaybackToggleIndicator(p)
	local controller = MomentContext.useMoment().controller
	local v3 = useTokens()
	local reducedMotion = usePreferences().reducedMotion

	local state, setState = React.useState(false)
	local v4, v5 = ReactOtter.useAnimatedBinding(0)

	local v6 = useIsPlaying()
	local v7

	if FFlagMomentsAutoplayAmpPolicy then
		v7 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if controller == nil then
					return "Idle"
				end

				return controller.getState(p2).readiness
			end)
		end, { controller })
	end

	local v8

	if FFlagMomentsAutoplayAmpPolicy then
		v8 = useSignalState(v7)
	end

	local ref = React.useRef(nil)
	function ref.current(p2)
		local v9

		if reducedMotion then
			v9 = ReactOtter.instant(p2 == "enter" and 1 or 0)
		elseif p2 == "enter" then
			v9 = ReactOtter.spring(1, v)
		else
			v9 = ReactOtter.ease(0, v2)
		end

		v5(v9)
	end

	local ref2 = React.useRef(nil)
	ref2.current = p.scheduleOverride or defaultSchedule

	local v9 = React.useMemo(function()
		return playbackToggleIndicatorMachine({ dwellMs = 800, exitDurationMs = 150 }, {
			schedule = function(p2: number, callback)
				return ref2.current(p2, callback)
			end,
			setMounted = setState,
			animate = function(p2)
				ref.current(p2)
			end
		})
	end, {})

	React.useEffect(function()
		return function()
			v9.dispose()
		end
	end, { v9 })

	React.useEffect(function()
		if controller == nil then
			return
		end

		local v10 = nil
		return (Signals.createEffect(function(p2)
			local userToggleNonce = controller.getUserToggleNonce(p2)

			if v10 == nil then
				v10 = userToggleNonce
				return
			end

			if userToggleNonce == v10 then
				return
			end

			v10 = userToggleNonce
			v9.notifyUserToggle()
		end))
	end, { controller, v9 })
	local v10

	if FFlagMomentsAutoplayAmpPolicy then
		if v8 == "Ready" then
			v10 = not v6
		else
			v10 = false
		end
	else
		v10 = nil
	end

	if not (state or FFlagMomentsAutoplayAmpPolicy and v10) then
		return nil
	end

	local mapped = v4:map(function(p2: number)
		if FFlagMomentsAutoplayAmpPolicy and v10 then
			return 1
		end

		return p2 * 0.25 + 0.75
	end)

	local mapped2 = v4:map(function(p2: number)
		if FFlagMomentsAutoplayAmpPolicy and v10 then
			return 0
		end

		return 1 - p2
	end)

	local createElement = React.createElement
	local v11 = {
		tag = "position-center-center anchor-center-center",
		Size = UDim2.fromOffset(64, 64),
		BackgroundTransparency = 1,
		scale = mapped,
		ZIndex = 3
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local name = if v6 then IconName.PauseLarge else IconName.PlayLarge
	return createElement(View, v11, {
		Circle = createElement2(
			View,
			{
				tag = "row align-x-center align-y-center size-full radius-circle clip bg-over-media-0",
				GroupTransparency = mapped2
			},
			{
				Glyph = createElement3(Icon, {
					name = name,
					size = IconSize.Large,
					style = v3.Color.Content.Emphasis
				})
			}
		)
	})
end

return PlaybackToggleIndicator
