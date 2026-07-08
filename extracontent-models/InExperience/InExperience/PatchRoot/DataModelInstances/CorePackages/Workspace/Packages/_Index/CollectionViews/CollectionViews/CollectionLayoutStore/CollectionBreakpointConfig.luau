local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent

require(CollectionViews.CollectionViewTypes)

local FFlagLuaAppCompositionLegacyLayout = require(CollectionViewsParent.SharedFlags).FFlagLuaAppCompositionLegacyLayout
local t1 = {
	{
		maxWidth = 499,
		items = {
			XSmall = 3,
			Small = 3,
			Medium = 2,
			Large = 1,
			XLarge = 1
		}
	},
	{
		maxWidth = 600,
		items = {
			XSmall = 4,
			Small = 4,
			Medium = 2,
			Large = 1,
			XLarge = 1
		}
	},
	{
		maxWidth = 799,
		items = {
			XSmall = 6,
			Small = 4,
			Medium = 2,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 1140,
		items = {
			XSmall = 9,
			Small = 6,
			Medium = 3,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1520,
		items = {
			XSmall = 12,
			Small = 8,
			Medium = 4,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1919,
		items = {
			XSmall = 16,
			Small = 8,
			Medium = 4,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1e999,
		items = {
			XSmall = 16,
			Small = 10,
			Medium = 5,
			Large = 4,
			XLarge = 1
		}
	}
}
local t2 = {
	{
		maxWidth = 475,
		items = {
			XSmall = 3,
			Small = 3,
			Medium = 2,
			Large = 1,
			XLarge = 1
		}
	},
	{
		maxWidth = 587,
		items = {
			XSmall = 4,
			Small = 3,
			Medium = 2,
			Large = 1,
			XLarge = 1
		}
	},
	{
		maxWidth = 679,
		items = {
			XSmall = 5,
			Small = 3,
			Medium = 2,
			Large = 1,
			XLarge = 1
		}
	},
	{
		maxWidth = 711,
		items = {
			XSmall = 5,
			Small = 3,
			Medium = 2,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 743,
		items = {
			XSmall = 5,
			Small = 4,
			Medium = 2,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 859,
		items = {
			XSmall = 6,
			Small = 4,
			Medium = 2,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 893,
		items = {
			XSmall = 7,
			Small = 4,
			Medium = 2,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 975,
		items = {
			XSmall = 7,
			Small = 6,
			Medium = 3,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 995,
		items = {
			XSmall = 8,
			Small = 6,
			Medium = 3,
			Large = 2,
			XLarge = 1
		}
	},
	{
		maxWidth = 1091,
		items = {
			XSmall = 8,
			Small = 6,
			Medium = 3,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1175,
		items = {
			XSmall = 9,
			Small = 6,
			Medium = 3,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1207,
		items = {
			XSmall = 9,
			Small = 8,
			Medium = 4,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1323,
		items = {
			XSmall = 10,
			Small = 8,
			Medium = 4,
			Large = 3,
			XLarge = 1
		}
	},
	{
		maxWidth = 1439,
		items = {
			XSmall = 11,
			Small = 8,
			Medium = 4,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1457,
		items = {
			XSmall = 12,
			Small = 8,
			Medium = 4,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1667,
		items = {
			XSmall = 12,
			Small = 10,
			Medium = 5,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1787,
		items = {
			XSmall = 13,
			Small = 10,
			Medium = 5,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1847,
		items = {
			XSmall = 14,
			Small = 10,
			Medium = 5,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1907,
		items = {
			XSmall = 14,
			Small = 12,
			Medium = 6,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 2027,
		items = {
			XSmall = 15,
			Small = 12,
			Medium = 6,
			Large = 4,
			XLarge = 1
		}
	},
	{
		maxWidth = 1e999,
		items = {
			XSmall = 16,
			Small = 12,
			Medium = 6,
			Large = 4,
			XLarge = 1
		}
	}
}
local v6 = if not FFlagLuaAppCompositionLegacyLayout then t1 else t2

return {
	resolveBreakpoint = function(n1: number) -- line: 53
		-- upvalues: v6 (copy)
		for v8, v9 in v6 do
			if n1 <= v9.maxWidth then
				return v8
			end
		end

		return #v6
	end,
	getItemsPerRow = function(n2: number, p1) -- line: 62
		-- upvalues: v6 (copy)
		local v12 = v6[n2]

		if v12 then
			return v12.items[p1] or 1
		end

		return 1
	end
}
