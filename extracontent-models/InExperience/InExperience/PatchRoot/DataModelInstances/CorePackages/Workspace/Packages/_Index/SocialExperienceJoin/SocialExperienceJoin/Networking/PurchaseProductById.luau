local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local Url = require(SocialExperienceJoinParent.Http).Url

return require(SocialExperienceJoin.Networking.myRoduxNetworking).POST(script.Name, function(p1, s1: string, t1: {[any]: any}?) -- line: 19
	-- upvalues: Url (copy)
	return p1(Url.ECONOMY_URL):path("v1"):path("purchases"):path("products"):id(s1):body(t1 or {})
end)
