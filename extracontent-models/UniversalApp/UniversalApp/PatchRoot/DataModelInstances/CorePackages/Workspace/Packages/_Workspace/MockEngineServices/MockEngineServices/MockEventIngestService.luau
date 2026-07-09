local t1 = {}

t1.__index = t1

function t1.new() -- line: 5
	-- upvalues: t1 (copy)
	local t2 = {
		methodCalls = {}
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1._resetMockData(p1) -- line: 17
	p1.methodCalls = {}
end
function t1.setRBXEvent(p2, p3, p4, p5) -- line: 21
	table.insert(p2.methodCalls, {
		name = "setRBXEvent",
		args = {
			eventContext = p3,
			eventName = p4,
			additionalArgs = p5
		}
	})
end
function t1.setRBXEventStream(p6, p7, p8, p9) -- line: 32
	table.insert(p6.methodCalls, {
		name = "setRBXEventStream",
		args = {
			eventContext = p7,
			eventName = p8,
			additionalArgs = p9
		}
	})
end
function t1.sendEventImmediately(p10, p11, p12, p13) -- line: 43
	table.insert(p10.methodCalls, {
		name = "sendEventImmediately",
		args = {
			eventContext = p11,
			eventName = p12,
			additionalArgs = p13
		}
	})
end
function t1.sendEventDeferred(p14, p15, p16, p17) -- line: 54
	table.insert(p14.methodCalls, {
		name = "sendEventDeferred",
		args = {
			eventContext = p15,
			eventName = p16,
			additionalArgs = p17
		}
	})
end

return t1
