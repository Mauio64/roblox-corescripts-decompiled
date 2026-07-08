local ParentParent = script.Parent.Parent
local Object = require(ParentParent.Collections).Object
local createSignal = require(ParentParent.Signal).createSignal
local AnimationStepSignal = require(script.Parent.AnimationStepSignal)

require(script.Parent.types)

local t1 = {}

t1.__index = t1

local function createGroupMotor(t2: {[any]: any}) -- line: 53
	-- upvalues: createSignal (copy), t1 (copy)
	local t3 = {}

	for k, v in pairs(t2) do
		t3[k] = {
			complete = true,
			value = v
		}
	end

	local v11, v12 = createSignal()
	local v13, v14 = createSignal()
	local t4 = {
		__allComplete = true,
		__running = false,
		__goals = {},
		__states = t3,
		__onComplete = v11,
		__fireOnComplete = v12,
		__onStep = v13,
		__fireOnStep = v14
	}

	setmetatable(t4, t1)

	return t4
end

function t1.start(t5: {[any]: any}, b1: boolean) -- line: 82
	-- upvalues: AnimationStepSignal (copy)
	if t5.__running then
		return
	end

	t5.__connection = AnimationStepSignal:Connect(function(p1) -- line: 87
		-- upvalues: t5 (copy)
		t5:step(p1)
	end)
	t5.__running = true

	if b1 then
		t5:step(0)
	end
end
function t1.stop(p2) -- line: 98
	if p2.__connection ~= nil then
		p2.__connection:Disconnect()
		p2.__running = false
	end
end
function t1.step(t6: {[any]: any}, n1: number) -- line: 105
	if t6.__allComplete then
		return
	end

	local v21 = true
	local t7 = {}

	for k, v in pairs(t6.__states) do
		local v25 = v

		if not v25.complete then
			local v26 = t6.__goals[k]

			if v26 ~= nil then
				local v27 = v26.step(v25, n1)

				if v27 ~= nil then
					v25 = v27
					t6.__states[k] = v27
				end
			else
				v25.complete = true
			end

			if not v25.complete then
				v21 = false
			end
		end

		t7[k] = v25.value
	end

	local __allComplete = t6.__allComplete

	t6.__allComplete = v21
	t6.__fireOnStep(t7)

	if t6.__allComplete and not __allComplete and t6.__running then
		t6:stop()
		t6.__fireOnComplete(t7)
	end
end
function t1.setGoal(t8: {[any]: any}, t9: {[any]: any}) -- line: 150
	-- upvalues: Object (copy)
	t8.__goals = Object.assign({}, t8.__goals, t9)

	local v31 = false

	for k, v in pairs(t9) do
		local v34 = t8.__states[k]

		if v.startingValue then
			v31 = true
			v34.value = v.startingValue

			if v34.initialValue then
				v34.initialValue = v.startingValue
			end
		end;

		({})[k] = v34.value

		if v34 == nil then
			error(("Cannot set goal for the value %s because it doesn't exist"):format((tostring(k))), 2)
		end

		v34.complete = false
	end

	t8.__allComplete = false
	t8:start(v31)
end
function t1.onStep(p3, p4) -- line: 177
	local v37 = p3.__onStep:subscribe(p4)

	return function() -- line: 180
		-- upvalues: v37 (copy)
		v37:unsubscribe()
	end
end
function t1.onComplete(p5, p6) -- line: 185
	local v40 = p5.__onComplete:subscribe(p6)

	return function() -- line: 188
		-- upvalues: v40 (copy)
		v40:unsubscribe()
	end
end
function t1.destroy(p7) -- line: 193
	p7:stop()
end

return createGroupMotor
