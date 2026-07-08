local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local getFIntUGCValidateCageMeshDistanceThreshold = require(ParentParent.flags.getFIntUGCValidateCageMeshDistanceThreshold)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

return {
	fflag = getFFlagUGCValidateMigrateCageGeometry,
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.innerCagesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: getFFlagUGCValidationEyebrowEyelashSupport (copy), UGCValidationService (copy), getFIntUGCValidateCageMeshDistanceThreshold (copy), ErrorSourceStrings (copy)
		if getFFlagUGCValidationEyebrowEyelashSupport() then
			local assetType = p2.uploadEnum.assetType

			if assetType == Enum.AssetType.EyebrowAccessory or assetType == Enum.AssetType.EyelashAccessory then
				return
			end
		end

		local Handle = p2.renderMeshesData.Handle

		if Handle == nil then
			return
		end

		local Handle2 = p2.innerCagesData.Handle
		local Handle3 = p2.outerCagesData.Handle

		if Handle2 == nil or Handle3 == nil then
			return
		end

		local v14 = UGCValidationService:CalculateAverageEditableCageMeshDistance(Handle2.editable, Handle3.editable, Handle.editable, Handle2.origin, Handle3.origin)

		if getFIntUGCValidateCageMeshDistanceThreshold() < v14 * 100 or v14 < 0 then
			if v14 < 0 then
				p1:fail(ErrorSourceStrings.Keys.CageMeshDistanceBounded_MeshOutsideCage, {})

				return
			end

			p1:fail(ErrorSourceStrings.Keys.CageMeshDistanceBounded_DistanceTooHigh, {
				distance = string.format("%.2f", v14)
			})
		end
	end
}
