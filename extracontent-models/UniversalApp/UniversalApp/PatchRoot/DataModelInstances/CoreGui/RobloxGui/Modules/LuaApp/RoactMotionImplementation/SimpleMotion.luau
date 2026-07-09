local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local stepSpring = require(script.Parent.stepSpring)
local merge = require(script.Parent.merge)
local Config = require(script.Parent.Config)
local MotionType = require(script.Parent.MotionType)
local MotionSpecifier = require(script.Parent.MotionSpecifier)
local v9 = Roact.Component:extend("SimpleMotion")
local t1 = {}

RunService.RenderStepped:Connect(function(dt) -- line: 36
	-- upvalues: t1 (copy)
	for k in pairs(t1) do
		k(dt)
	end
end)

function v9.init(p1) -- line: 42
	-- upvalues: MotionSpecifier (copy)
	local t2 = {}
	local t3 = {}

	for k, v in pairs(p1.props.style) do
		t3[k] = 0
		t2[k] = MotionSpecifier.extractValue(v)
	end

	if p1.props.defaultStyle then
		for k, v in pairs(p1.props.defaultStyle) do
			t2[k] = v
		end
	end

	p1.resting = false
	p1.wasResting = true
	p1.accumulator = 0
	p1.state = {
		values = t2,
		velocities = t3
	}
end
function v9.render(p2) -- line: 79
	return p2.props.render(p2.state.values)
end
function v9.update(p3, p4) -- line: 83
	-- upvalues: merge (copy), Config (copy), MotionSpecifier (copy), MotionType (copy), stepSpring (copy)
	if p3.resting then
		return
	end

	local v23 = merge(p3.state.values)
	local v24 = merge(p3.state.velocities)
	local v25 = false

	p3.accumulator = p3.accumulator + p4 % Config.MAX_ACCUMULATION

	local g26 = nil

	repeat
		if not (p3.accumulator >= Config.UPDATE_RATE) then
			g26 = true
		end

		if g26 then
			break
		end

		p3.accumulator = p3.accumulator - Config.UPDATE_RATE

		local v27 = true

		for k, v in pairs(p3.props.style) do
			local v30 = MotionSpecifier.getType(v)
			local v31 = nil
			local n1 = nil

			if v30 == MotionType.Instant then
				v31 = v
				n1 = 0
				p3.wasResting = false
			elseif v30 == MotionType.Spring then
				v31, n1 = stepSpring(Config.UPDATE_RATE * Config.TIME_FACTOR, v23[k], v24[k], v.value, v.stiffness, v.damping, v.precision)
			else
				error(("Unsupported MotionType %q"):format(v30))
			end

			v23[k] = v31
			v24[k] = n1

			if v31 ~= p3.state.values[k] or n1 ~= p3.state.velocities[k] then
				v25 = true
			end

			if v31 ~= MotionSpecifier.extractValue(v) or n1 ~= 0 then
				v27 = false
			end
		end
	until v27

	if not g26 then
		p3.resting = true
		p3.accumulator = 0
	end

	g26 = false

	if v25 then
		p3:setState({
			values = v23,
			velocities = v24
		})
	end

	if not p3.wasResting and p3.resting and p3.props.onRested then
		p3.props.onRested()
	end

	p3.wasResting = p3.resting
end
function v9.didMount(p5) -- line: 162
	-- upvalues: t1 (copy)
	function p5.renderCallback(p6) -- line: 163
		-- upvalues: p5 (copy)
		p5:update(p6)
	end

	t1[p5.renderCallback] = true
end
function v9.willUnmount(p7) -- line: 169
	-- upvalues: t1 (copy)
	t1[p7.renderCallback] = nil
end
function v9.didUpdate(p8, p9) -- line: 173
	if p9 == p8.props then
		return
	end

	p8.resting = false
end

return v9
