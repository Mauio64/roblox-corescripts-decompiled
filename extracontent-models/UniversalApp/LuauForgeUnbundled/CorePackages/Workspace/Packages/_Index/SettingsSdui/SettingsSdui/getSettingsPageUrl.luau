local url = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/UrlBuilder").UrlBuilder.new({
	base = url.APIS_URL,
	path = "account-management-api/v1/usersettings/menu"
})

local function getSettingsPageUrl()
	return urlBuilder()
end

return getSettingsPageUrl
