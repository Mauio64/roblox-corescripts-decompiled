local Parent = script:FindFirstAncestor("Foundation").Parent

require(Parent.React)

local Motion = require(Parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useButtonMotionStates(n1: number?, n2: number) -- line: 27
	-- upvalues: Motion (copy), TransitionPreset (copy)
	return {
		Default = Motion.createState({
			iconScale = 1,
			transparency = n1 or 0,
			textTransparency = n1 or 0
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				duration = 0.5,
				easingStyle = Enum.EasingStyle.Linear
			}),
			transparency = Motion.transition({
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			}),
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2
			})
		}),
		Loading = Motion.createState({
			transparency = 0,
			textTransparency = 1,
			iconTransparency = 1,
			iconScale = 0
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			}),
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2
			})
		}),
		Disabled = Motion.createState({
			transparency = n2,
			textTransparency = n2
		}, {
			default = Motion.transition({
				duration = 0.1,
				easingStyle = Enum.EasingStyle.Linear
			})
		})
	}
end

return useButtonMotionStates
