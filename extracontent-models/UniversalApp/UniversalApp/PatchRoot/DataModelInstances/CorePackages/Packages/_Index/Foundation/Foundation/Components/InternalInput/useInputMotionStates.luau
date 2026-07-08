local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Components.Types)
require(Foundation.Providers.Style.Tokens)

local Flags = require(Foundation.Utility.Flags)

require(FoundationParent.React)

local Motion = require(FoundationParent.Motion)
local TransitionPreset = Motion.TransitionPreset

local function useInputMotionStates(p1, p2) -- line: 41
	-- upvalues: Flags (copy), Motion (copy), TransitionPreset (copy)
	local v9, v10, v11, v12, v13

	if Flags.FoundationToggleVisualUpdate then
		v9 = if not p2 or not p2.backgroundStyle then p1.Color.Content.Default else p2.backgroundStyle
		v10 = if not p2 or not p2.hoverStyle then p1.Color.Content.Emphasis else p2.hoverStyle
		v11 = if not p2 or not p2.checkedStyle then p1.Color.ActionSubEmphasis.Background else p2.checkedStyle
		v12 = if not p2 or not p2.labelStyle then p1.Color.Content.Default else p2.labelStyle
		v13 = if not p2 or not p2.labelHoverStyle then p1.Color.Content.Emphasis else p2.labelHoverStyle
	else
		v9 = p1.Color.Content.Default
		v10 = p1.Color.Content.Emphasis
		v12 = p1.Color.Content.Default
		v13 = p1.Color.Content.Emphasis
		v11 = p2 or p1.Color.ActionSubEmphasis.Background
	end

	return {
		Default = Motion.createState({
			backgroundStyle = {
				Color3 = v9.Color3,
				Transparency = (not p2 or not p2.backgroundStyle) and 1 or p2.backgroundStyle.Transparency
			},
			strokeStyle = v9,
			labelStyle = v12
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2
			}),
			transparency = Motion.transition({
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			})
		}),
		Hover = Motion.createState({
			backgroundStyle = {
				Color3 = v10.Color3,
				Transparency = (not p2 or not p2.hoverStyle) and 1 or p2.hoverStyle.Transparency
			},
			strokeStyle = v10,
			labelStyle = v13
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0
			}),
			transparency = Motion.transition({
				duration = 0,
				easingStyle = Enum.EasingStyle.Linear
			})
		}),
		Checked = Motion.createState({
			backgroundStyle = v11,
			strokeStyle = v11,
			labelStyle = v13
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.2
			}),
			transparency = Motion.transition({
				duration = 0.2,
				easingStyle = Enum.EasingStyle.Linear
			})
		})
	}
end

return useInputMotionStates
