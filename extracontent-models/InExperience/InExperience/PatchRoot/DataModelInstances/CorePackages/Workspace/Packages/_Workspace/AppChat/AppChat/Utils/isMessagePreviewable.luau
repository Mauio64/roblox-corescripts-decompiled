local function isMessagePreviewable(p)
	if p.isPreviewable ~= nil then
		return p.isPreviewable
	end

	return p.is_previewable ~= nil and p.is_previewable
end

return isMessagePreviewable
