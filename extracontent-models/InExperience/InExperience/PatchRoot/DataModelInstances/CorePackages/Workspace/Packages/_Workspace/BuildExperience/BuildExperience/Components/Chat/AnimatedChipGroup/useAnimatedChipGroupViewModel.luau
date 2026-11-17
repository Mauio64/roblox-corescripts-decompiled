local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)

require(script.Parent.AnimatedChipGroupView)
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function useAnimatedChipGroupViewModel(p)
	local reducedMotion = usePreferences().reducedMotion
	local tokens = useTokens()
	local seconds = (#p.chips - 1) * 0.15 + 0.25
	local v, v2 = Motion.useMotion({
		seconds = not reducedMotion and 0 or seconds
	})

	React.useEffect(function()
		v2(Motion.createState({ seconds = seconds }, {
			default = Motion.transition({
				duration = reducedMotion and 0 or seconds,
				easingStyle = Enum.EasingStyle.Linear
			})
		}))
	end, { v2, seconds, reducedMotion })

	local chipAnimationStates = {}

	for k in p.chips do
		local v3 = 0.15 * (k - 1)
		chipAnimationStates[k] = {
			hasStarted = v.seconds:map(function(p2: number): boolean
				return v3 <= p2
			end),
			groupTransparency = v.seconds:map(function(p2: number)
				return 1 - math.clamp((p2 - v3) / 0.25, 0, 1)
			end)
		}
	end

	return {
		chips = p.chips,
		chipGroupRef = p.chipGroupRef,
		chipAnimationStates = chipAnimationStates,
		tokens = tokens
	}
end

return useAnimatedChipGroupViewModel
