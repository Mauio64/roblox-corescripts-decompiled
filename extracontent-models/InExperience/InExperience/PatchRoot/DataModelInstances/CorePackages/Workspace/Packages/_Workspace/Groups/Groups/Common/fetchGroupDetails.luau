local Parent = script:FindFirstAncestor("Groups").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, n1: number) -- line: 9
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v6 = UrlBuilder.fromString("apis:profile-platform-api/v1/profiles/get")
	local t1 = {
		profileType = "Community",
		profileId = n1,
		components = {
			{
				component = "CommunityProfileHeader"
			},
			{
				component = "Actions"
			},
			{
				component = "CommunityLocked"
			}
		}
	}
	local json = HttpService:JSONEncode(t1)

	return p1(v6(), "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 27
		return p2.responseBody
	end)
end
