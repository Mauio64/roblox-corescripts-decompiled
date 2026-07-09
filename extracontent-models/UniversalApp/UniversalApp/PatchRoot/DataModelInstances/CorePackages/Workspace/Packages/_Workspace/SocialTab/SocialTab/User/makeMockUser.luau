local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local User = dependencies.RoduxUsers.Models.User
local llama = dependencies.llama
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType

return function(p1) -- line: 8
	-- upvalues: User (copy), llama (copy), PresenceType (copy)
	local v7 = User.mock()

	return llama.Dictionary.join(v7, {
		thumbnail = "rbxassetid://2610133241",
		isPremium = false,
		username = v7.name,
		userPresenceType = PresenceType.Offline
	}, p1 or {})
end
