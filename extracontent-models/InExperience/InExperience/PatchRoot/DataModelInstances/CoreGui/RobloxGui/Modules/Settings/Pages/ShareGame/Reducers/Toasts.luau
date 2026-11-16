local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local ReceivedUserInviteStatus = require(ShareGame.Actions.ReceivedUserInviteStatus)
local StoppedToastTimer = require(ShareGame.Actions.StoppedToastTimer)

local Constants = require(ShareGame.Constants)
local InviteStatus = Constants.InviteStatus

return function(p, data)
	p = p or { failedInvites = {} }

	if data.type == ReceivedUserInviteStatus.name then
		local inviteStatus = data.inviteStatus

		if inviteStatus ~= InviteStatus.Moderated and inviteStatus ~= InviteStatus.Failed then
			return p
		end

		local v = { timeStamp = tick(), userId = data.userId, status = inviteStatus }

		return (Immutable.JoinDictionaries(p, {
			failedInvites = Immutable.JoinDictionaries(p.failedInvites, Immutable.Append(p.failedInvites, v))
		}))
	end

	if data.type == StoppedToastTimer.name then
		p = Immutable.JoinDictionaries(p, { failedInvites = {} })
	end

	return p
end
