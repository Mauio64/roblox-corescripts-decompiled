local ParentParent = script.Parent.Parent
local isCreatorStoreAssetType = require(ParentParent.Utils.isCreatorStoreAssetType)

require(ParentParent.Promise)

return {
	isAssetValid = function(p1) -- line: 17
		-- upvalues: isCreatorStoreAssetType (copy)
		if isCreatorStoreAssetType(p1.type) and (not p1.id or not p1.type or not p1.typeId or not p1.creator) then
			return false
		end

		return true
	end,
	fromAsset = function(p2) -- line: 29
		return {
			id = p2.id,
			type = p2.type,
			typeId = p2.typeId,
			creator = p2.creator,
			description = p2.description,
			isPublicDomainEnabled = p2.isPublicDomainEnabled,
			name = p2.name
		}
	end
}
