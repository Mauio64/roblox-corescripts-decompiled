local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local CFrameUtils = require(ParentParent.util.CFrameUtils)
local t1 = {}
local v10 = game:DefineFastInt("UGCValidationBoneCFrameBoundsMultiplierHundredths", 110)

t1.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}
t1.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.renderMeshesData
}
t1.fflag = R15plusUtils.checkFlagEnabledForAllowHrd

local v11 = game:DefineFastInt("UGCValidationMinimumJointDistanceHundredths", 5) / 100

function t1.run(p1, p2) -- line: 24
	-- upvalues: v10 (copy), getAllInstancesIsA (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), Vector3Utils (copy), ErrorSourceStrings (copy), CFrameUtils (copy), v11 (copy)
	local rootInstance = p2.rootInstance
	local v15 = v10 / 100

	for _, v17 in (getAllInstancesIsA(rootInstance, "MeshPart")) do
		local v18 = p2.renderMeshesData[v17.Name]

		if v18 then
			local v19 = v18.originalSize * v18.scale * v15 / 2
			local v20 = v17.CFrame:Inverse()

			for _, v22 in (getAllInstancesIsA(v17, "Bone")) do
				if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
					p1:setReportingInstance(v22)
				end

				local Position = (v20 * v22.WorldCFrame).Position

				if not Vector3Utils.isInRange(Position, -v19, v19) then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_OutOfBounds, {
						bonePath = v22:GetFullName(),
						partName = v17.Name
					})
				end

				if not CFrameUtils.fuzzyEq(v22.Transform, CFrame.identity) then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_TransformNotIdentity, {
						bonePath = v22:GetFullName()
					})
				end

				if v22.Parent:IsA("Bone") and v22.Position.Magnitude < v11 then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_TooCloseToParent, {
						bonePath = v22:GetFullName()
					})
				end
			end
		end
	end
end

return t1
