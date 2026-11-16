local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntFacsJointMaximumDistRatioDirect = require(parent.flags.getFIntFacsJointMaximumDistRatioDirect)
local getFIntFacsJointMaximumDistRatioAccumulated = require(parent.flags.getFIntFacsJointMaximumDistRatioAccumulated)

local getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds = require(parent.flags.getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	prereqTests = { ValidationEnums.ValidationModule.DynamicHeadFacsPresent },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		if not getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds() then
			return
		end

		local head = p.renderMeshesData.Head

		local success, result = pcall(function()
			return UGCValidationService:GetMaximalJointDistancesWithinFacs(head.editable)
		end)

		if not success then
			object:fail(ErrorSourceStrings.Keys.DynHead_JointBoundsCheckFailed)
			return
		end

		local v, actionName, v2, jointName = unpack(result)

		if getFIntFacsJointMaximumDistRatioDirect() / 100 < v then
			object:fail(ErrorSourceStrings.Keys.DynHead_JointDirectExceeded, {
				actionName = actionName
			})
		end

		if getFIntFacsJointMaximumDistRatioAccumulated() / 100 < v2 then
			object:fail(ErrorSourceStrings.Keys.DynHead_JointAccumulatedExceeded, {
				jointName = jointName
			})
		end
	end
}
