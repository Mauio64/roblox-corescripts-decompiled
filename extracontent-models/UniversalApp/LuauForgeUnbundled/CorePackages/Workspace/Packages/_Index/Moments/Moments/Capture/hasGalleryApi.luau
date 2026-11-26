local function hasGalleryApi()
	local success, result = pcall(function(): boolean
		local CaptureService = game:GetService("CaptureService")
		return CaptureService ~= nil and CaptureService.PromptCaptureGalleryPermissionAsync ~= nil
	end)

	return success and result == true
end

return hasGalleryApi
