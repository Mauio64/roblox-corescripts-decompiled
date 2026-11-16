local buttonTypes = require("@luauforge/deferred/ehC").Enums.ButtonTypes

local module = require("@luauforge/deferred/eUz")
local module2 = require("@luauforge/deferred/ehV")

local v5 = {
	[buttonTypes.Add] = module.MemberRequestFriendshipClick,
	[buttonTypes.Chat] = module.MemberChatClick,
	[buttonTypes.Join] = module.MemberJoinClick
}

if module2 then
	v5[buttonTypes.Accept] = module.MemberAcceptFriendshipClick
end

local function getMemberCtaEventName(p2)
	return v5[p2]
end

return getMemberCtaEventName
