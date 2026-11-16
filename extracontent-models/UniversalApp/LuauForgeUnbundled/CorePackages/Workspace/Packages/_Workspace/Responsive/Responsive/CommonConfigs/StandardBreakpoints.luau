local v5 = {
	XSmall = "XSmall",
	Small = "Small",
	Medium = "Medium",
	Large = "Large",
	XLarge = "XLarge",
	X2Large = "X2Large",
	Landscape = "Landscape",
	Portrait = "Portrait"
}

local v6 = {
	[v5.XSmall] = { Key = v5.XSmall, size = v5.XSmall, minWidth = 320, maxWidth = 360 },
	[v5.Small] = { Key = v5.Small, size = v5.Small, minWidth = 361, maxWidth = 600 },
	[v5.Medium] = { Key = v5.Medium, size = v5.Medium, minWidth = 601, maxWidth = 1140 },
	[v5.Large] = { Key = v5.Large, size = v5.Large, minWidth = 1141, maxWidth = 1520 },
	[v5.XLarge] = {
		Key = v5.XLarge,
		size = v5.XLarge,
		minWidth = 1521,
		maxWidth = 1920
	},
	[v5.X2Large] = {
		Key = v5.X2Large,
		size = v5.X2Large,
		minWidth = 1920,
		maxWidth = 4096
	}
}

local v7 = {
	[v5.XSmall] = { Key = v5.XSmall, size = v5.XSmall, maxWidth = 360 },
	[v5.Small] = { Key = v5.Small, size = v5.Small, maxWidth = 600 },
	[v5.Medium] = { Key = v5.Medium, size = v5.Medium, maxWidth = 1140 },
	[v5.Large] = { Key = v5.Large, size = v5.Large, maxWidth = 1520 },
	[v5.XLarge] = { Key = v5.XLarge, size = v5.XLarge, maxWidth = 1920 },
	[v5.X2Large] = { Key = v5.X2Large, size = v5.X2Large, maxWidth = 4096 }
}

local v8 = {
	[v5.XSmall] = {
		Key = v5.XSmall,
		size = v5.XSmall,
		minHeight = 320,
		maxHeight = 360
	},
	[v5.Small] = { Key = v5.Small, size = v5.Small, minHeight = 361, maxHeight = 600 },
	[v5.Medium] = {
		Key = v5.Medium,
		size = v5.Medium,
		minHeight = 601,
		maxHeight = 1140
	},
	[v5.Large] = { Key = v5.Large, size = v5.Large, minHeight = 1141, maxHeight = 1520 },
	[v5.XLarge] = {
		Key = v5.XLarge,
		size = v5.XLarge,
		minHeight = 1521,
		maxHeight = 1920
	},
	[v5.X2Large] = {
		Key = v5.X2Large,
		size = v5.X2Large,
		minHeight = 1920,
		maxHeight = 4096
	}
}

local v9 = {
	[v5.XSmall] = { Key = v5.XSmall, size = v5.XSmall, maxHeight = 360 },
	[v5.Small] = { Key = v5.Small, size = v5.Small, maxHeight = 600 },
	[v5.Medium] = { Key = v5.Medium, size = v5.Medium, maxHeight = 1140 },
	[v5.Large] = { Key = v5.Large, size = v5.Large, maxHeight = 1520 },
	[v5.XLarge] = { Key = v5.XLarge, size = v5.XLarge, maxHeight = 1920 },
	[v5.X2Large] = { Key = v5.X2Large, size = v5.X2Large, maxHeight = 4096 }
}

local v10 = {
	{ Key = v5.Landscape, minRatio = 1 },
	{ Key = v5.Portrait, minRatio = 0 }
}

local v11 = {
	v7[v5.XSmall],
	v7[v5.Small],
	v7[v5.Medium],
	v7[v5.Large],
	v7[v5.XLarge],
	v7[v5.X2Large]
}

local v12 = {
	v9[v5.XSmall],
	v9[v5.Small],
	v9[v5.Medium],
	v9[v5.Large],
	v9[v5.XLarge],
	v9[v5.X2Large]
}

local v13 = {}

for k, v14 in v11 do
	v13[v14.Key] = k
end

return {
	Enum = v5,
	sizes = v7,
	sizesMinMax = v6,
	sizesY = v9,
	sizesMinMaxY = v8,
	rules = { default = v11, Y = v12, Orientation = v10 },
	keyIndex = v13,
	getMinWidthFor = function(p2)
		local v14 = v6[p2]

		if v14 == nil then
			return 0
		end

		return v14.minWidth
	end,
	getMinHeightFor = function(p2)
		local v14 = v8[p2]

		if v14 == nil then
			return 0
		end

		return v14.minHeight
	end
}
