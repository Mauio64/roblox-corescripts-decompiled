local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local ParentParent2 = ParentParent.Parent.Parent
local Immutable = require(ParentParent2.AppCommonLib).Immutable
local ReceivedUserInviteStatus = require(Actions.ReceivedUserInviteStatus)
local ResetUserInviteStatus = require(Actions.ResetUserInviteStatus)

return function(p1, p2) -- line: 11
	-- upvalues: ReceivedUserInviteStatus (copy), Immutable (copy), ResetUserInviteStatus (copy)
	local v9 = p1 or {}

	if p2.type == ReceivedUserInviteStatus.name then
		return (Immutable.Set(v9, p2.userId, p2.inviteStatus))
	end

	if p2.type == ResetUserInviteStatus.name then
		v9 = {}
	end

	return v9
end
