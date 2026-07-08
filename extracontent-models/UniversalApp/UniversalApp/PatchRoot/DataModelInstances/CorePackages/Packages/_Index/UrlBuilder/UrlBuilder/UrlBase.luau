local BaseUrl = game:GetService("ContentProvider").BaseUrl
local v2 = string.gsub(BaseUrl, ".*://", "")
local v3 = string.gsub(v2, "/.*", "")
local u4 = string.gsub(v3, "^www%.", "")
local t1 = {
	new = function(p1, p2) -- line: 24
		-- upvalues: u4 (ref)
		assert(type(p1) == "string", "UrlBase.new: `name` should be a string")

		if p2 == nil then
			p2 = {}
		end

		if type(p2) == "number" or type(p2) == "string" then
			p2 = {
				version = p2
			}
		end

		assert(type(p2) == "table", "UrlBase.new: `params` should be a table")

		local proto = p2.proto
		local version = p2.version
		local path = p2.path

		if proto == nil then
			proto = p2.secure ~= false and "https" or "http"
		end

		if #proto > 0 then
			proto ..= "://"
		end

		local v12 = proto .. p1

		if #p1 > 0 then
			v12 ..= "."
		end

		local v13 = v12 .. u4

		if version ~= nil and #tostring(version) > 0 then
			v13 ..= "/v" .. tostring(version)
		end

		if path ~= nil and #path > 0 then
			v13 ..= "/" .. path
		end

		return v13
	end
}
local v6 = string.sub(u4, -6) == "qq.com"

t1.API = t1.new("api")
t1.APIS = t1.new("apis")
t1.APIS_RBXCDN = "https://apis.rbxcdn.com"
t1.AUTH = t1.new("auth")
t1.CHAT = t1.new("chat")
t1.CREATE = t1.new("create")
t1.FRIENDS = t1.new("friends", 1)
t1.ASSETGAME = t1.new("assetgame")
t1.GAMES = t1.new("games", 1)
t1.NOTIFICATION = t1.new("notification", 2)
t1.NOTIFICATIONS = t1.new("notifications", 2)
t1.PRESENCE = t1.new("presence", 1)
t1.REALTIME = t1.new("realtime")
t1.WEB = t1.new("web")
t1.WWW = t1.new("www")
t1.ADS = t1.new("ads", 1)
t1.ADCONFIGURATION = t1.new("adconfiguration", 2)
t1.FOLLOWINGS = t1.new("followings", 1)
t1.PREMIUM = t1.new("premiumfeatures", 1)
t1.BLOG = "https://blog.roblox.com"
t1.CORP = not v6 and "https://corp.roblox.com" or "https://roblox.qq.com"
t1.USERMODERATION = t1.new("usermoderation")
t1.ACCOUNTINFORMATION = t1.new("accountinformation", 1)
t1.ACCOUNTSETTINGS = t1.new("accountsettings")
t1.BADGES = t1.new("badges", 1)
t1.INVENTORY = t1.new("inventory", 1)
t1.CATALOG = t1.new("catalog", 1)
t1.AVATAR = t1.new("avatar", 1)
t1.MOBILENAV = "roblox://navigation"
t1.APPSFLYER = "https://ro.blox.com"

return t1
