local ContentProvider = game:GetService("ContentProvider")
local _ = {
	sitetest3 = 70389767,
	sitetest1 = 75308808508742,
	production = 95206881
}

local function getDefaultTemplatePlaceId() -- line: 15
	-- upvalues: ContentProvider (copy)
	local ok, result = pcall(function() -- line: 16
		-- upvalues: ContentProvider (copy)
		return ContentProvider.BaseUrl
	end)
	local v6 = (not ok or typeof(result) ~= "string") and "" or result

	if string.find(v6, "sitetest3", 1, true) then
		return 70389767
	end

	if string.find(v6, "sitetest1", 1, true) then
		return 75308808508742
	end

	return 95206881
end

return getDefaultTemplatePlaceId
