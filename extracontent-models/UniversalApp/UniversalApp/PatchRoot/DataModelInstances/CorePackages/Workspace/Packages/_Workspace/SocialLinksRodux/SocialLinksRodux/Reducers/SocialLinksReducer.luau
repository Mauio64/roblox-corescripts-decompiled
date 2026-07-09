local SocialLinksRodux = script:FindFirstAncestor("SocialLinksRodux")
local getSocialLinks = require(SocialLinksRodux.Reducers.SocialLinks.getSocialLinks)
local getSelfSocialLinks = require(SocialLinksRodux.Reducers.SocialLinks.getSelfSocialLinks)
local t1 = {
	profileSocialLinks = {},
	selfSocialLinks = {}
}

return function(p1) -- line: 11
	-- upvalues: getSocialLinks (copy), getSelfSocialLinks (copy), t1 (copy)
	local v6 = getSocialLinks(p1)
	local v7 = getSelfSocialLinks(p1)

	return function(p2, p3) -- line: 15
		-- upvalues: t1 (copy), v6 (copy), v7 (copy)
		local v10 = p2 or t1

		return {
			profileSocialLinks = v6(v10.profileSocialLinks, p3),
			selfSocialLinks = v7(v10.selfSocialLinks, p3)
		}
	end
end
