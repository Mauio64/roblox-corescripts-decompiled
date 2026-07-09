local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local function getItemSize(p1, n1: number, p2, b1: boolean?, n2: number?) -- line: 8
	-- upvalues: Constants (copy), Utils (copy)
	local p1Font = p1.Font
	local v11 = p1Font.Header2.RelativeSize * p1Font.BaseSize + (n2 or 0)
	local v12 = p2 or Constants.ItemTileType.CatalogItemTile
	local v13 = Utils.GridItemHeightGetter(v12, v11, b1)

	return Vector2.new(n1, v13(n1))
end

return getItemSize
