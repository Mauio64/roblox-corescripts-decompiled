local function openCapturesGallery(object): boolean
	local capturesPage = object.Instance.CapturesPage

	if not capturesPage then
		return false
	end

	if object:GetVisibility() then
		object:SwitchToPage(capturesPage, true)
	else
		object:SetVisibility(true, false, capturesPage)
	end

	return true
end

return openCapturesGallery
