local module = require("@luauforge/bundled/dHO")
require("@luauforge/bundled/dMd")
require("@luauforge/bundled/dHK")

local headShapeProperties = module.Enums.HeadShapeProperties

local module2 = require("@luauforge/bundled/ggv")

local function selectLastTryOnClassicHeadShapeAssetId(p2)
	local v5 = module2(p2)
	return v5 and headShapeProperties[v5] and headShapeProperties[v5].assetId
end

return selectLastTryOnClassicHeadShapeAssetId
