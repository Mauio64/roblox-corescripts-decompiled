local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local GetFStringUGCValidationMaxCageDistance = require(ParentParent.flags.GetFStringUGCValidationMaxCageDistance)

return {
	fflag = getFFlagUGCValidateMigrateCageGeometry,
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	expectedFailures = {},
	run = function(p1, p2) -- line: 23
		-- upvalues: AssetCalculator (copy), UGCValidationService (copy), GetFStringUGCValidationMaxCageDistance (copy), ErrorSourceStrings (copy)
		local t1 = {}

		for _, child in p2.rootInstance:GetChildren() do
			t1[child.Name] = child
		end

		if next(t1) == nil then
			return
		end

		local v13 = AssetCalculator.calculateAllTransformsForFullBody(t1)
		local t2 = {}

		for v15, v16 in t1 do
			local v17 = p2.renderMeshesData[v15]
			local v18 = p2.outerCagesData[v15]

			if v17 ~= nil and v18 ~= nil then
				local v19 = v16.Size / v17.originalSize

				table.insert(t2, {
					renderMesh = v17.editable,
					outerCage = v18.editable,
					renderMeshTransform = v13[v15],
					outerCageLocalTransform = v18.origin,
					scale = v19,
					name = v15
				})
			end
		end

		if #t2 == 0 then
			return
		end

		local v20, v21 = UGCValidationService:CalculateBodyMaxCageDistance(t2)

		if v20 > GetFStringUGCValidationMaxCageDistance.asNumber() then
			p1:fail(ErrorSourceStrings.Keys.BodyPartCageDistanceValid_TooFar, {
				partName = v21,
				distance = string.format("%.2f", v20),
				maxDistance = GetFStringUGCValidationMaxCageDistance.asString()
			})
		end
	end
}
