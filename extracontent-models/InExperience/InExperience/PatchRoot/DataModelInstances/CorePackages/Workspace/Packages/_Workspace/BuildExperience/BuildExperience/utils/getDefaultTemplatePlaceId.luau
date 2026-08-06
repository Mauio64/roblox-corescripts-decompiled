local ContentProvider = game:GetService("ContentProvider")
local v2 = game:DefineFastFlag("BuildExperienceConfigurableProductionTemplatePlaceId", false)
local v3 = game:DefineFastString("BuildExperienceProductionTemplatePlaceId", "95206881")
local t1 = {
	sitetest3 = 70389767,
	sitetest1 = 75308808508742,
	production = not v2 and 95206881 or (tonumber(v3) or 95206881)
}

local function getDefaultTemplatePlaceId() -- line: 21
	-- upvalues: ContentProvider (copy), t1 (copy)
	local ok, result = pcall(function() -- line: 22
		-- upvalues: ContentProvider (copy)
		return ContentProvider.BaseUrl
	end)
	local v8 = (not ok or typeof(result) ~= "string") and "" or result

	if string.find(v8, "sitetest3", 1, true) then
		return t1.sitetest3
	end

	if string.find(v8, "sitetest1", 1, true) then
		return t1.sitetest1
	end

	return t1.production
end

return getDefaultTemplatePlaceId
