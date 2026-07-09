local AppStorageService = game:GetService("AppStorageService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey

local function getAppId() -- line: 32
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	local Item = AppStorageService:GetItem(LocalStorageKey.AppInstallationId)

	if Item and Item ~= "" then
		return Item
	end

	return "unknown"
end
local function getBtid() -- line: 40
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	local Item = AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)

	if Item and Item ~= "" then
		return Item
	end

	return "0"
end
local function buildRobloxWebNavQueryParams(t1: {[any]: any}) -- line: 48
	-- upvalues: RunService (copy), AppStorageService (copy), LocalStorageKey (copy)
	local t2 = {
		utm_content = t1.utm_content,
		utm_source = t1.utm_source or "UAP",
		utm_app_version = t1.utm_app_version or RunService:GetRobloxVersion()
	}
	local utm_app_id = t1.utm_app_id

	if not utm_app_id then
		local Item = AppStorageService:GetItem(LocalStorageKey.AppInstallationId)

		utm_app_id = (not Item or Item == "") and "unknown" or Item
	end

	t2.utm_app_id = utm_app_id

	local utm_btid = t1.utm_btid

	if not utm_btid then
		local Item = AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)

		utm_btid = (not Item or Item == "") and "0" or Item
	end

	t2.utm_btid = utm_btid

	return t2
end

return buildRobloxWebNavQueryParams
