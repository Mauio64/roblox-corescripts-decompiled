local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgesSeeAllUrl = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgesSeeAllUrl")
local getBadgesSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgesSeeAllPageKey")
local fFlagSduiExtendedCapabilitiesDiscovery = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SharedFlags").FFlagSduiExtendedCapabilitiesDiscovery

local function fetchBadgesSeeAllPageIfNeeded(p2, p3, p4)
	if fFlagSduiExtendedCapabilitiesDiscovery then
		local v5 = getBadgesSeeAllPageKey(p2)

		local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/ServiceContractsProto")
		local badges_see_all = ServiceContractsProto.apppageplatform.badges.badges_see_all
		local getBadgesSeeAllPostUrl = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgesSeeAllPostUrl")
		local BadgesSeeAllPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/BadgesSeeAllPageConstants")
		local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
		local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
		local v6 = getBadgesSeeAllPostUrl()
		local pageEntryFormat = ServiceContractsProto.apppageplatform.shared.page_entry_content.PageEntryFormat

		local function buildBody(cursor)
			local new = badges_see_all.BadgesSeeAllRequest.new
			local v7 = {
				universe_id = tonumber(p2),
				cursor = 0,
				page_size = 0,
				page_entry_format = 0,
				client_capabilities = 0
			}

			if not cursor or cursor == "" then
				cursor = nil
			end

			v7.cursor = cursor
			v7.page_size = BadgesSeeAllPageConstants.RequestPageSize
			v7.page_entry_format = pageEntryFormat.toNumber("PAGE_ENTRY_FORMAT_UNIVERSAL")
			v7.client_capabilities = sduiCapabilities.buildClientCapabilities()
			return (new(v7))
		end

		local function nextCursor(p5)
			local next_cursor = p5 and p5.pagination and p5.pagination.next_cursor

			if next_cursor and next_cursor ~= "" then
				return next_cursor
			end

			return nil
		end

		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.Protobuf,
			url = v6,
			surfaceKey = appPage.BadgesSeeAll,
			configKey = v5,
			loadTimer = p3,
			apiProto = badges_see_all.BadgesSeeAllV2Response,
			postConfig = {
				contentType = sduiApiStorePostConfigContentType.Proto,
				protoMessage = badges_see_all.BadgesSeeAllRequest,
				body = buildBody(nil)
			},
			buildNextPageUrl = function(p5)
				local next_cursor = p5 and p5.pagination and p5.pagination.next_cursor

				if not next_cursor or next_cursor == "" then
					next_cursor = nil
				end

				if next_cursor then
					return v6
				end

				return nil
			end,
			buildNextPagePostBody = function(p5)
				local next_cursor = p5 and p5.pagination and p5.pagination.next_cursor

				if not next_cursor or next_cursor == "" then
					next_cursor = nil
				end

				if next_cursor then
					return buildBody(next_cursor)
				end

				return nil
			end
		}, p4)

		return v6
	else
		local v5 = getBadgesSeeAllUrl(p2)
		local v6 = getBadgesSeeAllPageKey(p2)

		local badges_see_all = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/ServiceContractsProto").apppageplatform.badges.badges_see_all

		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.Protobuf,
			url = v5,
			surfaceKey = appPage.BadgesSeeAll,
			configKey = v6,
			loadTimer = p3,
			apiProto = badges_see_all.BadgesSeeAllV2Response,
			buildNextPageUrl = function(p5)
				local next_cursor = p5 and p5.pagination and p5.pagination.next_cursor

				if next_cursor and next_cursor ~= "" then
					return getBadgesSeeAllUrl(p2, next_cursor)
				end

				return nil
			end
		}, p4)

		return v5
	end
end

return fetchBadgesSeeAllPageIfNeeded
