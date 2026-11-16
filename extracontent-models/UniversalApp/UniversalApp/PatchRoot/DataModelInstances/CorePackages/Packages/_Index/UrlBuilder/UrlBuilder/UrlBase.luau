local ContentProvider = game:GetService("ContentProvider")

local BaseUrl = ContentProvider.BaseUrl
local v = string.gsub(BaseUrl, ".*://", "")
local v2 = string.gsub(v, "/.*", "")
local v3 = string.gsub(v2, "^www%.", "")

local UrlBase = {
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	["new"] = nil,
	new = function(name, p)
		assert(type(name) == "string", "UrlBase.new: `name` should be a string")
		local version2 = p == nil and {} or p

		local v4 = (type(version2) == "number" or type(version2) == "string") and {
			version = version2
		} or version2

		assert(type(v4) == "table", "UrlBase.new: `params` should be a table")
		local proto = v4.proto
		local version = v4.version
		local path = v4.path
		local v5 = proto == nil and (v4.secure == false and "http" or "https") or proto

		if #v5 > 0 then
			v5 ..= "://"
		end

		local v6 = v5 .. name

		if #name > 0 then
			v6 ..= "."
		end

		local v7 = v6 .. v3

		if version ~= nil and #tostring(version) > 0 then
			v7 ..= "/v" .. tostring(version)
		end

		if path ~= nil and #path > 0 then
			return v7 .. "/" .. path
		end

		return v7
	end
}

local v4 = string.sub(v3, -6) == "qq.com"

UrlBase.API = UrlBase.new("api")
UrlBase.APIS = UrlBase.new("apis")
UrlBase.APIS_RBXCDN = "https://apis.rbxcdn.com"
UrlBase.AUTH = UrlBase.new("auth")
UrlBase.CHAT = UrlBase.new("chat")
UrlBase.CREATE = UrlBase.new("create")
UrlBase.FRIENDS = UrlBase.new("friends", 1)
UrlBase.ASSETGAME = UrlBase.new("assetgame")
UrlBase.GAMES = UrlBase.new("games", 1)
UrlBase.NOTIFICATION = UrlBase.new("notification", 2)
UrlBase.NOTIFICATIONS = UrlBase.new("notifications", 2)
UrlBase.PRESENCE = UrlBase.new("presence", 1)
UrlBase.REALTIME = UrlBase.new("realtime")
UrlBase.WEB = UrlBase.new("web")
UrlBase.WWW = UrlBase.new("www")
UrlBase.ADS = UrlBase.new("ads", 1)
UrlBase.ADCONFIGURATION = UrlBase.new("adconfiguration", 2)
UrlBase.FOLLOWINGS = UrlBase.new("followings", 1)
UrlBase.PREMIUM = UrlBase.new("premiumfeatures", 1)
UrlBase.BLOG = "https://blog.roblox.com"
UrlBase.CORP = v4 and "https://roblox.qq.com" or "https://corp.roblox.com"
UrlBase.USERMODERATION = UrlBase.new("usermoderation")
UrlBase.ACCOUNTINFORMATION = UrlBase.new("accountinformation", 1)

UrlBase.ACCOUNTSETTINGS = UrlBase.new("accountsettings")
UrlBase.BADGES = UrlBase.new("badges", 1)
UrlBase.INVENTORY = UrlBase.new("inventory", 1)
UrlBase.CATALOG = UrlBase.new("catalog", 1)

UrlBase.AVATAR = UrlBase.new("avatar", 1)

UrlBase.MOBILENAV = "roblox://navigation"
UrlBase.APPSFLYER = "https://ro.blox.com"

return UrlBase
