local Parent = script:FindFirstAncestor("SocialLinksRodux").Parent
local Rodux = require(Parent.Rodux)

return function(p1) -- line: 15
	-- upvalues: Rodux (copy)
	local SocialLinksNetworking = p1.SocialLinksNetworking

	return Rodux.createReducer({}, {
		[SocialLinksNetworking.GetSelfSocialLinks.Succeeded.name] = function(_, p3) -- line: 19
			return {
				socialLinks = {
					facebook = p3.responseBody.facebook,
					twitter = p3.responseBody.twitter,
					youtube = p3.responseBody.youtube,
					twitch = p3.responseBody.twitch,
					guilded = p3.responseBody.guilded
				},
				visibility = p3.responseBody.promotionChannelsVisibilityPrivacy
			}
		end
	})
end
