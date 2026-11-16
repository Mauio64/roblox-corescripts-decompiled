local parent = script:FindFirstAncestor("Foundation").Parent

require(parent.React)

local Motion = require(parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useSpinnerMotionStates()
	return {
		Default = Motion.createState({ scale = 0, transparency = 1 }, {
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2 }),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			})
		}),
		Loading = Motion.createState({ scale = 1, transparency = 0 }, {
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2, delay = 0.1 }),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			})
		})
	}
end

return useSpinnerMotionStates
