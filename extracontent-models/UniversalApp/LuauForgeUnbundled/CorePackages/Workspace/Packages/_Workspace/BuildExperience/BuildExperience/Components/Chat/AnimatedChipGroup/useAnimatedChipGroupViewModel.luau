local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnimatedChipGroup/AnimatedChipGroupView")
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function useAnimatedChipGroupViewModel(p2)
	local reducedMotion = usePreferences().reducedMotion
	local v5 = useTokens()
	local v6 = (#p2.chips - 1) * 0.15 + 0.25
	local v7, v8 = Motion.useMotion({
		seconds = not reducedMotion and 0 or v6
	})

	React.useEffect(function()
		v8(Motion.createState({ seconds = v6 }, {
			default = Motion.transition({
				duration = reducedMotion and 0 or v6,
				easingStyle = Enum.EasingStyle.Linear
			})
		}))
	end, { v8, v6, reducedMotion })

	local v9 = {}

	for k in p2.chips do
		local v10 = 0.15 * (k - 1)
		v9[k] = {
			hasStarted = v7.seconds:map(function(p3): boolean
				return v10 <= p3
			end),
			groupTransparency = v7.seconds:map(function(p3)
				return 1 - math.clamp((p3 - v10) / 0.25, 0, 1)
			end)
		}
	end

	return {
		chips = p2.chips,
		chipGroupRef = p2.chipGroupRef,
		chipAnimationStates = v9,
		tokens = v5
	}
end

return useAnimatedChipGroupViewModel
