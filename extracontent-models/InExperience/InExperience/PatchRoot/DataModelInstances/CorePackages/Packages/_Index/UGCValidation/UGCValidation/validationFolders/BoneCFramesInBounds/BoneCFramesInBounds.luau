local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local CFrameUtils = require(ParentParent.util.CFrameUtils)
local t1 = {}
local v9 = game:DefineFastInt("UGCValidationBoneCFrameBoundsMultiplierHundredths", 110)

t1.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}
t1.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.renderMeshesData
}
t1.fflag = R15plusUtils.checkFlagEnabledForAllowHrd

local v10 = game:DefineFastInt("UGCValidationMinimumJointDistanceHundredths", 5) / 100

function t1.run(p1, p2) -- line: 22
	-- upvalues: v9 (copy), getAllInstancesIsA (copy), Vector3Utils (copy), ErrorSourceStrings (copy), CFrameUtils (copy), v10 (copy)
	local rootInstance = p2.rootInstance
	local v14 = v9 / 100

	for _, v16 in (getAllInstancesIsA(rootInstance, "MeshPart")) do
		local v17 = p2.renderMeshesData[v16.Name]

		if v17 then
			local v18 = v17.originalSize * v17.scale * v14 / 2
			local v19 = v16.CFrame:Inverse()

			for _, v21 in (getAllInstancesIsA(v16, "Bone")) do
				p1:setReportingInstance(v21)

				local Position = (v19 * v21.WorldCFrame).Position

				if not Vector3Utils.isInRange(Position, -v18, v18) then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_OutOfBounds, {
						bonePath = v21:GetFullName(),
						partName = v16.Name
					})
				end

				if not CFrameUtils.fuzzyEq(v21.Transform, CFrame.identity) then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_TransformNotIdentity, {
						bonePath = v21:GetFullName()
					})
				end

				if v21.Parent:IsA("Bone") and v21.Position.Magnitude < v10 then
					p1:fail(ErrorSourceStrings.Keys.HrdBone_TooCloseToParent, {
						bonePath = v21:GetFullName()
					})
				end
			end
		end
	end
end

return t1
