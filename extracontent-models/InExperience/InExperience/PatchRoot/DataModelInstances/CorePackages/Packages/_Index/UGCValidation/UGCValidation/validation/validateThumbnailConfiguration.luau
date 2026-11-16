local UGCValidationService = game:GetService("UGCValidationService")

local defineFastFlag = game:DefineFastFlag("UGCValidationAddThumbnailFrustumCheckingv2", false)

local parent = script.Parent.Parent

require(parent.util.Types)

local Analytics = require(parent.Analytics)

local function validateThumbnailConfiguration(instance, instance2, p, vector3: Vector3, p2)
	local thumbnailConfiguration = instance:FindFirstChild("ThumbnailConfiguration")

	if not thumbnailConfiguration then
		return true
	end

	local thumbnailCameraTarget = thumbnailConfiguration:FindFirstChild("ThumbnailCameraTarget")

	if thumbnailCameraTarget.Value ~= instance2 then
		Analytics.reportFailure(Analytics.ErrorType.validateThumbnailConfiguration_InvalidTarget, nil, p2)

		return
			false,
			{ string.format(
					"Invalid target asset for thumbnail generation. Expected it to be '%s'.",
					instance2:GetFullName()
				) }
	end

	if game:GetEngineFeature("EngineUGCValidateThumbnailerMeshInFrustum") and defineFastFlag then
		local cframe = thumbnailCameraTarget.Value.CFrame
		local v = cframe * thumbnailConfiguration:FindFirstChild("ThumbnailCameraValue").Value

		if UGCValidationService:CheckEditableMeshInCameraFrustum(p.editableMesh, vector3, cframe, v) == false then
			Analytics.reportFailure(Analytics.ErrorType.validateThumbnailConfiguration_OutsideView, nil, p2)

			return
				false,
				{ string.format(
						"Asset '%s' is positioned outside the thumbnail camera view. You need to reposition the asset at the center of the camera view and try again.",
						p.fullName
					) }
		end
	end

	return true
end

return validateThumbnailConfiguration
