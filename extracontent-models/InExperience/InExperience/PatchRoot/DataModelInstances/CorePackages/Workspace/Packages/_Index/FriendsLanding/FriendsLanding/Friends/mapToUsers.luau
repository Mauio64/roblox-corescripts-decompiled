local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local t = dependencies.t
local RoduxPresence = dependencies.RoduxPresence
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local UserLibConstants = dependencies.UserLibConstants

if require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers) then
	return nil
end

return function(p1) -- line: 17
	-- upvalues: t (copy), getDeepValue (copy), llama (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), RoduxPresence (copy)
	return function(p2) -- line: 18
		-- upvalues: t (copy), getDeepValue (copy), p1 (copy), llama (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), RoduxPresence (copy)
		assert(t.string(p2))

		local v11 = getDeepValue(p1, string.format("FriendsLanding.Friends.byUserId.%s", p2)) or {}
		local v12 = p1.FriendsLanding.DeletedUsers or nil
		local VerifiedUsers = p1.FriendsLanding.VerifiedUsers

		return llama.Dictionary.map(v11, function(p3) -- line: 24
			-- upvalues: p1 (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), llama (copy), getDeepValue (copy), RoduxPresence (copy), v12 (copy), VerifiedUsers (copy)
			local v15 = if not p1.isTest then getRbxthumbWithTypeSizeAndOptions(p3, UserLibConstants.RbxthumbTypes.Avatar, 352) else ""

			return llama.Dictionary.join(getDeepValue(p1, string.format("FriendsLanding.Users.byUserId.%s", p3)), RoduxPresence.Selectors.getUserPresenceByUserId(p1, p3), {
				thumbnail = v15
			}, {
				isDeleted = v12 and v12[p3]
			}, {
				hasVerifiedBadge = VerifiedUsers and VerifiedUsers[p3]
			}, {
				isInactiveFriend = getDeepValue(p1, `FriendsLanding.InactiveFriends.{ p3 }`)
			}, {
				friendRank = getDeepValue(p1, `FriendsLanding.Friends.friendsRankByUserId.{ p1.LocalUserId }.{ p3 }`)
			})
		end)
	end
end
