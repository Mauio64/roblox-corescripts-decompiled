local Players = game:GetService("Players")
local Badges = script:FindFirstAncestor("Badges")
local parent = Badges.Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgeDetailsUrl = require(Badges.BadgesSeeAllPage.getBadgeDetailsUrl)
local getBadgeDetailsPageKey = require(script.Parent.getBadgeDetailsPageKey)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiExtendedCapabilitiesDiscovery = SharedFlags.FFlagSduiExtendedCapabilitiesDiscovery

local function getLocalPlayerUserId() -- 1 equivalent call inferred from this helper
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

local function fetchBadgeDetailsPage(p: string, loadTimer)
	local localPlayerUserId = getLocalPlayerUserId() -- inferred equivalent call

	if FFlagSduiExtendedCapabilitiesDiscovery then
		local ServiceContractsProto = require(parent.ServiceContractsProto)
		local badge_details_page = ServiceContractsProto.apppageplatform.badges.badge_details_page
		local getBadgeDetailsPostUrl = require(Badges.BadgesSeeAllPage.getBadgeDetailsPostUrl)
		local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
		local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
		local badgeDetailsPostUrl = getBadgeDetailsPostUrl()
		local pageEntryFormat = ServiceContractsProto.apppageplatform.shared.page_entry_content.PageEntryFormat
		local new = badge_details_page.BadgeDetailsPageRequest.new
		local v = {
			badge_id = tonumber(p),
			user_id = 0,
			page_entry_format = 0,
			client_capabilities = 0
		}
		local user_id

		if localPlayerUserId then
			user_id = tonumber(localPlayerUserId)
		end

		v.user_id = user_id
		v.page_entry_format = pageEntryFormat.toNumber("PAGE_ENTRY_FORMAT_UNIVERSAL")
		v.client_capabilities = sduiCapabilities.buildClientCapabilities()
		local body = new(v)

		getSduiApiStore().fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = badgeDetailsPostUrl,
			surfaceKey = AppPage.BadgeDetails,
			configKey = getBadgeDetailsPageKey(p),
			loadTimer = loadTimer,
			apiProto = badge_details_page.BadgeDetailsPageV2Response,
			postConfig = {
				contentType = sduiApiStorePostConfigContentType.Proto,
				protoMessage = badge_details_page.BadgeDetailsPageRequest,
				body = body
			}
		})
	else
		local badgeDetailsUrl = getBadgeDetailsUrl(p, localPlayerUserId)

		local ServiceContractsProto = require(parent.ServiceContractsProto)
		local badge_details_page = ServiceContractsProto.apppageplatform.badges.badge_details_page

		getSduiApiStore().fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = badgeDetailsUrl,
			surfaceKey = AppPage.BadgeDetails,
			configKey = getBadgeDetailsPageKey(p),
			loadTimer = loadTimer,
			apiProto = badge_details_page.BadgeDetailsPageV2Response
		})
	end
end

return fetchBadgeDetailsPage
