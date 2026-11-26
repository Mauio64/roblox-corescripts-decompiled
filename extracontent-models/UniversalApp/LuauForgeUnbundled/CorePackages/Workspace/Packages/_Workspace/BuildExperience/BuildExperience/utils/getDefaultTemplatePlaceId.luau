local ContentProvider = game:GetService("ContentProvider")

local defineFastFlag = game:DefineFastFlag("BuildExperienceConfigurableProductionTemplatePlaceId", false)

local defineFastString = game:DefineFastString("BuildExperienceProductionTemplatePlaceId", "95206881")

local v5 = {
	sitetest3 = 70389767,
	sitetest1 = 75308808508742,
	production = defineFastFlag and tonumber(defineFastString) or 95206881
}

local function getDefaultTemplatePlaceId()
	local success, result = pcall(function()
		return ContentProvider.BaseUrl
	end)

	local v6 = (not success or typeof(result) ~= "string") and "" or result

	if string.find(v6, "sitetest3", 1, true) then
		return v5.sitetest3
	end

	if string.find(v6, "sitetest1", 1, true) then
		return v5.sitetest1
	end

	return v5.production
end

return getDefaultTemplatePlaceId
