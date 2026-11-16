local enum = {
	XSmall = "XSmall",
	Small = "Small",
	Medium = "Medium",
	Large = "Large",
	XLarge = "XLarge",
	X2Large = "X2Large",
	Landscape = "Landscape",
	Portrait = "Portrait"
}

local sizesMinMax = {
	[enum.XSmall] = { Key = enum.XSmall, size = enum.XSmall, minWidth = 320, maxWidth = 360 },
	[enum.Small] = { Key = enum.Small, size = enum.Small, minWidth = 361, maxWidth = 600 },
	[enum.Medium] = { Key = enum.Medium, size = enum.Medium, minWidth = 601, maxWidth = 1140 },
	[enum.Large] = { Key = enum.Large, size = enum.Large, minWidth = 1141, maxWidth = 1520 },
	[enum.XLarge] = { Key = enum.XLarge, size = enum.XLarge, minWidth = 1521, maxWidth = 1920 },
	[enum.X2Large] = { Key = enum.X2Large, size = enum.X2Large, minWidth = 1920, maxWidth = 4096 }
}

local sizes = {
	[enum.XSmall] = { Key = enum.XSmall, size = enum.XSmall, maxWidth = 360 },
	[enum.Small] = { Key = enum.Small, size = enum.Small, maxWidth = 600 },
	[enum.Medium] = { Key = enum.Medium, size = enum.Medium, maxWidth = 1140 },
	[enum.Large] = { Key = enum.Large, size = enum.Large, maxWidth = 1520 },
	[enum.XLarge] = { Key = enum.XLarge, size = enum.XLarge, maxWidth = 1920 },
	[enum.X2Large] = { Key = enum.X2Large, size = enum.X2Large, maxWidth = 4096 }
}

local sizesMinMaxY = {
	[enum.XSmall] = { Key = enum.XSmall, size = enum.XSmall, minHeight = 320, maxHeight = 360 },
	[enum.Small] = { Key = enum.Small, size = enum.Small, minHeight = 361, maxHeight = 600 },
	[enum.Medium] = { Key = enum.Medium, size = enum.Medium, minHeight = 601, maxHeight = 1140 },
	[enum.Large] = { Key = enum.Large, size = enum.Large, minHeight = 1141, maxHeight = 1520 },
	[enum.XLarge] = { Key = enum.XLarge, size = enum.XLarge, minHeight = 1521, maxHeight = 1920 },
	[enum.X2Large] = { Key = enum.X2Large, size = enum.X2Large, minHeight = 1920, maxHeight = 4096 }
}

local sizesY = {
	[enum.XSmall] = { Key = enum.XSmall, size = enum.XSmall, maxHeight = 360 },
	[enum.Small] = { Key = enum.Small, size = enum.Small, maxHeight = 600 },
	[enum.Medium] = { Key = enum.Medium, size = enum.Medium, maxHeight = 1140 },
	[enum.Large] = { Key = enum.Large, size = enum.Large, maxHeight = 1520 },
	[enum.XLarge] = { Key = enum.XLarge, size = enum.XLarge, maxHeight = 1920 },
	[enum.X2Large] = { Key = enum.X2Large, size = enum.X2Large, maxHeight = 4096 }
}

local orientation = {
	{ Key = enum.Landscape, minRatio = 1 },
	{ Key = enum.Portrait, minRatio = 0 }
}

local default = {
	sizes[enum.XSmall],
	sizes[enum.Small],
	sizes[enum.Medium],
	sizes[enum.Large],
	sizes[enum.XLarge],
	sizes[enum.X2Large]
}

local v = {
	sizesY[enum.XSmall],
	sizesY[enum.Small],
	sizesY[enum.Medium],
	sizesY[enum.Large],
	sizesY[enum.XLarge],
	sizesY[enum.X2Large]
}

local keyIndex = {}

for k, v2 in default do
	keyIndex[v2.Key] = k
end

local StandardBreakpoints = {}
StandardBreakpoints.Enum = enum
StandardBreakpoints.sizes = sizes
StandardBreakpoints.sizesMinMax = sizesMinMax
StandardBreakpoints.sizesY = sizesY
StandardBreakpoints.sizesMinMaxY = sizesMinMaxY
StandardBreakpoints.rules = { default = default, Y = v, Orientation = orientation }
StandardBreakpoints.keyIndex = keyIndex

function StandardBreakpoints.getMinWidthFor(p)
	local v2 = sizesMinMax[p]
	return if v2 == nil then 0 else v2.minWidth
end

function StandardBreakpoints.getMinHeightFor(p)
	local v2 = sizesMinMaxY[p]
	return if v2 == nil then 0 else v2.minHeight
end

return StandardBreakpoints
