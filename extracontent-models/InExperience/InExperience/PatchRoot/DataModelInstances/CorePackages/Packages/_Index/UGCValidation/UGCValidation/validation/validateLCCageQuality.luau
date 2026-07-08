local ParentParent = script.Parent.Parent
local getCageMeshInfos = require(ParentParent.validation.getCageMeshInfos)
local getFStringLCCageQualityDocumentationLink = require(ParentParent.flags.getFStringLCCageQualityDocumentationLink)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local validateVerticesSimilarity = require(ParentParent.validation.validateVerticesSimilarity)
local validateLCCagingRelevancy = require(ParentParent.validation.validateLCCagingRelevancy)
local validateRenderMeshInsideOuterCageMesh = require(ParentParent.validation.validateRenderMeshInsideOuterCageMesh)
local validateCageMeshDistance = require(ParentParent.validation.validateCageMeshDistance)
local validateCageUVDuplicates = require(ParentParent.validation.validateCageUVDuplicates)
local ValidateModifiedCageArea = require(ParentParent.validation.ValidateModifiedCageArea)

require(ParentParent.util.Types)

local function validateLCCageQuality(p1, p2, p3) -- line: 18
	-- upvalues: getCageMeshInfos (copy), getFFlagUGCValidateMigrateCageGeometry (copy), validateVerticesSimilarity (copy), validateLCCagingRelevancy (copy), validateRenderMeshInsideOuterCageMesh (copy), getFFlagUGCValidationEyebrowEyelashSupport (copy), validateCageMeshDistance (copy), validateCageUVDuplicates (copy), ValidateModifiedCageArea (copy), getFStringLCCageQualityDocumentationLink (copy)
	local v16 = true
	local t1 = {}
	local WrapLayer = p1:FindFirstChild("Handle"):FindFirstChildOfClass("WrapLayer")

	assert(WrapLayer, "calling validateInstanceTree() means we would not get this far if there was no WrapLayer")

	local v19, v20, v21 = getCageMeshInfos(p1, p3)

	if not v19 or v21 == nil then
		return false, v20
	end

	local t2 = {
		v21[1],
		v21[2]
	}
	local v23, v24 = unpack(t2)

	if not getFFlagUGCValidateMigrateCageGeometry() then
		for _, v26 in t2 do
			local v27, v28 = validateVerticesSimilarity(v26, p3, Vector3.new(1, 1, 1), v26.fullName)

			if not v27 and v28 ~= nil then
				v16 = false

				for _, v30 in v28 do
					table.insert(t1, v30)
				end
			end
		end
	end

	local v31, v32 = validateLCCagingRelevancy(v23, v24, p2, WrapLayer.ReferenceOrigin.Position, WrapLayer.CageOrigin.Position, p3)

	if not v31 and v32 ~= nil then
		v16 = false

		for _, v34 in v32 do
			table.insert(t1, v34)
		end
	end

	local v35, v36 = validateRenderMeshInsideOuterCageMesh(WrapLayer, v24, p2, p3)

	if not v35 then
		table.insert(t1, table.concat(v36, "\n"))
		v16 = false
	end

	if not getFFlagUGCValidateMigrateCageGeometry() then
		if getFFlagUGCValidationEyebrowEyelashSupport() then
			local assetTypeEnum = p3.assetTypeEnum

			if assetTypeEnum ~= Enum.AssetType.EyebrowAccessory and assetTypeEnum ~= Enum.AssetType.EyelashAccessory then
				local v38, v39 = validateCageMeshDistance(v23, v24, p2, WrapLayer.ReferenceOrigin, WrapLayer.CageOrigin, p3)

				if not v38 then
					table.insert(t1, table.concat(v39, "\n"))
					v16 = false
				end
			end
		else
			local v40, v41 = validateCageMeshDistance(v23, v24, p2, WrapLayer.ReferenceOrigin, WrapLayer.CageOrigin, p3)

			if not v40 then
				table.insert(t1, table.concat(v41, "\n"))
				v16 = false
			end
		end
	end

	local v42, v43 = validateCageUVDuplicates(v23, v24, p2, p3)

	if not v42 then
		table.insert(t1, table.concat(v43, "\n"))
		v16 = false
	end

	local v44, v45 = ValidateModifiedCageArea.validate(v23, WrapLayer.ReferenceOrigin, v24, WrapLayer.CageOrigin, p2, p3)

	if not v44 then
		table.insert(t1, table.concat(v45, "\n"))
		v16 = false
	end

	if not v16 then
		if getFStringLCCageQualityDocumentationLink() ~= "" then
			table.insert(t1, (string.format("[Caging best practices](%s)", getFStringLCCageQualityDocumentationLink())))
		end

		return false, t1
	end

	return true
end

return validateLCCageQuality
