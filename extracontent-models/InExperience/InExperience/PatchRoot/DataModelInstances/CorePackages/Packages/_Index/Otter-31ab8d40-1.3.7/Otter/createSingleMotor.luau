local ParentParent = script.Parent.Parent
local createSignal = require(ParentParent.Signal).createSignal
local AnimationStepSignal = require(script.Parent.AnimationStepSignal)

require(script.Parent.types)

local t1 = {}

t1.__index = t1

local function createSingleMotor(p1) -- line: 41
	-- upvalues: createSignal (copy), t1 (copy)
	local v7, v8 = createSignal()
	local v9, v10 = createSignal()
	local t2 = {
		__goal = nil,
		__running = false,
		__state = {
			complete = true,
			value = p1
		},
		__onComplete = v7,
		__fireOnComplete = v8,
		__onStep = v9,
		__fireOnStep = v10
	}

	setmetatable(t2, t1)

	return t2
end

function t1.start(p2) -- line: 63
	-- upvalues: AnimationStepSignal (copy)
	if p2.__running then
		return
	end

	p2.__connection = AnimationStepSignal:Connect(function(p3) -- line: 68
		-- upvalues: p2 (copy)
		p2:step(p3)
	end)
	p2.__running = true

	if p2.__goal and p2.__goal.startingValue then
		p2.__state.value = p2.__goal.startingValue

		if p2.__state.initialValue then
			p2.__state.initialValue = p2.__goal.startingValue
		end

		p2:step(0)
	end
end
function t1.stop(p4) -- line: 83
	if p4.__connection ~= nil then
		p4.__connection:Disconnect()
	end

	p4.__running = false
end
function t1.step(t3: {[any]: any}, n1: number) -- line: 91
	if t3.__state.complete then
		return
	end

	if t3.__goal == nil then
		return
	end

	local v16 = t3.__goal.step(t3.__state, n1)

	if v16 ~= nil then
		t3.__state = v16
	end

	t3.__fireOnStep(t3.__state.value)

	if t3.__state.complete and t3.__running then
		t3:stop()
		t3.__fireOnComplete(t3.__state.value)
	end
end
function t1.setGoal(p5, p6) -- line: 114
	p5.__goal = p6
	p5.__state.complete = false
	p5:start()
end
function t1.onStep(p7, p8) -- line: 120
	local v21 = p7.__onStep:subscribe(p8)

	return function() -- line: 123
		-- upvalues: v21 (copy)
		v21:unsubscribe()
	end
end
function t1.onComplete(p9, p10) -- line: 128
	local v24 = p9.__onComplete:subscribe(p10)

	return function() -- line: 131
		-- upvalues: v24 (copy)
		v24:unsubscribe()
	end
end
function t1.destroy(p11) -- line: 136
	p11:stop()
end

return createSingleMotor
