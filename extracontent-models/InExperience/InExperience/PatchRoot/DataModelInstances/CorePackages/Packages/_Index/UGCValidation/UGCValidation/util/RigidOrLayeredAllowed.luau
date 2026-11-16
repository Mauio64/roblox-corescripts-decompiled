local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local getFStringUGCLCAllowedAssetTypeIds = require(parent.flags.getFStringUGCLCAllowedAssetTypeIds)
local RigidOrLayeredAllowed = {}

function RigidOrLayeredAllowed.isRigidAccessoryAllowed(p): boolean
	local v = Constants.ASSET_TYPE_INFO[p]

	return v ~= nil and v.rigidAllowed == true
end

function RigidOrLayeredAllowed.isLayeredClothingAllowed(p): boolean
	return table.find(string.split(getFStringUGCLCAllowedAssetTypeIds(), ","), (tostring(p.Value))) ~= nil
end

return RigidOrLayeredAllowed
