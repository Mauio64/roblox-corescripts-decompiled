local t1 = {}

t1.__index = t1

function t1.new() -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		StandardizedFields = {},
		sentEvents = {},
		sentCounters = {},
		sentStats = {},
		loggedEvents = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.logEvent(t3: {[any]: any}, s1: string) -- line: 16
	if t3.loggedEvents[s1] == nil then
		t3.loggedEvents[s1] = 0
	end

	local loggedEvents = t3.loggedEvents

	loggedEvents[s1] = loggedEvents[s1] + 1
end
function t1.logEventOnce(t4: {[any]: any}, s2: string) -- line: 23
	t4.loggedEvents[s2] = 1
end
function t1.logRobloxTelemetryEvent(p1, p2, _, p4) -- line: 27
	table.insert(p1.sentEvents, {
		eventConfig = p2,
		customFields = p4
	})
end
function t1.logRobloxTelemetryStat(p5, p6, p7, p8) -- line: 31
	table.insert(p5.sentStats, {
		eventConfig = p6,
		statValue = p7,
		customFields = p8
	})
end
function t1.logRobloxTelemetryCounter(p9, p10, p11, p12) -- line: 35
	table.insert(p9.setCounters, {
		eventConfig = p10,
		increment = p11,
		customFields = p12
	})
end
function t1.mockGetSentEvents(p13) -- line: 39
	return p13.sentEvents
end
function t1.mockGetSentCounters(p14) -- line: 42
	return p14.sentCounters
end
function t1.mockGetSentStats(p15) -- line: 45
	return p15.sentStats
end
function t1.mockClearSentEvents(p16) -- line: 48
	p16.sentEvents = {}
end
function t1.mockClearSentCounters(p17) -- line: 51
	p17.sentCounters = {}
end
function t1.mockClearSentStats(p18) -- line: 54
	p18.sentStats = {}
end

return t1
