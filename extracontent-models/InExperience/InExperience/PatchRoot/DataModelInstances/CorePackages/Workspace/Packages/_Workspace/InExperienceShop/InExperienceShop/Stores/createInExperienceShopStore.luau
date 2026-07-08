local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local createSignal = require(InExperienceShopParent.Signals).createSignal
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local Errors = require(InExperienceShop.Api.Errors)
local fetchAllShopData = require(InExperienceShop.Api.fetchAllShopData)
local fetchShopWidgetsOnly = require(InExperienceShop.Api.fetchShopWidgetsOnly)
local multiGetProductInfo = require(InExperienceShop.Api.multiGetProductInfo)
local streamMultiGetProductInfo = require(InExperienceShop.Api.streamMultiGetProductInfo)
local logCounter = require(InExperienceShop.Internal.logCounter)
local ProductInfoFailedItemsCounter = require(InExperienceShop.Events.ProductInfoFailedItemsCounter)
local userOwnsGamePass = require(InExperienceShop.Api.userOwnsGamePass)
local FFlagShopUseMockData = require(InExperienceShop.Flags.FFlagShopUseMockData)
local FFlagShopUseMockUserOwnsGamePass = require(InExperienceShop.Flags.FFlagShopUseMockUserOwnsGamePass)
local FFlagShopUseMockMultiGetProductInfo = require(InExperienceShop.Flags.FFlagShopUseMockMultiGetProductInfo)
local FFlagEnableShopProductInfoRefresh = require(InExperienceShop.Flags.FFlagEnableShopProductInfoRefresh)
local FFlagEnablePartialDisplayInExperienceShop = require(InExperienceShop.Flags.FFlagEnablePartialDisplayInExperienceShop)

require(InExperienceShop.Flags.FFlagPromoteRobuxInTopPicks)

local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local FIntShopOwnershipFetchMaxAttempts = require(InExperienceShop.Flags.FIntShopOwnershipFetchMaxAttempts)
local MockFetchAllShopData = require(InExperienceShop.Mocks.MockFetchAllShopData)
local MockMultiGetProductInfo = require(InExperienceShop.Mocks.MockMultiGetProductInfo)
local MockUserOwnsGamePass = require(InExperienceShop.Mocks.MockUserOwnsGamePass)
local promoteBonusRobuxPackageToTopPicks = require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)
local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)
local sortRobuxPackagesByAmountDescending = require(InExperienceShop.Utils.sortRobuxPackagesByAmountDescending)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagInExperienceShopExpectStringMetadataValues = require(InExperienceShop.Flags.FFlagInExperienceShopExpectStringMetadataValues)

local function isValidShopData(p1) -- line: 108
	return type(p1) == "table" and (type(p1.categories) == "table" and type(p1.sections) == "table")
end
local function isPartialDisplayEnabled() -- line: 121
	-- upvalues: FFlagEnablePartialDisplayInExperienceShop (copy)
	local v36 = FFlagEnablePartialDisplayInExperienceShop

	if typeof(v36) == "function" then
		return (v36())
	end

	return v36
