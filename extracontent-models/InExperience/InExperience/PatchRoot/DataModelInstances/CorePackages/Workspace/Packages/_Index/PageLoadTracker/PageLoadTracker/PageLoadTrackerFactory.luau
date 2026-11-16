local createPageTracker = require(script.Parent.createPageTracker)

local function getTracker(p, p2: string)
	if p.trackers[p2] == nil then
		local pageTracker = createPageTracker()
		p.trackers[p2] = pageTracker
	end

	return p.trackers[p2]
end

local function removeTracker(p, p2: string)
	local tracker = p.trackers[p2]

	if tracker then
		tracker:stop()
		p.trackers[p2] = nil
	end
end

local function createFactory() -- 1 equivalent call inferred from this helper
	return { trackers = {}, getTracker = getTracker, removeTracker = removeTracker }
end

local instance = nil

return {
	getInstance = function()
		if not instance then
			instance = createFactory() -- inferred equivalent call
		end

		return instance
	end
}
