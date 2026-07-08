local Badges = script:FindFirstAncestor("Badges")
local BadgesParent = Badges.Parent
local AppPage = require(BadgesParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(BadgesParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgesSeeAllUrl = require(Badges.BadgesSeeAllPage.getBadgesSeeAllUrl)
local getBadgesSeeAllPageKey = require(Badges.BadgesSeeAllPage.getBadgesSeeAllPageKey)
local FFlagSduiProtobufJsonDecode = require(BadgesParent.SharedFlags).FFlagSduiProtobufJsonDecode
local FFlagSduiUniversalPageEntry = require(BadgesParent.SharedFlags).FFlagSduiUniversalPageEntry

local function fetchBadgesSeeAllPageIfNeeded(s1: string, p1, b1: boolean?) -- line: 15
	-- upvalues: getBadgesSeeAllUrl (copy), getBadgesSeeAllPageKey (copy), BadgesParent (copy), getSduiApiStore (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), AppPage (copy), FFlagSduiUniversalPageEntry (copy)
	local v15 = getBadgesSeeAllUrl(s1)
	local v16 = getBadgesSeeAllPageKey(s1)
	local badges_see_all = require(BadgesParent.ServiceContractsProto).apppageplatform.badges.badges_see_all

	getSduiApiStore().fetchIfNeeded({
		responseType = if not FFlagSduiProtobufJsonDecode then nil else SduiResponseType.Protobuf,
		url = v15,
		surfaceKey = AppPage.BadgesSeeAll,
		configKey = v16,
		loadTimer = p1,
		apiProto = if not FFlagSduiUniversalPageEntry then badges_see_all.BadgesSeeAllResponse else badges_see_all.BadgesSeeAllV2Response,
		buildNextPageUrl = function(p2) -- line: 36
			-- upvalues: getBadgesSeeAllUrl (copy), s1 (copy)
			local v19 = p2 and (p2.pagination and p2.pagination.next_cursor)

			if v19 and v19 ~= "" then
				return getBadgesSeeAllUrl(s1, v19)
			end

			return nil
		end
	}, b1)

	return v15
end

return fetchBadgesSeeAllPageIfNeeded
