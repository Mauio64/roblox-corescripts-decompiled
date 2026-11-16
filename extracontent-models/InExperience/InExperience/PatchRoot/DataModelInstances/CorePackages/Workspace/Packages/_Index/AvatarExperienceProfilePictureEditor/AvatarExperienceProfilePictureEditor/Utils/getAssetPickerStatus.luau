local function getAssetPickerStatus(flag: boolean, flag2: boolean): string
	if flag then
		return "loading"
	end

	return if flag2 then "error" else "ready"
end

return getAssetPickerStatus
