local UGCValidationService = game:GetService("UGCValidationService")
local parent = script.Parent.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
return {
	["fflag"] = require(parent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(object, data)
		local handle = data.rootInstance:FindFirstChild("Handle")
		local handle2 = data.renderMeshesData.Handle

		if handle == nil or handle2 == nil then
			error("Schema should have ensured data exists for handle")
		end

		local boneNames = {}

		for _, v in handle2.editable:GetBones() do
			table.insert(boneNames, handle2.editable:GetBoneName(v))
		end

		local v = { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(handle2.editable) }

		local editableMeshSkinningTransferJointsInfo = UGCValidationService:GetEditableMeshSkinningTransferJointsInfo(handle2.editable)

		local wrapLayer = handle:FindFirstChildOfClass("WrapLayer")
		assert(wrapLayer, "WrapLayer not found on handle")
		local v2 = wrapLayer.AutoSkin == Enum.WrapLayerAutoSkin.EnabledOverride

		object:setReportingInstance(handle)

		for _, jointName in boneNames do
			if Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES[jointName] then
				if not v2 then
					object:fail(ErrorSourceStrings.Keys.AccessorySkinning_TransferJointWithoutAutoSkin, {
						jointName = jointName
					})
				end
			elseif not Constants.R15_STANDARD_JOINT_NAMES[jointName] then
				object:fail(ErrorSourceStrings.Keys.AccessorySkinning_ExtraJoint, {
					jointName = jointName
				})
			end
		end

		for _, v3 in editableMeshSkinningTransferJointsInfo do
			if not v3 then
				object:fail(ErrorSourceStrings.Keys.AccessorySkinning_WeightNotFull)
				break
			end
		end

		if Constants.SkinningTransferRequiredTypes[data.uploadEnum.assetType] then
			if not v2 then
				object:fail(ErrorSourceStrings.Keys.AccessorySkinning_RequiredSkinningTransfer, {
					assetType = data.uploadEnum.assetType.Name
				})
			end

			for k, _ in Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES do
				if table.find(v, k) == nil then
					object:fail(ErrorSourceStrings.Keys.AccessorySkinning_MissingTransferJoint, {
						assetType = data.uploadEnum.assetType.Name,
						requiredJointName = k
					})
				end
			end

			for _, jointName in v do
				if not Constants.R15_STANDARD_JOINT_NAMES[jointName] then
					continue
				end

				local v3 = {}

				for k, _ in Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES do
					table.insert(v3, k)
				end

				object:fail(ErrorSourceStrings.Keys.AccessorySkinning_NotLeaderOrFollower, {
					jointName = jointName,
					validJointNameList = table.concat(v3, ", ")
				})
			end
		end
	end
}
