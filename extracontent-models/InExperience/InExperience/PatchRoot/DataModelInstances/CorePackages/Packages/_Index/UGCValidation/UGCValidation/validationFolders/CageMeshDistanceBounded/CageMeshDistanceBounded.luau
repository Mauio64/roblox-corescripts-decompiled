local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidateCageMeshDistanceThreshold = require(parent.flags.getFIntUGCValidateCageMeshDistanceThreshold)
local getFFlagUGCValidationEyebrowEyelashSupport = require(parent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.innerCagesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	expectedFailures = {},
	run = function(object, data)
		if getFFlagUGCValidationEyebrowEyelashSupport() then
			local assetType = data.uploadEnum.assetType

			if assetType == Enum.AssetType.EyebrowAccessory or assetType == Enum.AssetType.EyelashAccessory then
				return
			end
		end

		local handle = data.renderMeshesData.Handle

		if handle == nil then
			return
		end

		local handle2 = data.innerCagesData.Handle
		local handle3 = data.outerCagesData.Handle

		if handle2 == nil or handle3 == nil then
			return
		end

		local averageEditableCageMeshDistance = UGCValidationService:CalculateAverageEditableCageMeshDistance(
			handle2.editable,
			handle3.editable,
			handle.editable,
			handle2.origin,
			handle3.origin
		)

		if
			getFIntUGCValidateCageMeshDistanceThreshold() < averageEditableCageMeshDistance * 100
			or averageEditableCageMeshDistance < 0
		then
			if averageEditableCageMeshDistance < 0 then
				object:fail(ErrorSourceStrings.Keys.CageMeshDistanceBounded_MeshOutsideCage, {})
			else
				object:fail(ErrorSourceStrings.Keys.CageMeshDistanceBounded_DistanceTooHigh, {
					distance = string.format("%.2f", averageEditableCageMeshDistance)
				})
			end
		end
	end
}
