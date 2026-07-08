local AppStorageService = game:GetService("AppStorageService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local UnifiedLoggingParent = UnifiedLogging.Parent
local Cryo = require(UnifiedLoggingParent.Cryo)
local DiscoveryEventErrorLogger = require(UnifiedLoggingParent.DiscoveryUtils).DiscoveryEventErrorLogger
local ContentType = require(UnifiedLogging.ContentType)
local itemActionEvent = require(UnifiedLogging.itemActionEvent)
local userEntryUtils = require(UnifiedLogging.userEntryUtils)

require(UnifiedLogging.SduiAnalyticsTypes)

local calculateRowPositionFields = require(UnifiedLogging.calculateRowPositionFields)

local function v10(p1, n1: number, n2: number, s1: string, n3: number, p2, n4: number, s2: string, s3: string?, s4: string?, n5: number?, n6: number?) -- line: 19
	-- upvalues: DiscoveryEventErrorLogger (copy)
	if not p1 then
		DiscoveryEventErrorLogger.reportError("SendItemActionEventNilEntry", `Entry at index { n1 } was nil when sending item action event for collection { p2 }`, {
			entryIndex = n1,
			collectionId = p2
		})

		return {}
	end

	return {
		collectionComponentType = s3,
		itemComponentType = s4,
		collectionId = p2,
		collectionPosition = n3,
		totalNumberOfItems = n4,
		contentType = s1,
		itemId = p1.id,
		itemPosition = n1,
		positionInRow = n5,
		rowNumber = n2,
		feedRowNumber = n6,
		positionInTopic = n1,
		actionType = s2
	}
end

return {
	sendFromItemCollection = if not require(UnifiedLoggingParent.SharedFlags).FFlagEnableTopSongsSort then nil else function(p3, p4, p5, n7: number, n8: number, p6, n9: number, s5: string, n10: number, s6: string, s7: string) -- line: 186
		-- upvalues: DiscoveryEventErrorLogger (copy), v10 (copy), itemActionEvent (copy)
		if not p3 or not p4 then
			DiscoveryEventErrorLogger.reportError("SendItemActionEventNilServiceItemCollection", "Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection", {
				eventIngest = p3,
				appAnalytics = p4
			})

			return
		end

		local v70 = v10(p5, n8, n7, s6, n9, s5, n10, s7)

		itemActionEvent(p3, p6, s6, v70)
	end,
	sendFromFriendsCarousel = function(p7, p8, p9, n11: number, p10, n12: number, p11, n13: number, s8: string, s9: string) -- line: 73
		-- upvalues: DiscoveryEventErrorLogger (copy), ContentType (copy), v10 (copy), userEntryUtils (copy), Cryo (copy), itemActionEvent (copy)
		if not p7 or not p8 then
			DiscoveryEventErrorLogger.reportError("SendItemActionEventNilService", `Event Ingest or App Analytics was nil when trying to send an itemActionEvent for collection { p11 }`, {
				eventIngest = p7,
				appAnalytics = p8,
				sortId = p11
			})

			return
		end

		local User = ContentType.User
		local v37 = v10(p9, n11, 1, User, n12, p11, n13, s9)
		local v38 = userEntryUtils.extractFieldsFromUserEntry(p9)
		local t1 = {
			sourceCarousel = s8,
			presence = v38.presence,
			friendStatus = v38.friendStatus,
			presenceUniverseId = v38.presenceUniverseId
		}
		local v40 = Cryo.Dictionary.union(v37, t1)

		itemActionEvent(p7, p10, User, v40)
	end,
	sendFromServerDrivenUi = function(p12, p13, n14: number, p14, s10: string, p15, s11: string, n15: number, n16: number, n17: number, _: number?, s12: string, t2: {[any]: any}?, n19: number?) -- line: 119
		-- upvalues: DiscoveryEventErrorLogger (copy), calculateRowPositionFields (copy), v10 (copy), Cryo (copy), AppStorageService (copy), itemActionEvent (copy)
		if not p12 then
			DiscoveryEventErrorLogger.reportError("SendItemActionEventFromSduiNilService", `Event Ingest was nil when trying to send an itemActionEvent for collection { p15 }`, {
				eventIngest = p12,
				collectionId = p15
			})

			return
		end

		local v55 = calculateRowPositionFields(n14, n15, n19)
		local v56 = v10(p13, n14, v55.rowInSort, s11, n16, p15, n17, s12, p14.collectionComponentType, p13.itemComponentType, v55.positionInRow, v55.rowOnPage)
		local v57 = Cryo.Dictionary.join(p14, p13, t2 or {}, v56)
		local Item = AppStorageService:GetItem("MobileAdvertisingId")

		if Item and Item ~= "" then
			v57.mobileAdvertisingId = Item
		end

		if v57.collectionId and type(v57.collectionId) == "string" and type((tonumber(v57.collectionId))) ~= "number" then
			v57.collectionIdStr = v57.collectionId
			v57.collectionId = nil
		end

		itemActionEvent(p12, s10, s11, v57)
	end
}
