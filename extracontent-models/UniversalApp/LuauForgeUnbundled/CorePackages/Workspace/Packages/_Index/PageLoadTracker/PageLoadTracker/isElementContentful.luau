local v5 = {
	ImageLabel = true,
	ImageButton = true,
	TextLabel = true,
	TextBox = true,
	TextButton = true,
	VideoFrame = true,
	ViewportFrame = true
}

function LUAUFORGE_MODULE_GLOBALS_dCZ_isElementContentful(instance)
	if instance.Visible and instance.BackgroundTransparency ~= 1 then
		return v5[instance.ClassName]
	end

	return false
end

return LUAUFORGE_MODULE_GLOBALS_dCZ_isElementContentful
