local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local RoduxNetworking = dependencies.RoduxNetworking
local Url = dependencies.Url

return RoduxNetworking.GET(script.Name, function(p1) -- line: 7
	-- upvalues: Url (copy)
	return p1(Url.CHAT_URL):path("chat-settings")
end)
