local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local LayoutConfig = require(CorePackages.Workspace.Packages.RobloxAppEnums).LayoutConfig
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local WideGameTileViewConfig = require(CorePackages.Workspace.Packages.GameTile).WideGameTileViewConfig
local GetFFlagLuaAppUpdateGameSortGridRowHeight10ft = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Flags.GetFFlagLuaAppUpdateGameSortGridRowHeight10ft

local function scaleSizeForPlatform(n1: number, p1) -- line: 18
	return n1 * p1.Stroke.Standard
end

local Kind = LayoutConfig.Kind
local Keys = LayoutConfig.Keys
local t1 = {
	sd = {
		min = 0,
		max = 1024
	},
	hd = {
		min = 1024,
		max = 1280
	},
	hd_ts = {
		min = 1280,
		max = 1440
	},
	fhd = {
		min = 1440,
		max = 1920
	},
	fhd_ts = {
		min = 1920,
		max = 2260
	},
	["2k"] = {
		min = 2260,
		max = 2560
	},
	["2k_ts"] = {
		min = 2560,
		max = 3240
	},
	["4k"] = {
		min = 3240,
		max = 3840
	},
	["6k"] = {
		min = 3840,
		max = 1e999
	}
}
local t2 = nil

local function makeLayoutTokens(p2, p3) -- line: 127
	-- upvalues: t2 (ref), t1 (copy), Kind (copy), Keys (copy), GetFFlagLuaAppUpdateGameSortGridRowHeight10ft (copy), UiMode (copy), DiscoveryTypes (copy), WideGameTileViewConfig (copy)
	t2 = {}

	for v17, v18 in t1 do
		t2[v17] = {
			min = v18.min * p3.Stroke.Standard,
			max = v18.max * p3.Stroke.Standard
		}
	end

	local t3 = {
		breakpoints = if not t2 then t1 else t2,
		kinds = Kind,
		grid = {
			default = {
				scrollableMaxTilesPerRow = 20,
				margin = p3.Size.Size_1200,
				gutter = p3.Size.Size_1200,
				columns = {
					default = 4
				}
			},
			sd = {
				margin = p3.Size.Size_300,
				gutter = p3.Size.Size_300,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 4,
					[Kind.Experiences.WithFooter] = 4,
					[Kind.Experiences.AppGameTile] = 4,
					[Kind.Experiences.GridTile] = 4,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 8
				}
			},
			hd = {
				margin = 18 * p3.Stroke.Standard,
				gutter = 18 * p3.Stroke.Standard,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 6,
					[Kind.Experiences.WithFooter] = 6,
					[Kind.Experiences.AppGameTile] = 6,
					[Kind.Experiences.GridTile] = 4,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 10
				}
			},
			hd_ts = {
				margin = p3.Size.Size_600,
				gutter = p3.Size.Size_600,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 7,
					[Kind.Experiences.WithFooter] = 7,
					[Kind.Experiences.AppGameTile] = 7,
					[Kind.Experiences.GridTile] = 4,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 12
				}
			},
			fhd = {
				margin = 34 * p3.Stroke.Standard,
				gutter = 34 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 8,
					[Kind.Experiences.WithFooter] = 8,
					[Kind.Experiences.AppGameTile] = 8,
					[Kind.Experiences.GridTile] = 4,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 12
				}
			},
			fhd_ts = {
				margin = 38 * p3.Stroke.Standard,
				gutter = 38 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 9,
					[Kind.Experiences.WithFooter] = 9,
					[Kind.Experiences.AppGameTile] = 9,
					[Kind.Experiences.GridTile] = 4,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 12
				}
			},
			["2k"] = {
				columns = {
					[Kind.Experiences.Default] = 10,
					[Kind.Experiences.WithFooter] = 10,
					[Kind.Experiences.AppGameTile] = 10,
					[Kind.Experiences.GridTile] = 6,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 14
				}
			},
			["2k_ts"] = {
				columns = {
					[Kind.Experiences.Default] = 11,
					[Kind.Experiences.WithFooter] = 11,
					[Kind.Experiences.AppGameTile] = 11,
					[Kind.Experiences.GridTile] = 6,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 16
				}
			},
			["4k"] = {
				columns = {
					[Kind.Experiences.Default] = 12,
					[Kind.Experiences.WithFooter] = 12,
					[Kind.Experiences.AppGameTile] = 12,
					[Kind.Experiences.GridTile] = 6,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 20
				}
			},
			["6k"] = {
				width = 3840 * p3.Stroke.Standard,
				columns = {
					[Kind.Experiences.Default] = 12,
					[Kind.Experiences.WithFooter] = 12,
					[Kind.Experiences.AppGameTile] = 12,
					[Kind.Experiences.GridTile] = 6,
					[Kind.Experiences.EventTile] = 4,
					[Kind.Friends] = 20
				}
			}
		},
		tiles = {
			hover = {
				topOffset = 10 * p3.Stroke.Standard,
				bottomOffset = 22 * p3.Stroke.Standard,
				horizontalOffset = -4 * p3.Stroke.Standard
			}
		},
		topBar = {
			gutter = p3.Size.Size_400,
			columns = 1,
			[Keys.PaddingRightItems] = p3.Size.Size_400,
			[Keys.PaddingVertical] = p3.Size.Size_400
		},
		layoutTypes = {
			[Kind.Friends] = {
				relativeHeight = {
					Scale = 1,
					Offset = 44 * p3.Stroke.Standard
				}
			},
			[Kind.Experiences.Default] = {
				relativeHeight = {
					Scale = 1,
					Offset = 60 * p3.Stroke.Standard
				}
			},
			[Kind.Experiences.WithFooter] = {
				relativeHeight = {
					Scale = 1,
					Offset = if not GetFFlagLuaAppUpdateGameSortGridRowHeight10ft() or p2.uiMode ~= UiMode.TenFoot then 82 * p3.Stroke.Standard else 98 * p3.Stroke.Standard
				}
			},
			[Kind.Experiences.AppGameTile] = {
				relativeHeight = {
					Scale = 1,
					Offset = DiscoveryTypes.Constants.GAME_GRID_TILE_FOOTER_HEIGHT * p3.Stroke.Standard
				}
			},
			[Kind.Experiences.GridTile] = {
				gutter = p3.Size.Size_600,
				relativeHeight = {
					Scale = 0.5625,
					Offset = WideGameTileViewConfig.getFooterHeight(p3)
				}
			},
			[Kind.Experiences.EventTile] = {
				gutter = p3.Size.Size_600,
				relativeHeight = {
					Scale = 0.5625,
					Offset = WideGameTileViewConfig.getFooterHeight(p3)
				}
			}
		}
	}

	if p2.uiMode == UiMode.TenFoot then
		t3.grid.fhd.margin = 0 * p3.Stroke.Standard
		t3.grid.fhd.gutter = p3.Size.Size_600
		t3.grid.fhd.verticalGutter = 0 * p3.Stroke.Standard
		t3.grid.fhd.columns[Kind.Friends] = 12
	end

	return t3
end

return makeLayoutTokens
