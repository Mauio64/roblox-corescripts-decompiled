local AppStorageService = game:GetService("AppStorageService")
local RunService = game:GetService("RunService")

local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey

local function getAppId()
	local item = AppStorageService:GetItem(localStorageKey.AppInstallationId)

	if item and item ~= "" then
		return item
	end

	return "unknown"
end

local function getBtid()
	local item = AppStorageService:GetItem(localStorageKey.BrowserTrackerId)

	if item and item ~= "" then
		return item
	end

	return "0"
end

local function buildRobloxWebNavQueryParams(data)
	local robloxWebNavQueryParams = {
		utm_content = data.utm_content,
		utm_source = data.utm_source or "UAP",
		utm_app_version = data.utm_app_version or RunService:GetRobloxVersion(),
		utm_app_id = 0,
		utm_btid = 0
	}
	local v5 = data.utm_app_id

	if not v5 then
		local item = AppStorageService:GetItem(localStorageKey.AppInstallationId)
		v5 = (not item or item == "") and "unknown" or item
	end

	robloxWebNavQueryParams.utm_app_id = v5
	local v6 = data.utm_btid

	if not v6 then
		local item = AppStorageService:GetItem(localStorageKey.BrowserTrackerId)
		v6 = (not item or item == "") and "0" or item
	end

	robloxWebNavQueryParams.utm_btid = v6
	return robloxWebNavQueryParams
end

return buildRobloxWebNavQueryParams
