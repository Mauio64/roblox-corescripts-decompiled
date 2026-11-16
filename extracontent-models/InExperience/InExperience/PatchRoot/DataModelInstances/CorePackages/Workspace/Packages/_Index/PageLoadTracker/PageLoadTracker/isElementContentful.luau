local v = {
	ImageLabel = true,
	ImageButton = true,
	TextLabel = true,
	TextBox = true,
	TextButton = true,
	VideoFrame = true,
	ViewportFrame = true
}

function isElementContentful(instance)
	if instance.Visible and instance.BackgroundTransparency ~= 1 then
		return v[instance.ClassName]
	end

	return false
end

return isElementContentful
