local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)

return function(p1, p2) -- line: 9
	-- upvalues: ReceivedUserInviteStatus (copy), Immutable (copy)
	local v7 = p1 or {}

	if p2.type == ReceivedUserInviteStatus.name then
		v7 = Immutable.Set(v7, p2.userId, p2.inviteStatus)
	end

	return v7
end
