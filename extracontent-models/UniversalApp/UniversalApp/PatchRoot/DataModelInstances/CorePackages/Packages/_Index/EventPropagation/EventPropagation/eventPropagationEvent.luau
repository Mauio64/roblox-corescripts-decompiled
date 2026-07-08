local t1 = {}

t1.__index = t1

function t1.new(p1, p2, s1: string, s2: string, b1: boolean?, p3) -- line: 18
	-- upvalues: t1 (copy)
	local t2 = {
		cancelled = false,
		phase = s2,
		currentInstance = p2,
		targetInstance = p1,
		eventName = s1,
		synthetic = b1 or false,
		eventData = if type(p3) ~= "table" or table.isfrozen(p3) then p3 else table.freeze(p3)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.cancel(p4) -- line: 41
	p4.cancelled = true
end

return t1
