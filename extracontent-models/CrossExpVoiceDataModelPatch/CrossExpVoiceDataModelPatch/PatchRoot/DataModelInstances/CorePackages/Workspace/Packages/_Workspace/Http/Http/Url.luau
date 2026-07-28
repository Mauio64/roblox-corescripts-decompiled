local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation() -- line: 12
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) ~= "/" then
		BaseUrl ..= "/"
	end

	local _, stop = BaseUrl:find("://")
	local start, stop2 = BaseUrl:find("%.", stop + 1)

	return BaseUrl, BaseUrl:sub(stop + 1, start - 1), (BaseUrl:sub(stop2 + 1))
end
local function preventTableModification(_, _, _) -- line: 34
	error("Attempt to modify read-only table")
end
local function createReadOnlyTable(p4) -- line: 37
	-- upvalues: preventTableModification (copy)
	return (setmetatable({}, {
		__metatable = false,
		__index = p4,
		__newindex = preventTableModification
	}))
end

local v5, v6, v7 = parseBaseUrlInformation()
local v8 = string.format("https://api.%s", v7)
local v9 = string.format("https://apis.%s", v7)
local v10 = string.format("https://auth.%s", v7)
local v11 = string.format("https://accountsettings.%s", v7)
local v12 = string.format("https://avatar.%s", v7)
local v13 = string.format("https://catalog.%s", v7)
local v14 = string.format("https://create.%s", v7)
local v15 = string.format("https://inventory.%s", v7)
local v16 = string.format("https://chat.%sv2", v7)
local v17 = string.format("https://friends.%sv1", v7)
local v18 = string.format("https://users.%sv1", v7)
local v19 = string.format("https://assetgame.%s", v7)
local v20 = string.format("https://games.%s", v7)
local v21 = string.format("https://groups.%s", v7)
local v22 = string.format("https://notifications.%s", v7)
local v23 = string.format("https://presence.%sv1", v7)
local v24 = string.format("https://realtime.%s", v7)
local v25 = string.format("https://web.%s", v7)
local v26 = string.format("https://www.%s", v7)
local v27 = string.format("https://ads.%s", v7)
local v28 = string.format("https://adconfiguration.%s", v7)
local v29 = string.format("https://followings.%s", v7)
local v30 = string.format("https://economy.%s", v7)
local v31 = string.format("https://thumbnails.%s", v7)
local v32 = string.format("https://thumbnailsdelivery.%s", v7)
local v33 = string.format("https://accountsettings.%s", v7)
local v34 = string.format("https://premiumfeatures.%s", v7)
local v35 = string.format("https://locale.%s", v7)
local v36 = string.format("https://badges.%s", v7)
local v37 = string.format("https://metrics.%sv1", v7)
local v38 = string.format("https://apis.rcs.%s", v7)
local v39 = string.format("https://discussions.%s", v7)
local v40 = string.format("https://contacts.%s", v7)
local v41 = string.format("https://search.%s", v7)
local v42 = string.format("https://static.%s", v7)
local v43 = string.format("https://gamesearchuitreatments.api.%s", v7)
local v44 = string.format("https://gameinternationalization.%s", v7)
local v45 = string.format("https://economycreatorstats.%s", v7)
local v46 = string.format("https://usermoderation.%s", v7)
local v47 = string.gsub(v5, "http://", "https://")
local v48 = string.format("https://voice.%s", v7)
local v49 = string.format("https://translations.%s", v7)
local v50 = string.format("https://twostepverification.%s", v7)
local v51 = string.format("https://privatemessages.%sv1", v7)
local v52 = v42

if v7 == "roblox.com/" then
	v52 = string.gsub(v52, v7, "rbxcdn.com/")
end

local t2 = {
	DOMAIN = v7,
	PREFIX = v6,
	BASE_URL = v47,
	BASE_URL_SECURE = v47,
	API_URL = v8,
	APIS_URL = v9,
	AUTH_URL = v10,
	ACCOUNT_SETTINGS_URL = v11,
	AVATAR_URL = v12,
	CATALOG_URL = v13,
	CREATOR_HUB_URL = v14,
	INVENTORY_URL = v15,
	GAME_URL = v20,
	GAME_ASSET_URL = v19,
	GROUPS_URL = v21,
	CHAT_URL = v16,
	FRIEND_URL = v17,
	USERS_URL = v18,
	PRESENCE_URL = v23,
	NOTIFICATION_URL = v22,
	REALTIME_URL = v24,
	WEB_URL = v25,
	WWW_URL = v26,
	ADS_URL = v27,
	AD_CONFIGURATION_URL = v28,
	SEARCH_URL = v41,
	GAME_SEARCH_UI_TREATMENTS = v43,
	GAME_INTERNATIONALIZATION_URL = v44,
	FOLLOWINGS_URL = v29,
	ECONOMY_URL = v30,
	THUMBNAILS_URL = v31,
	THUMBNAILSDELIVERY_URL = v32,
	BADGES_URL = v36,
	ACCOUNT_SETTINGS = v33,
	PREMIUM_FEATURES = v34,
	LOCALE = v35,
	METRICS_URL = v37,
	APIS_RCS_URL = v38,
	DISCUSSIONS_URL = v39,
	CONTACTS_URL = v40,
	STATIC_URL = v42,
	STATIC_CDN_URL = v52,
	BLOG_URL = "https://blog.roblox.com/",
	CORP_URL = "https://corp.roblox.com/",
	STORE_URL = "https://www.amazon.com/roblox",
	ECNOMY_CREATOR_STATS = v45,
	USER_MODERATION_URL = v46,
	VOICE_URL = v48,
	TRANSLATIONS_URL = v49,
	TWOSTEPVERIFICATION_URL = v50,
	PRIVATEMESSAGES_URL = v51,
	getUserProfileUrl = function(p5, p6) -- line: 155
		return string.format("%susers/%s/profile", p5.BASE_URL, p6)
	end,
	getUserFriendsUrl = function(p7, p8) -- line: 159
		return string.format("%susers/%s/friends", p7.BASE_URL, p8)
	end,
	getUserInventoryUrl = function(p9, p10) -- line: 163
		return string.format("%susers/%s/inventory", p9.BASE_URL, p10)
	end,
	getPlaceDefaultThumbnailUrl = function(p11, p12, p13, p14) -- line: 167
		return string.format("%sThumbs/Asset.ashx?width=%d&height=%d&assetId=%s&ignorePlaceMediaItems=true", p11.BASE_URL, p13, p14, (tostring(p12)))
	end,
	isVanitySite = function(p15) -- line: 177
		return p15.PREFIX ~= "www"
	end,
	makeQueryString = function(_, p17) -- line: 182
		local t1 = {}

		for k, v in pairs(p17) do
			if v ~= nil then
				if type(v) == "table" then
					for i = 1, #v do
						table.insert(t1, k .. "=" .. v[i])
					end
				else
					table.insert(t1, k .. "=" .. tostring(v))
				end
			end
		end

		return table.concat(t1, "&")
	end,
	stripHttpsAndTrailingSlash = function(s1: string) -- line: 205
		return (string.gsub(string.gsub(s1, "^https://", ""), "/*$", ""))
	end
}

return (setmetatable({}, {
	__metatable = false,
	__index = t2,
	__newindex = preventTableModification
}))
