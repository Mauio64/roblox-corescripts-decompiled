local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidateEyebrowEyelashThumbnailSchema = require(ParentParent.flags.getFFlagUGCValidateEyebrowEyelashThumbnailSchema)
local v7 = game:DefineFastFlag("UGCValidationAddThumbnailFrustumCheckingv2", false)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p1, p2) -- line: 30
		-- upvalues: getFFlagUGCValidateEyebrowEyelashThumbnailSchema (copy), ErrorSourceStrings (copy), v7 (copy), UGCValidationService (copy)
		local rootInstance = p2.rootInstance

		if getFFlagUGCValidateEyebrowEyelashThumbnailSchema() then
			local v11 = p2.uploadEnum and p2.uploadEnum.assetType

			if v11 == Enum.AssetType.EyebrowAccessory or v11 == Enum.AssetType.EyelashAccessory then
				return
			end
		end

		local ThumbnailConfiguration = rootInstance:FindFirstChild("ThumbnailConfiguration")

		if not ThumbnailConfiguration then
			return
		end

		local Handle = rootInstance:FindFirstChild("Handle")

		if not Handle or not Handle:IsA("BasePart") then
			return
		end

		local ThumbnailCameraTarget = ThumbnailConfiguration:FindFirstChild("ThumbnailCameraTarget")

		if not ThumbnailCameraTarget then
			return
		end

		if Handle ~= ThumbnailCameraTarget.Value then
			p1:fail(ErrorSourceStrings.Keys.ThumbnailInvalidTarget, {
				ExpectedTarget = Handle:GetFullName()
			})

			return
		end

		if game:GetEngineFeature("EngineUGCValidateThumbnailerMeshInFrustum") and v7 then
			local renderMeshesData = p2.renderMeshesData

			if not renderMeshesData then
				return
			end

			local v16 = renderMeshesData[Handle.Name]

			if not v16 then
				return
			end

			local ValueCFrame = ThumbnailCameraTarget.Value.CFrame
			local ThumbnailCameraValue = ThumbnailConfiguration:FindFirstChild("ThumbnailCameraValue")

			if not ThumbnailCameraValue then
				return
			end

			local v19 = ValueCFrame * ThumbnailCameraValue.Value
			local scale = v16.scale

			if UGCValidationService:CheckEditableMeshInCameraFrustum(v16.editable, scale, ValueCFrame, v19) == false then
				p1:fail(ErrorSourceStrings.Keys.ThumbnailOutsideView, {
					InstancePath = Handle:GetFullName()
				})
			end
		end
	end
}
