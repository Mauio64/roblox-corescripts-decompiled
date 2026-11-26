local AppStorageService = game:GetService("AppStorageService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Cryo")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local ContentType = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/ContentType")
local itemActionEvent = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/itemActionEvent")
local userEntryUtils = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/userEntryUtils")
require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/SduiAnalyticsTypes")
local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/calculateRowPositionFields")

local function fn(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	if p2 then
		return {
			collectionComponentType = p10,
			itemComponentType = p11,
			collectionId = p7,
			collectionPosition = p6,
			totalNumberOfItems = p8,
			contentType = p5,
			itemId = p2.id,
			itemPosition = p3,
			positionInRow = p12,
			rowNumber = p4,
			feedRowNumber = p13,
			positionInTopic = p3,
			actionType = p9
		}
	end

	discoveryEventErrorLogger.reportError(
		"SendItemActionEventNilEntry",
		`Entry at index {p3} was nil when sending item action event for collection {p7}`,
		{ entryIndex = p3, collectionId = p7 }
	)

	return {}
end

return {
	sendFromItemCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagEnableTopSongsSort and function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
		if p2 and p3 then
			itemActionEvent(p2, p7, p11, fn(p4, p6, p5, p11, p8, p9, p10, p12))
		else
			discoveryEventErrorLogger.reportError(
				"SendItemActionEventNilServiceItemCollection",
				"Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection",
				{ eventIngest = p2, appAnalytics = p3 }
			)
		end
	end or nil,
	sendFromFriendsCarousel = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
		if not (p2 and p3) then
			discoveryEventErrorLogger.reportError(
				"SendItemActionEventNilService",
				`Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection {p8}`,
				{ eventIngest = p2, appAnalytics = p3, sortId = p8 }
			)

			return
		end

		local user = ContentType.User

		local v5 = fn(p4, p5, 1, user, p7, p8, p9, p11)
		local fieldsFromUserEntry = userEntryUtils.extractFieldsFromUserEntry(p4)

		local v6 = {
			sourceCarousel = p10,
			presence = fieldsFromUserEntry.presence,
			friendStatus = fieldsFromUserEntry.friendStatus,
			presenceUniverseId = fieldsFromUserEntry.presenceUniverseId
		}

		itemActionEvent(p2, p6, user, (Cryo.Dictionary.union(v5, v6)))
	end,
	sendFromServerDrivenUi = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, options, p14)
		if not p2 then
			discoveryEventErrorLogger.reportError(
				"SendItemActionEventFromSduiNilService",
				`Event Ingest was nil when trying to send an itemActionEvent for collection {p7}`,
				{ eventIngest = p2, collectionId = p7 }
			)

			return
		end

		local v5 = calculateRowPositionFields(p4, p9, p14)

		local v6 = fn(
			p3,
			p4,
			v5.rowInSort,
			p8,
			p10,
			p7,
			p11,
			p13,
			p5.collectionComponentType,
			p3.itemComponentType,
			v5.positionInRow,
			v5.rowOnPage
		)

		local joined = Cryo.Dictionary.join(p5, p3, options or {}, v6)

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

		itemActionEvent(p2, p6, p8, joined)
	end
}
