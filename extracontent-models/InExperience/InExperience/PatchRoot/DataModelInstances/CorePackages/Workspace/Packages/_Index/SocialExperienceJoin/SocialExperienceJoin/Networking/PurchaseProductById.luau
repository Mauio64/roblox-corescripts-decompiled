local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local Http = require(parent.Http)
local Url = Http.Url

local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)

return myRoduxNetworking.POST(script.Name, function(callback, p: string, options)
	return callback(Url.ECONOMY_URL):path("v1"):path("purchases"):path("products"):id(p):body(options or {})
end)
