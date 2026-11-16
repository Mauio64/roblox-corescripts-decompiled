local isCreatorStoreAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isCreatorStoreAssetType")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

return {
	isAssetValid = function(data): boolean
		if isCreatorStoreAssetType(data.type) and not (data.id and data.type and data.typeId and data.creator) then
			return false
		end

		return true
	end,
	fromAsset = function(data)
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
}
