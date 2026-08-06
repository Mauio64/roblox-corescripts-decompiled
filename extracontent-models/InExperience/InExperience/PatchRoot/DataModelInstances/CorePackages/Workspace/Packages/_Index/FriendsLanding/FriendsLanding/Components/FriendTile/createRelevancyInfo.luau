local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local UIBlox = dependencies.UIBlox
local isUserInGame = require(FriendsLanding.Friends.isUserInGame)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)
local NotLocalizedStrings = require(FriendsLanding.Enums.NotLocalizedStrings)
local Images = UIBlox.App.ImageSet.Images
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local FFlagFriendsPageAlwaysOpenPPV = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageAlwaysOpenPPV
local FFlagFriendsPageUnifiedOpenProfileLogic = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageUnifiedOpenProfileLogic
local uDim2 = UDim2.fromOffset(12, 12)

return function(p1, s1: string, s2: string?, p2, p3, n1: number, b1: boolean?, p4, s3: string?, b2: boolean?) -- line: 18
	-- upvalues: getCorrectUserPresence (copy), Images (copy), PresenceType (copy), uDim2 (copy), isUserInGame (copy), FFlagFriendsPageAlwaysOpenPPV (copy), FFlagFriendsPageUnifiedOpenProfileLogic (copy), NotLocalizedStrings (copy)
	local t1 = {}
	local v24 = getCorrectUserPresence(p1)

	t1.icon = s2 and Images[s2] or nil

	if v24 == PresenceType.Online then
		if not b2 then
			t1.iconSize = uDim2
		end

		t1.iconColor = p3.OnlineStatus.Color
		t1.iconTransparency = p3.OnlineStatus.Transparency
	end

	if p1.isDeleted then
		t1.text = s3
	elseif isUserInGame(p1) then
		t1.text = p1.lastLocation
		t1.onActivated = if not FFlagFriendsPageAlwaysOpenPPV and not FFlagFriendsPageUnifiedOpenProfileLogic then p2(p1.universeId, p1.id, n1) else nil
	elseif p1.userPresenceType == PresenceType.InStudio then
		if p1.lastLocation and p1.lastLocation ~= "" then
			t1.text = p1.lastLocation
		else
			t1.text = b1 and NotLocalizedStrings.StudioPresenceTextLuobu.rawValue() or NotLocalizedStrings.StudioPresenceTextGlobal.rawValue()
		end
	else
		t1.text = s1
	end

	if not b2 and p4 then
		t1.fontStyle = isUserInGame(p1) and p4.CaptionHeader or p4.CaptionBody
	end

	return t1
end
