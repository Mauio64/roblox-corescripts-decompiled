local ParentParent = script.Parent.Parent
local Signal = require(ParentParent.AppCommonLib).Signal
local t1 = {}

t1.__index = t1

local function defaultCompareFn(p1, p2) -- line: 44
	return p1 == p2
end

function t1.new(p3, p4: ((...any) -> ...any)?) -- line: 48
	-- upvalues: defaultCompareFn (copy), Signal (copy), t1 (copy)
	return (setmetatable({
		_isEqual = p4 or defaultCompareFn,
		_value = p3,
		_changeSignal = Signal.new()
	}, t1))
end
function t1.get(p5) -- line: 57
	return p5._value
end
function t1.set(p6, p7) -- line: 61
	if not p6._isEqual(p6._value, p7) then
		p6._value = p7
		p6._changeSignal:fire(p7)
	end
end
function t1.connect(p8, p9, p10) -- line: 68
	local v15 = p8._changeSignal:connect(p9)

	if p10 == true then
		p9(p8._value)
	end

	return v15
end
function t1.__tostring(p11) -- line: 77
	return "ObservableValue(" .. tostring(p11._value) .. ")"
end

return t1
