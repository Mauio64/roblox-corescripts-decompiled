local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local useTokens = require(Foundation.Providers.Style.useTokens)
local Motion = require(FoundationParent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useOptionSelectorGroupItemMotionStates(n1: number?, n2: number) -- line: 27
	-- upvalues: useTokens (copy), Motion (copy), TransitionPreset (copy)
	local v9 = useTokens()

	return {
		Default = Motion.createState({
			transparency = n1 or 0,
			textTransparency = n1 or 0
		}, {
			iconTransparency = Motion.transition(TransitionPreset.Default, {
				easingStyle = Enum.EasingStyle.Linear,
				duration = v9.Time.Time_500
			}),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = v9.Time.Time_200
			}),
			default = Motion.transition(TransitionPreset.Default, {
				duration = v9.Time.Time_200
			})
		}),
		Disabled = Motion.createState({
			transparency = n2,
			textTransparency = n2
		}, {
			default = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = v9.Time.Time_100
			})
		})
	}
end

return useOptionSelectorGroupItemMotionStates
