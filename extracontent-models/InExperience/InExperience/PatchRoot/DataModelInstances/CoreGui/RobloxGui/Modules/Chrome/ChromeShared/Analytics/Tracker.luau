local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
	-- upvalues: t1 (copy)
	return (setmetatable({
		trackers = {}
	}, t1))
end
function t1.toggle(t2: {[any]: any}, s1: string) -- line: 24
	t2[s1] = not t2[s1]

	return t2[s1]
end
function t1.set(t3: {[any]: any}, s2: string, p1) -- line: 29
	t3.trackers[s2] = p1
end
function t1.get(t4: {[any]: any}, s3: string) -- line: 33
	return t4.trackers[s3]
end
function t1.reset(t5: {[any]: any}, s4: string) -- line: 37
	t5.trackers[s4] = nil
end
function t1.startTime(t6: {[any]: any}, s5: string) -- line: 41
	t6.trackers[s5] = DateTime.now().UnixTimestampMillis
end
function t1.finishTime(t7: {[any]: any}, s6: string) -- line: 45
	if t7.trackers[s6] then
		local v15 = DateTime.now().UnixTimestampMillis - t7.trackers[s6]

		t7.trackers[s6] = 0

		return v15
	end

	return 0
end

return t1
