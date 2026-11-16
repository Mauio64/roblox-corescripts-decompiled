local Url = {}

local ContentProvider = game:GetService("ContentProvider")

local function getBaseDomain(baseUrl) -- 1 equivalent call inferred from this helper
	local _, v = baseUrl:find("%.")
	local baseDomain = baseUrl:sub(v + 1)

	if baseDomain:sub(-1) ~= "/" then
		baseDomain ..= "/"
	end

	return baseDomain
end

local baseDomain = getBaseDomain(ContentProvider.BaseUrl) -- inferred equivalent call

local v = {
	GAME_URL = string.format("https://games.%s", baseDomain),
	RCS_URL = string.format("https://apis.rcs.%s", baseDomain),
	APIS_URL = string.format("https://apis.%s", baseDomain),
	ACCOUNT_SETTINGS_URL = string.format("https://accountsettings.%s", baseDomain),
	GAME_INTERNATIONALIZATION_URL = string.format("https://gameinternationalization.%s", baseDomain),
	LOCALE_URL = string.format("https://locale.%s", baseDomain),
	ROLES_URL = string.format("https://users.%s", baseDomain),
	CATALOG_URL = string.format("https://catalog.%s", baseDomain),
	CREATE_URL = string.format("https://create.%s", baseDomain),
	DEVELOP_URL = string.format("https://develop.%s", baseDomain)
}

setmetatable(Url, {
	__newindex = function(_, _, _) end,
	__index = function(_, p)
		return v[p]
	end
})

return Url
