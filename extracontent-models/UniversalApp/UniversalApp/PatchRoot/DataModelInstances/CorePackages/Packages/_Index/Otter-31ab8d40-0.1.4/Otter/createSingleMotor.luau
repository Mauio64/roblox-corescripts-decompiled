local RunService = game:GetService("RunService")
local createSignal = require(script.Parent.createSignal)
local t1 = {
	prototype = {}
}

t1.__index = t1.prototype

local function createSingleMotor(p1) -- line: 9
	-- upvalues: createSignal (copy), t1 (copy)
	assert(typeof(p1) == "number")

	local t2 = {
		__goal = nil,
		__running = false,
		__state = {
			complete = true,
			value = p1
		},
		__onComplete = createSignal(),
		__onStep = createSignal()
	}

	setmetatable(t2, t1)

	return t2
end

function t1.prototype.start(p2) -- line: 28
	-- upvalues: RunService (copy)
	if p2.__running then
		return
	end

	p2.__connection = RunService.Heartbeat:Connect(function(dt) -- line: 33
		-- upvalues: p2 (copy)
		p2:step(dt)
	end)
	p2.__running = true
end
function t1.prototype.stop(p3) -- line: 40
	if p3.__connection ~= nil then
		p3.__connection:Disconnect()
	end

	p3.__running = false
end
function t1.prototype.step(p4, p5) -- line: 48
	assert(typeof(p5) == "number")

	if p4.__state.complete then
		return
	end

	if p4.__goal == nil then
		return
	end

	local v11 = p4.__goal:step(p4.__state, p5)

	if v11 ~= nil then
		p4.__state = v11
	end

	p4.__onStep:fire(p4.__state.value)

	if p4.__state.complete and p4.__running then
		p4:stop()
		p4.__onComplete:fire(p4.__state.value)
	end
end
function t1.prototype.setGoal(p6, p7) -- line: 73
	p6.__goal = p7
	p6.__state.complete = false
	p6:start()
end
function t1.prototype.onStep(p8, p9) -- line: 79
	assert(typeof(p9) == "function")

	return p8.__onStep:subscribe(p9)
end
function t1.prototype.onComplete(p10, p11) -- line: 85
	assert(typeof(p11) == "function")

	return p10.__onComplete:subscribe(p11)
end
function t1.prototype.destroy(p12) -- line: 91
	p12:stop()
end

return createSingleMotor
