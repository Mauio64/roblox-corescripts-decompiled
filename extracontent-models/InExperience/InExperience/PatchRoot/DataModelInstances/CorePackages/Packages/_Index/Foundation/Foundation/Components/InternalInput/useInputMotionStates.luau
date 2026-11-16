local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(Foundation.Components.Types)

require(Foundation.Providers.Style.Tokens)

require(parent.React)

local Motion = require(parent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useInputMotionStates(p, p2)
	local strokeStyle

	if p2 and p2.backgroundStyle then
		strokeStyle = p2.backgroundStyle
	else
		strokeStyle = p.Color.Content.Default
	end

	local v

	if p2 and p2.checkedStyle then
		v = p2.checkedStyle
	else
		v = p.Color.ActionSubEmphasis.Background
	end

	local emphasis = p.Color.Content.Emphasis

	return {
		Default = Motion.createState({
			backgroundStyle = {
				Color3 = strokeStyle.Color3,
				Transparency = not (p2 and p2.backgroundStyle) and 1 or p2.backgroundStyle.Transparency
			},
			strokeStyle = strokeStyle,
			labelStyle = emphasis
		}, {
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2 }),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			})
		}),
		Checked = Motion.createState({ backgroundStyle = v, strokeStyle = v, labelStyle = emphasis }, {
			default = Motion.transition(TransitionPreset.Default, { duration = 0.2 }),
			transparency = Motion.transition({
				easingStyle = Enum.EasingStyle.Linear,
				duration = 0.2
			})
		})
	}
end

return useInputMotionStates
