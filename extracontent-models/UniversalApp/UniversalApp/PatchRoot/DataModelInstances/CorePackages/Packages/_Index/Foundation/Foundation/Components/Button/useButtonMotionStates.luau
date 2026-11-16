local parent = script:FindFirstAncestor("Foundation").Parent

require(parent.React)

local Motion = require(parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useButtonMotionStates(value: number?, p: number)
	return {
		Default = Motion.createState({
			transparency = value or 0,
			textTransparency = value or 0,
			iconScale = 1
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.5
			}),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			}),
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2 })
		}),
		Loading = Motion.createState({
			transparency = 0,
			textTransparency = 1,
			iconTransparency = 1,
			iconScale = 0
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			}),
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2 })
		}),
		Disabled = Motion.createState({ transparency = p, textTransparency = p }, {
			default = Motion.transition({ easingStyle = Enum.EasingStyle.Linear, duration = 0.1 })
		})
	}
end

return useButtonMotionStates
