local module = require("@luauforge/bundled/hvk")
local networkingChat = module.NetworkingChat
local module2 = require("@luauforge/bundled/hvt")

local getFFlagSocialTabReplaceRefreshConversations = require("@luauforge/bundled/hvo").getFFlagSocialTabReplaceRefreshConversations

local llama = module.llama
local roduxUsers = module.RoduxUsers

local function userUpdatedFromUser(user)
	return roduxUsers.Actions.UserUpdated({
		id = user.id,
		username = user.name,
		displayName = user.displayName,
		friendRank = user.friendRank,
		hasVerifiedBadge = user.hasVerifiedBadge
	})
end

local v5 = {
	AddUser = function(p2)
		return { userUpdatedFromUser(p2.user) }
	end,
	AddUsers = function(p2)
		return llama.Dictionary.values(llama.Dictionary.map(p2.users, userUpdatedFromUser))
	end,
	[getFFlagSocialTabReplaceRefreshConversations() and networkingChat.GetUserConversations.Succeeded.name or ""] = getFFlagSocialTabReplaceRefreshConversations() and module2 or nil
}

local v6 = roduxUsers.installReducer()

return function(p2, p3)
	local v7 = p2 or { byUserId = {} }

	local v8 = v5[p3.type]
	local v9

	if v8 then
		v9 = if getFFlagSocialTabReplaceRefreshConversations() then v8(p3, v7) else v8(p3)
	else
		v9 = { p3 }
	end

	return llama.List.reduce(v9, v6, v7)
end
