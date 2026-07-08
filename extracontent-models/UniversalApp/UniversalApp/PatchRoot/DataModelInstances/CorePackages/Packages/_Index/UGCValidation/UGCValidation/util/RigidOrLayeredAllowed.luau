local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local getFStringUGCLCAllowedAssetTypeIds = require(ParentParent.flags.getFStringUGCLCAllowedAssetTypeIds)

return {
	isRigidAccessoryAllowed = function(p1) -- line: 9
		-- upvalues: Constants (copy)
		local v5 = Constants.ASSET_TYPE_INFO[p1]

		if v5 == nil then
			return false
		end

		return v5.rigidAllowed == true
	end,
	isLayeredClothingAllowed = function(p2) -- line: 18
		-- upvalues: getFStringUGCLCAllowedAssetTypeIds (copy)
		return table.find(string.split(getFStringUGCLCAllowedAssetTypeIds(), ","), (tostring(p2.Value))) ~= nil
	end
}
