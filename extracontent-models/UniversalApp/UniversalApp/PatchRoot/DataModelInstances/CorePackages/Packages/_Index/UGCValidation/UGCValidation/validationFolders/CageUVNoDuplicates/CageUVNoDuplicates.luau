local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local getFFlagUGCValidateMigrateCageUV = require(ParentParent.flags.getFFlagUGCValidateMigrateCageUV)
local getFIntUGCValidateCageDuplicateUVThreshold = require(ParentParent.flags.getFIntUGCValidateCageDuplicateUVThreshold)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {
		ValidationEnums.SharedDataMember.innerCagesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	conditionalData = {},
	fflag = getFFlagUGCValidateMigrateCageUV,
	expectedFailures = {},
	run = function(p1, p2) -- line: 39
		-- upvalues: WrapTargetCageUVReferenceValues (copy), UGCValidationService (copy), getFIntUGCValidateCageDuplicateUVThreshold (copy), ErrorSourceStrings (copy)
		local t1 = {}

		for _, v in pairs(WrapTargetCageUVReferenceValues) do
			for _, v2 in pairs(v) do
				table.insert(t1, v2)
			end
		end

		local function checkCage(t2: {[any]: any}, b1: boolean) -- line: 48
			-- upvalues: UGCValidationService (copy), t1 (copy), getFIntUGCValidateCageDuplicateUVThreshold (copy), p1 (copy), ErrorSourceStrings (copy)
			for v18, v19 in t2 do
				local v20 = UGCValidationService:ValidateEditableMeshUVDuplicates(t1, v19.editable)

				if v20 > getFIntUGCValidateCageDuplicateUVThreshold() then
					p1:fail(ErrorSourceStrings.Keys.CageUV_ExtraDuplicateUVs, {
						count = tostring(v20),
						cageType = not b1 and "outer" or "inner",
						partName = v18
					})
				end
			end
		end

		checkCage(p2.innerCagesData, true)
		checkCage(p2.outerCagesData, false)
	end
}
