local AppStorageService = game:GetService("AppStorageService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Cryo")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local ContentType = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/ContentType")
local itemImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/itemImpressionsEvent")
local sduiCustomImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/sduiCustomImpressionsEvent")
local userEntryUtils = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/userEntryUtils")
local buildItemMetadataFields = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/buildItemMetadataFields")
local buildGameMetadataFields = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/buildGameMetadataFields")
require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/SduiAnalyticsTypes")

local fFlagLuaAppDesktopFriendCarouselClicks = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppDesktopFriendCarouselClicks
local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagProfilePlatformEnableImpressions
local fFlagItemImpressionsAddGameMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagItemImpressionsAddGameMetadata

local function fn(items, list, p2, p3, p4, p5, p6, p7, collectionIdStr, p8)
	local ids = {}
	local v5 = {}

	local v6 = {}
	local v7 = {}

	local v8 = {}
	local v9 = {}

	for k, item in items do
		local v10 = if list then list[item] or nil else nil

		if v10 == nil then
			discoveryEventErrorLogger.reportError(
				"SendItemImpressionsEventNilEntry",
				`Entry at index {item} was nil when sending item impressions for collection {p5}`,
				{ entryIndex = item, collectionId = p5 }
			)
		else
			table.insert(ids, v10.id)
			table.insert(v5, item)
			table.insert(v6, item)
			local v11

			if p3 and p3 > 0 then
				v11 = math.ceil(item / p3)
				item %= p3

				if item == 0 then
					item = p3
				end

				table.insert(v7, v11)
			else
				ArgCheck.assert(p3 ~= 0)
				v11 = 1
			end

			if p8 then
				table.insert(v8, p8 + v11 - 1)
				table.insert(v9, item)
			end
		end
	end

	local count = #ids
	ArgCheck.assert(count == #v5)

	if #v7 > 0 then
		ArgCheck.assert(count == #v7)
	end

	if #v8 > 0 then
		ArgCheck.assert(count == #v8)
	end

	if #v9 > 0 then
		ArgCheck.assert(count == #v9)
	end

	local v10 = {
		contentType = p2,
		itemIds = table.concat(ids, ","),
		itemPositions = table.concat(v5, ","),
		positionsInTopic = table.concat(v6, ","),
		collectionPosition = p4,
		collectionId = p5,
		totalNumberOfItems = p6 or list and #list or 0,
		collectionComponentType = p7,
		collectionIdStr = 0
	}

	if not fFlagProfilePlatformEnableImpressions then
		collectionIdStr = nil
	end

	v10.collectionIdStr = collectionIdStr

	if #v7 > 0 then
		v10.rowNumbers = table.concat(v7, ",")
	end

	if #v8 > 0 then
		v10.feedRowNumbers = table.concat(v8, ",")
	end

	if #v9 > 0 then
		v10.positionsInRow = table.concat(v9, ",")
	end

	return v10
end

local function fn2(items, list, p2)
	local v5 = {}
	local v6 = {}
	local v7 = {}

	for k, item in items do
		local v8 = if list then list[item] or nil else nil

		if v8 == nil then
			continue
		end

		if fFlagLuaAppDesktopFriendCarouselClicks then
			local fieldsFromUserEntry = userEntryUtils.extractFieldsFromUserEntry(v8)

			table.insert(v5, fieldsFromUserEntry.presence)
			table.insert(v6, fieldsFromUserEntry.friendStatus)
			table.insert(v7, fieldsFromUserEntry.presenceUniverseId)
		else
			table.insert(v5, v8.presence and v8.presence.userPresenceType or "")

			table.insert(v6, v8.isFriend and "friend" or "notFriend")

			table.insert(
				v7,
				(not v8.presence or not v8.presence.universeId or v8.presence.universeId == "") and "-1" or v8.presence.universeId
			)
		end
	end

	return {
		sourceCarousel = p2,
		presences = table.concat(v5, ","),
		friendStatuses = table.concat(v6, ","),
		presenceUniverseIds = table.concat(v7, ",")
	}
end

local v5 = {
	sendFromFriendsCarousel = function(p2, p3, list, list2, p4, p5, p6, p7)
		if p2 and p3 then
			if not list or #list == 0 or (not list2 or #list2 == 0) then
				return
			end

			local v6 = #list2
			local user = ContentType.User

			local v7 = fn(list, list2, user, v6, p5, p6)

			local v8 = fn2(list, list2, p7)

			itemImpressionsEvent(p2, p4, user, (Cryo.Dictionary.union(v7, v8)))
		elseif fFlagLuaAppDesktopFriendCarouselClicks then
			discoveryEventErrorLogger.reportError(
				"SendItemImpressionsService",
				`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {p6}`,
				{ eventIngest = p2, appAnalytics = p3, sortId = p6 }
			)
		end
	end,
	sendFromItemCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagEnableTopSongsSort and function(p2, p3, list, list2, p4, p5, p6, p7, p8, p9, p10)
		if not (p2 and p3) then
			discoveryEventErrorLogger.reportError(
				"SendItemImpressionsService",
				`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {p9}`,
				{ eventIngest = p2, appAnalytics = p3, sortId = p9 }
			)

			return
		end

		if not list or #list == 0 or (not list2 or #list2 == 0) then
			return
		end

		local v6 = fn(list, list2, p7, p4, p6, p9, p8, nil, p10)

		if not fFlagItemImpressionsAddGameMetadata then
			itemImpressionsEvent(p2, p5, p7, v6)

			return
		end

		if p7 == ContentType.Game then
			local v7 = buildGameMetadataFields(list, list2, p10)
			v6 = Cryo.Dictionary.union(v6, v7)
		end

		itemImpressionsEvent(p2, p5, p7, v6)
	end or nil,
	sendFromProfile = 0,
	sendFromServerDrivenUi = 0
}
local v6

if fFlagProfilePlatformEnableImpressions then
	v6 = fFlagProfilePlatformEnableImpressions and function(p2, p3, list, list2, p4, p5, p6, p7, p8)
		if not (p2 and p3) then
			discoveryEventErrorLogger.reportError(
				"SendItemImpressionsFromProfile",
				`Event Ingest or App Analytics was nil when trying to send itemImpressions for collection {p8} on Profile Platform`,
				{ eventIngest = p2, appAnalytics = p3, collectionIdStr = p8 }
			)

			return
		end

		if not list or #list == 0 or (not list2 or #list2 == 0) then
			return
		end

		local v7 = fn(list, list2, p6, p4, p7, nil, #list2, nil, p8)

		if not fFlagItemImpressionsAddGameMetadata then
			itemImpressionsEvent(p2, p5, p6, v7)

			return
		end

		if p6 == ContentType.Game then
			local v8 = buildGameMetadataFields(list, list2, p8)
			v7 = Cryo.Dictionary.union(v7, v8)
		end

		itemImpressionsEvent(p2, p5, p6, v7)
	end or nil
end

v5.sendFromProfile = v6

function v5.sendFromServerDrivenUi(p2, list, list2, p3, p4, p5, p6, p7, p8, p9, p10)
	if not p2 then
		discoveryEventErrorLogger.reportError(
			"SendItemImpressionsFromSduiNilService",
			`Event Ingest was nil when trying to send itemImpressions for collection {p5}`,
			{ collectionId = p5 }
		)

		return
	end

	if not list or #list == 0 or (not list2 or #list2 == 0) then
		return
	end

	if not p3 then
		return
	end

	local v5 = fn(list, list2, p6, p7, p8, p5, p3.totalNumberOfItems, p3.collectionComponentType, nil, p9)

	local v6 = buildItemMetadataFields(list, list2, p5)

	local joined = Cryo.Dictionary.join(p3, v6, v5)

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

	if p10 then
		sduiCustomImpressionsEvent(p10, p4, joined)
	else
		itemImpressionsEvent(p2, p4, p6, joined)
	end
end
return v5
