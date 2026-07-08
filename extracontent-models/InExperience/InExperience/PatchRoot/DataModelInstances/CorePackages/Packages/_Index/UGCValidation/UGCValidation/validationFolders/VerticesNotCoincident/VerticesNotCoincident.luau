local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local getFIntUGCLCCageVerticesSimilarityMaximum = require(ParentParent.flags.getFIntUGCLCCageVerticesSimilarityMaximum)

return {
	fflag = getFFlagUGCValidateMigrateCageGeometry,
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {
		ValidationEnums.SharedDataMember.innerCagesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	expectedFailures = {},
	run = function(p1, p2) -- line: 22
		-- upvalues: getFIntUGCLCCageVerticesSimilarityMaximum (copy), UGCValidationService (copy), ErrorSourceStrings (copy)
		local v9 = getFIntUGCLCCageVerticesSimilarityMaximum()
		local t1 = {}

		for v11, v12 in p2.innerCagesData do
			table.insert(t1, {
				name = v11 .. " (inner cage)",
				data = v12
			})
		end

		for v13, v14 in p2.outerCagesData do
			table.insert(t1, {
				name = v13 .. " (outer cage)",
				data = v14
			})
		end

		for _, v16 in t1 do
			local v17 = math.floor(UGCValidationService:GetEditableMeshVerticesSimilarityRate(v16.data.editable, (Vector3.new(1, 1, 1))) * 100)

			if v9 < v17 then
				p1:fail(ErrorSourceStrings.Keys.VerticesNotCoincident_TooManySimilar, {
					cageName = v16.name,
					percentage = tostring(v17),
					threshold = tostring(v9)
				})
			end
		end
	end
}
