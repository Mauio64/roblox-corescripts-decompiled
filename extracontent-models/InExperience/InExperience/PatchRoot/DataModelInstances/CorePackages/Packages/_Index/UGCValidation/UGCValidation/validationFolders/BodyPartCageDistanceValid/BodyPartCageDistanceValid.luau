local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local AssetCalculator = require(parent.util.AssetCalculator)

local GetFStringUGCValidationMaxCageDistance = require(parent.flags.GetFStringUGCValidationMaxCageDistance)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	expectedFailures = {},
	run = function(object, data)
		local childrenByName = {}

		for _, child in data.rootInstance:GetChildren() do
			childrenByName[child.Name] = child
		end

		if next(childrenByName) == nil then
			return
		end

		local allTransformsForFullBody = AssetCalculator.calculateAllTransformsForFullBody(childrenByName)

		local v = {}

		for k, v2 in childrenByName do
			local v3 = data.renderMeshesData[k]
			local v4 = data.outerCagesData[k]

			if not (v3 ~= nil and v4 ~= nil) then
				continue
			end

			local scale = v2.Size / v3.originalSize

			table.insert(v, {
				renderMesh = v3.editable,
				outerCage = v4.editable,
				renderMeshTransform = allTransformsForFullBody[k],
				outerCageLocalTransform = v4.origin,
				scale = scale,
				name = k
			})
		end

		if #v == 0 then
			return
		end

		local bodyMaxCageDistance, partName = UGCValidationService:CalculateBodyMaxCageDistance(v)

		if GetFStringUGCValidationMaxCageDistance.asNumber() < bodyMaxCageDistance then
			object:fail(ErrorSourceStrings.Keys.BodyPartCageDistanceValid_TooFar, {
				partName = partName,
				distance = string.format("%.2f", bodyMaxCageDistance),
				maxDistance = GetFStringUGCValidationMaxCageDistance.asString()
			})
		end
	end
}
