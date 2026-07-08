local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local TransitionPreset = require(ParentParent.Enums.TransitionPreset)
local t1 = {
	presets = {
		[TransitionPreset.Default] = {
			duration = 0.3,
			delay = 0,
			easingStyle = {
				0.2,
				0,
				0,
				1
			}
		},
		[TransitionPreset.Quick] = {
			duration = 0.05,
			delay = 0,
			easingStyle = {
				0.2,
				0,
				0,
				1
			}
		},
		[TransitionPreset.Slow] = {
			duration = 1,
			delay = 0,
			easingStyle = {
				0.2,
				0,
				0,
				1
			}
		}
	}
}

function t1.getDefaultTransition() -- line: 28
	-- upvalues: t1 (copy), TransitionPreset (copy)
	local v4 = t1.presets[TransitionPreset.Default]

	return {
		duration = v4.duration,
		easingStyle = v4.easingStyle,
		delay = v4.delay
	}
end
function t1.createDefaultTransitionState() -- line: 39
	-- upvalues: t1 (copy)
	return {
		default = t1.getDefaultTransition()
	}
end

return t1
