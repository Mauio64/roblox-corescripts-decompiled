local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)
local StoppedToastTimer = require(ShareGame.Actions.StoppedToastTimer)
local InviteStatus = require(ShareGame.Constants).InviteStatus

return function(p1, p2) -- line: 13
	-- upvalues: ReceivedUserInviteStatus (copy), InviteStatus (copy), Immutable (copy), StoppedToastTimer (copy)
	local v9 = p1 or {
		failedInvites = {}
	}

	if p2.type == ReceivedUserInviteStatus.name then
		local inviteStatus = p2.inviteStatus

		if inviteStatus == InviteStatus.Moderated or inviteStatus == InviteStatus.Failed then
			local t1 = {
				timeStamp = tick(),
				userId = p2.userId,
				status = inviteStatus
			}

			return (Immutable.JoinDictionaries(v9, {
				failedInvites = Immutable.JoinDictionaries(v9.failedInvites, Immutable.Append(v9.failedInvites, t1))
			}))
		end
	elseif p2.type == StoppedToastTimer.name then
		v9 = Immutable.JoinDictionaries(v9, {
			failedInvites = {}
		})
	end

	return v9
end
