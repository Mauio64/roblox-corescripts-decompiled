local function isMessagePreviewable(p2)
	if p2.isPreviewable ~= nil then
		return p2.isPreviewable
	end

	if p2.is_previewable == nil then
		return false
	end

	return p2.is_previewable
end

return isMessagePreviewable
