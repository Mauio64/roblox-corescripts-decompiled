local t1 = {}

local function getBaseDomain(p1) -- line: 7
	local _, stop = p1:find("%.")
	local v20 = p1:sub(stop + 1)

	if v20:sub(-1) ~= "/" then
		v20 ..= "/"
	end

	return v20
end

local BaseUrl = game:GetService("ContentProvider").BaseUrl
local _, stop = BaseUrl:find("%.")
local v6 = BaseUrl:sub(stop + 1)

if v6:sub(-1) ~= "/" then
	v6 ..= "/"
end

local v7 = string.format("https://games.%s", v6)
local v8 = string.format("https://apis.rcs.%s", v6)
local v9 = string.format("https://apis.%s", v6)
local v10 = string.format("https://accountsettings.%s", v6)
local v11 = string.format("https://gameinternationalization.%s", v6)
local v12 = string.format("https://locale.%s", v6)
local v13 = string.format("https://users.%s", v6)
local v14 = string.format("https://catalog.%s", v6)
local v15 = string.format("https://create.%s", v6)
local t2 = {
	GAME_URL = v7,
	RCS_URL = v8,
	APIS_URL = v9,
	ACCOUNT_SETTINGS_URL = v10,
	GAME_INTERNATIONALIZATION_URL = v11,
	LOCALE_URL = v12,
	ROLES_URL = v13,
	CATALOG_URL = v14,
	CREATE_URL = v15
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 43
	end,
	__index = function(_, p6) -- line: 44
		-- upvalues: t2 (copy)
		return t2[p6]
	end
})

return t1
