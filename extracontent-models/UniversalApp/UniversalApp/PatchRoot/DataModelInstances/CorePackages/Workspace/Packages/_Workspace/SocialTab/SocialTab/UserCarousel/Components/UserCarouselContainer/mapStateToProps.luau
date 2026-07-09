local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local llama = dependencies.llama
local User = dependencies.SocialLibraries.User
local User2 = require(SocialTab.User)
local Logger = require(SocialTab.Logger)
local getFFlagDebugSocialTabCarouselEnabled = require(SocialTab.Flags.getFFlagDebugSocialTabCarouselEnabled)
local getFIntDebugSocialTabCarouselFriendsNumber = require(SocialTab.Flags.getFIntDebugSocialTabCarouselFriendsNumber)

local function v9(p1, p2) -- line: 12
	-- upvalues: llama (copy), User2 (copy), User (copy), Logger (copy)
	local v13 = p1.SocialTab.Friends.byUserId.localUserId or {}
	local ok, result = xpcall(function() -- line: 15
		-- upvalues: llama (copy), v13 (copy), User2 (copy), p1 (copy), p2 (copy), User (copy)
		return llama.List.sort(llama.List.map(v13, User2.mapToUsers(p1, p2)), User.sortFriendsByCorrectedPresenceAndRank)
	end, debug.traceback)

	if not ok then
		Logger:info((tostring(result)))
	end

	assert(ok, (tostring(result)))

	return result
end
local function v10(p3) -- line: 28
	-- upvalues: getFIntDebugSocialTabCarouselFriendsNumber (copy), llama (copy)
	local v17 = getFIntDebugSocialTabCarouselFriendsNumber()

	if v17 == 0 or not p3 then
		return {}
	end

	if v17 > #p3 then
		local t1 = {}

		while v17 > #t1 do
			t1 = llama.List.join(t1, p3)
		end

		return llama.List.slice(t1, 1, v17)
	end

	return llama.List.slice(p3, 1, v17)
end

return function(p4, p5) -- line: 45
	-- upvalues: getFFlagDebugSocialTabCarouselEnabled (copy), v10 (copy), v9 (copy)
	local v21 = p4.SocialTab.Friends.requests.receivedCount or 0

	return {
		screenSize = p4.ScreenSize,
		friends = if not getFFlagDebugSocialTabCarouselEnabled() then v9(p4, p5) else v10((v9(p4, p5))),
		hasFriendRequests = v21 > 0
	}
end
