local Players = game:GetService("Players")
local Badges = script:FindFirstAncestor("Badges")
local BadgesParent = Badges.Parent
local AppPage = require(BadgesParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(BadgesParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgeDetailsUrl = require(Badges.BadgesSeeAllPage.getBadgeDetailsUrl)
local getBadgeDetailsPageKey = require(script.Parent.getBadgeDetailsPageKey)
local FFlagSduiUniversalPageEntry = require(BadgesParent.SharedFlags).FFlagSduiUniversalPageEntry

local function getLocalPlayerUserId() -- line: 15
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	local UserId = LocalPlayer.UserId

	if UserId <= 0 then
		return nil
	end

	return (tostring(UserId))
end
local function fetchBadgeDetailsPage(s1: string, p1) -- line: 27
	-- upvalues: Players (copy), getBadgeDetailsUrl (copy), BadgesParent (copy), getSduiApiStore (copy), SduiResponseType (copy), AppPage (copy), getBadgeDetailsPageKey (copy), FFlagSduiUniversalPageEntry (copy)
	local LocalPlayer = Players.LocalPlayer
	local v18

	if not LocalPlayer then
		v18 = nil
	else
		local UserId = LocalPlayer.UserId

		v18 = if not (UserId <= 0) then tostring(UserId) else nil
	end

	local v20 = getBadgeDetailsUrl(s1, v18)
	local badge_details_page = require(BadgesParent.ServiceContractsProto).apppageplatform.badges.badge_details_page

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v20,
		surfaceKey = AppPage.BadgeDetails,
		configKey = getBadgeDetailsPageKey(s1),
		loadTimer = p1,
		apiProto = if not FFlagSduiUniversalPageEntry then badge_details_page.BadgeDetailsPageResponse else badge_details_page.BadgeDetailsPageV2Response
	})
end

return fetchBadgeDetailsPage
