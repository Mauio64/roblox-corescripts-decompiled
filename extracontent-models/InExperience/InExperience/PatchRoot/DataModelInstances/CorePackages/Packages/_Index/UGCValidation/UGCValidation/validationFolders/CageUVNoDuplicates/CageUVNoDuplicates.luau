local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local WrapTargetCageUVReferenceValues = require(parent.WrapTargetCageUVReferenceValues)

local getFIntUGCValidateCageDuplicateUVThreshold = require(parent.flags.getFIntUGCValidateCageDuplicateUVThreshold)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = { ValidationEnums.SharedDataMember.innerCagesData, ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	expectedFailures = {},
	run = function(object, p)
		local v = {}

		for _, wrapTargetCageUVReferenceValue in pairs(WrapTargetCageUVReferenceValues) do
			for _, v2 in pairs(wrapTargetCageUVReferenceValue) do
				table.insert(v, v2)
			end
		end

		local function checkCage(items, flag: boolean)
			for k, item in items do
				local v2 = UGCValidationService:ValidateEditableMeshUVDuplicates(v, item.editable)

				if getFIntUGCValidateCageDuplicateUVThreshold() < v2 then
					object:fail(ErrorSourceStrings.Keys.CageUV_ExtraDuplicateUVs, {
						count = tostring(v2),
						cageType = flag and "inner" or "outer",
						partName = k
					})
				end
			end
		end

		checkCage(p.innerCagesData, true)
		checkCage(p.outerCagesData, false)
	end
}
