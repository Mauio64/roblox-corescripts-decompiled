local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateDynamicHeadData = require(ParentParent.flags.getFFlagUGCValidateMigrateDynamicHeadData)
local getFIntFacsJointMaximumDistRatioDirect = require(ParentParent.flags.getFIntFacsJointMaximumDistRatioDirect)
local getFIntFacsJointMaximumDistRatioAccumulated = require(ParentParent.flags.getFIntFacsJointMaximumDistRatioAccumulated)
local getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds = require(ParentParent.flags.getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds)

return {
	fflag = getFFlagUGCValidateMigrateDynamicHeadData,
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	prereqTests = { ValidationEnums.ValidationModule.DynamicHeadFacsPresent },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 29
		-- upvalues: getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds (copy), UGCValidationService (copy), ErrorSourceStrings (copy), getFIntFacsJointMaximumDistRatioDirect (copy), getFIntFacsJointMaximumDistRatioAccumulated (copy)
		if not getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds() then
			return
		end

		local Head = p2.renderMeshesData.Head
		local ok, result = pcall(function() -- line: 38
			-- upvalues: UGCValidationService (copy), Head (copy)
			return UGCValidationService:GetMaximalJointDistancesWithinFacs(Head.editable)
		end)

		if not ok then
			p1:fail(ErrorSourceStrings.Keys.DynHead_JointBoundsCheckFailed)

			return
		end

		local v14, v15, v16, v17 = unpack(result)

		if v14 > getFIntFacsJointMaximumDistRatioDirect() / 100 then
			p1:fail(ErrorSourceStrings.Keys.DynHead_JointDirectExceeded, {
				actionName = v15
			})
		end

		if v16 > getFIntFacsJointMaximumDistRatioAccumulated() / 100 then
			p1:fail(ErrorSourceStrings.Keys.DynHead_JointAccumulatedExceeded, {
				jointName = v17
			})
		end
	end
}
