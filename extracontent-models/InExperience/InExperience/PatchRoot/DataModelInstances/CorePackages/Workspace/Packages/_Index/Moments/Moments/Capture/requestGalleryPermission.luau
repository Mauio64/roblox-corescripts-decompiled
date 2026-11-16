local function requestGalleryPermission(p)
	local v = p or game:GetService("CaptureService")

	local success, result = pcall(function()
		return v:PromptCaptureGalleryPermissionAsync(Enum.CaptureGalleryPermission.ReadAndUpload)
	end)

	return success and result == true
end

return requestGalleryPermission
