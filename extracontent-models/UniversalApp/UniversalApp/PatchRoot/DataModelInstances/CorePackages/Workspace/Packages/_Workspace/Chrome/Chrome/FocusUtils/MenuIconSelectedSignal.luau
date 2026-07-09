local ParentParent = script.Parent.Parent.Parent
local Signal = require(ParentParent.AppCommonLib).Signal
local t1 = {}

t1.__index = t1

function t1.new() -- line: 17
	-- upvalues: Signal (copy), t1 (copy)
	return (setmetatable({
		_value = false,
		_changeSignal = Signal.new()
	}, t1))
end
function t1.get(p1) -- line: 24
	return p1._value
end
function t1.set(t2: {[any]: any}, b1: boolean) -- line: 28
	if b1 ~= t2._value then
		t2._value = b1
		t2._changeSignal:fire(b1)
	end
end
function t1.connect(p2, p3, p4) -- line: 35
	local v10 = p2._changeSignal:connect(p3)

	if p4 == true then
		p3(p2._value)
	end

	return v10
end

return t1.new()
