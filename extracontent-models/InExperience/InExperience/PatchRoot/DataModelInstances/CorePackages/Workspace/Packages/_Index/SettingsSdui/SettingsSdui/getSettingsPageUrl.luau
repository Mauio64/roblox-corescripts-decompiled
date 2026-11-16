local parent = script:FindFirstAncestor("SettingsSdui").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.APIS_URL,
	path = "account-management-api/v1/usersettings/menu"
})

local function getSettingsPageUrl()
	return urlBuilder()
end

return getSettingsPageUrl
