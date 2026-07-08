local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local bodyAssetMasksRenderer = require(ParentParent.util.bodyAssetMasksRenderer)
local AccurateBoundingBoxRasterUtil = require(ParentParent.util.AccurateBoundingBoxRasterUtil)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	fflag = getFFlagUGCValidateMigratePoseBlocking,
	expectedFailures = {}
}

local function getAssetTypeFromUploadEnum(p1) -- line: 37
	if p1.uploadEnum and p1.uploadEnum.assetType then
		return p1.uploadEnum.assetType
	end

	return nil
end
local function buildEditableMeshesFromSharedData(p2) -- line: 44
	local t2 = {}

	for v13, v14 in p2.renderMeshesData do
		local v15 = p2.rootInstance:FindFirstChild(v13, true) or (v13 ~= p2.rootInstance.Name or p2.rootInstance)

		if v15 and v14.editable then
			t2[v15] = {
				MeshId = {
					created = false,
					instance = v14.editable
				}
			}
		end
	end

	return t2
end

function t1.run(p3, p4) -- line: 61
	-- upvalues: buildEditableMeshesFromSharedData (copy), ValidationEnums (copy), AccurateBoundingBoxRasterUtil (copy), bodyAssetMasksRenderer (copy), ErrorSourceStrings (copy)
	local v18 = if not p4.uploadEnum or not p4.uploadEnum.assetType then nil else p4.uploadEnum.assetType

	if not v18 then
		return
	end

	local rootInstance = p4.rootInstance
	local v20 = buildEditableMeshesFromSharedData(p4)
	local t3 = {
		shouldYield = false,
		assetTypeEnum = v18,
		isServer = p4.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend,
		editableMeshes = v20
	}
	local v22 = AccurateBoundingBoxRasterUtil.getBoundsViewsForAssetType(v18)
	local v23, v24 = bodyAssetMasksRenderer.new(rootInstance, v22, t3)

	if not v23 then
		if v24 then
			for _, v26 in v24 do
				p3:fail(ErrorSourceStrings.Keys.BoundingBox_ValidationFailed, {
					reason = v26
				})
			end
		end

		return
	end

	local v27, v28 = AccurateBoundingBoxRasterUtil.validate(rootInstance, v24, t3)

	if not v27 and v28 then
		for _, v30 in v28 do
			p3:fail(ErrorSourceStrings.Keys.BoundingBox_ValidationFailed, {
				reason = v30
			})
		end
	end
end

return t1
