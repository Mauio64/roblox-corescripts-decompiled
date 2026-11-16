local AppStorageService = game:GetService("AppStorageService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local parent = UnifiedLogging.Parent

local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local ContentType = require(UnifiedLogging.ContentType)
local itemImpressionsEvent = require(UnifiedLogging.itemImpressionsEvent)
local sduiCustomImpressionsEvent = require(UnifiedLogging.sduiCustomImpressionsEvent)
local userEntryUtils = require(UnifiedLogging.userEntryUtils)
local buildItemMetadataFields = require(UnifiedLogging.buildItemMetadataFields)
local buildGameMetadataFields = require(UnifiedLogging.buildGameMetadataFields)
require(UnifiedLogging.SduiAnalyticsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDesktopFriendCarouselClicks = SharedFlags.FFlagLuaAppDesktopFriendCarouselClicks
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags2.FFlagProfilePlatformEnableImpressions
local SharedFlags3 = require(parent.SharedFlags)
local FFlagItemImpressionsAddGameMetadata = SharedFlags3.FFlagItemImpressionsAddGameMetadata
local SharedFlags4 = require(parent.SharedFlags)

local function fn(items, list, contentType: string, p: number, collectionPosition: number, collectionId, p2: number?, collectionComponentType: string?, collectionIdStr: string?, p3: number?)
	local ids = {}
	local v = {}

	local v2 = {}
	local v3 = {}

	local v4 = {}
	local v5 = {}

	for _, item in items do
		local v6

		if list then
			v6 = list[item] or nil
		end

		if v6 == nil then
			DiscoveryEventErrorLogger.reportError(
				"SendItemImpressionsEventNilEntry",
				`Entry at index {item} was nil when sending item impressions for collection {collectionId}`,
				{ entryIndex = item, collectionId = collectionId }
			)
		else
			table.insert(ids, v6.id)
			table.insert(v, item)
			table.insert(v2, item)
			local v7

			if p and p > 0 then
				v7 = math.ceil(item / p)
				item %= p

				if item == 0 then
					item = p
				end

				table.insert(v3, v7)
			else
				ArgCheck.assert(p ~= 0)
				v7 = 1
			end

			if p3 then
				table.insert(v4, p3 + v7 - 1)
				table.insert(v5, item)
			end
		end
	end

	local count = #ids
	ArgCheck.assert(count == #v)

	if #v3 > 0 then
		ArgCheck.assert(count == #v3)
	end

	if #v4 > 0 then
		ArgCheck.assert(count == #v4)
	end

	if #v5 > 0 then
		ArgCheck.assert(count == #v5)
	end

	local v6 = {
		contentType = contentType,
		itemIds = table.concat(ids, ","),
		itemPositions = table.concat(v, ","),
		positionsInTopic = table.concat(v2, ","),
		collectionPosition = collectionPosition,
		collectionId = collectionId,
		totalNumberOfItems = p2 or list and #list or 0,
		collectionComponentType = collectionComponentType,
		collectionIdStr = 0
	}

	if not FFlagProfilePlatformEnableImpressions then
		collectionIdStr = nil
	end

	v6.collectionIdStr = collectionIdStr

	if #v3 > 0 then
		v6.rowNumbers = table.concat(v3, ",")
	end

	if #v4 > 0 then
		v6.feedRowNumbers = table.concat(v4, ",")
	end

	if #v5 > 0 then
		v6.positionsInRow = table.concat(v5, ",")
	end

	return v6
end

local function fn2(items, list, sourceCarousel: string)
	local v = {}
	local v2 = {}
	local v3 = {}

	for _, item in items do
		local v4

		if list then
			v4 = list[item] or nil
		end

		if v4 == nil then
			continue
		end

		if FFlagLuaAppDesktopFriendCarouselClicks then
			local fieldsFromUserEntry = userEntryUtils.extractFieldsFromUserEntry(v4)

			table.insert(v, fieldsFromUserEntry.presence)
			table.insert(v2, fieldsFromUserEntry.friendStatus)
			table.insert(v3, fieldsFromUserEntry.presenceUniverseId)
		else
			table.insert(v, v4.presence and v4.presence.userPresenceType or "")

			table.insert(v2, v4.isFriend and "friend" or "notFriend")

			table.insert(
				v3,
				(not v4.presence or not v4.presence.universeId or v4.presence.universeId == "") and "-1" or v4.presence.universeId
			)
		end
	end

	return {
		sourceCarousel = sourceCarousel,
		presences = table.concat(v, ","),
		friendStatuses = table.concat(v2, ","),
		presenceUniverseIds = table.concat(v3, ",")
	}
end

local SendItemImpressions = {
	sendFromFriendsCarousel = function(eventIngest, appAnalytics, list, list2, p, p2: number, sortId, sourceCarousel: string)
		if eventIngest and appAnalytics then
			if not list or #list == 0 or (not list2 or #list2 == 0) then
				return
			end

			local v = #list2
			local user = ContentType.User

			local v2 = fn(list, list2, user, v, p2, sortId)

			local v3 = fn2(list, list2, sourceCarousel)

			itemImpressionsEvent(eventIngest, p, user, (Cryo.Dictionary.union(v2, v3)))
		elseif FFlagLuaAppDesktopFriendCarouselClicks then
			DiscoveryEventErrorLogger.reportError(
				"SendItemImpressionsService",
				`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {sortId}`,
				{ eventIngest = eventIngest, appAnalytics = appAnalytics, sortId = sortId }
			)
		end
	end,
	sendFromItemCollection = SharedFlags4.FFlagEnableTopSongsSort and function(eventIngest, appAnalytics, list, list2, p: number, p2, p3: number, p4: string, p5: number, sortId: number?, p6: string?)
		if not (eventIngest and appAnalytics) then
			DiscoveryEventErrorLogger.reportError(
				"SendItemImpressionsService",
				`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {sortId}`,
				{ eventIngest = eventIngest, appAnalytics = appAnalytics, sortId = sortId }
			)

			return
		end

		if not list or #list == 0 or (not list2 or #list2 == 0) then
			return
		end

		local v = fn(list, list2, p4, p, p3, sortId, p5, nil, p6)

		if not FFlagItemImpressionsAddGameMetadata then
			itemImpressionsEvent(eventIngest, p2, p4, v)

			return
		end

		if p4 == ContentType.Game then
			local gameMetadataFields = buildGameMetadataFields(list, list2, p6)
			v = Cryo.Dictionary.union(v, gameMetadataFields)
		end

		itemImpressionsEvent(eventIngest, p2, p4, v)
	end or nil,
	sendFromProfile = 0,
	sendFromServerDrivenUi = 0
}
local sendFromProfile

if FFlagProfilePlatformEnableImpressions then
	sendFromProfile = FFlagProfilePlatformEnableImpressions
		and function(eventIngest, appAnalytics, list, list2, p: number, p2: string, p3: string, p4: number, collectionIdStr: string)
			if not (eventIngest and appAnalytics) then
				DiscoveryEventErrorLogger.reportError(
					"SendItemImpressionsFromProfile",
					`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {collectionIdStr} on Profile Platform`,
					{
						eventIngest = eventIngest,
						appAnalytics = appAnalytics,
						collectionIdStr = collectionIdStr
					}
				)

				return
			end

			if not list or #list == 0 or (not list2 or #list2 == 0) then
				return
			end

			local v = fn(list, list2, p3, p, p4, nil, #list2, nil, collectionIdStr)

			if not FFlagItemImpressionsAddGameMetadata then
				itemImpressionsEvent(eventIngest, p2, p3, v)

				return
			end

			if p3 == ContentType.Game then
				local gameMetadataFields = buildGameMetadataFields(list, list2, collectionIdStr)
				v = Cryo.Dictionary.union(v, gameMetadataFields)
			end

			itemImpressionsEvent(eventIngest, p2, p3, v)
		end
		or nil
end

SendItemImpressions.sendFromProfile = sendFromProfile

function SendItemImpressions.sendFromServerDrivenUi(p, list, list2, p2, p3: string, collectionId, contentType: string, p4: number, collectionPosition: number, p5: number?, p6: string?)
	if not p then
		DiscoveryEventErrorLogger.reportError(
			"SendItemImpressionsFromSduiNilService",
			`Event Ingest was nil when trying to send itemImpressions for collection {collectionId}`,
			{ collectionId = collectionId }
		)

		return
	end

	if not list or #list == 0 or (not list2 or #list2 == 0) then
		return
	end

	if not p2 then
		return
	end

	local v = fn(
		list,
		list2,
		contentType,
		p4,
		collectionPosition,
		collectionId,
		p2.totalNumberOfItems,
		p2.collectionComponentType,
		nil,
		p5
	)

	local itemMetadataFields = buildItemMetadataFields(list, list2, collectionId)

	local joined = Cryo.Dictionary.join(p2, itemMetadataFields, v)

	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		joined.mobileAdvertisingId = item
	end

	if
		joined.collectionId
		and type(joined.collectionId) == "string"
		and type((tonumber(joined.collectionId))) ~= "number"
	then
		joined.collectionIdStr = joined.collectionId
		joined.collectionId = nil
	end

	if p6 then
		sduiCustomImpressionsEvent(p6, p3, joined)
	else
		itemImpressionsEvent(p, p3, contentType, joined)
	end
end
return SendItemImpressions
