local v5 = {}

local ContentProvider = game:GetService("ContentProvider")

local function getBaseDomain(value)
	local v6, v7 = value:find("%.")
	local baseDomain = value:sub(v7 + 1)

	if baseDomain:sub(-1) ~= "/" then
		baseDomain ..= "/"
	end

	return baseDomain
end

local baseUrl = ContentProvider.BaseUrl
local v6, v7 = baseUrl:find("%.")
local v8 = baseUrl:sub(v7 + 1)

if v8:sub(-1) ~= "/" then
	v8 ..= "/"
end

local v9 = {
	GAME_URL = string.format("https://games.%s", v8),
	RCS_URL = string.format("https://apis.rcs.%s", v8),
	APIS_URL = string.format("https://apis.%s", v8),
	ACCOUNT_SETTINGS_URL = string.format("https://accountsettings.%s", v8),
	GAME_INTERNATIONALIZATION_URL = string.format("https://gameinternationalization.%s", v8),
	LOCALE_URL = string.format("https://locale.%s", v8),
	ROLES_URL = string.format("https://users.%s", v8),
	CATALOG_URL = string.format("https://catalog.%s", v8),
	CREATE_URL = string.format("https://create.%s", v8),
	DEVELOP_URL = string.format("https://develop.%s", v8)
}

setmetatable(v5, {
	__newindex = function(p2, p3, p4) end,
	__index = function(p2, p3)
		return v9[p3]
	end
})

return v5
