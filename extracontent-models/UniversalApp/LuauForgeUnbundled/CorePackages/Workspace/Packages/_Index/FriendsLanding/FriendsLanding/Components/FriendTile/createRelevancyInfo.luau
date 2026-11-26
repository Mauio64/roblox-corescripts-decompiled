local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local uiBlox = dependencies.UIBlox
local isUserInGame = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/isUserInGame")
local getCorrectUserPresence = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/getCorrectUserPresence")
local NotLocalizedStrings = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Enums/NotLocalizedStrings")
local images = uiBlox.App.ImageSet.Images

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local udim = UDim2.fromOffset(12, 12)

return function(data, text, p2, p3, p4, p5, p6, p7, text2, p8)
	local v6 = getCorrectUserPresence(data)
	local v5 = {}

	v5.icon = p2 and images[p2] or nil

	if v6 == presenceType.Online then
		if not p8 then
			v5.iconSize = udim
		end

		v5.iconColor = p4.OnlineStatus.Color
		v5.iconTransparency = p4.OnlineStatus.Transparency
	end

	if data.isDeleted then
		v5.text = text2
	elseif isUserInGame(data) then
		v5.text = data.lastLocation
	elseif data.userPresenceType == presenceType.InStudio then
		if data.lastLocation and data.lastLocation ~= "" then
			v5.text = data.lastLocation
		else
			v5.text = p6 and NotLocalizedStrings.StudioPresenceTextLuobu.rawValue()
				or NotLocalizedStrings.StudioPresenceTextGlobal.rawValue()
		end
	else
		v5.text = text
	end

	if not p8 and p7 then
		v5.fontStyle = isUserInGame(data) and p7.CaptionHeader or p7.CaptionBody
	end

	return v5
end
