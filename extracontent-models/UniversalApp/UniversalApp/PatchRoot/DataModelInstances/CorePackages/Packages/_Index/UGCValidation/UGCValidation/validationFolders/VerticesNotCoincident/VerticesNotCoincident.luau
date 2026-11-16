local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCLCCageVerticesSimilarityMaximum = require(parent.flags.getFIntUGCLCCageVerticesSimilarityMaximum)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = { ValidationEnums.SharedDataMember.innerCagesData, ValidationEnums.SharedDataMember.outerCagesData },
	expectedFailures = {},
	run = function(object, p)
		local fIntUGCLCCageVerticesSimilarityMaximum = getFIntUGCLCCageVerticesSimilarityMaximum()

		local v = {}

		for k, v2 in p.innerCagesData do
			table.insert(v, {
				name = k .. " (inner cage)",
				data = v2
			})
		end

		for k, v2 in p.outerCagesData do
			table.insert(v, {
				name = k .. " (outer cage)",
				data = v2
			})
		end

		for _, v2 in v do
			local v3 = math.floor(UGCValidationService:GetEditableMeshVerticesSimilarityRate(
				v2.data.editable,
				Vector3.new(1, 1, 1)
			) * 100)

			if fIntUGCLCCageVerticesSimilarityMaximum < v3 then
				object:fail(ErrorSourceStrings.Keys.VerticesNotCoincident_TooManySimilar, {
					cageName = v2.name,
					percentage = tostring(v3),
					threshold = tostring(fIntUGCLCCageVerticesSimilarityMaximum)
				})
			end
		end
	end
}
