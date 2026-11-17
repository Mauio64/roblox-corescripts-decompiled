local Foundation = script:FindFirstAncestor("Foundation")

local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local Flags = require(Foundation.Utility.Flags)
local v

if Flags.FoundationFloatingElevationLayer then
	v = {}
	v[ElevationLayer.Popover] = { start = 4, finish = 99, step = 1 }

	v[ElevationLayer.Floating] = { start = 100, finish = 199, step = 10 }
	v[ElevationLayer.Drawer] = { start = 200, finish = 299, step = 10 }
	v[ElevationLayer.Sheet] = { start = 300, finish = 399, step = 10 }
	v[ElevationLayer.Dialog] = { start = 400, finish = 499, step = 10 }
	v[ElevationLayer.Notification] = { start = 600, finish = 699, step = 1 }
else
	v = {}
	v[ElevationLayer.Popover] = { start = 4, finish = 99, step = 1 }
	v[ElevationLayer.Drawer] = { start = 100, finish = 199, step = 10 }
	v[ElevationLayer.Sheet] = { start = 200, finish = 299, step = 10 }
	v[ElevationLayer.Dialog] = { start = 300, finish = 399, step = 10 }

	v[ElevationLayer.Notification] = { start = 400, finish = 499, step = 1 }
	v[ElevationLayer.Floating] = { start = 500, finish = 599, step = 10 }
end

return {
	ELEVATION_LAYERS = v,
	getRelativeIndex = function(p)
		local v2 = v[p.layer]
		return p.zIndex - v2.start
	end
}
