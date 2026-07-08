local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local MomentContext = require(script.Parent.MomentContext)
local playbackToggleIndicatorMachine = require(script.Parent.playbackToggleIndicatorMachine)
local Icon = Foundation.Icon
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local useSignalState = SignalsReact.useSignalState
local t1 = {
	frequency = 4,
	dampingRatio = 1
}
local t2 = {
	duration = 0.15,
	easingStyle = Enum.EasingStyle.Quad
}

local function defaultSchedule(n1: number, p1: ((...any) -> ...any)) -- line: 57
	local thread = task.delay(n1 / 1000, p1)

	return function() -- line: 59
		-- upvalues: thread (copy)
		task.cancel(thread)
	end
end
local function PlaybackToggleIndicator(t3: {[any]: any}) -- line: 70
	-- upvalues: MomentContext (copy), useTokens (copy), usePreferences (copy), React (copy), ReactOtter (copy), Signals (copy), useSignalState (copy), t1 (copy), t2 (copy), defaultSchedule (copy), playbackToggleIndicatorMachine (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy)
	local controller = MomentContext.useMoment().controller
	local v25 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v27, v28 = React.useState(false)
	local v29, v30 = ReactOtter.useAnimatedBinding(0)
	local v31 = React.useMemo(function() -- line: 82
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p2) -- line: 83
			-- upvalues: controller (copy)
			if controller == nil then
				return false
			end

			return controller.getState(p2).isPlaying
		end)
	end, { controller })
	local v32 = useSignalState(v31)
	local v33 = React.useRef(nil)

	function v33.current(p3) -- line: 95
		-- upvalues: reducedMotion (copy), ReactOtter (copy), t1 (copy), t2 (copy), v30 (copy)
		local v39 = if not reducedMotion then if p3 ~= "enter" then ReactOtter.ease(0, t2) else ReactOtter.spring(1, t1) else ReactOtter.instant(p3 ~= "enter" and 0 or 1)

		v30(v39)
	end

	local v34 = React.useRef(nil)

	v34.current = t3.scheduleOverride or defaultSchedule

	local v35 = React.useMemo(function() -- line: 113
		-- upvalues: playbackToggleIndicatorMachine (copy), v34 (copy), v28 (copy), v33 (copy)
		return playbackToggleIndicatorMachine({
			dwellMs = 800,
			exitDurationMs = 150
		}, {
			schedule = function(n2: number, p4: ((...any) -> ...any)) -- line: 118
				-- upvalues: v34 (copy)
				return v34.current(n2, p4)
			end,
			setMounted = v28,
			animate = function(p5) -- line: 122
				-- upvalues: v33 (copy)
				v33.current(p5)
			end
		})
	end, {})

	React.useEffect(function() -- line: 130
		-- upvalues: v35 (copy)
		return function() -- line: 131
			-- upvalues: v35 (copy)
			v35.dispose()
		end
	end, { v35 })
	React.useEffect(function() -- line: 139
		-- upvalues: controller (copy), Signals (copy), v35 (copy)
		if controller == nil then
			return
		end

		local u40 = nil

		return (Signals.createEffect(function(p6) -- line: 144
			-- upvalues: controller (copy), u40 (ref), v35 (copy)
			local v48 = controller.getUserToggleNonce(p6)

			if u40 == nil then
				u40 = v48

				return
			end

			if v48 == u40 then
				return
			end

			u40 = v48
			v35.notifyUserToggle()
		end))
	end, {
		controller,
		v35
	})

	if not v27 then
		return nil
	end

	local v36 = v29:map(function(n3: number) -- line: 163
		return n3 * 0.25 + 0.75
	end)
	local v37 = v29:map(function(n4: number) -- line: 166
		return 1 - n4
	end)

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center",
		BackgroundTransparency = 1,
		ZIndex = 3,
		Size = UDim2.fromOffset(64, 64),
		scale = v36
	}, {
		Circle = React.createElement(View, {
			tag = "row align-x-center align-y-center size-full radius-circle clip bg-over-media-0",
			GroupTransparency = v37
		}, {
			Glyph = React.createElement(Icon, {
				name = if not v32 then IconName.PlayLarge else IconName.PauseLarge,
				size = IconSize.Large,
				style = v25.Color.Content.Emphasis
			})
		})
	})
end

return PlaybackToggleIndicator
