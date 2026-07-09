local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol.default
local ShareLinkTypes = require(script.Parent.ShareLinkTypes)

require(script.Parent.Types)

local FFlagShareLinkAddReferredByPlayerIdLaunchParam = require(script.Parent.Flags.FFlagShareLinkAddReferredByPlayerIdLaunchParam)

return function(p1, p2) -- line: 10
	-- upvalues: FFlagShareLinkAddReferredByPlayerIdLaunchParam (copy), ShareLinkTypes (copy), default (copy)
	local notificationExperienceInviteData = p1.responseBody.notificationExperienceInviteData

	if not notificationExperienceInviteData or not notificationExperienceInviteData.placeId then
		return
	end

	local v8 = notificationExperienceInviteData.launchData and notificationExperienceInviteData.launchData ~= ""
	local v9 = FFlagShareLinkAddReferredByPlayerIdLaunchParam and notificationExperienceInviteData.inviterId
	local t1 = {
		launchData = if not v8 then nil else notificationExperienceInviteData.launchData,
		userId = notificationExperienceInviteData.inviterId,
		referredByPlayerId = if not v9 then nil else notificationExperienceInviteData.inviterId
	}

	p2.launchGame(notificationExperienceInviteData.placeId, ShareLinkTypes.NotificationExperienceInviteLinkType, t1, default, "NotificationExperienceInviteLink")
end
