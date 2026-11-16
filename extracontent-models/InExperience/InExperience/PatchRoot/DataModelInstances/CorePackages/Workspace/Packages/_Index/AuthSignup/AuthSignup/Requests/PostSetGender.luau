local parent = script:FindFirstAncestor("AuthSignup").Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({ base = Url.USERS_URL, path = "gender" })

return function(callback, gender: string)
	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({ gender = gender })
	})
end
