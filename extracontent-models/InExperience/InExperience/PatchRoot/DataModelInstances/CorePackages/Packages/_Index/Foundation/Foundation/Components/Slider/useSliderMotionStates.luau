local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local Motion = require(FoundationParent.Motion)
local TransitionPreset = Motion.TransitionPreset

require(Foundation.Components.Types)

local function useSliderMotionStates(p1, p2) -- line: 28
	-- upvalues: Motion (copy), TransitionPreset (copy)
	return {
		Hidden = Motion.createState({
			transparency = 1,
			knobStyle = {
				Transparency = 1,
				Color3 = p1.Color3
			}
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.15
			})
		}),
		Idle = Motion.createState({
			transparency = 0,
			knobStyle = p1
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.15
			})
		}),
		Dragging = Motion.createState({
			transparency = 0,
			knobStyle = p2
		}, {
			default = Motion.transition(TransitionPreset.Default, {
				duration = 0.1
			})
		})
	}
end

return useSliderMotionStates
