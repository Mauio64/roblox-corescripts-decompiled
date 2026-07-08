local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation() -- line: 11
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) ~= "/" then
		BaseUrl ..= "/"
	end

	local _, stop = BaseUrl:find("://")
	local start, stop2 = BaseUrl:find("%.", stop + 1)

	return BaseUrl, BaseUrl:sub(stop + 1, start - 1), (BaseUrl:sub(stop2 + 1))
end
local function preventTableModification(_, _, _) -- line: 33
	error("Attempt to modify read-only table")
end
local function createReadOnlyTable(p4) -- line: 36
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
local v14 = string.format("https://chat.%sv2", v7)
local v15 = string.format("https://create.%s", v7)
local v16 = string.format("https://friends.%sv1", v7)
local v17 = string.format("https://assetgame.%s", v7)
local v18 = string.format("https://games.%s", v7)
local v19 = string.format("https://notifications.%s", v7)
local v20 = string.format("https://presence.%sv1", v7)
local v21 = string.format("https://realtime.%s", v7)
local v22 = string.format("https://web.%s", v7)
local v23 = string.format("https://www.%s", v7)
local v24 = string.format("https://ads.%s", v7)
local v25 = string.format("https://followings.%s", v7)
local v26 = string.format("https://economy.%s", v7)
local v27 = string.format("https://thumbnails.%s", v7)
local v28 = string.format("https://accountsettings.%s", v7)
local v29 = string.format("https://premiumfeatures.%s", v7)
local v30 = string.format("https://locale.%s", v7)
local v31 = string.format("https://badges.%s", v7)
local v32 = string.format("https://metrics.%sv1", v7)
local v33 = string.format("https://apis.rcs.%s", v7)
local v34 = string.format("https://discussions.%s", v7)
local v35 = string.gsub(v5, "http://", "https://")
local v36 = string.format("https://gameinternationalization.%s", v7)
local t2 = {
	DOMAIN = v7,
	PREFIX = v6,
	BASE_URL = v5,
	BASE_URL_SECURE = v35,
	API_URL = v8,
	APIS_URL = v9,
	AUTH_URL = v10,
	ACCOUNT_SETTINGS_URL = v11,
	AVATAR_URL = v12,
	CATALOG_URL = v13,
	CREATOR_HUB_URL = v15,
	GAME_URL = v18,
	GAME_ASSET_URL = v17,
	CHAT_URL = v14,
	FRIEND_URL = v16,
	PRESENCE_URL = v20,
	NOTIFICATION_URL = v19,
	REALTIME_URL = v21,
	WEB_URL = v22,
	WWW_URL = v23,
	ADS_URL = v24,
	FOLLOWINGS_URL = v25,
	ECONOMY_URL = v26,
	THUMBNAILS_URL = v27,
	BADGES_URL = v31,
	ACCOUNT_SETTINGS = v28,
	PREMIUM_FEATURES = v29,
	LOCALE = v30,
	METRICS_URL = v32,
	APIS_RCS_URL = v33,
	DISCUSSIONS_URL = v34,
	BLOG_URL = "https://blog.roblox.com/",
	CORP_URL = "https://corp.roblox.com/",
	GAME_I18N_URL = v36,
	getUserProfileUrl = function(p5, p6) -- line: 117
		return string.format("%susers/%s/profile", p5.BASE_URL, p6)
	end,
	getUserFriendsUrl = function(p7, p8) -- line: 121
		return string.format("%susers/%s/friends", p7.BASE_URL, p8)
	end,
	getUserInventoryUrl = function(p9, p10) -- line: 125
		return string.format("%susers/%s/inventory", p9.BASE_URL, p10)
	end,
	getPlaceDefaultThumbnailUrl = function(p11, p12, p13, p14) -- line: 129
		return string.format("%sThumbs/Asset.ashx?width=%d&height=%d&assetId=%s&ignorePlaceMediaItems=true", p11.BASE_URL, p13, p14, (tostring(p12)))
	end,
	isVanitySite = function(p15) -- line: 138
		return p15.PREFIX ~= "www"
	end,
	makeQueryString = function(_, p17) -- line: 143
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
	end
}

return (setmetatable({}, {
	__metatable = false,
	__index = t2,
	__newindex = preventTableModification
}))
