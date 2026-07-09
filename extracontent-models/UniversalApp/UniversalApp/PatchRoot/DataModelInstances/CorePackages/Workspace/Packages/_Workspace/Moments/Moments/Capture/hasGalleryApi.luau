local function hasGalleryApi() -- line: 8
	local ok, result = pcall(function() -- line: 9
		local CaptureService = game:GetService("CaptureService")

		return CaptureService ~= nil and CaptureService.PromptCaptureGalleryPermissionAsync ~= nil
	end)

	return ok and result == true
end

return hasGalleryApi
