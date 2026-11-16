local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local Url = Http.Url
require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({ base = Url.USERS_URL, path = "usernames/users" })

return function(callback, p: string, flag: boolean?)
	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({
			usernames = { p },
			excludeBannedUsers = flag or false
		})
	})
end
