require(script.Parent.Types)

local TransitionPreset = require(script.Parent.Enums.TransitionPreset)
local presets = require(script.Parent.Utility.TimingConfigs).presets
local v3 = presets[TransitionPreset.Default]
local t1 = {}

local function getTransition(p1) -- line: 12
	-- upvalues: v3 (copy)
	return p1.transition or {
		default = v3
	}
end

function t1.createState(t2: {[any]: any}, t3: {[any]: any}?) -- line: 18
	-- upvalues: v3 (copy)
	local t4 = {
		transition = {
			default = t3 and t3.default or v3
		}
	}

	for v10, v11 in t2 do
		t4[v10] = v11

		if t3 and t3[v10] then
			(t4.transition or {
				default = v3
			})[v10] = t3[v10]
		end
	end

	return t4
end
function t1.transition(p2, p3) -- line: 40
	-- upvalues: presets (copy), v3 (copy)
	local v14 = if type(p2) ~= "string" then p2 else presets[p2] or v3
	local t5 = {
		duration = v14 and v14.duration or v3.duration,
		easingStyle = v14 and v14.easingStyle or v3.easingStyle,
		delay = v14 and v14.delay or v3.delay
	}

	if p3 then
		if p3.duration then
			t5.duration = p3.duration
		end

		if p3.easingStyle then
			t5.easingStyle = p3.easingStyle
		end

		if p3.delay then
			t5.delay = p3.delay
		end
	end

	return t5
end
function t1.animate(p4, t6: {[any]: any}) -- line: 69
	-- upvalues: v3 (copy)
	if not p4 then
		return
	end

	local v18 = p4.transition or {
		default = v3
	}

	for v19, v20 in t6 do
		local v21 = v18[v19]
		local v22 = if v21 == nil then v18.default else v21

		if v22.delay and v22.delay > 0 then
			local v23 = table.clone(v22)

			task.delay(v22.delay, function() -- line: 88
				-- upvalues: v20 (copy), p4 (copy), v19 (copy), v23 (copy)
				v20(p4[v19], v23)
			end)
		else
			v20(p4[v19], v22)
		end
	end
end

return t1
