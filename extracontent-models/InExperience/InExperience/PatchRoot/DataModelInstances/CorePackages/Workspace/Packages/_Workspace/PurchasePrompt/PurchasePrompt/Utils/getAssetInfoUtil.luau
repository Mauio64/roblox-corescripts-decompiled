local parent = script.Parent.Parent
local isCreatorStoreAssetType = require(parent.Utils.isCreatorStoreAssetType)
require(parent.Promise)
local GetAssetInfoUtil = {}

function GetAssetInfoUtil.isAssetValid(data): boolean
	if isCreatorStoreAssetType(data.type) and not (data.id and data.type and data.typeId and data.creator) then
		return false
	end

	return true
end

function GetAssetInfoUtil.fromAsset(data)
	return {
		["id"] = data.id,
		type = data.type,
		typeId = data.typeId,
		creator = data.creator,
		description = data.description,
		isPublicDomainEnabled = data.isPublicDomainEnabled,
		name = data.name
	}
end

return GetAssetInfoUtil
