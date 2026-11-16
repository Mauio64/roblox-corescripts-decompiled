local parent = script.Parent.Parent
local actions = parent.Actions
local parent2 = parent.Parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local ReceivedUserInviteStatus = require(actions.ReceivedUserInviteStatus)
local ResetUserInviteStatus = require(actions.ResetUserInviteStatus)
return function(options, data)
	local v = options or {}

	if data.type == ReceivedUserInviteStatus.name then
		return (Immutable.Set(v, data.userId, data.inviteStatus))
	end

	return data.type == ResetUserInviteStatus.name and {} or v
end
