local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(p1, p2) -- line: 13
		-- upvalues: UGCValidationService (copy), Constants (copy), ErrorSourceStrings (copy)
		local Handle = p2.rootInstance:FindFirstChild("Handle")
		local Handle2 = p2.renderMeshesData.Handle

		if Handle == nil or Handle2 == nil then
			error("Schema should have ensured data exists for handle")
		end

		local t1 = {}

		for _, v12 in Handle2.editable:GetBones() do
			table.insert(t1, Handle2.editable:GetBoneName(v12))
		end

		local t2 = { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(Handle2.editable) }
		local EditableMeshSkinningTransferJointsInfo = UGCValidationService:GetEditableMeshSkinningTransferJointsInfo(Handle2.editable)
		local WrapLayer = Handle:FindFirstChildOfClass("WrapLayer")

		assert(WrapLayer, "WrapLayer not found on handle")

		local v16 = WrapLayer.AutoSkin == Enum.WrapLayerAutoSkin.EnabledOverride

		p1:setReportingInstance(Handle)

		for _, v18 in t1 do
			if Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES[v18] then
				if not v16 then
					p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_TransferJointWithoutAutoSkin, {
						jointName = v18
					})
				end
			elseif not Constants.R15_STANDARD_JOINT_NAMES[v18] then
				p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_ExtraJoint, {
					jointName = v18
				})
			end
		end

		for _, v20 in EditableMeshSkinningTransferJointsInfo do
			if not v20 then
				p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_WeightNotFull)

				break
			end
		end

		if Constants.SkinningTransferRequiredTypes[p2.uploadEnum.assetType] then
			if not v16 then
				p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_RequiredSkinningTransfer, {
					assetType = p2.uploadEnum.assetType.Name
				})
			end

			for v21, _ in Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES do
				if table.find(t2, v21) == nil then
					p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_MissingTransferJoint, {
						assetType = p2.uploadEnum.assetType.Name,
						requiredJointName = v21
					})
				end
			end

			for _, v24 in t2 do
				if Constants.R15_STANDARD_JOINT_NAMES[v24] then
					local t3 = {}

					for v26, _ in Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES do
						table.insert(t3, v26)
					end

					p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_NotLeaderOrFollower, {
						jointName = v24,
						validJointNameList = table.concat(t3, ", ")
					})
				end
			end
		end
	end
}
