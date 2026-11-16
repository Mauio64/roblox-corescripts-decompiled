local CorePackages = game:GetService("CorePackages")
local layoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LayoutConfig
require("@game/CorePackages/Workspace/Packages/Style")
require(CorePackages.Packages.UIBlox)

local function makeGridSettingsConfig(p2)
	local layout = p2.LuaApps.Layout
	local breakpoints = layout.breakpoints
	local kinds = layout.kinds
	local grid = layout.grid
	local tiles = layout.tiles
	local layoutTypes = layout.layoutTypes

	return {
		margin = grid.default.margin,
		gutter = grid.default.gutter,
		columns = grid.default.columns.default,
		hoverTileTopOffset = tiles.hover.topOffset,
		hoverTileBottomOffset = tiles.hover.bottomOffset,
		hoverTileHorizontalOffset = tiles.hover.horizontalOffset,
		scrollableMaxTilesPerRow = grid.default.scrollableMaxTilesPerRow,
		{
			kind = kinds.TopBar,
			columns = layout.topBar.columns,
			gutter = layout.topBar.gutter,
			[layoutConfig.Keys.PaddingRightItems] = layout.topBar[layoutConfig.Keys.PaddingRightItems],
			[layoutConfig.Keys.PaddingVertical] = layout.topBar[layoutConfig.Keys.PaddingVertical]
		},
		{
			kind = kinds.Friends,
			relativeHeight = layoutTypes[kinds.Friends].relativeHeight
		},
		{
			kind = kinds.Experiences.Default,
			relativeHeight = layoutTypes[kinds.Experiences.Default].relativeHeight,
			margin = 48
		},
		{
			kind = kinds.Experiences.WithFooter,
			relativeHeight = layoutTypes[kinds.Experiences.WithFooter].relativeHeight
		},
		{
			kind = kinds.Experiences.AppGameTile,
			relativeHeight = layoutTypes[kinds.Experiences.AppGameTile].relativeHeight,
			margin = 48
		},
		{
			kind = kinds.Experiences.GridTile,
			relativeHeight = layoutTypes[kinds.Experiences.GridTile].relativeHeight,
			gutter = layoutTypes[kinds.Experiences.GridTile].gutter
		},
		{
			kind = kinds.Experiences.EventTile,
			relativeHeight = layoutTypes[kinds.Experiences.EventTile].relativeHeight,
			gutter = layoutTypes[kinds.Experiences.EventTile].gutter,
			margin = 48
		},
		{
			breakpoint = "sd",
			min = breakpoints.sd.min,
			max = breakpoints.sd.max,
			margin = grid.sd.margin,
			gutter = grid.sd.gutter,
			verticalGutter = grid.sd.verticalGutter,
			{ kind = kinds.Experiences, columns = grid.sd.columns[kinds.Experiences] },
			{
				kind = kinds.Experiences.Default,
				columns = grid.sd.columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid.sd.columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid.sd.columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid.sd.columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid.sd.columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid.sd.columns[kinds.Friends] }
		},
		{
			breakpoint = "hd",
			min = breakpoints.hd.min,
			max = breakpoints.hd.max,
			margin = grid.hd.margin,
			gutter = grid.hd.gutter,
			verticalGutter = grid.hd.verticalGutter,
			{ kind = kinds.Experiences, columns = grid.hd.columns[kinds.Experiences] },
			{
				kind = kinds.Experiences.Default,
				columns = grid.hd.columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid.hd.columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid.hd.columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid.hd.columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid.hd.columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid.hd.columns[kinds.Friends] }
		},
		{
			breakpoint = "hd_ts",
			min = breakpoints.hd_ts.min,
			max = breakpoints.hd_ts.max,
			margin = grid.hd_ts.margin,
			gutter = grid.hd_ts.gutter,
			verticalGutter = grid.hd_ts.verticalGutter,
			{
				kind = kinds.Experiences,
				columns = grid.hd_ts.columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid.hd_ts.columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid.hd_ts.columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid.hd_ts.columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid.hd_ts.columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid.hd_ts.columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid.hd_ts.columns[kinds.Friends] }
		},
		{
			breakpoint = "fhd",
			min = breakpoints.fhd.min,
			max = breakpoints.fhd.max,
			margin = grid.fhd.margin,
			gutter = grid.fhd.gutter,
			{ kind = kinds.Experiences, columns = grid.fhd.columns[kinds.Experiences] },
			{
				kind = kinds.Experiences.Default,
				columns = grid.fhd.columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid.fhd.columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid.fhd.columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid.fhd.columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid.fhd.columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid.fhd.columns[kinds.Friends] }
		},
		{
			breakpoint = "fhd_ts",
			min = breakpoints.fhd_ts.min,
			max = breakpoints.fhd_ts.max,
			margin = grid.fhd_ts.margin,
			gutter = grid.fhd_ts.gutter,
			{
				kind = kinds.Experiences,
				columns = grid.fhd_ts.columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid.fhd_ts.columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid.fhd_ts.columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid.fhd_ts.columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid.fhd_ts.columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid.fhd_ts.columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid.fhd_ts.columns[kinds.Friends] }
		},
		{
			breakpoint = "2k",
			min = breakpoints["2k"].min,
			max = breakpoints["2k"].max,
			{
				kind = kinds.Experiences,
				columns = grid["2k"].columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid["2k"].columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid["2k"].columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid["2k"].columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid["2k"].columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid["2k"].columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid["2k"].columns[kinds.Friends] }
		},
		{
			breakpoint = "2k_ts",
			min = breakpoints["2k_ts"].min,
			max = breakpoints["2k_ts"].max,
			{
				kind = kinds.Experiences,
				columns = grid["2k_ts"].columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid["2k_ts"].columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid["2k_ts"].columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid["2k_ts"].columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid["2k_ts"].columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid["2k_ts"].columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid["2k_ts"].columns[kinds.Friends] }
		},
		{
			breakpoint = "4k",
			min = breakpoints["4k"].min,
			max = breakpoints["4k"].max,
			{
				kind = kinds.Experiences,
				columns = grid["4k"].columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid["4k"].columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid["4k"].columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid["4k"].columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid["4k"].columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid["4k"].columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid["4k"].columns[kinds.Friends] }
		},
		{
			breakpoint = "6k",
			min = breakpoints["6k"].min,
			max = breakpoints["6k"].max,
			width = grid["6k"].width,
			{
				kind = kinds.Experiences,
				columns = grid["6k"].columns[kinds.Experiences]
			},
			{
				kind = kinds.Experiences.Default,
				columns = grid["6k"].columns[kinds.Experiences.Default]
			},
			{
				kind = kinds.Experiences.WithFooter,
				columns = grid["6k"].columns[kinds.Experiences.WithFooter]
			},
			{
				kind = kinds.Experiences.AppGameTile,
				columns = grid["6k"].columns[kinds.Experiences.AppGameTile]
			},
			{
				kind = kinds.Experiences.GridTile,
				columns = grid["6k"].columns[kinds.Experiences.GridTile]
			},
			{
				kind = kinds.Experiences.EventTile,
				columns = grid["6k"].columns[kinds.Experiences.EventTile]
			},
			{ kind = kinds.Friends, columns = grid["6k"].columns[kinds.Friends] }
		}
	}
end

return makeGridSettingsConfig
