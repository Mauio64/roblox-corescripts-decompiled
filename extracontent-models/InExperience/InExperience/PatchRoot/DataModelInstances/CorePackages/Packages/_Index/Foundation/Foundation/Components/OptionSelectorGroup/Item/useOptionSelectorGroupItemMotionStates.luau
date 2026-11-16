local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.React)

local useTokens = require(Foundation.Providers.Style.useTokens)

local Motion = require(parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useOptionSelectorGroupItemMotionStates(value: number?, p: number)
	local v = useTokens()
	return {
		Default = Motion.createState({
			transparency = value or 0,
			textTransparency = value or 0
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				easingStyle = Enum.EasingStyle.Linear,
				duration = v.Time.Time_500
			}),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = v.Time.Time_200
			}),
			default = Motion.transition(TransitionPreset.Default, { duration = v.Time.Time_200 })
		}),
		Disabled = Motion.createState({ transparency = p, textTransparency = p }, {
			default = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = v.Time.Time_100
			})
		})
	}
end

return useOptionSelectorGroupItemMotionStates
