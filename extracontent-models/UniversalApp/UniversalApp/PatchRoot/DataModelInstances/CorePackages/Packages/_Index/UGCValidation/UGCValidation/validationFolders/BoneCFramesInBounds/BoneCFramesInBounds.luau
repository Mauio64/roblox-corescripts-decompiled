local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)
local R15plusUtils = require(parent.util.R15plusUtils)
local Vector3Utils = require(parent.util.Vector3Utils)
local CFrameUtils = require(parent.util.CFrameUtils)

local defineFastInt = game:DefineFastInt("UGCValidationBoneCFrameBoundsMultiplierHundredths", 110)
local BoneCFramesInBounds = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}
local v = game:DefineFastInt("UGCValidationMinimumJointDistanceHundredths", 5) / 100

function BoneCFramesInBounds.run(object, p)
	local rootInstance = p.rootInstance
	local v2 = defineFastInt / 100

	for _, v3 in getAllInstancesIsA(rootInstance, "MeshPart"), nil, nil do
		local v4 = p.renderMeshesData[v3.Name]

		if not v4 then
			continue
		end

		local v5 = v4.originalSize * v4.scale * v2 / 2
		local inverse = v3.CFrame:Inverse()

		for _, v6 in getAllInstancesIsA(v3, "Bone"), nil, nil do
			object:setReportingInstance(v6)
			local position = (inverse * v6.WorldCFrame).Position

			if not Vector3Utils.isInRange(position, -v5, v5) then
				object:fail(ErrorSourceStrings.Keys.HrdBone_OutOfBounds, {
					bonePath = v6:GetFullName(),
					partName = v3.Name
				})
			end

			if not CFrameUtils.fuzzyEq(v6.Transform, CFrame.identity) then
				object:fail(ErrorSourceStrings.Keys.HrdBone_TransformNotIdentity, {
					bonePath = v6:GetFullName()
				})
			end

			if v6.Parent:IsA("Bone") and v6.Position.Magnitude < v then
				object:fail(ErrorSourceStrings.Keys.HrdBone_TooCloseToParent, {
					bonePath = v6:GetFullName()
				})
			end
		end
	end
end

return BoneCFramesInBounds
