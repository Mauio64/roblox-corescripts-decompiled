local CaptureService = game:GetService("CaptureService")

local function isImageAttachmentSupported()
	local success, result = pcall(function()
		local v = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

		if v then
			if CaptureService.ReadCapturesFromGalleryAsync == nil or CaptureService.StartUploadCaptureAsync == nil then
				return false
			end

			return CaptureService.CheckUploadCaptureStatusAsync ~= nil
		end

		return v
	end)

	return success and result == true
end

return isImageAttachmentSupported
