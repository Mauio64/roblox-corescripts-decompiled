local Tracker = {}
Tracker.__index = Tracker

function Tracker.new()
	return (setmetatable({ trackers = {} }, Tracker))
end

function Tracker:toggle(p: string)
	self[p] = not self[p]
	return self[p]
end

function Tracker.set(p, p2: string, p3)
	p.trackers[p2] = p3
end

function Tracker.get(p, p2: string)
	return p.trackers[p2]
end

function Tracker.reset(p, p2: string)
	p.trackers[p2] = nil
end

function Tracker.startTime(p, p2: string)
	p.trackers[p2] = DateTime.now().UnixTimestampMillis
end

function Tracker.finishTime(p, p2: string)
	if not p.trackers[p2] then
		return 0
	end

	local v = DateTime.now().UnixTimestampMillis - p.trackers[p2]
	p.trackers[p2] = 0
	return v
end

return Tracker
