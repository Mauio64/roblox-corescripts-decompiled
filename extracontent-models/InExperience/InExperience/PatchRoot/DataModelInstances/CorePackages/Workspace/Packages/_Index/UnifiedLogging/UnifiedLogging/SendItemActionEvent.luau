local AppStorageService = game:GetService("AppStorageService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local parent = UnifiedLogging.Parent

local Cryo = require(parent.Cryo)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local ContentType = require(UnifiedLogging.ContentType)
local itemActionEvent = require(UnifiedLogging.itemActionEvent)
local userEntryUtils = require(UnifiedLogging.userEntryUtils)
require(UnifiedLogging.SduiAnalyticsTypes)
local calculateRowPositionFields = require(UnifiedLogging.calculateRowPositionFields)

local SharedFlags = require(parent.SharedFlags)

local function fn(p, p2: number, rowNumber: number, contentType: string, collectionPosition: number, collectionId, totalNumberOfItems: number, actionType: string, collectionComponentType: string?, itemComponentType: string?, positionInRow: number?, feedRowNumber: number?)
	if p then
		return {
			collectionComponentType = collectionComponentType,
			itemComponentType = itemComponentType,
			collectionId = collectionId,
			collectionPosition = collectionPosition,
			totalNumberOfItems = totalNumberOfItems,
			contentType = contentType,
			itemId = p.id,
			itemPosition = p2,
			positionInRow = positionInRow,
			rowNumber = rowNumber,
			feedRowNumber = feedRowNumber,
			positionInTopic = p2,
			actionType = actionType
		}
	end

	DiscoveryEventErrorLogger.reportError(
		"SendItemActionEventNilEntry",
		`Entry at index {p2} was nil when sending item action event for collection {collectionId}`,
		{ entryIndex = p2, collectionId = collectionId }
	)

	return {}
end

local function fn2(p, sourceCarousel: string) -- 1 equivalent call inferred from this helper
	local fieldsFromUserEntry = userEntryUtils.extractFieldsFromUserEntry(p)

	return {
		sourceCarousel = sourceCarousel,
		presence = fieldsFromUserEntry.presence,
		friendStatus = fieldsFromUserEntry.friendStatus,
		presenceUniverseId = fieldsFromUserEntry.presenceUniverseId
	}
end

local SendItemActionEvent = {}
SendItemActionEvent.sendFromItemCollection = SharedFlags.FFlagEnableTopSongsSort
	and function(eventIngest, appAnalytics, p, p2: number, p3: number, p4, p5: number, p6: string, p7: number, p8: string, p9: string)
		if eventIngest and appAnalytics then
			itemActionEvent(eventIngest, p4, p8, fn(p, p3, p2, p8, p5, p6, p7, p9))
		else
			DiscoveryEventErrorLogger.reportError(
				"SendItemActionEventNilServiceItemCollection",
				"Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection",
				{ eventIngest = eventIngest, appAnalytics = appAnalytics }
			)
		end
	end
	or nil

function SendItemActionEvent.sendFromFriendsCarousel(eventIngest, appAnalytics, p, p2: number, p3, p4: number, sortId, p5: number, sourceCarousel: string, p6: string)
	if not (eventIngest and appAnalytics) then
		DiscoveryEventErrorLogger.reportError(
			"SendItemActionEventNilService",
			`Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection {sortId}`,
			{ eventIngest = eventIngest, appAnalytics = appAnalytics, sortId = sortId }
		)

		return
	end

	local user = ContentType.User

	local v = fn(p, p2, 1, user, p4, sortId, p5, p6)
	local v2 = fn2(p, sourceCarousel) -- inferred equivalent call
	itemActionEvent(eventIngest, p3, user, (Cryo.Dictionary.union(v, v2)))
end

function SendItemActionEvent.sendFromServerDrivenUi(eventIngest, p, p2: number, p3, p4: string, collectionId, contentType: string, p5: number, collectionPosition: number, totalNumberOfItems: number, _: number?, actionType: string, options, p6: number?)
	if not eventIngest then
		DiscoveryEventErrorLogger.reportError(
			"SendItemActionEventFromSduiNilService",
			`Event Ingest was nil when trying to send an itemActionEvent for collection {collectionId}`,
			{ eventIngest = eventIngest, collectionId = collectionId }
		)

		return
	end

	local v = calculateRowPositionFields(p2, p5, p6)

	local v2 = fn(
		p,
		p2,
		v.rowInSort,
		contentType,
		collectionPosition,
		collectionId,
		totalNumberOfItems,
		actionType,
		p3.collectionComponentType,
		p.itemComponentType,
		v.positionInRow,
		v.rowOnPage
	)

	local joined = Cryo.Dictionary.join(p3, p, options or {}, v2)

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

	itemActionEvent(eventIngest, p4, contentType, joined)
end

return SendItemActionEvent
