local ReactFiberLane = require(script.Parent.ReactFiberLane)
local NoLanes = ReactFiberLane.NoLanes
local mergeLanes = ReactFiberLane.mergeLanes

return {
	workInProgressRootSkippedLanes = function(p1) -- line: 24
		-- upvalues: NoLanes (ref)
		if p1 == nil then
			return NoLanes
		end

		NoLanes = p1

		return NoLanes
	end,
	markSkippedUpdateLanes = function(p2) -- line: 34
		-- upvalues: NoLanes (ref), mergeLanes (copy)
		NoLanes = mergeLanes(p2, NoLanes)
	end
}
