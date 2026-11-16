local parent = script.Parent.Parent

local validateAccurateBoundingBoxRasterMethod = require(parent.validation.validateAccurateBoundingBoxRasterMethod)
local AccurateBoundingBoxRasterUtil = {}

function AccurateBoundingBoxRasterUtil.getBoundsViewsForAssetType(p)
	return validateAccurateBoundingBoxRasterMethod.getBoundsViewsForAssetType(p)
end

function AccurateBoundingBoxRasterUtil.validate(p, p2, p3)
	return validateAccurateBoundingBoxRasterMethod.validate(p, p2, p3)
end

return AccurateBoundingBoxRasterUtil
