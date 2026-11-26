local createGetSocialLinks = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/networkRequests/createGetSocialLinks")
local createGetSelfSocialLinks = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/networkRequests/createGetSelfSocialLinks")
local createSetSocialLinks = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/networkRequests/createSetSocialLinks")

return function(p2)
	return {
		GetSocialLinks = createGetSocialLinks(p2),
		GetSelfSocialLinks = createGetSelfSocialLinks(p2),
		SetSocialLinks = createSetSocialLinks(p2)
	}
end
