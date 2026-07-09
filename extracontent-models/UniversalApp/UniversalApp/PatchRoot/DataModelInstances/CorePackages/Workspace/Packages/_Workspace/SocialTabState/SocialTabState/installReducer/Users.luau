local SocialTabState = script:FindFirstAncestor("SocialTabState")
local SocialTabStateParent = SocialTabState.Parent
local dependencies = require(SocialTabState.dependencies)
local NetworkingChat = dependencies.NetworkingChat
local getUsersFromConversations = require(SocialTabState.utils.getUsersFromConversations)
local getFFlagSocialTabReplaceRefreshConversations = require(SocialTabStateParent.SharedFlags).getFFlagSocialTabReplaceRefreshConversations
local llama = dependencies.llama
local RoduxUsers = dependencies.RoduxUsers

local function userUpdatedFromUser(p1) -- line: 13
	-- upvalues: RoduxUsers (copy)
	return RoduxUsers.Actions.UserUpdated({
		id = p1.id,
		username = p1.name,
		displayName = p1.displayName,
		friendRank = p1.friendRank,
		hasVerifiedBadge = p1.hasVerifiedBadge
	})
end

local t1 = {
	AddUser = function(p2) -- line: 24
		-- upvalues: userUpdatedFromUser (copy)
		return { userUpdatedFromUser(p2.user) }
	end,
	AddUsers = function(p3) -- line: 28
		-- upvalues: llama (copy), userUpdatedFromUser (copy)
		return llama.Dictionary.values(llama.Dictionary.map(p3.users, userUpdatedFromUser))
	end,
	[getFFlagSocialTabReplaceRefreshConversations() and NetworkingChat.GetUserConversations.Succeeded.name or ""] = getFFlagSocialTabReplaceRefreshConversations() and getUsersFromConversations or nil
}
local v11 = RoduxUsers.installReducer()

return function(p4, p5) -- line: 39
	-- upvalues: t1 (copy), getFFlagSocialTabReplaceRefreshConversations (copy), llama (copy), v11 (copy)
	local v17 = p4 or {
		byUserId = {}
	}
	local t2 = { p5 }
	local v19 = t1[p5.type]

	if v19 then
		t2 = if not getFFlagSocialTabReplaceRefreshConversations() then v19(p5) else v19(p5, v17)
	end

	return llama.List.reduce(t2, v11, v17)
end
