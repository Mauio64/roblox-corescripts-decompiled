local Foundation = script:FindFirstAncestor("Foundation")

local ElevationLayer = require(Foundation.Enums.ElevationLayer)

local v = {
	[ElevationLayer.Popover] = { start = 4, finish = 99, step = 1 },
	[ElevationLayer.Drawer] = { start = 100, finish = 199, step = 10 },
	[ElevationLayer.Sheet] = { start = 200, finish = 299, step = 10 },
	[ElevationLayer.Dialog] = { start = 300, finish = 399, step = 10 },
	[ElevationLayer.Notification] = { start = 400, finish = 499, step = 1 }
}

return {
	ELEVATION_LAYERS = v,
	getRelativeIndex = function(p)
		local v2 = v[p.layer]
		return p.zIndex - v2.start
	end
}
