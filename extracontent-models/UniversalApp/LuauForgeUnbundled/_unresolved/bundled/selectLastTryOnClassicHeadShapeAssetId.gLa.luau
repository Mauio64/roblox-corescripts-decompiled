local module = require("@luauforge/bundled/dKX")
require("@luauforge/bundled/dPt")
require("@luauforge/bundled/dKT")

local headShapeProperties = module.Enums.HeadShapeProperties

local module2 = require("@luauforge/bundled/gLb")

local function selectLastTryOnClassicHeadShapeAssetId(p2)
	local v5 = module2(p2)
	return v5 and headShapeProperties[v5] and headShapeProperties[v5].assetId
end

return selectLastTryOnClassicHeadShapeAssetId
