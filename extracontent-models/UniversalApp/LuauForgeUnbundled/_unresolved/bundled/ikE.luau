local AppStorageService = game:GetService("AppStorageService")

local module = require("@luauforge/bundled/ggq")

local v5 = { BASELINE = "v10.1", CLOSED_SELF_VIEW = "v10.2" }

function LUAUFORGE_MODULE_GLOBALS_ikE_canShowChromeSurvey(p2)
	if p2 == "" or p2 == nil then
		return false
	end

	local v6 = LUAUFORGE_MODULE_GLOBALS_ikE_getCurrentMenuVersion()
	local v7 = false

	for k, v9 in v5 do
		if p2 == v9 and p2 == v6 then
			v7 = true
			break
		end
	end

	local v9 = p2 == "v10.0" and p2 == v6

	return v7 or v9
end

function LUAUFORGE_MODULE_GLOBALS_ikE_getCurrentMenuVersion()
	local success, result = pcall(function()
		return AppStorageService:GetItem(module.LOCAL_STORAGE_KEY_EXPERIENCE_MENU_VERSION)
	end)

	if success and result ~= "" then
		return result
	end

	return ""
end

return { canShowChromeSurvey = LUAUFORGE_MODULE_GLOBALS_ikE_canShowChromeSurvey }
