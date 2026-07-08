local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local ValidationRulesUtil = require(scriptParent.util.ValidationRulesUtil)
local flags = scriptParent.flags
local getEngineUGCValidateAssetTextureLimits = require(flags.getEngineUGCValidateAssetTextureLimits)

return {
	isBodyPart = function(p1) -- line: 10
		-- upvalues: Constants (copy)
		return Constants.ASSET_TYPE_INFO[p1] and Constants.ASSET_TYPE_INFO[p1].isBodyPart
	end,
	isMakeupAsset = function(p2) -- line: 14
		return p2 == Enum.AssetType.LipMakeup or (p2 == Enum.AssetType.EyeMakeup or p2 == Enum.AssetType.FaceMakeup)
	end,
	getBodyPartAssets = function() -- line: 20
		-- upvalues: Constants (copy)
		local t1 = {}

		for v9, v10 in Constants.ASSET_TYPE_INFO do
			if v10.isBodyPart then
				table.insert(t1, v9)
			end
		end

		return t1
	end,
	getRigAttachmentToParent = function(p3, s1: string) -- line: 31
		-- upvalues: Constants (copy)
		if not p3 then
			p3 = Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[s1]
		end

		if p3 then
			local v13 = Constants.ASSET_TYPE_INFO[p3]

			if not v13.isBodyPart then
				return ""
			end

			return v13.subParts[s1].rigAttachmentToParent.name
		end

		return ""
	end,
	getAttachments = function(p4, s2: string) -- line: 46
		-- upvalues: Constants (copy)
		if not p4 then
			p4 = Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE[s2]
		end

		local v16 = nil

		if p4 then
			local v17 = Constants.ASSET_TYPE_INFO[p4]

			if not v17.isBodyPart then
				return {}
			end

			v16 = v17.subParts[s2]
		end

		local t2 = {}

		if v16 then
			table.insert(t2, v16.rigAttachmentToParent.name)

			for v19 in v16.otherAttachments do
				table.insert(t2, v19)
			end
		end

		return t2
	end,
	getTextureLimit = function(p5, p6, s3: string) -- line: 70
		-- upvalues: getEngineUGCValidateAssetTextureLimits (copy), Constants (copy), ValidationRulesUtil (copy)
		if not getEngineUGCValidateAssetTextureLimits() then
			return Constants.MAX_TEXTURE_SIZE
		end

		if not p5 then
			return Constants.MAX_TEXTURE_SIZE
		end

		local v23 = ValidationRulesUtil:getRules().TextureRules.AssetTextureLimits[p5]

		if not v23 then
			return Constants.MAX_TEXTURE_SIZE
		end

		if p6:IsA("SpecialMesh") and s3 == "TextureId" then
			return v23.ColorMapSize
		end

		if p6:IsA("MeshPart") and s3 == "TextureID" then
			return v23.ColorMapSize
		end

		local v24 = p6:IsA("Decal")

		if p6:IsA("SurfaceAppearance") or v24 then
			if s3 == "ColorMap" then
				return v23.ColorMapSize
			end

			if s3 == "MetalnessMap" then
				return v23.MetalnessMapSize
			end

			if s3 == "NormalMap" then
				return v23.NormalMapSize
			end

			if s3 == "RoughnessMap" then
				return v23.RoughnessMapSize
			end
		end

		return Constants.MAX_TEXTURE_SIZE
	end
}
