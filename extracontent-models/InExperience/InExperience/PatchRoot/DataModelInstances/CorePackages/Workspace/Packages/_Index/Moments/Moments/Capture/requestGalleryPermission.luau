local function requestGalleryPermission(t1: {[any]: any}?) -- line: 20
	local v3 = t1 or game:GetService("CaptureService")
	local ok, result = pcall(function() -- line: 25
		-- upvalues: v3 (copy)
		return v3:PromptCaptureGalleryPermissionAsync(Enum.CaptureGalleryPermission.ReadAndUpload)
	end)

	return ok and result == true
end

return requestGalleryPermission
