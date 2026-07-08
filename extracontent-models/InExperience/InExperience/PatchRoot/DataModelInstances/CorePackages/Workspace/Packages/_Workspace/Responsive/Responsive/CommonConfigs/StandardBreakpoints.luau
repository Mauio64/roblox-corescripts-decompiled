local t1 = {
	XSmall = "XSmall",
	Small = "Small",
	Medium = "Medium",
	Large = "Large",
	XLarge = "XLarge",
	X2Large = "X2Large",
	Landscape = "Landscape",
	Portrait = "Portrait"
}
local t2 = {
	[t1.XSmall] = {
		minWidth = 320,
		maxWidth = 360,
		Key = t1.XSmall,
		size = t1.XSmall
	},
	[t1.Small] = {
		minWidth = 361,
		maxWidth = 600,
		Key = t1.Small,
		size = t1.Small
	},
	[t1.Medium] = {
		minWidth = 601,
		maxWidth = 1140,
		Key = t1.Medium,
		size = t1.Medium
	},
	[t1.Large] = {
		minWidth = 1141,
		maxWidth = 1520,
		Key = t1.Large,
		size = t1.Large
	},
	[t1.XLarge] = {
		minWidth = 1521,
		maxWidth = 1920,
		Key = t1.XLarge,
		size = t1.XLarge
	},
	[t1.X2Large] = {
		minWidth = 1920,
		maxWidth = 4096,
		Key = t1.X2Large,
		size = t1.X2Large
	}
}
local t3 = {
	[t1.XSmall] = {
		maxWidth = 360,
		Key = t1.XSmall,
		size = t1.XSmall
	},
	[t1.Small] = {
		maxWidth = 600,
		Key = t1.Small,
		size = t1.Small
	},
	[t1.Medium] = {
		maxWidth = 1140,
		Key = t1.Medium,
		size = t1.Medium
	},
	[t1.Large] = {
		maxWidth = 1520,
		Key = t1.Large,
		size = t1.Large
	},
	[t1.XLarge] = {
		maxWidth = 1920,
		Key = t1.XLarge,
		size = t1.XLarge
	},
	[t1.X2Large] = {
		maxWidth = 4096,
		Key = t1.X2Large,
		size = t1.X2Large
	}
}
local t4 = {
	[t1.XSmall] = {
		minHeight = 320,
		maxHeight = 360,
		Key = t1.XSmall,
		size = t1.XSmall
	},
	[t1.Small] = {
		minHeight = 361,
		maxHeight = 600,
		Key = t1.Small,
		size = t1.Small
	},
	[t1.Medium] = {
		minHeight = 601,
		maxHeight = 1140,
		Key = t1.Medium,
		size = t1.Medium
	},
	[t1.Large] = {
		minHeight = 1141,
		maxHeight = 1520,
		Key = t1.Large,
		size = t1.Large
	},
	[t1.XLarge] = {
		minHeight = 1521,
		maxHeight = 1920,
		Key = t1.XLarge,
		size = t1.XLarge
	},
	[t1.X2Large] = {
		minHeight = 1920,
		maxHeight = 4096,
		Key = t1.X2Large,
		size = t1.X2Large
	}
}
local t5 = {
	[t1.XSmall] = {
		maxHeight = 360,
		Key = t1.XSmall,
		size = t1.XSmall
	},
	[t1.Small] = {
		maxHeight = 600,
		Key = t1.Small,
		size = t1.Small
	},
	[t1.Medium] = {
		maxHeight = 1140,
		Key = t1.Medium,
		size = t1.Medium
	},
	[t1.Large] = {
		maxHeight = 1520,
		Key = t1.Large,
		size = t1.Large
	},
	[t1.XLarge] = {
		maxHeight = 1920,
		Key = t1.XLarge,
		size = t1.XLarge
	},
	[t1.X2Large] = {
		maxHeight = 4096,
		Key = t1.X2Large,
		size = t1.X2Large
	}
}
local t6 = {
	{
		minRatio = 1,
		Key = t1.Landscape
	},
	{
		minRatio = 0,
		Key = t1.Portrait
	}
}
local t7 = {
	t3[t1.XSmall],
	t3[t1.Small],
	t3[t1.Medium],
	t3[t1.Large],
	t3[t1.XLarge],
	t3[t1.X2Large]
}
local t8 = {
	t5[t1.XSmall],
	t5[t1.Small],
	t5[t1.Medium],
	t5[t1.Large],
	t5[t1.XLarge],
	t5[t1.X2Large]
}
local t9 = {}

for v10, v11 in t7 do
	t9[v11.Key] = v10
end

return {
	Enum = t1,
	sizes = t3,
	sizesMinMax = t2,
	sizesY = t5,
	sizesMinMaxY = t4,
	rules = {
		default = t7,
		Y = t8,
		Orientation = t6
	},
	keyIndex = t9,
	getMinWidthFor = function(p1) -- line: 86
		-- upvalues: t2 (copy)
		local v13 = t2[p1]

		if v13 == nil then
			return 0
		end

		return v13.minWidth
	end,
	getMinHeightFor = function(p2) -- line: 93
		-- upvalues: t4 (copy)
		local v15 = t4[p2]

		if v15 == nil then
			return 0
		end

		return v15.minHeight
	end
}
