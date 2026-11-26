local CaptureService = game:GetService("CaptureService")

local function isImageAttachmentSupported()
	local success, result = pcall(function()
		local v5 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

		if v5 then
			if
				CaptureService.ReadCapturesFromGalleryAsync == nil
				or CaptureService.StartUploadCaptureAsync == nil
			then
				v5 = false
			else
				v5 = CaptureService.CheckUploadCaptureStatusAsync ~= nil
			end
		end

		return v5
	end)

	return success and result == true
end

return isImageAttachmentSupported
