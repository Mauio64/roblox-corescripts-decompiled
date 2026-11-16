local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local uiBlox = dependencies.UIBlox
local isUserInGame = require(FriendsLanding.Friends.isUserInGame)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)
local NotLocalizedStrings = require(FriendsLanding.Enums.NotLocalizedStrings)
local images = uiBlox.App.ImageSet.Images

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local udim = UDim2.fromOffset(12, 12)

return function(data, text: string, p: string?, _, p2, _: number, flag: boolean?, p3, text2: string?, flag2: boolean?)
	local correctUserPresence = getCorrectUserPresence(data)
	local v = {}

	v.icon = p and images[p] or nil

	if correctUserPresence == presenceType.Online then
		if not flag2 then
			v.iconSize = udim
		end

		v.iconColor = p2.OnlineStatus.Color
		v.iconTransparency = p2.OnlineStatus.Transparency
	end

	if data.isDeleted then
		v.text = text2
	elseif isUserInGame(data) then
		v.text = data.lastLocation
	elseif data.userPresenceType == presenceType.InStudio then
		if data.lastLocation and data.lastLocation ~= "" then
			v.text = data.lastLocation
		else
			v.text = flag and NotLocalizedStrings.StudioPresenceTextLuobu.rawValue()
				or NotLocalizedStrings.StudioPresenceTextGlobal.rawValue()
		end
	else
		v.text = text
	end

	if not flag2 and p3 then
		v.fontStyle = isUserInGame(data) and p3.CaptionHeader or p3.CaptionBody
	end

	return v
end
