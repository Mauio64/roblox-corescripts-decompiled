local AppStorageService = game:GetService("AppStorageService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local UnifiedLoggingParent = UnifiedLogging.Parent
local ArgCheck = require(UnifiedLoggingParent.ArgCheck)
local Cryo = require(UnifiedLoggingParent.Cryo)
local DiscoveryEventErrorLogger = require(UnifiedLoggingParent.DiscoveryUtils).DiscoveryEventErrorLogger
local ContentType = require(UnifiedLogging.ContentType)
local itemImpressionsEvent = require(UnifiedLogging.itemImpressionsEvent)
local sduiCustomImpressionsEvent = require(UnifiedLogging.sduiCustomImpressionsEvent)
local userEntryUtils = require(UnifiedLogging.userEntryUtils)
local buildItemMetadataFields = require(UnifiedLogging.buildItemMetadataFields)
local buildGameMetadataFields = require(UnifiedLogging.buildGameMetadataFields)

require(UnifiedLogging.SduiAnalyticsTypes)

local FFlagLuaAppDesktopFriendCarouselClicks = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppDesktopFriendCarouselClicks
local FFlagProfilePlatformEnableImpressions = require(UnifiedLoggingParent.SharedFlags).FFlagProfilePlatformEnableImpressions
local FFlagItemImpressionsAddGameMetadata = require(UnifiedLoggingParent.SharedFlags).FFlagItemImpressionsAddGameMetadata
local FFlagEnableTopSongsSort = require(UnifiedLoggingParent.SharedFlags).FFlagEnableTopSongsSort

local function v17(p1, p2, s1: string, n1: number, n2: number, p3, n3: number?, s2: string?, s3: string?, n4: number?) -- line: 25
	-- upvalues: ArgCheck (copy), DiscoveryEventErrorLogger (copy), FFlagProfilePlatformEnableImpressions (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}

	for _, v36 in p1 do
		local v37 = p2 and p2[v36] or nil

		if v37 ~= nil then
			table.insert(t1, v37.id)
			table.insert(t2, v36)
			table.insert(t4, v36)

			local v38, v39

			if n1 and n1 > 0 then
				v38 = math.ceil(v36 / n1)
				v39 = v36 % n1

				if v39 == 0 then
					v39 = n1
				end

				table.insert(t3, v38)
			else
				ArgCheck.assert(n1 ~= 0)
				v38 = 1
				v39 = v36
			end

			if n4 then
				table.insert(t5, n4 + v38 - 1)
				table.insert(t6, v39)
			end
		else
			DiscoveryEventErrorLogger.reportError("SendItemImpressionsEventNilEntry", `Entry at index { v36 } was nil when sending item impressions for collection { p3 }`, {
				entryIndex = v36,
				collectionId = p3
			})
		end
	end

	local v40 = #t1

	ArgCheck.assert(v40 == #t2)

	if #t3 > 0 then
		ArgCheck.assert(v40 == #t3)
	end

	if #t5 > 0 then
		ArgCheck.assert(v40 == #t5)
	end

	if #t6 > 0 then
		ArgCheck.assert(v40 == #t6)
	end

	local t7 = {
		contentType = s1,
		itemIds = table.concat(t1, ","),
		itemPositions = table.concat(t2, ","),
		positionsInTopic = table.concat(t4, ","),
		collectionPosition = n2,
		collectionId = p3,
		totalNumberOfItems = if not n3 then not p2 and 0 or #p2 else n3,
		collectionComponentType = s2,
		collectionIdStr = if not FFlagProfilePlatformEnableImpressions then nil else s3
	}

	if #t3 > 0 then
		t7.rowNumbers = table.concat(t3, ",")
	end

	if #t5 > 0 then
		t7.feedRowNumbers = table.concat(t5, ",")
	end

	if #t6 > 0 then
		t7.positionsInRow = table.concat(t6, ",")
	end

	return t7
end
local function v18(p4, p5, s4: string) -- line: 125
	-- upvalues: FFlagLuaAppDesktopFriendCarouselClicks (copy), userEntryUtils (copy)
	local t8 = {}
	local t9 = {}
	local t10 = {}

	for _, v49 in p4 do
		local v50 = p5 and p5[v49] or nil

		if v50 ~= nil then
			if FFlagLuaAppDesktopFriendCarouselClicks then
				local v51 = userEntryUtils.extractFieldsFromUserEntry(v50)

				table.insert(t8, v51.presence)
				table.insert(t9, v51.friendStatus)
				table.insert(t10, v51.presenceUniverseId)
			else
				table.insert(t8, v50.presence and v50.presence.userPresenceType or "")
				table.insert(t9, not v50.isFriend and "notFriend" or "friend")
				table.insert(t10, (not v50.presence or (not v50.presence.universeId or v50.presence.universeId == "")) and "-1" or v50.presence.universeId)
			end
		end
	end

	return {
		sourceCarousel = s4,
		presences = table.concat(t8, ","),
		friendStatuses = table.concat(t9, ","),
		presenceUniverseIds = table.concat(t10, ",")
	}
end

return {
	sendFromFriendsCarousel = function(p6, p7, p8, p9, p10, n5: number, p11, s5: string) -- line: 166
		-- upvalues: FFlagLuaAppDesktopFriendCarouselClicks (copy), DiscoveryEventErrorLogger (copy), ContentType (copy), v17 (copy), v18 (copy), Cryo (copy), itemImpressionsEvent (copy)
		if not p6 or not p7 then
			if FFlagLuaAppDesktopFriendCarouselClicks then
				DiscoveryEventErrorLogger.reportError("SendItemImpressionsService", `Event Ingest or App Analytics was nil when trying to send itemImpressions for collection { p11 }`, {
					eventIngest = p6,
					appAnalytics = p7,
					sortId = p11
				})
			end

			return
		end

		if not p8 or #p8 == 0 then
			return
		end

		if not p9 or #p9 == 0 then
			return
		end

		local v60 = #p9
		local User = ContentType.User
		local v62 = v17(p8, p9, User, v60, n5, p11)
		local v63 = v18(p8, p9, s5)
		local v64 = Cryo.Dictionary.union(v62, v63)

		itemImpressionsEvent(p6, p10, User, v64)
	end,
	sendFromItemCollection = if not FFlagEnableTopSongsSort then nil else function(p12, p13, p14, t11: {[any]: any}, n6: number, p15, n7: number, s6: string, n8: number, n9: number?, s7: string?) -- line: 346
		-- upvalues: DiscoveryEventErrorLogger (copy), v17 (copy), FFlagItemImpressionsAddGameMetadata (copy), ContentType (copy), buildGameMetadataFields (copy), Cryo (copy), itemImpressionsEvent (copy)
		if not p12 or not p13 then
			DiscoveryEventErrorLogger.reportError("SendItemImpressionsService", `Event Ingest or App Analytics was nil when trying to send itemImpressions for collection { n9 }`, {
				eventIngest = p12,
				appAnalytics = p13,
				sortId = n9
			})

			return
		end

		if not p14 or #p14 == 0 then
			return
		end

		if not t11 or #t11 == 0 then
			return
		end

		local v102 = v17(p14, t11, s6, n6, n7, n9, n8, nil, s7)

		if FFlagItemImpressionsAddGameMetadata then
			if s6 == ContentType.Game then
				local v103 = buildGameMetadataFields(p14, t11, s7)

				v102 = Cryo.Dictionary.union(v102, v103)
			end

			itemImpressionsEvent(p12, p15, s6, v102)

			return
		end

		itemImpressionsEvent(p12, p15, s6, v102)
	end,
	sendFromProfile = if not FFlagProfilePlatformEnableImpressions then nil else if not FFlagProfilePlatformEnableImpressions then nil else function(p16, p17, t12: {[any]: any}, t13: {[any]: any}, n10: number, s8: string, s9: string, n11: number, s10: string) -- line: 214
		-- upvalues: DiscoveryEventErrorLogger (copy), v17 (copy), FFlagItemImpressionsAddGameMetadata (copy), ContentType (copy), buildGameMetadataFields (copy), Cryo (copy), itemImpressionsEvent (copy)
		if not p16 or not p17 then
			DiscoveryEventErrorLogger.reportError("SendItemImpressionsFromProfile", `Event Ingest or App Analytics was nil when trying to send itemImpressions for collection { s10 } on Profile Platform`, {
				eventIngest = p16,
				appAnalytics = p17,
				collectionIdStr = s10
			})

			return
		end

		if not t12 or #t12 == 0 then
			return
		end

		if not t13 or #t13 == 0 then
			return
		end

		local v74 = v17(t12, t13, s9, n10, n11, nil, #t13, nil, s10)

		if FFlagItemImpressionsAddGameMetadata then
			if s9 == ContentType.Game then
				local v75 = buildGameMetadataFields(t12, t13, s10)

				v74 = Cryo.Dictionary.union(v74, v75)
			end

			itemImpressionsEvent(p16, s8, s9, v74)

			return
		end

		itemImpressionsEvent(p16, s8, s9, v74)
	end,
	sendFromServerDrivenUi = function(p18, t14: {[any]: any}, t15: {[any]: any}, p19, s11: string, p20, s12: string, n12: number, n13: number, n14: number?, s13: string?) -- line: 273
		-- upvalues: DiscoveryEventErrorLogger (copy), v17 (copy), buildItemMetadataFields (copy), Cryo (copy), AppStorageService (copy), sduiCustomImpressionsEvent (copy), itemImpressionsEvent (copy)
		if not p18 then
			DiscoveryEventErrorLogger.reportError("SendItemImpressionsFromSduiNilService", `Event Ingest was nil when trying to send itemImpressions for collection { p20 }`, {
				collectionId = p20
			})

			return
		end

		if not t14 or #t14 == 0 then
			return
		end

		if not t15 or #t15 == 0 then
			return
		end

		if not p19 then
			return
		end

		local v87 = v17(t14, t15, s12, n12, n13, p20, p19.totalNumberOfItems, p19.collectionComponentType, nil, n14)
		local v88 = buildItemMetadataFields(t14, t15, p20)
		local v89 = Cryo.Dictionary.join(p19, v88, v87)
		local Item = AppStorageService:GetItem("MobileAdvertisingId")

		if Item and Item ~= "" then
			v89.mobileAdvertisingId = Item
		end

		if v89.collectionId and type(v89.collectionId) == "string" and type((tonumber(v89.collectionId))) ~= "number" then
			v89.collectionIdStr = v89.collectionId
			v89.collectionId = nil
		end

		if s13 then
			sduiCustomImpressionsEvent(s13, s11, v89)

			return
		end

		itemImpressionsEvent(p18, s11, s12, v89)
	end
}
