local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local selected = ContentProvider.BaseUrl

	if selected:sub(#selected) ~= "/" then
		selected ..= "/"
	end

	local _, v = selected:find("://")

	local v2, v3 = selected:find("%.", v + 1)
	return selected, selected:sub(v + 1, v2 - 1), (selected:sub(v3 + 1))
end

local function preventTableModification(_, _, _)
	error("Attempt to modify read-only table")
end
local function createReadOnlyTable(p)
	return (setmetatable({}, {
		__index = p,
		__newindex = preventTableModification,
		__metatable = false
	}))
end

local v, prefix, domain = parseBaseUrlInformation()

local v2 = string.format("https://api.%s", domain)
local v3 = string.format("https://apis.%s", domain)
local v4 = string.format("https://auth.%s", domain)
local v5 = string.format("https://accountsettings.%s", domain)
local v6 = string.format("https://avatar.%s", domain)
local v7 = string.format("https://catalog.%s", domain)
local v8 = string.format("https://create.%s", domain)
local v9 = string.format("https://inventory.%s", domain)
local v10 = string.format("https://chat.%sv2", domain)
local v11 = string.format("https://friends.%sv1", domain)
local v12 = string.format("https://users.%sv1", domain)
local v13 = string.format("https://assetgame.%s", domain)
local v14 = string.format("https://games.%s", domain)
local v15 = string.format("https://groups.%s", domain)
local v16 = string.format("https://notifications.%s", domain)
local v17 = string.format("https://presence.%sv1", domain)
local v18 = string.format("https://realtime.%s", domain)
local v19 = string.format("https://web.%s", domain)
local v20 = string.format("https://www.%s", domain)
local v21 = string.format("https://ads.%s", domain)
local v22 = string.format("https://adconfiguration.%s", domain)
local v23 = string.format("https://followings.%s", domain)
local v24 = string.format("https://economy.%s", domain)
local v25 = string.format("https://thumbnails.%s", domain)
local v26 = string.format("https://thumbnailsdelivery.%s", domain)
local v27 = string.format("https://accountsettings.%s", domain)
local v28 = string.format("https://premiumfeatures.%s", domain)
local locale = string.format("https://locale.%s", domain)
local v29 = string.format("https://badges.%s", domain)
local v30 = string.format("https://metrics.%sv1", domain)
local v31 = string.format("https://apis.rcs.%s", domain)
local v32 = string.format("https://discussions.%s", domain)
local v36 = string.format("https://contacts.%s", domain)
local v37 = string.format("https://search.%s", domain)
local v38 = string.format("https://static.%s", domain)
local v39 = string.format("https://gamesearchuitreatments.api.%s", domain)
local v40 = string.format("https://gameinternationalization.%s", domain)
local v41 = string.format("https://economycreatorstats.%s", domain)
local v42 = string.format("https://usermoderation.%s", domain)
local v43 = string.gsub(v, "http://", "https://")
local v44 = string.format("https://voice.%s", domain)
local v45 = string.format("https://translations.%s", domain)
local v46 = string.format("https://twostepverification.%s", domain)
local v47 = string.format("https://privatemessages.%sv1", domain)
local v48

if domain == "roblox.com/" then
	v48 = string.gsub(v38, "roblox.com/", "rbxcdn.com/")
else
	v48 = v38
end

return (setmetatable({}, {
	__index = {
		DOMAIN = domain,
		PREFIX = prefix,
		BASE_URL = v43,
		BASE_URL_SECURE = v43,
		API_URL = v2,
		APIS_URL = v3,
		AUTH_URL = v4,
		ACCOUNT_SETTINGS_URL = v5,
		AVATAR_URL = v6,
		CATALOG_URL = v7,
		CREATOR_HUB_URL = v8,
		INVENTORY_URL = v9,
		GAME_URL = v14,
		GAME_ASSET_URL = v13,
		GROUPS_URL = v15,
		CHAT_URL = v10,
		FRIEND_URL = v11,
		USERS_URL = v12,
		PRESENCE_URL = v17,
		NOTIFICATION_URL = v16,
		REALTIME_URL = v18,
		WEB_URL = v19,
		WWW_URL = v20,
		ADS_URL = v21,
		AD_CONFIGURATION_URL = v22,
		SEARCH_URL = v37,
		GAME_SEARCH_UI_TREATMENTS = v39,
		GAME_INTERNATIONALIZATION_URL = v40,
		FOLLOWINGS_URL = v23,
		ECONOMY_URL = v24,
		THUMBNAILS_URL = v25,
		THUMBNAILSDELIVERY_URL = v26,
		BADGES_URL = v29,
		ACCOUNT_SETTINGS = v27,
		PREMIUM_FEATURES = v28,
		LOCALE = locale,
		METRICS_URL = v30,
		APIS_RCS_URL = v31,
		DISCUSSIONS_URL = v32,
		CONTACTS_URL = v36,
		STATIC_URL = v38,
		STATIC_CDN_URL = v48,
		BLOG_URL = "https://blog.roblox.com/",
		CORP_URL = "https://corp.roblox.com/",
		STORE_URL = "https://www.amazon.com/roblox",
		ECNOMY_CREATOR_STATS = v41,
		USER_MODERATION_URL = v42,
		VOICE_URL = v44,
		TRANSLATIONS_URL = v45,
		TWOSTEPVERIFICATION_URL = v46,
		PRIVATEMESSAGES_URL = v47,
		getUserProfileUrl = function(p, p2)
			return string.format("%susers/%s/profile", p.BASE_URL, p2)
		end,
		getUserFriendsUrl = function(p, p2)
			return string.format("%susers/%s/friends", p.BASE_URL, p2)
		end,
		getUserInventoryUrl = function(p, p2)
			return string.format("%susers/%s/inventory", p.BASE_URL, p2)
		end,
		getPlaceDefaultThumbnailUrl = function(p, p2, p3, p4)
			return string.format(
				"%sThumbs/Asset.ashx?width=%d&height=%d&assetId=%s&ignorePlaceMediaItems=true",
				p.BASE_URL,
				p3,
				p4,
				(tostring(p2))
			)
		end,
		isVanitySite = function(p): boolean
			return p.PREFIX ~= "www"
		end,
		makeQueryString = function(_, items)
			local v49 = {}

			for k, item in pairs(items) do
				if item == nil then
					continue
				end

				if type(item) == "table" then
					for i = 1, #item do
						table.insert(v49, k .. "=" .. item[i])
					end
				else
					table.insert(v49, k .. "=" .. tostring(item))
				end
			end

			return table.concat(v49, "&")
		end,
		stripHttpsAndTrailingSlash = function(value: string)
			return (string.gsub(string.gsub(value, "^https://", ""), "/*$", ""))
		end
	},
	__newindex = preventTableModification,
	__metatable = false
}))
