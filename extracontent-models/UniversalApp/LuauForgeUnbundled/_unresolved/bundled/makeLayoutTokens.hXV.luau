require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local layoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LayoutConfig
local module = require("@luauforge/bundled/cyO")

local wideGameTileViewConfig = require("@luauforge/bundled/fYU").WideGameTileViewConfig

local getFFlagLuaAppUpdateGameSortGridRowHeight10ft = require("@luauforge/bundled/dpZ").Modules.LuaApp.Flags.GetFFlagLuaAppUpdateGameSortGridRowHeight10ft

local function scaleSizeForPlatform(p2, p3)
	return p2 * p3.Stroke.Standard
end

local kind = layoutConfig.Kind
local keys = layoutConfig.Keys

local v5 = {
	sd = { min = 0, max = 1024 },
	hd = { min = 1024, max = 1280 },
	hd_ts = { min = 1280, max = 1440 },
	fhd = { min = 1440, max = 1920 },
	fhd_ts = { min = 1920, max = 2260 },
	["2k"] = { min = 2260, max = 2560 },
	["2k_ts"] = { min = 2560, max = 3240 },
	["4k"] = { min = 3240, max = 3840 },
	["6k"] = { min = 3840, max = 1e999 }
}

local v6 = nil

local function makeLayoutTokens(p2, p3)
	v6 = {}

	for k, v7 in v5 do
		v6[k] = {
			min = v7.min * p3.Stroke.Standard,
			max = v7.max * p3.Stroke.Standard
		}
	end

	local layoutTokens = {
		breakpoints = if v6 then v6 else v5,
		kinds = kind,
		grid = {
			default = {
				margin = p3.Size.Size_1200,
				gutter = p3.Size.Size_1200,
				scrollableMaxTilesPerRow = 20,
				columns = { default = 4 }
			},
			sd = {
				margin = p3.Size.Size_300,
				gutter = p3.Size.Size_300,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 4,
					[kind.Experiences.WithFooter] = 4,
					[kind.Experiences.AppGameTile] = 4,
					[kind.Experiences.GridTile] = 4,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 8
				}
			},
			hd = {
				margin = 18 * p3.Stroke.Standard,
				gutter = 18 * p3.Stroke.Standard,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 6,
					[kind.Experiences.WithFooter] = 6,
					[kind.Experiences.AppGameTile] = 6,
					[kind.Experiences.GridTile] = 4,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 10
				}
			},
			hd_ts = {
				margin = p3.Size.Size_600,
				gutter = p3.Size.Size_600,
				verticalGutter = 34 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 7,
					[kind.Experiences.WithFooter] = 7,
					[kind.Experiences.AppGameTile] = 7,
					[kind.Experiences.GridTile] = 4,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 12
				}
			},
			fhd = {
				margin = 34 * p3.Stroke.Standard,
				gutter = 34 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 8,
					[kind.Experiences.WithFooter] = 8,
					[kind.Experiences.AppGameTile] = 8,
					[kind.Experiences.GridTile] = 4,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 12
				}
			},
			fhd_ts = {
				margin = 38 * p3.Stroke.Standard,
				gutter = 38 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 9,
					[kind.Experiences.WithFooter] = 9,
					[kind.Experiences.AppGameTile] = 9,
					[kind.Experiences.GridTile] = 4,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 12
				}
			},
			["2k"] = {
				columns = {
					[kind.Experiences.Default] = 10,
					[kind.Experiences.WithFooter] = 10,
					[kind.Experiences.AppGameTile] = 10,
					[kind.Experiences.GridTile] = 6,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 14
				}
			},
			["2k_ts"] = {
				columns = {
					[kind.Experiences.Default] = 11,
					[kind.Experiences.WithFooter] = 11,
					[kind.Experiences.AppGameTile] = 11,
					[kind.Experiences.GridTile] = 6,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 16
				}
			},
			["4k"] = {
				columns = {
					[kind.Experiences.Default] = 12,
					[kind.Experiences.WithFooter] = 12,
					[kind.Experiences.AppGameTile] = 12,
					[kind.Experiences.GridTile] = 6,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 20
				}
			},
			["6k"] = {
				width = 3840 * p3.Stroke.Standard,
				columns = {
					[kind.Experiences.Default] = 12,
					[kind.Experiences.WithFooter] = 12,
					[kind.Experiences.AppGameTile] = 12,
					[kind.Experiences.GridTile] = 6,
					[kind.Experiences.EventTile] = 4,
					[kind.Friends] = 20
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
		topBar = 0,
		layoutTypes = 0
	}

	local size_400s = {
		gutter = p3.Size.Size_400,
		columns = 1,
		[keys.PaddingRightItems] = p3.Size.Size_400,
		[keys.PaddingVertical] = p3.Size.Size_400
	}
	layoutTokens.topBar = size_400s
	local v27 = {
		[kind.Friends] = {
			relativeHeight = {
				Scale = 1,
				Offset = 44 * p3.Stroke.Standard
			}
		},
		[kind.Experiences.Default] = {
			relativeHeight = {
				Scale = 1,
				Offset = 60 * p3.Stroke.Standard
			}
		}
	}

	local withFooter = kind.Experiences.WithFooter
	local v30 = if getFFlagLuaAppUpdateGameSortGridRowHeight10ft() and p2.uiMode == uiMode.TenFoot then 98 * p3.Stroke.Standard else 82 * p3.Stroke.Standard
	v27[withFooter] = {
		relativeHeight = { Scale = 1, Offset = v30 }
	}
	v27[kind.Experiences.AppGameTile] = {
		relativeHeight = {
			Scale = 1,
			Offset = module.Constants.GAME_GRID_TILE_FOOTER_HEIGHT * p3.Stroke.Standard
		}
	}

	v27[kind.Experiences.GridTile] = {
		gutter = p3.Size.Size_600,
		relativeHeight = {
			Scale = 0.5625,
			Offset = wideGameTileViewConfig.getFooterHeight(p3)
		}
	}

	v27[kind.Experiences.EventTile] = {
		gutter = p3.Size.Size_600,
		relativeHeight = {
			Scale = 0.5625,
			Offset = wideGameTileViewConfig.getFooterHeight(p3)
		}
	}
	layoutTokens.layoutTypes = v27

	if p2.uiMode ~= uiMode.TenFoot then
		return layoutTokens
	end

	layoutTokens.grid.fhd.margin = 0 * p3.Stroke.Standard
	layoutTokens.grid.fhd.gutter = p3.Size.Size_600
	layoutTokens.grid.fhd.verticalGutter = 0 * p3.Stroke.Standard
	layoutTokens.grid.fhd.columns[kind.Friends] = 12

	return layoutTokens
end

return makeLayoutTokens