end
local function createInExperienceShopStore() -- line: 127
	-- upvalues: createSignal (copy), Constants (copy), sortRobuxPackagesByAmountDescending (copy), promoteBonusRobuxPackageToTopPicks (copy), FFlagEnableRobuxInExperienceShop (copy), BonusPromotionEligibility (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePass (copy), FFlagEnableExperienceShopGlobalIcon (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), InExperienceShop (copy), FFlagShopUseMockData (copy), FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), streamMultiGetProductInfo (copy), logCounter (copy), ProductInfoFailedItemsCounter (copy), Errors (copy), FFlagEnablePartialDisplayInExperienceShop (copy), fetchShopWidgetsOnly (copy), MockFetchAllShopData (copy), fetchAllShopData (copy), FFlagEnableShopProductInfoRefresh (copy), multiGetProductInfo (copy), Promise (copy), Players (copy), MarketplaceService (copy), FIntShopOwnershipFetchMaxAttempts (copy)
	local v37, v38 = createSignal({})
	local v39, v40 = createSignal({})
	local v41, v42 = createSignal(false)
	local v43, v44 = createSignal(nil)
	local v45, v46 = createSignal(nil)
	local v47, v48 = createSignal(false)
	local v49, v50 = createSignal(false)
	local v51, v52 = createSignal({})
	local v53, v54 = createSignal({})
	local v55, v56 = createSignal(Constants.MIN_COLUMNS)
	local t1 = {}
	local u58 = false
	local u59 = false
	local u60 = false
	local u61 = false
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}

	local function commitBonusPromotionEligibility(s1: string, p2) -- line: 200
		-- upvalues: t4 (copy), v54 (copy)
		t4[s1] = p2
		v54(table.clone(t4))
	end
	local function sortRobuxPackagesInSections(t6: {[any]: any}) -- line: 205
		-- upvalues: sortRobuxPackagesByAmountDescending (copy)
		local v87 = false

		for _, v89 in t6 do
			local robuxPackages = v89.robuxPackages

			if robuxPackages ~= nil and #robuxPackages > 1 then
				v87 = true

				break
			end
		end

		if not v87 then
			return t6
		end

		local v91 = table.clone(t6)

		for i, v in ipairs(t6) do
			local robuxPackages = v.robuxPackages

			if robuxPackages ~= nil and not (#robuxPackages <= 1) then
				v91[i] = {
					id = v.id,
					name = v.name,
					items = v.items,
					paymentSessionId = v.paymentSessionId,
					robuxPackages = sortRobuxPackagesByAmountDescending(robuxPackages),
					featuredRobuxPackage = v.featuredRobuxPackage
				}
			end
		end

		return v91
	end
	local function reapplyFeaturedPromotion() -- line: 236
		-- upvalues: promoteBonusRobuxPackageToTopPicks (copy), t3 (ref), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy)
		local v95 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

		v40((sortRobuxPackagesInSections(v95)))
	end
	local function writeOwnership(s2: string, b1: boolean) -- line: 244
		-- upvalues: v51 (copy), v52 (copy), FFlagEnableRobuxInExperienceShop (copy), promoteBonusRobuxPackageToTopPicks (copy), t3 (ref), BonusPromotionEligibility (copy), t4 (copy), v54 (copy), v40 (copy), sortRobuxPackagesInSections (copy)
		local v98 = table.clone(v51(false))

		v98[s2] = b1
		v52(v98)

		if not b1 or not FFlagEnableRobuxInExperienceShop then
			return
		end

		local v99 = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(t3)
		local v100 = if v99 == nil then nil else promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(v99)

		if v100 == nil or v100 ~= s2 then
			return
		end

		t4[s2] = BonusPromotionEligibility.Ineligible
		v54(table.clone(t4))

		local v101 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

		v40((sortRobuxPackagesInSections(v101)))
	end
	local function fetchBonusGamePassOwnershipForPromotionId(s3: string) -- line: 306
		-- upvalues: t5 (copy), BonusPromotionEligibility (copy), t4 (copy), v54 (copy), promoteBonusRobuxPackageToTopPicks (copy), t3 (ref), v40 (copy), sortRobuxPackagesInSections (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePass (copy), v51 (copy), writeOwnership (copy)
		if t5[s3] then
			return
		end

		t4[s3] = BonusPromotionEligibility.Unknown
		v54(table.clone(t4))

		local v105 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

		v40((sortRobuxPackagesInSections(v105)))

		local num = tonumber(s3)

		if num == nil then
			t4[s3] = BonusPromotionEligibility.Ineligible
			v54(table.clone(t4))

			local v107 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v107)))

			return
		end

		t5[s3] = true;
		((if not FFlagShopUseMockUserOwnsGamePass then userOwnsGamePass else MockUserOwnsGamePass))(num):andThen(function(b2: boolean) -- line: 326
			-- upvalues: s3 (copy), BonusPromotionEligibility (copy), t4 (copy), v54 (copy), v51 (copy), writeOwnership (copy), promoteBonusRobuxPackageToTopPicks (copy), t3 (ref), v40 (copy), sortRobuxPackagesInSections (copy)
			t4[s3] = if not b2 then BonusPromotionEligibility.Eligible else BonusPromotionEligibility.Ineligible
			v54(table.clone(t4))

			if v51(false)[s3] == nil then
				writeOwnership(s3, b2)
			end

			local v191 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v191)))
		end):catch(function(p3) -- line: 336
			-- upvalues: s3 (copy), BonusPromotionEligibility (copy), t4 (copy), v54 (copy), promoteBonusRobuxPackageToTopPicks (copy), t3 (ref), v40 (copy), sortRobuxPackagesInSections (copy)
			warn("[Shop] fetchBonusGamePassOwnershipForPromotion failed", s3, (tostring(p3)))
			t4[s3] = BonusPromotionEligibility.Ineligible
			v54(table.clone(t4))

			local v193 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v193)))
		end):finally(function() -- line: 341
			-- upvalues: t5 (copy), s3 (copy)
			t5[s3] = nil
		end)
	end
	local function fetchBonusGamePassOwnershipForPromotion(t7: {[any]: any}) -- line: 346
		-- upvalues: FFlagEnableRobuxInExperienceShop (copy), promoteBonusRobuxPackageToTopPicks (copy), fetchBonusGamePassOwnershipForPromotionId (copy)
		if not FFlagEnableRobuxInExperienceShop then
			return
		end

		local v109 = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(t7)
		local v110 = if v109 == nil then nil else promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(v109)

		for _, v112 in if v110 == nil then {} else { v110 } do
			fetchBonusGamePassOwnershipForPromotionId(v112)
		end
	end
	local function applySections(t8: {[any]: any}) -- line: 360
		-- upvalues: t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy)
		t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(t8)

		local v114 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

		v40((sortRobuxPackagesInSections(v114)))
		fetchBonusGamePassOwnershipForPromotion(t3)
	end
	local function commitShopMetadata(p4) -- line: 370
		-- upvalues: FFlagEnableExperienceShopGlobalIcon (copy), v46 (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), v48 (copy), v50 (copy)
		if FFlagEnableExperienceShopGlobalIcon then
			local metadata = p4.metadata

			v46(metadata)

			local v117 = if metadata == nil then nil else metadata.inExperienceGlobalIconEnabled
			local v118 = if not FFlagInExperienceShopExpectStringMetadataValues then v117 == true else v117 == "true"

			v48(v118)
			v50(metadata ~= nil and metadata.newOffers == true)
		end
	end
	local function buildProductInfoRequestsForHydration(t9: {[any]: any}, t10: {[any]: any}) -- line: 387
		-- upvalues: InExperienceShop (copy), FFlagEnableRobuxInExperienceShop (copy)
		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local v123 = refreshShopItems.buildRequestsFromSections(t9)

		if FFlagEnableRobuxInExperienceShop then
			hydrateRobuxBonusItems.appendBonusItemRequests(v123, t9)
		end

		refreshShopItems.appendFailedItemRequests(v123, t10)

		return v123
	end
	local function applyStreamingProductInfoResult(t11: {[any]: any}, p5, t12: {[any]: any}) -- line: 401
		-- upvalues: InExperienceShop (copy), FFlagEnableRobuxInExperienceShop (copy)
		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local makeRequestKey = require(InExperienceShop.Api.shopItemMapping).makeRequestKey
		local v130 = makeRequestKey(p5.request.id, p5.request.infoType)
		local t13 = {}
		local t14 = {}

		for _, v134 in t12 do
			if v130 == makeRequestKey(v134.id, v134.infoType) then
				table.insert(t13, v134)
			else
				table.insert(t14, v134)
			end
		end

		local v135 = refreshShopItems.mergeProductInfoIntoSections(t11, { p5 })
		local v136 = if not FFlagEnableRobuxInExperienceShop then v135 else hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(v135, { p5 })
		local v137, v138 = refreshShopItems.insertRecoveredItemsIntoSections(v136, { p5 }, t13)

		for _, v140 in v138 do
			table.insert(t14, v140)
		end

		return v137, t14
	end
	local function routeStreamMultiGetProductInfo(t15: {[any]: any}, p6: ((...any) -> ...any)) -- line: 436
		-- upvalues: FFlagShopUseMockData (copy), FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), streamMultiGetProductInfo (copy)
		if FFlagShopUseMockData and FFlagShopUseMockMultiGetProductInfo then
			return MockMultiGetProductInfo.streamMultiGetProductInfo(t15, {
				onResult = p6
			}, 0)
		end

		return streamMultiGetProductInfo(t15, {
			onResult = p6
		})
	end
	local function streamProductInfoIntoSections(t16: {[any]: any}, t17: {[any]: any}, t18: {[any]: any}, p7: ((...any) -> ...any)?) -- line: 446
		-- upvalues: u61 (ref), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), routeStreamMultiGetProductInfo (copy), applyStreamingProductInfoResult (copy), t2 (ref), logCounter (copy), ProductInfoFailedItemsCounter (copy)
		if #t17 == 0 then
			if p7 then
				p7(t18)
			end

			return
		end

		u61 = true

		local u147 = t16
		local u148 = t18
		local u149 = nil
		local u150 = false

		local function flushPendingSections() -- line: 465
			-- upvalues: u150 (ref), u149 (ref), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy)
			u150 = false

			if u149 ~= nil then
				local v194 = u149

				t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(v194)

				local v195 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

				v40((sortRobuxPackagesInSections(v195)))
				fetchBonusGamePassOwnershipForPromotion(t3)
				u149 = nil
			end
		end
		local function scheduleFlush(t19: {[any]: any}) -- line: 473
			-- upvalues: u149 (ref), u150 (ref), flushPendingSections (copy)
			u149 = t19

			if u150 then
				return
			end

			u150 = true
			task.delay(0.05, flushPendingSections)
		end

		routeStreamMultiGetProductInfo(t17, function(p8) -- line: 482
			-- upvalues: u147 (ref), u148 (ref), applyStreamingProductInfoResult (copy), u149 (ref), u150 (ref), flushPendingSections (copy)
			local v198, v199 = applyStreamingProductInfoResult(u147, p8, u148)

			u147 = v198
			u148 = v199
			u149 = u147

			if u150 then
				return
			end

			u150 = true
			task.delay(0.05, flushPendingSections)
		end):andThen(function(_: {[any]: any}) -- line: 487
			-- upvalues: u150 (ref), u149 (ref), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), u147 (ref), t2 (ref), u148 (ref), logCounter (copy), ProductInfoFailedItemsCounter (copy), u61 (ref), p7 (copy)
			u150 = false

			if u149 ~= nil then
				local v201 = u149

				t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(v201)

				local v202 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

				v40((sortRobuxPackagesInSections(v202)))
				fetchBonusGamePassOwnershipForPromotion(t3)
				u149 = nil
			end

			local v203 = u147

			t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(v203)

			local v204 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v204)))
			fetchBonusGamePassOwnershipForPromotion(t3)
			t2 = u148

			if #u148 > 0 then
				logCounter(ProductInfoFailedItemsCounter, #u148)
			end

			u61 = false

			if p7 then
				p7(u148)
			end
		end):catch(function(p9) -- line: 499
			-- upvalues: u150 (ref), u149 (ref), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), u61 (ref), p7 (copy), u148 (ref)
			warn("[Shop] streamProductInfoIntoSections failed", (tostring(p9)))
			u150 = false

			if u149 ~= nil then
				local v206 = u149

				t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(v206)

				local v207 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

				v40((sortRobuxPackagesInSections(v207)))
				fetchBonusGamePassOwnershipForPromotion(t3)
				u149 = nil
			end

			u61 = false

			if p7 then
				p7(u148)
			end
		end)
	end
	local function runShopFetch(p10: ((...any) -> ...any), p11: ((...any) -> ...any), s4: string) -- line: 509
		-- upvalues: u59 (ref), u58 (ref), v42 (copy), v44 (copy), FFlagShopUseMockData (copy), Errors (copy), v38 (copy), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), FFlagEnableExperienceShopGlobalIcon (copy), v46 (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), v48 (copy), v50 (copy), t2 (ref)
		if u59 or u58 then
			return
		end

		u58 = true
		v42(true)
		v44(nil);
		((if not FFlagShopUseMockData then p10() else p11())):andThen(function(p12) -- line: 520
			-- upvalues: Errors (copy), s4 (copy), v38 (copy), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), FFlagEnableExperienceShopGlobalIcon (copy), v46 (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), v48 (copy), v50 (copy), t2 (ref), v42 (copy), u58 (ref), u59 (ref)
			if type(p12) ~= "table" or (type(p12.categories) ~= "table" or type(p12.sections) ~= "table") then
				return Errors.rejectSchema(string.format("createInExperienceShopStore: %s payload missing categories/sections", s4), p12)
			end

			v38(p12.categories)

			local sections = p12.sections

			t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(sections)

			local v210 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v210)))
			fetchBonusGamePassOwnershipForPromotion(t3)

			if FFlagEnableExperienceShopGlobalIcon then
				local metadata = p12.metadata

				v46(metadata)

				local v212 = if metadata == nil then nil else metadata.inExperienceGlobalIconEnabled
				local v213 = if not FFlagInExperienceShopExpectStringMetadataValues then v212 == true else v212 == "true"

				v48(v213)
				v50(metadata ~= nil and metadata.newOffers == true)
			end

			t2 = p12.failedItems or {}
			v42(false)
			u58 = false
			u59 = true
		end):catch(function(p13) -- line: 538
			-- upvalues: v44 (copy), v38 (copy), v40 (copy), t2 (ref), v42 (copy), u58 (ref)
			v44(p13)
			v38({})
			v40({})
			t2 = {}
			v42(false)
			u58 = false
		end)
	end
	local function runPartialDisplayShopFetch(p14: ((...any) -> ...any), p15: ((...any) -> ...any), s5: string) -- line: 551
		-- upvalues: u59 (ref), u58 (ref), v42 (copy), v44 (copy), FFlagShopUseMockData (copy), Errors (copy), v38 (copy), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), FFlagEnableExperienceShopGlobalIcon (copy), v46 (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), v48 (copy), v50 (copy), t2 (ref), buildProductInfoRequestsForHydration (copy), streamProductInfoIntoSections (copy)
		if u59 or u58 then
			return
		end

		u58 = true
		v42(true)
		v44(nil);
		((if not FFlagShopUseMockData then p14() else p15())):andThen(function(p16) -- line: 566
			-- upvalues: Errors (copy), s5 (copy), v38 (copy), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), FFlagEnableExperienceShopGlobalIcon (copy), v46 (copy), FFlagInExperienceShopExpectStringMetadataValues (copy), v48 (copy), v50 (copy), t2 (ref), v42 (copy), u58 (ref), u59 (ref), buildProductInfoRequestsForHydration (copy), streamProductInfoIntoSections (copy)
			if type(p16) ~= "table" or (type(p16.categories) ~= "table" or type(p16.sections) ~= "table") then
				return Errors.rejectSchema(string.format("createInExperienceShopStore: %s payload missing categories/sections", s5), p16)
			end

			v38(p16.categories)

			local sections = p16.sections

			t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(sections)

			local v217 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v217)))
			fetchBonusGamePassOwnershipForPromotion(t3)

			if FFlagEnableExperienceShopGlobalIcon then
				local metadata = p16.metadata

				v46(metadata)

				local v219 = if metadata == nil then nil else metadata.inExperienceGlobalIconEnabled
				local v220 = if not FFlagInExperienceShopExpectStringMetadataValues then v219 == true else v219 == "true"

				v48(v220)
				v50(metadata ~= nil and metadata.newOffers == true)
			end

			t2 = p16.failedItems or {}
			v42(false)
			u58 = false
			u59 = true

			local v221 = t3
			local v222 = buildProductInfoRequestsForHydration(v221, t2)

			streamProductInfoIntoSections(v221, v222, t2, nil)
		end):catch(function(p17) -- line: 585
			-- upvalues: v44 (copy), v38 (copy), v40 (copy), t2 (ref), v42 (copy), u58 (ref)
			v44(p17)
			v38({})
			v40({})
			t2 = {}
			v42(false)
			u58 = false
		end)
	end
	local function refreshShopItemInfo() -- line: 630
		-- upvalues: FFlagEnableShopProductInfoRefresh (copy), u59 (ref), u60 (ref), u61 (ref), InExperienceShop (copy), t3 (ref), v39 (copy), FFlagEnableRobuxInExperienceShop (copy), t2 (ref), FFlagEnablePartialDisplayInExperienceShop (copy), streamProductInfoIntoSections (copy), FFlagShopUseMockData (copy), FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), multiGetProductInfo (copy), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy)
		if not FFlagEnableShopProductInfoRefresh then
			return
		end

		if not u59 or u60 or u61 then
			return
		end

		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local v162 = if not (#t3 > 0) then v39(false) else t3
		local v163 = refreshShopItems.buildRequestsFromSections(v162)

		if FFlagEnableRobuxInExperienceShop then
			hydrateRobuxBonusItems.appendBonusItemRequests(v163, v162)
		end

		local v164 = t2

		refreshShopItems.appendFailedItemRequests(v163, v164)

		if #v163 == 0 then
			return
		end

		u60 = true

		local v165 = FFlagEnablePartialDisplayInExperienceShop

		if if typeof(v165) ~= "function" then v165 else v165() then
			streamProductInfoIntoSections(v162, v163, v164, function() -- line: 662
				-- upvalues: u60 (ref)
				u60 = false
			end)

			return
		end;

		((if not FFlagShopUseMockData or not FFlagShopUseMockMultiGetProductInfo then multiGetProductInfo(v163) else MockMultiGetProductInfo.multiGetProductInfo(v163, 0))):andThen(function(p18) -- line: 677
			-- upvalues: refreshShopItems (copy), v162 (copy), FFlagEnableRobuxInExperienceShop (copy), hydrateRobuxBonusItems (copy), v164 (copy), t2 (ref), t3 (ref), promoteBonusRobuxPackageToTopPicks (copy), t4 (copy), v40 (copy), sortRobuxPackagesInSections (copy), fetchBonusGamePassOwnershipForPromotion (copy), u60 (ref)
			local v225 = refreshShopItems.mergeProductInfoIntoSections(v162, p18)
			local v226 = if not FFlagEnableRobuxInExperienceShop then v225 else hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(v225, p18)
			local v227, v228 = refreshShopItems.insertRecoveredItemsIntoSections(v226, p18, v164)

			t2 = v228
			t3 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(v227)

			local v229 = promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(t3, t4)

			v40((sortRobuxPackagesInSections(v229)))
			fetchBonusGamePassOwnershipForPromotion(t3)
			u60 = false
		end):catch(function(p19) -- line: 688
			-- upvalues: u60 (ref)
			warn("[Shop] refreshShopItemInfo failed", (tostring(p19)))
			u60 = false
		end)
	end

	local t21 = {}

	local function pollOwnershipUntilTrue(p20: ((...any) -> ...any), n1: number, n2: number, n3: number) -- line: 725
		-- upvalues: Promise (copy), pollOwnershipUntilTrue (copy), Constants (copy)
		return p20(n1):andThen(function(b3: boolean) -- line: 732
			-- upvalues: n2 (copy), Promise (copy), n3 (copy), pollOwnershipUntilTrue (copy), p20 (copy), n1 (copy), Constants (copy)
			if b3 then
				return true
			end

			if n2 <= 1 then
				return false
			end

			return Promise.delay(n3):andThen(function() -- line: 739
				-- upvalues: pollOwnershipUntilTrue (copy), p20 (copy), n1 (copy), n2 (copy), n3 (copy), Constants (copy)
				return pollOwnershipUntilTrue(p20, n1, n2 - 1, n3 * Constants.POLL_BACKOFF_MULTIPLIER)
			end)
		end):catch(function(p21) -- line: 748
			-- upvalues: n2 (copy), n1 (copy), Promise (copy), n3 (copy), pollOwnershipUntilTrue (copy), p20 (copy), Constants (copy)
			if n2 <= 1 then
				warn("[Shop] pollOwnershipUntilTrue exhausted with engine error", n1, (tostring(p21)))

				return nil
			end

			return Promise.delay(n3):andThen(function() -- line: 753
				-- upvalues: pollOwnershipUntilTrue (copy), p20 (copy), n1 (copy), n2 (copy), n3 (copy), Constants (copy)
				return pollOwnershipUntilTrue(p20, n1, n2 - 1, n3 * Constants.POLL_BACKOFF_MULTIPLIER)
			end)
		end)
	end
	local function pollGamePassOwnershipAfterPurchase(s6: string, n4: number, p22: ((...any) -> ...any), b4: boolean?) -- line: 769
		-- upvalues: t21 (copy), pollOwnershipUntilTrue (copy), Constants (copy), writeOwnership (copy), Players (copy), MarketplaceService (copy), Promise (copy)
		if t21[s6] then
			return
		end

		local num = tonumber(s6)

		if num == nil then
			return
		end

		t21[s6] = true

		local function startPoll() -- line: 785
			-- upvalues: pollOwnershipUntilTrue (copy), p22 (copy), num (copy), n4 (copy), Constants (copy), writeOwnership (copy), s6 (copy), b4 (copy), Players (copy), MarketplaceService (copy), t21 (copy)
			pollOwnershipUntilTrue(p22, num, n4, Constants.POLL_INITIAL_DELAY_SECONDS):andThen(function(b5: boolean?) -- line: 787
				-- upvalues: writeOwnership (copy), s6 (copy), b4 (copy), Players (copy), MarketplaceService (copy), num (copy)
				if b5 ~= true then
					return
				end

				writeOwnership(s6, b5)

				if b4 then
					local LocalPlayer = Players.LocalPlayer

					if LocalPlayer ~= nil then
						MarketplaceService:SignalPromptGamePassPurchaseFinished(LocalPlayer, num, true)
					end
				end
			end):finally(function() -- line: 801
				-- upvalues: t21 (copy), s6 (copy)
				t21[s6] = nil
			end)
		end

		Promise.delay(Constants.POLL_INITIAL_DELAY_SECONDS):andThen(startPoll)
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId: number, purchased: boolean) -- line: 819
		-- upvalues: Players (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePass (copy), FIntShopOwnershipFetchMaxAttempts (copy), t21 (copy), pollOwnershipUntilTrue (copy), Constants (copy), writeOwnership (copy), MarketplaceService (copy), Promise (copy)
		if not purchased then
			return
		end

		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer == nil or player.UserId ~= LocalPlayer.UserId then
			return
		end

		local v181 = if not FFlagShopUseMockUserOwnsGamePass then userOwnsGamePass else MockUserOwnsGamePass
		local str = tostring(gamePassId)
		local v183 = FIntShopOwnershipFetchMaxAttempts

		if t21[str] then
			return
		end

		local num = tonumber(str)

		if num == nil then
			return
		end

		t21[str] = true

		local v185 = nil

		local function startPoll() -- line: 785
			-- upvalues: pollOwnershipUntilTrue (copy), v181 (copy), num (copy), v183 (copy), Constants (copy), writeOwnership (copy), str (copy), v185 (copy), Players (copy), MarketplaceService (copy), t21 (copy)
			pollOwnershipUntilTrue(v181, num, v183, Constants.POLL_INITIAL_DELAY_SECONDS):andThen(function(b6: boolean?) -- line: 787
				-- upvalues: writeOwnership (copy), str (copy), v185 (copy), Players (copy), MarketplaceService (copy), num (copy)
				if b6 ~= true then
					return
				end

				writeOwnership(str, b6)

				if v185 then
					local LocalPlayer2 = Players.LocalPlayer

					if LocalPlayer2 ~= nil then
						MarketplaceService:SignalPromptGamePassPurchaseFinished(LocalPlayer2, num, true)
					end
				end
			end):finally(function() -- line: 801
				-- upvalues: t21 (copy), str (copy)
				t21[str] = nil
			end)
		end

		Promise.delay(Constants.POLL_INITIAL_DELAY_SECONDS):andThen(startPoll)
	end)

	return {
		getCategories = v37,
		getSections = v39,
		getLoading = v41,
		getError = v43,
		getOwnership = v51,
		getBonusPromotionEligibility = v53,
		getItemsPerRow = v55,
		getMetadata = v45,
		getGlobalIconBackendEnabled = v47,
		getGlobalIconHasNewOffers = v49,
		onShopOpened = function() -- line: 705
			-- upvalues: FFlagEnablePartialDisplayInExperienceShop (copy), runPartialDisplayShopFetch (copy), fetchShopWidgetsOnly (copy), MockFetchAllShopData (copy), runShopFetch (copy), fetchAllShopData (copy), refreshShopItemInfo (copy)
			local v166 = FFlagEnablePartialDisplayInExperienceShop

			if if typeof(v166) ~= "function" then v166 else v166() then
				runPartialDisplayShopFetch(fetchShopWidgetsOnly, MockFetchAllShopData.fetchShopWidgetsOnly, "fetchAllShopData")
			else
				runShopFetch(fetchAllShopData, MockFetchAllShopData.fetchAllShopData, "fetchAllShopData")
			end

			refreshShopItemInfo()
		end,
		fetchAllShopData = function() -- line: 595
			-- upvalues: FFlagEnablePartialDisplayInExperienceShop (copy), runPartialDisplayShopFetch (copy), fetchShopWidgetsOnly (copy), MockFetchAllShopData (copy), runShopFetch (copy), fetchAllShopData (copy)
			local v159 = FFlagEnablePartialDisplayInExperienceShop

			if if typeof(v159) ~= "function" then v159 else v159() then
				runPartialDisplayShopFetch(fetchShopWidgetsOnly, MockFetchAllShopData.fetchShopWidgetsOnly, "fetchAllShopData")

				return
			end

			runShopFetch(fetchAllShopData, MockFetchAllShopData.fetchAllShopData, "fetchAllShopData")
		end,
		prefetchWidgetsOnly = function() -- line: 607
			-- upvalues: runShopFetch (copy), fetchShopWidgetsOnly (copy), MockFetchAllShopData (copy)
			runShopFetch(fetchShopWidgetsOnly, MockFetchAllShopData.fetchShopWidgetsOnly, "prefetchWidgetsOnly")
		end,
		refreshShopItemInfo = refreshShopItemInfo,
		fetchGamePassOwnership = function(s7: string) -- line: 267
			-- upvalues: t1 (copy), v51 (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePass (copy), writeOwnership (copy)
			if t1[s7] then
				return
			end

			if v51(false)[s7] ~= nil then
				return
			end

			local num = tonumber(s7)

			if num == nil then
				return
			end

			t1[s7] = true;
			((if not FFlagShopUseMockUserOwnsGamePass then userOwnsGamePass else MockUserOwnsGamePass))(num):andThen(function(b7: boolean) -- line: 283
				-- upvalues: v51 (copy), s7 (copy), writeOwnership (copy)
				if v51(false)[s7] ~= nil then
					return
				end

				writeOwnership(s7, b7)
			end):catch(function(p23) -- line: 295
				-- upvalues: s7 (copy)
				warn("[Shop] fetchGamePassOwnership failed", s7, (tostring(p23)))
			end):finally(function() -- line: 301
				-- upvalues: t1 (copy), s7 (copy)
				t1[s7] = nil
			end)
		end,
		pollGamePassOwnership = pollGamePassOwnershipAfterPurchase,
		setItemsPerRow = function(n5: number) -- line: 843
			-- upvalues: v56 (copy)
			v56(n5)
		end
	}
end

return createInExperienceShopStore
