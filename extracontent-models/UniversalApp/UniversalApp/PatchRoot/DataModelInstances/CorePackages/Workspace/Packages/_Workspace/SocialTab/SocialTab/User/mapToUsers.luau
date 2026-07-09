local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local llama = dependencies.llama
local t = dependencies.t
local RoduxPresence = dependencies.RoduxPresence
local getStandardSizeAvatarHeadShotRbxthumb = dependencies.getStandardSizeAvatarHeadShotRbxthumb

return function(p1, _) -- line: 8
	-- upvalues: t (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), llama (copy), RoduxPresence (copy)
	return function(p3) -- line: 9
		-- upvalues: t (copy), p1 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), llama (copy), RoduxPresence (copy)
		assert(t.string(p3))

		if p1.SocialTab.Users.byUserId[p3] then
			local v10 = getStandardSizeAvatarHeadShotRbxthumb(p3)

			return llama.Dictionary.join(p1.SocialTab.Users.byUserId[p3], RoduxPresence.Selectors.getUserPresenceByUserId(p1, p3), {
				thumbnail = v10,
				isPremium = p1.SocialTab.PremiumByUserId[p3] or false,
				hasVerifiedBadge = if not p1.VerifiedBadges or not p1.VerifiedBadges.VerifiedUsers then nil else p1.VerifiedBadges.VerifiedUsers[p3] or false
			})
		end

		return nil
	end
end
