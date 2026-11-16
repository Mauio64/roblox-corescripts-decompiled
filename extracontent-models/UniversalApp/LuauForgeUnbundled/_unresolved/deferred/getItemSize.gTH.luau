local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dMc")

local function getItemSize(p2, p3, p4, p5, value)
	local font = p2.Font
	local v5 = font.Header2.RelativeSize * font.BaseSize + (value or 0)
	local v6 = p4 or module.ItemTileType.CatalogItemTile

	local gridItemHeightGetter = module2.GridItemHeightGetter(v6, v5, p5)
	return Vector2.new(p3, gridItemHeightGetter(p3))
end

return getItemSize
