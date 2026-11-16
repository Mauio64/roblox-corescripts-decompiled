require(script.Parent.Types)

local TransitionPreset = require(script.Parent.Enums.TransitionPreset)

local TimingConfigs = require(script.Parent.Utility.TimingConfigs)
local presets = TimingConfigs.presets
local preset = presets[TransitionPreset.Default]

local function getTransition(state) -- 1 equivalent call inferred from this helper
	return state.transition or { default = preset }
end

local Motion = {}

function Motion.createState(items, p)
	local state = {
		transition = {
			default = p and p.default or preset
		}
	}

	for k, item in items do
		state[k] = item

		if not (p and p[k]) then
			continue
		end

		local transition = getTransition(state) -- inferred equivalent call
		transition[k] = p[k]
	end

	return state
end

function Motion.transition(value, data)
	if type(value) == "string" then
		value = presets[value] or preset
	end

	local v = {
		duration = value and value.duration or preset.duration,
		easingStyle = value and value.easingStyle or preset.easingStyle,
		delay = value and value.delay or preset.delay
	}

	if not data then
		return v
	end

	if data.duration then
		v.duration = data.duration
	end

	if data.easingStyle then
		v.easingStyle = data.easingStyle
	end

	if data.delay then
		v.delay = data.delay
	end

	return v
end

function Motion.animate(p, items)
	if not p then
		return
	end

	local transition = p.transition or { default = preset }

	for k, item in items do
		local v = transition[k]

		if v == nil then
			v = transition.default
		end

		if v.delay and v.delay > 0 then
			local clone = table.clone(v)
			task.delay(v.delay, function()
				item(p[k], clone)
			end)
		else
			item(p[k], v)
		end
	end
end

return Motion
