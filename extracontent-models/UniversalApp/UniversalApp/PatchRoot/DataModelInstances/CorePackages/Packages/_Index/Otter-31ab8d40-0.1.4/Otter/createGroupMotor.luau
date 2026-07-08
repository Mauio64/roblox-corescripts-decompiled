local RunService = game:GetService("RunService")
local assign = require(script.Parent.assign)
local createSignal = require(script.Parent.createSignal)
local t1 = {
	prototype = {}
}

t1.__index = t1.prototype

local function createGroupMotor(p1) -- line: 10
	-- upvalues: createSignal (copy), t1 (copy)
	assert(typeof(p1) == "table")

	local t2 = {}

	for k, v in pairs(p1) do
		t2[k] = {
			complete = true,
			value = v
		}
	end

	local t3 = {
		__allComplete = true,
		__running = false,
		__goals = {},
		__states = t2,
		__onComplete = createSignal(),
		__onStep = createSignal()
	}

	setmetatable(t3, t1)

	return t3
end

function t1.prototype.start(p2) -- line: 36
	-- upvalues: RunService (copy)
	if p2.__running then
		return
	end

	p2.__connection = RunService.Heartbeat:Connect(function(dt) -- line: 41
		-- upvalues: p2 (copy)
		p2:step(dt)
	end)
	p2.__running = true
end
function t1.prototype.stop(p3) -- line: 48
	if p3.__connection ~= nil then
		p3.__connection:Disconnect()
		p3.__running = false
	end
end
function t1.prototype.step(p4, p5) -- line: 55
	assert(typeof(p5) == "number")

	if p4.__allComplete then
		return
	end

	local v15 = true
	local t4 = {}

	for k, v in pairs(p4.__states) do
		local v19 = v

		if not v19.complete then
			local v20 = p4.__goals[k]

			if v20 ~= nil then
				local v21 = v20:step(v19, p5)

				if v21 ~= nil then
					v19 = v21
					p4.__states[k] = v21
				end
			else
				v19.complete = true
			end

			if not v19.complete then
				v15 = false
			end
		end

		t4[k] = v19.value
	end

	local __allComplete = p4.__allComplete

	p4.__allComplete = v15
	p4.__onStep:fire(t4)

	if p4.__allComplete and not __allComplete and p4.__running then
		p4:stop()
		p4.__onComplete:fire(t4)
	end
end
function t1.prototype.setGoal(p6, p7) -- line: 102
	-- upvalues: assign (copy)
	assert(typeof(p7) == "table")
	p6.__goals = assign({}, p6.__goals, p7)

	for k in pairs(p7) do
		local v26 = p6.__states[k]

		if v26 == nil then
			error(("Cannot set goal for the value %s because it doesn't exist"):format((tostring(k))), 2)
		end

		v26.complete = false
	end

	p6.__allComplete = false
	p6:start()
end
function t1.prototype.onStep(p8, p9) -- line: 121
	assert(typeof(p9) == "function")

	return p8.__onStep:subscribe(p9)
end
function t1.prototype.onComplete(p10, p11) -- line: 127
	assert(typeof(p11) == "function")

	return p10.__onComplete:subscribe(p11)
end
function t1.prototype.destroy(p12) -- line: 133
	p12:stop()
end

return createGroupMotor
