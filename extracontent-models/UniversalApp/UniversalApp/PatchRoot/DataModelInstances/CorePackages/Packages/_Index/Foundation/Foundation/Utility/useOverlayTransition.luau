local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useOverlayTransition(p)
	local v = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local isOpen = p.isOpen
	local onExited = p.onExited

	local state, setState = React.useState(isOpen)

	local state2, setState2 = React.useState(isOpen)
	local v2 = isOpen and 1 or 0
	local progress, v3 = useAnimatedBinding(0, function(p2: number)
		setState2(false)

		if p2 == 0 and not isOpen and state then
			setState(false)

			if onExited then
				onExited()
			end
		end
	end)

	React.useEffect(function()
		if isOpen then
			setState(true)
		end

		if reducedMotion then
			v3((Otter.instant(v2)))
			return
		end

		setState2(progress:getValue() ~= v2)
		local ease = Otter.ease
		local easingStyle

		if isOpen then
			easingStyle = v.Ease.StandardOut
		else
			easingStyle = v.Ease.StandardIn
		end

		local duration

		if isOpen then
			duration = v.Time.Time_300
		else
			duration = v.Time.Time_200
		end

		v3(ease(v2, { easingStyle = easingStyle, duration = duration }))
	end, { isOpen, v2, reducedMotion, v, progress, v3 })

	return {
		isMounted = isOpen or state,
		isAnimating = state2,
		progress = progress
	}
end

return useOverlayTransition
