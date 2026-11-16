local default = require("@luauforge/bundled/bXj").GameProtocol.default

local module = require("@luauforge/bundled/hMx")
require("@luauforge/bundled/hZh")

local module2 = require("@luauforge/bundled/hZN")

return function(p2, p3)
	local notificationExperienceInviteData = p2.responseBody.notificationExperienceInviteData

	if not (notificationExperienceInviteData and notificationExperienceInviteData.placeId) then
		return
	end

	local v5 = notificationExperienceInviteData.launchData
		and notificationExperienceInviteData.launchData ~= ""
	local inviterId = module2 and notificationExperienceInviteData.inviterId

	local v7 = if v5 then notificationExperienceInviteData.launchData else nil
	local v6 = {
		launchData = v7,
		userId = notificationExperienceInviteData.inviterId,
		referredByPlayerId = 0
	}
	local v8 = if inviterId then notificationExperienceInviteData.inviterId else nil
	v6.referredByPlayerId = v8

	p3.launchGame(
		notificationExperienceInviteData.placeId,
		module.NotificationExperienceInviteLinkType,
		v6,
		default,
		"NotificationExperienceInviteLink"
	)
end
