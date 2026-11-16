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
local v8 = string.format("https://chat.%sv2", domain)
local v9 = string.format("https://create.%s", domain)
local v10 = string.format("https://friends.%sv1", domain)
local v11 = string.format("https://assetgame.%s", domain)
local v12 = string.format("https://games.%s", domain)
local v13 = string.format("https://notifications.%s", domain)
local v14 = string.format("https://presence.%sv1", domain)
local v15 = string.format("https://realtime.%s", domain)
local v16 = string.format("https://web.%s", domain)
local v17 = string.format("https://www.%s", domain)
local v18 = string.format("https://ads.%s", domain)
local v19 = string.format("https://followings.%s", domain)
local v20 = string.format("https://economy.%s", domain)
local v21 = string.format("https://thumbnails.%s", domain)
local v22 = string.format("https://accountsettings.%s", domain)
local v23 = string.format("https://premiumfeatures.%s", domain)
local locale = string.format("https://locale.%s", domain)
local v24 = string.format("https://badges.%s", domain)
local v25 = string.format("https://metrics.%sv1", domain)
local v26 = string.format("https://apis.rcs.%s", domain)
local v27 = string.format("https://discussions.%s", domain)
return (setmetatable({}, {
	__index = {
		DOMAIN = domain,
		PREFIX = prefix,
		BASE_URL = v,
		BASE_URL_SECURE = string.gsub(v, "http://", "https://"),
		API_URL = v2,
		APIS_URL = v3,
		AUTH_URL = v4,
		ACCOUNT_SETTINGS_URL = v5,
		AVATAR_URL = v6,
		CATALOG_URL = v7,
		CREATOR_HUB_URL = v9,
		GAME_URL = v12,
		GAME_ASSET_URL = v11,
		CHAT_URL = v8,
		FRIEND_URL = v10,
		PRESENCE_URL = v14,
		NOTIFICATION_URL = v13,
		REALTIME_URL = v15,
		WEB_URL = v16,
		WWW_URL = v17,
		ADS_URL = v18,
		FOLLOWINGS_URL = v19,
		ECONOMY_URL = v20,
		THUMBNAILS_URL = v21,
		BADGES_URL = v24,
		ACCOUNT_SETTINGS = v22,
		PREMIUM_FEATURES = v23,
		LOCALE = locale,
		METRICS_URL = v25,
		APIS_RCS_URL = v26,
		DISCUSSIONS_URL = v27,
		BLOG_URL = "https://blog.roblox.com/",
		CORP_URL = "https://corp.roblox.com/",
		GAME_I18N_URL = string.format("https://gameinternationalization.%s", domain),
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
			local v28 = {}

			for k, item in pairs(items) do
				if item == nil then
					continue
				end

				if type(item) == "table" then
					for i = 1, #item do
						table.insert(v28, k .. "=" .. item[i])
					end
				else
					table.insert(v28, k .. "=" .. tostring(item))
				end
			end

			return table.concat(v28, "&")
		end
	},
	__newindex = preventTableModification,
	__metatable = false
}))
