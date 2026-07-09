local createPageTracker = require(script.Parent.createPageTracker)

local function getTracker(t1: {[any]: any}, s1: string) -- line: 10
	-- upvalues: createPageTracker (copy)
	if t1.trackers[s1] == nil then
		local v8 = createPageTracker()

		t1.trackers[s1] = v8
	end

	return t1.trackers[s1]
end
local function removeTracker(t2: {[any]: any}, s2: string) -- line: 18
	local v11 = t2.trackers[s2]

	if v11 then
		v11:stop()
		t2.trackers[s2] = nil
	end
end
local function createFactory() -- line: 27
	-- upvalues: getTracker (copy), removeTracker (copy)
	return {
		trackers = {},
		getTracker = getTracker,
		removeTracker = removeTracker
	}
end

local t3 = nil

return {
	getInstance = function() -- line: 39
		-- upvalues: t3 (ref), getTracker (copy), removeTracker (copy)
		if not t3 then
			t3 = {
				trackers = {},
				getTracker = getTracker,
				removeTracker = removeTracker
			}
		end

		return t3
	end
}
