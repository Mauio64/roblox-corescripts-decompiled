local AppStorageService = game:GetService("AppStorageService")
local CsatSurveyConstants = require(script.Parent.CsatSurveyConstants)
local t1 = {
	BASELINE = "v10.1",
	CLOSED_SELF_VIEW = "v10.2"
}

function canShowChromeSurvey(p1) -- line: 14
	-- upvalues: t1 (copy)
	if p1 == "" or p1 == nil then
		return false
	end

	local v5 = getCurrentMenuVersion()
	local v6 = false

	for _, v8 in t1 do
		if p1 == v8 and p1 == v5 then
			v6 = true

			break
		end
	end

	local v9 = p1 == "v10.0" and p1 == v5

	return v6 or v9
end
function getCurrentMenuVersion() -- line: 36
	-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy)
	local ok, result = pcall(function() -- line: 38
		-- upvalues: AppStorageService (copy), CsatSurveyConstants (copy)
		return AppStorageService:GetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_EXPERIENCE_MENU_VERSION)
	end)

	if ok and result ~= "" then
		return result
	end

	return ""
end

return {
	canShowChromeSurvey = canShowChromeSurvey
}
