local UGCValidationService = game:GetService("UGCValidationService")
local v2 = game:DefineFastFlag("UGCValidationAddThumbnailFrustumCheckingv2", false)
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)

local function validateThumbnailConfiguration(p1, p2, p3, vector3: Vector3, p4) -- line: 14
	-- upvalues: Analytics (copy), v2 (copy), UGCValidationService (copy)
	local ThumbnailConfiguration = p1:FindFirstChild("ThumbnailConfiguration")

	if ThumbnailConfiguration then
		local ThumbnailCameraTarget = ThumbnailConfiguration:FindFirstChild("ThumbnailCameraTarget")

		if p2 ~= ThumbnailCameraTarget.Value then
			Analytics.reportFailure(Analytics.ErrorType.validateThumbnailConfiguration_InvalidTarget, nil, p4)

			return false, { string.format("Invalid target asset for thumbnail generation. Expected it to be '%s'.", p2:GetFullName()) }
		end

		if game:GetEngineFeature("EngineUGCValidateThumbnailerMeshInFrustum") and v2 then
			local ValueCFrame = ThumbnailCameraTarget.Value.CFrame
			local v14 = ValueCFrame * ThumbnailConfiguration:FindFirstChild("ThumbnailCameraValue").Value

			if UGCValidationService:CheckEditableMeshInCameraFrustum(p3.editableMesh, vector3, ValueCFrame, v14) == false then
				Analytics.reportFailure(Analytics.ErrorType.validateThumbnailConfiguration_OutsideView, nil, p4)

				return false, { string.format("Asset '%s' is positioned outside the thumbnail camera view. You need to reposition the asset at the center of the camera view and try again.", p3.fullName) }
			end
		end
	end

	return true
end

return validateThumbnailConfiguration
