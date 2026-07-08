local ParentParent = script.Parent.Parent
local validateAccurateBoundingBoxRasterMethod = require(ParentParent.validation.validateAccurateBoundingBoxRasterMethod)

return {
	getBoundsViewsForAssetType = function(p1) -- line: 22
		-- upvalues: validateAccurateBoundingBoxRasterMethod (copy)
		return validateAccurateBoundingBoxRasterMethod.getBoundsViewsForAssetType(p1)
	end,
	validate = function(p2, p3, p4) -- line: 26
		-- upvalues: validateAccurateBoundingBoxRasterMethod (copy)
		return validateAccurateBoundingBoxRasterMethod.validate(p2, p3, p4)
	end
}
