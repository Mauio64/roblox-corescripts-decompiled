local parent = script.Parent.Parent
require(parent.Types)
local TransitionPreset = require(parent.Enums.TransitionPreset)
local TimingConfigs = {}

TimingConfigs.presets = {
	[TransitionPreset.Default] = {
		duration = 0.3,
		easingStyle = { 0.2, 0, 0, 1 },
		delay = 0
	},
	[TransitionPreset.Quick] = {
		duration = 0.05,
		easingStyle = { 0.2, 0, 0, 1 },
		delay = 0
	},
	[TransitionPreset.Slow] = {
		duration = 1,
		easingStyle = { 0.2, 0, 0, 1 },
		delay = 0
	}
}

function TimingConfigs.getDefaultTransition()
	local preset = TimingConfigs.presets[TransitionPreset.Default]

	return { duration = preset.duration, easingStyle = preset.easingStyle, delay = preset.delay }
end

function TimingConfigs.createDefaultTransitionState()
	return {
		default = TimingConfigs.getDefaultTransition()
	}
end

return TimingConfigs
