local Foundation = script:FindFirstAncestor("Foundation")
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local t1 = {
	[ElevationLayer.Popover] = {
		start = 4,
		finish = 99,
		step = 1
	},
	[ElevationLayer.Drawer] = {
		start = 100,
		finish = 199,
		step = 10
	},
	[ElevationLayer.Sheet] = {
		start = 200,
		finish = 299,
		step = 10
	},
	[ElevationLayer.Dialog] = {
		start = 300,
		finish = 399,
		step = 10
	},
	[ElevationLayer.Notification] = {
		start = 400,
		finish = 499,
		step = 1
	}
}

return {
	ELEVATION_LAYERS = t1,
	getRelativeIndex = function(t2: {[any]: any}) -- line: 23
		-- upvalues: t1 (copy)
		local v5 = t1[t2.layer]

		return t2.zIndex - v5.start
	end
}
