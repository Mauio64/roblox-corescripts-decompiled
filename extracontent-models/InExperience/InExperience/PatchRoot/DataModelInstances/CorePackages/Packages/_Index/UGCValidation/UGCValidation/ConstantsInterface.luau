local parent = script.Parent

local Constants = require(parent.Constants)
local ValidationRulesUtil = require(parent.util.ValidationRulesUtil)

local flags = parent.flags
local getEngineUGCValidateAssetTextureLimits = require(flags.getEngineUGCValidateAssetTextureLimits)
local ConstantsInterface = {}

function ConstantsInterface.isBodyPart(p)
	return Constants.ASSET_TYPE_INFO[p] and Constants.ASSET_TYPE_INFO[p].isBodyPart
end

function ConstantsInterface.isMakeupAsset(p): boolean
	return p == Enum.AssetType.LipMakeup or p == Enum.AssetType.EyeMakeup or p == Enum.AssetType.FaceMakeup
end

function ConstantsInterface.getBodyPartAssets()
	local bodyPartAssets = {}

	for k, v in Constants.ASSET_TYPE_INFO do
		if v.isBodyPart then
			table.insert(bodyPartAssets, k)
		end
	end

	return bodyPartAssets
end

function ConstantsInterface.getRigAttachmentToParent(p, p2: string)
	p = p or Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[p2]

	if not p then
		return ""
	end

	local v = Constants.ASSET_TYPE_INFO[p]

	if v.isBodyPart then
		return v.subParts[p2].rigAttachmentToParent.name
	end

	return ""
end

function ConstantsInterface.getAttachments(p, p2: string)
	p = p or Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[p2]
	local v

	if p then
		local v2 = Constants.ASSET_TYPE_INFO[p]

		if not v2.isBodyPart then
			return {}
		end

		v = v2.subParts[p2]
	end

	local result = {}

	if v then
		table.insert(result, v.rigAttachmentToParent.name)

		for k in v.otherAttachments do
			table.insert(result, k)
		end
	end

	return result
end

function ConstantsInterface.getTextureLimit(p, instance, p2: string)
	if not (getEngineUGCValidateAssetTextureLimits() and p) then
		return Constants.MAX_TEXTURE_SIZE
	end

	local assetTextureLimit = ValidationRulesUtil:getRules().TextureRules.AssetTextureLimits[p]

	if not assetTextureLimit then
		return Constants.MAX_TEXTURE_SIZE
	end

	if instance:IsA("SpecialMesh") and p2 == "TextureId" or instance:IsA("MeshPart") and p2 == "TextureID" then
		return assetTextureLimit.ColorMapSize
	end

	local isA = instance:IsA("Decal")

	if not (instance:IsA("SurfaceAppearance") or isA) then
		return Constants.MAX_TEXTURE_SIZE
	end

	if p2 == "ColorMap" then
		return assetTextureLimit.ColorMapSize
	elseif p2 == "MetalnessMap" then
		return assetTextureLimit.MetalnessMapSize
	elseif p2 == "NormalMap" then
		return assetTextureLimit.NormalMapSize
	elseif p2 == "RoughnessMap" then
		return assetTextureLimit.RoughnessMapSize
	end

	return Constants.MAX_TEXTURE_SIZE
end

return ConstantsInterface
