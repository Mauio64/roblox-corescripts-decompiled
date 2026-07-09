local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signal = require(scriptParentParent.AppCommonLib).Signal

require(scriptParent.Types)

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 29
	-- upvalues: Signal (copy), t1 (copy)
	return (setmetatable({
		_value = p1,
		_changeSignal = Signal.new()
	}, t1))
end
function t1.get(p2) -- line: 36
	return p2._value
end
function t1.set(p3, p4) -- line: 40
	if p4 ~= p3._value then
		p3._value = p4
		p3._changeSignal:fire(p4)
	end
end
function t1.signal(p5) -- line: 47
	return p5._changeSignal
end
function t1.connect(p6, p7, p8) -- line: 51
	local v13 = p6._changeSignal:connect(p7)

	if p8 == true then
		p7(p6._value)
	end

	return v13
end

return t1
