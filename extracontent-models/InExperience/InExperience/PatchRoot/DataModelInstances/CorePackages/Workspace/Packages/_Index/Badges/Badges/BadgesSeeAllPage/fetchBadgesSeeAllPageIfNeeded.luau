local Badges = script:FindFirstAncestor("Badges")
local parent = Badges.Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getBadgesSeeAllUrl = require(Badges.BadgesSeeAllPage.getBadgesSeeAllUrl)
local getBadgesSeeAllPageKey = require(Badges.BadgesSeeAllPage.getBadgesSeeAllPageKey)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiExtendedCapabilitiesDiscovery = SharedFlags.FFlagSduiExtendedCapabilitiesDiscovery

local function fetchBadgesSeeAllPageIfNeeded(p: string, loadTimer, flag: boolean?)
	if FFlagSduiExtendedCapabilitiesDiscovery then
		local badgesSeeAllPageKey = getBadgesSeeAllPageKey(p)

		local ServiceContractsProto = require(parent.ServiceContractsProto)
		local badges_see_all = ServiceContractsProto.apppageplatform.badges.badges_see_all
		local getBadgesSeeAllPostUrl = require(Badges.BadgesSeeAllPage.getBadgesSeeAllPostUrl)
		local BadgesSeeAllPageConstants = require(Badges.BadgesSeeAllPage.BadgesSeeAllPageConstants)
		local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
		local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
		local badgesSeeAllPostUrl = getBadgesSeeAllPostUrl()
		local pageEntryFormat = ServiceContractsProto.apppageplatform.shared.page_entry_content.PageEntryFormat

		local function buildBody(cursor: string?)
			local new = badges_see_all.BadgesSeeAllRequest.new
			local v = {
				universe_id = tonumber(p),
				cursor = 0,
				page_size = 0,
				page_entry_format = 0,
				client_capabilities = 0
			}

			if not cursor or cursor == "" then
				cursor = nil
			end

			v.cursor = cursor
			v.page_size = BadgesSeeAllPageConstants.RequestPageSize
			v.page_entry_format = pageEntryFormat.toNumber("PAGE_ENTRY_FORMAT_UNIVERSAL")
			v.client_capabilities = sduiCapabilities.buildClientCapabilities()
			return (new(v))
		end

		local function nextCursor(p2) -- 2 equivalent calls inferred from this helper
			local next_cursor = p2 and p2.pagination and p2.pagination.next_cursor

			if next_cursor and next_cursor ~= "" then
				return next_cursor
			end

			return nil
		end

		getSduiApiStore().fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = badgesSeeAllPostUrl,
			surfaceKey = AppPage.BadgesSeeAll,
			configKey = badgesSeeAllPageKey,
			loadTimer = loadTimer,
			apiProto = badges_see_all.BadgesSeeAllV2Response,
			postConfig = {
				contentType = sduiApiStorePostConfigContentType.Proto,
				protoMessage = badges_see_all.BadgesSeeAllRequest,
				body = buildBody(nil)
			},
			buildNextPageUrl = function(p2)
				if nextCursor(p2) then -- inferred equivalent call
					return badgesSeeAllPostUrl
				end

				return nil
			end,
			buildNextPagePostBody = function(p2)
				local next_cursor = nextCursor(p2) -- inferred equivalent call

				if next_cursor then
					return buildBody(next_cursor)
				end

				return nil
			end
		}, flag)

		return badgesSeeAllPostUrl
	else
		local badgesSeeAllUrl = getBadgesSeeAllUrl(p)
		local badgesSeeAllPageKey = getBadgesSeeAllPageKey(p)

		local ServiceContractsProto = require(parent.ServiceContractsProto)
		local badges_see_all = ServiceContractsProto.apppageplatform.badges.badges_see_all

		getSduiApiStore().fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = badgesSeeAllUrl,
			surfaceKey = AppPage.BadgesSeeAll,
			configKey = badgesSeeAllPageKey,
			loadTimer = loadTimer,
			apiProto = badges_see_all.BadgesSeeAllV2Response,
			buildNextPageUrl = function(p2)
				local next_cursor = p2 and p2.pagination and p2.pagination.next_cursor

				if next_cursor and next_cursor ~= "" then
					return getBadgesSeeAllUrl(p, next_cursor)
				end

				return nil
			end
		}, flag)

		return badgesSeeAllUrl
	end
end

return fetchBadgesSeeAllPageIfNeeded
