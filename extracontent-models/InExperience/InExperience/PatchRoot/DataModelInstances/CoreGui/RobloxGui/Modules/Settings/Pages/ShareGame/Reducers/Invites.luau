local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)

return function(options, data)
	local v = options or {}

	if data.type == ReceivedUserInviteStatus.name then
		return (Immutable.Set(v, data.userId, data.inviteStatus))
	end

	return v
end
