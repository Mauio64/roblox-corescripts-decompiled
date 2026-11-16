local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastFlag = game:DefineFastFlag("UGCValidationAddThumbnailFrustumCheckingv2", false)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	expectedFailures = {},
	run = function(object, data)
		local rootInstance = data.rootInstance

		local assetType = data.uploadEnum and data.uploadEnum.assetType

		if assetType == Enum.AssetType.EyebrowAccessory or assetType == Enum.AssetType.EyelashAccessory then
			return
		end

		local thumbnailConfiguration = rootInstance:FindFirstChild("ThumbnailConfiguration")

		if not thumbnailConfiguration then
			return
		end

		local handle = rootInstance:FindFirstChild("Handle")

		if not (handle and handle:IsA("BasePart")) then
			return
		end

		local thumbnailCameraTarget = thumbnailConfiguration:FindFirstChild("ThumbnailCameraTarget")

		if not thumbnailCameraTarget then
			return
		end

		if thumbnailCameraTarget.Value ~= handle then
			object:fail(ErrorSourceStrings.Keys.ThumbnailInvalidTarget, {
				ExpectedTarget = handle:GetFullName()
			})
		elseif game:GetEngineFeature("EngineUGCValidateThumbnailerMeshInFrustum") and defineFastFlag then
			local renderMeshesData = data.renderMeshesData

			if not renderMeshesData then
				return
			end

			local v = renderMeshesData[handle.Name]

			if not v then
				return
			end

			local cframe = thumbnailCameraTarget.Value.CFrame
			local thumbnailCameraValue = thumbnailConfiguration:FindFirstChild("ThumbnailCameraValue")

			if not thumbnailCameraValue then
				return
			end

			local v2 = cframe * thumbnailCameraValue.Value
			local scale = v.scale

			if UGCValidationService:CheckEditableMeshInCameraFrustum(v.editable, scale, cframe, v2) == false then
				object:fail(ErrorSourceStrings.Keys.ThumbnailOutsideView, {
					InstancePath = handle:GetFullName()
				})
			end
		end
	end
}
