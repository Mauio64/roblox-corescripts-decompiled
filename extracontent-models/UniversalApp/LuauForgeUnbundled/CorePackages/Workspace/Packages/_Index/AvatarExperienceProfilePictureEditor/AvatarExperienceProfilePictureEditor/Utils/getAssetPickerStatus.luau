local function getAssetPickerStatus(p2, p3): string
	if p2 then
		return "loading"
	end

	if p3 then
		return "error"
	end

	return "ready"
end

return getAssetPickerStatus
