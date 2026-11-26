local Players = game:GetService("Players")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgeDetailsUrl = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgeDetailsUrl")
local getBadgeDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgeDetailsPage/getBadgeDetailsPageKey")

local fFlagSduiExtendedCapabilitiesDiscovery = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SharedFlags").FFlagSduiExtendedCapabilitiesDiscovery

local function getLocalPlayerUserId()
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return nil
	end

	local userId = localPlayer.UserId

	if userId <= 0 then
		return nil
	end

	return (tostring(userId))
end

local function fetchBadgeDetailsPage(p2, p3)
	local localPlayer = Players.LocalPlayer
	local v5

	if localPlayer then
		local userId = localPlayer.UserId

		if not (userId <= 0) then
			v5 = tostring(userId)
		end
	end

	if fFlagSduiExtendedCapabilitiesDiscovery then
		local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/ServiceContractsProto")
		local badge_details_page = ServiceContractsProto.apppageplatform.badges.badge_details_page
		local getBadgeDetailsPostUrl = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgeDetailsPostUrl")
		local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
		local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
		local v6 = getBadgeDetailsPostUrl()
		local pageEntryFormat = ServiceContractsProto.apppageplatform.shared.page_entry_content.PageEntryFormat
		local new = badge_details_page.BadgeDetailsPageRequest.new
		local v7 = {
			badge_id = tonumber(p2),
			user_id = 0,
			page_entry_format = 0,
			client_capabilities = 0
		}
		local v8 = if v5 then tonumber(v5) else nil
		v7.user_id = v8
		v7.page_entry_format = pageEntryFormat.toNumber("PAGE_ENTRY_FORMAT_UNIVERSAL")
		v7.client_capabilities = sduiCapabilities.buildClientCapabilities()
		local v9 = new(v7)

		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.Protobuf,
			url = v6,
			surfaceKey = appPage.BadgeDetails,
			configKey = getBadgeDetailsPageKey(p2),
			loadTimer = p3,
			apiProto = badge_details_page.BadgeDetailsPageV2Response,
			postConfig = {
				contentType = sduiApiStorePostConfigContentType.Proto,
				protoMessage = badge_details_page.BadgeDetailsPageRequest,
				body = v9
			}
		})
	else
		local v6 = getBadgeDetailsUrl(p2, v5)

		local badge_details_page = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/ServiceContractsProto").apppageplatform.badges.badge_details_page

		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.Protobuf,
			url = v6,
			surfaceKey = appPage.BadgeDetails,
			configKey = getBadgeDetailsPageKey(p2),
			loadTimer = p3,
			apiProto = badge_details_page.BadgeDetailsPageV2Response
		})
	end
end

return fetchBadgeDetailsPage
