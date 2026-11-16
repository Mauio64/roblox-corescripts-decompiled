local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local bodyAssetMasksRenderer = require(parent.util.bodyAssetMasksRenderer)
local AccurateBoundingBoxRasterUtil = require(parent.util.AccurateBoundingBoxRasterUtil)

local BoundingBoxAccurate = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function getAssetTypeFromUploadEnum(p) -- 1 equivalent call inferred from this helper
	if p.uploadEnum and p.uploadEnum.assetType then
		return p.uploadEnum.assetType
	end

	return nil
end

local function buildEditableMeshesFromSharedData(p)
	local editableMeshesFromSharedData = {}

	for childName, v in p.renderMeshesData do
		local v2 = p.rootInstance:FindFirstChild(childName, true)

		if not v2 and p.rootInstance.Name == childName then
			v2 = p.rootInstance
		end

		if v2 and v.editable then
			editableMeshesFromSharedData[v2] = {
				MeshId = { instance = v.editable, created = false }
			}
		end
	end

	return editableMeshesFromSharedData
end

function BoundingBoxAccurate.run(object, p)
	local assetTypeFromUploadEnum = getAssetTypeFromUploadEnum(p) -- inferred equivalent call

	if not assetTypeFromUploadEnum then
		return
	end

	local rootInstance = p.rootInstance
	local editableMeshesFromSharedData = buildEditableMeshesFromSharedData(p)

	local v = {
		assetTypeEnum = assetTypeFromUploadEnum,
		isServer = p.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend,
		editableMeshes = editableMeshesFromSharedData,
		shouldYield = false
	}

	local boundsViewsForAssetType = AccurateBoundingBoxRasterUtil.getBoundsViewsForAssetType(assetTypeFromUploadEnum)
	local v2, v3 = bodyAssetMasksRenderer.new(rootInstance, boundsViewsForAssetType, v)

	if v2 then
		local v4, v5 = AccurateBoundingBoxRasterUtil.validate(rootInstance, v3, v)

		if not v4 and v5 then
			for _, reason in v5 do
				object:fail(ErrorSourceStrings.Keys.BoundingBox_ValidationFailed, {
					reason = reason
				})
			end
		end
	elseif v3 then
		for _, reason in v3 do
			object:fail(ErrorSourceStrings.Keys.BoundingBox_ValidationFailed, { reason = reason })
		end
	end
end

return BoundingBoxAccurate
