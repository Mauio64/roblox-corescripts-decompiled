local Parent = script:FindFirstAncestor("Foundation").Parent

require(Parent.React)

local Motion = require(Parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useSpinnerMotionStates() -- line: 24
	-- upvalues: Motion (copy), TransitionPreset (copy)
	return {
		Default = Motion.createState({
			scale = 0,
			transparency = 1
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2
			}),
			transparency = Motion.transition({
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			})
		}),
		Loading = Motion.createState({
			scale = 1,
			transparency = 0
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2,
				delay = 0.1
			}),
			transparency = Motion.transition({
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			})
		})
	}
end

return useSpinnerMotionStates
