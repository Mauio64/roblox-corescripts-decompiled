local function fetchGalleryCaptures(object, p)
	local v = p or { Enum.CaptureType.Screenshot }

	if object == nil then
		object = game:GetService("CaptureService")
	end

	local success, result = pcall(function()
		local capturesFromGalleryAsync, v2 = object:ReadCapturesFromGalleryAsync(v, false)

		if capturesFromGalleryAsync == Enum.ReadCapturesFromGalleryResult.Success then
			return v2
		end

		return nil
	end)
	return if success and result ~= nil then result else nil
end

return fetchGalleryCaptures
