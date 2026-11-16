local parent = script.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)

local function shouldValidateR15LegacyDuplicate(p): boolean
	if not (p and p.consumerConfig and p.consumerConfig.enforceR15FolderStructure) then
		return false
	end

	local uploadEnum = p.uploadEnum

	if uploadEnum.bundleType == Enum.BundleType.BodyParts then
		return true
	end

	local assetType = uploadEnum.assetType
	return assetType ~= nil and Constants.AssetUploadsWithFolderStructure[assetType] == true
end

return shouldValidateR15LegacyDuplicate
