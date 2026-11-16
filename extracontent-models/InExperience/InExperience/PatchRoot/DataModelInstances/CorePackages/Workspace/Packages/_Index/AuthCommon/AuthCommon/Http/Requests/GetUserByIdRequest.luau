local parent = script:FindFirstAncestor("AuthCommon").Parent

local Http = require(parent.Http)
local Url = Http.Url
require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, p: string)
	return callback(urlBuilder.new({ base = Url.USERS_URL, path = `users/{p}` })(), "GET")
end
