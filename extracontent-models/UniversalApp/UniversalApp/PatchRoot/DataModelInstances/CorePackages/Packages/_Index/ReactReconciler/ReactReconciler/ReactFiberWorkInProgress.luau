local ReactFiberLane = require(script.Parent.ReactFiberLane)
local v = ReactFiberLane.NoLanes
local mergeLanes = ReactFiberLane.mergeLanes
local ReactFiberWorkInProgress = {}

function ReactFiberWorkInProgress.workInProgressRootSkippedLanes(p)
	if p == nil then
		return v
	end

	v = p
	return v
end

function ReactFiberWorkInProgress.markSkippedUpdateLanes(p)
	v = mergeLanes(p, v)
end

return ReactFiberWorkInProgress
