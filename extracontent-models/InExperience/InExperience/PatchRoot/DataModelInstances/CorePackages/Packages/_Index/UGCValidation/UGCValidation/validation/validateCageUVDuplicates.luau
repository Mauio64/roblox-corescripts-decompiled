local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local getFIntUGCValidateCageDuplicateUVThreshold = require(ParentParent.flags.getFIntUGCValidateCageDuplicateUVThreshold)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local Analytics = require(ParentParent.Analytics)
local UGCValidationService = game:GetService("UGCValidationService")

local function validateCageUVDuplicates(p1, p2, p3, p4) -- line: 18
	-- upvalues: WrapTargetCageUVReferenceValues (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCValidateCageDuplicateUVThreshold (copy), FailureReasonsAccumulator (copy)
	local t1 = {}

	for _, v in pairs(WrapTargetCageUVReferenceValues) do
		for _, v2 in pairs(v) do
			table.insert(t1, v2)
		end
	end

	local function checkCageUV(t2: {[any]: any}, p5, b1: boolean) -- line: 31
		-- upvalues: pcallDeferred (copy), UGCValidationService (copy), p4 (copy), Analytics (copy), p3 (copy), getFIntUGCValidateCageDuplicateUVThreshold (copy)
		local v23, v24 = pcallDeferred(function() -- line: 36
			-- upvalues: UGCValidationService (copy), t2 (copy), p5 (copy)
			return UGCValidationService:ValidateEditableMeshUVDuplicates(t2, p5.editableMesh)
		end, p4)

		if not v23 then
			Analytics.reportFailure(Analytics.ErrorType.validateCageUVDuplicate_FailedToExecute, nil, p4)

			return false, { (string.format("Failed to load UVs for Inner cage of '%s'. Make sure the UV map exists and try again.", p3.fullName)) }
		end

		if v24 > getFIntUGCValidateCageDuplicateUVThreshold() then
			Analytics.reportFailure(Analytics.ErrorType.validateCageUVDuplicate_UnexpectedUVValue, nil, p4)

			return false, { string.format("There are %d UV values in %s cage that do not belong to the template. Please correct the cage UV.", v24, not b1 and "outer" or "inner") .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageExtraUvs)" }
		end

		return true
	end

	local v19 = FailureReasonsAccumulator.new()

	v19:updateReasons(checkCageUV(t1, p1, true))
	v19:updateReasons(checkCageUV(t1, p2, false))

	return v19:getFinalResults()
end

return validateCageUVDuplicates
