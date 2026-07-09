local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Promise = require(CorePackages.Packages.Promise)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local PurchaseProduct = require(Modules.AvatarExperience.Catalog.Thunks.PurchaseProduct)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local WearAfterOutfitPurchase = require(Modules.AvatarExperience.Catalog.Thunks.WearAfterOutfitPurchase)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local PurchasePromptInteractiveAlert = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchasePromptInteractiveAlert)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local v35 = Roact.PureComponent:extend("PurchaseOutfitPrompt")

v35.validateProps = t.strictInterface({
	navigation = t.table,
	itemsToPurchase = t.table,
	ownedTryOnItems = t.table,
	totalOutfitPrice = t.integer,
	entryPoint = t.optional(t.string),
	itemDataTable = t.table,
	userAssets = t.table,
	collectiblesItemInfo = t.table,
	collectiblesResellersInstances = t.table,
	collectiblesResellableInstances = t.table,
	purchaseProduct = t.callback,
	setCurrentToastMessage = t.callback,
	wearAfterOutfitPurchase = t.callback,
	economicRestrictionErrorHandler = t.callback,
	networking = t.callback,
	analytics = t.table,
	aeAnalytics = t.table,
	localization = t.table,
	enablePurchasePromptIncludingWarning = t.boolean,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

local function closePrompt(p1) -- line: 89
	-- upvalues: NavigationUtils (copy)
	NavigationUtils.closeOverlay(p1)
end
local function purchaseResolveNav(p2) -- line: 93
	-- upvalues: NavigationUtils (copy)
	NavigationUtils.closeOverlay(p2)
	NavigationUtils.closeFocusedScreen(p2)
end

local v38 = memoize(function(p3, p4) -- line: 100
	-- upvalues: ItemData (copy)
	local t1 = {}

	for v48, v49 in p4 do
		t1[v48] = ItemData(p3, v48, v49.itemType)
	end

	return t1
end)

local function u39(p5, p6) -- line: 109
	-- upvalues: v38 (copy)
	local Common = p5.AvatarExperience.Common

	return v38(Common, p6)
end

function v35.getToast(p7, p8, p9, _) -- line: 121
	-- upvalues: ToastType (copy)
	local localization = p7.props.localization
	local t2 = {
		numItems = p8
	}
	local v59 = localization:Format("Feature.Avatar.Label.OutfitPurchaseSuccess", t2)
	local v60 = localization:Format("Feature.Avatar.Label.OutfitPurchaseFailure", t2)
	local InformationMessage

	if p9 then
		InformationMessage = ToastType.InformationMessage
	else
		v59 = v60
		InformationMessage = ToastType.NetworkingError
	end

	return {
		isLocalized = true,
		toastMessage = v59,
		toastType = InformationMessage
	}
end

local function getSuccessAndFailureCounts(p11) -- line: 151
	local n1 = 0
	local n2 = 0

	for _, v66 in p11 do
		if v66 == true then
			n1 += 1
		else
			n2 += 1
		end
	end

	return n1, n2
end

function v35.showToasts(p12, p13, p14) -- line: 170
	local n3 = 0
	local n4 = 0

	for _, v73 in p13 do
		if v73 == true then
			n3 += 1
		else
			n4 += 1
		end
	end

	if n3 > 0 then
		p12.props.setCurrentToastMessage(p12:getToast(n3, true, p14))
	end

	if n4 > 0 then
		p12.props.setCurrentToastMessage(p12:getToast(n4, false, p14))
	end
end
function v35.formatOwnedItemForWearAfterPurchase(_, p16, p17) -- line: 187
	-- upvalues: Constants (copy)
	local v77 = p17.itemType == Constants.ItemType.Bundle

	return {
		purchased = false,
		owned = true,
		assetIsWearable = not v77,
		bundleId = v77 and p16 or nil,
		tryOnBundleInfo = v77 and p17.bundleInfo or nil,
		assetId = not v77 and p16 or nil,
		assetType = v77 and Constants.ItemType.Bundle or nil,
		overrideOrder = p17.order,
		itemSubType = p17.itemSubType
	}
end
function v35.handleWearAfterPurchase(p18, p19, p20) -- line: 211
	if not p18.state.isWearAfterPurchaseChecked then
		return
	end

	local t3 = {}

	for v82, v83 in p18.props.ownedTryOnItems do
		table.insert(t3, p18:formatOwnedItemForWearAfterPurchase(v82, v83))
	end

	for v84, v85 in p19 do
		if v85 == true and p20[v84].purchased == true then
			table.insert(t3, p20[v84])
		end
	end

	p18.props.wearAfterOutfitPurchase(t3, p18.props.navigation, p18.props.aeAnalytics)
end
function v35.init(p21) -- line: 235
	-- upvalues: NavigationUtils (copy), CatalogUtils (copy), Promise (copy)
	p21.isMounted = false
	p21.state = {
		isWearAfterPurchaseChecked = true,
		isPurchasing = false
	}

	function p21.onCancel() -- line: 243
		-- upvalues: p21 (copy), NavigationUtils (copy)
		if p21.state.isPurchasing then
			return
		end

		local navigation = p21.props.navigation

		NavigationUtils.closeOverlay(navigation)
	end
	function p21.onConfirm(p22) -- line: 251
		-- upvalues: p21 (copy), CatalogUtils (copy), Promise (copy), NavigationUtils (copy)
		if p21.state.isPurchasing then
			return
		end

		local networking = p21.props.networking
		local analytics = p21.props.analytics
		local navigation = p21.props.navigation
		local t4 = {}
		local entryPoint = p21.props.entryPoint

		for v115, v116 in p21.props.itemsToPurchase do
			local itemType = v116.itemType
			local itemSubType = v116.itemSubType
			local expectedPrice = v116.expectedPrice
			local v120 = p21.props.itemDataTable[v115]
			local id = v120.product.id
			local expectedSellerId = v120.expectedSellerId
			local resellerUserAssetIds = v120.resellerUserAssetIds
			local v124 = CatalogUtils.IsResellable(v120)
			local v125 = v120 and v120.collectibleItemId
			local v126 = v120 and (v120.creator and v120.creator.type)
			local v127 = resellerUserAssetIds and resellerUserAssetIds[1]
			local v128 = p21.props.userAssets[v127]
			local userAssetId = nil

			if v124 and v128 then
				userAssetId = v128.userAssetId
				expectedSellerId = v128.userId
			end

			local collectibleInstanceId = nil

			if v125 then
				local collectiblesItemInfo = p21.props.collectiblesItemInfo
				local collectiblesResellersInstances = p21.props.collectiblesResellersInstances
				local collectiblesResellableInstances = p21.props.collectiblesResellableInstances
				local v134 = CatalogUtils.findCheapestCollectiblePurchaseInfoV2(v125, v124, collectiblesItemInfo, collectiblesResellersInstances, collectiblesResellableInstances)

				if v134.price then
					expectedPrice = v134.price
				end

				if v134.collectibleInstanceId then
					collectibleInstanceId = v134.collectibleInstanceId
					expectedSellerId = v134.expectedSellerId
				end
			end

			table.insert(t4, p21.props.purchaseProduct(networking, id, expectedPrice or 0, expectedSellerId, v115, itemType, itemSubType, false, userAssetId, analytics, navigation, false, true, entryPoint, v125, collectibleInstanceId, v126, p21.props.economicRestrictionErrorHandler))
		end

		p21:setState({
			isPurchasing = true
		})
		Promise.new(function(resolve, _) -- line: 344
			-- upvalues: t4 (copy)
			local t5 = {}
			local t6 = {}

			for _, v168 in t4 do
				local v169, v170 = v168:await()

				table.insert(t5, v169)
				table.insert(t6, v170)
			end

			resolve(t5, t6)
		end):andThen(function(p24, p25) -- line: 359
			-- upvalues: p21 (copy), p22 (copy), NavigationUtils (copy)
			if p21.isMounted then
				p21:setState({
					isPurchasing = false
				})
				p21:showToasts(p24, p22)
				p21:handleWearAfterPurchase(p24, p25)

				local navigation2 = p21.props.navigation

				NavigationUtils.closeOverlay(navigation2)
				NavigationUtils.closeFocusedScreen(navigation2)

				return
			end

			p21:showToasts(p24, p22)
			p21:handleWearAfterPurchase(p24, p25)
		end)
	end
	function p21.toggleWearAfterPurchase() -- line: 377
		-- upvalues: p21 (copy)
		local isWearAfterPurchaseChecked = p21.state.isWearAfterPurchaseChecked

		p21:setState({
			isWearAfterPurchaseChecked = not isWearAfterPurchaseChecked
		})
	end
end
function v35.renderAlertLocalized(p26, p27) -- line: 385
	-- upvalues: tutils (copy), Roact (copy), PurchasePromptInteractiveAlert (copy)
	local totalOutfitPrice = p26.props.totalOutfitPrice
	local v90 = tutils.fieldCount(p26.props.itemsToPurchase)
	local v91 = totalOutfitPrice == 0
	local v92 = nil
	local localization = p26.props.localization
	local t7 = {
		numItems = v90
	}
	local v95 = localization:Format("Feature.Avatar.Label.GetOutfitMultiple", t7)
	local v96 = localization:Format("Feature.Avatar.Label.BuyOutfitMultiple", t7)
	local v97 = localization:Format("Feature.Avatar.Label.BuyOutfitLuobuMultiple", t7)
	local getOutfit, get

	if v91 then
		getOutfit = p27.getOutfit

		if v90 > 1 then
			v92 = v95
		elseif v90 == 1 then
			v92 = p27.getOutfitOne
		end

		get = p27.get
	else
		getOutfit = p27.buyOutfit

		if p26.props.enablePurchasePromptIncludingWarning then
			if v90 > 1 then
				v92 = v97
			elseif v90 == 1 then
				v92 = p27.buyOutfitLuobuSingle
			end
		elseif v90 > 1 then
			v92 = v96
		elseif v90 == 1 then
			v92 = p27.buyOutfitSingle
		end

		get = p27.buyOutfit
	end

	return Roact.createElement(PurchasePromptInteractiveAlert, {
		showWearAfterPurchase = true,
		priceInRobux = totalOutfitPrice,
		isWearAfterPurchaseChecked = p26.state.isWearAfterPurchaseChecked,
		toggleWearAfterPurchase = p26.toggleWearAfterPurchase,
		titleText = getOutfit,
		bodyText = v92,
		confirmButtonText = get,
		onConfirm = function() -- line: 438
			-- upvalues: p26 (copy), p27 (copy)
			return p26.onConfirm(p27)
		end,
		onCancel = p26.onCancel,
		isLoading = p26.state.isPurchasing,
		defaultChildRef = p26.props.defaultChildRef
	})
end
function v35.render(p28) -- line: 447
	-- upvalues: withLocalization (copy)
	return withLocalization({
		getOutfit = "Feature.Avatar.Title.GetOutfit",
		buyOutfit = "Feature.Avatar.Title.BuyOutfit",
		get = "Feature.Catalog.Label.Get",
		getOutfitOne = "Feature.Avatar.Label.GetOutfitOne",
		buyOutfitSingle = "Feature.Avatar.Label.BuyOutfitSingle",
		buyOutfitLuobuSingle = "Feature.Avatar.Label.BuyOutfitLuobuSingle"
	})(function(p29) -- line: 455
		-- upvalues: p28 (copy)
		return p28:renderAlertLocalized(p29)
	end)
end
function v35.didMount(p30) -- line: 460
	p30.isMounted = true
end
function v35.willUnmount(p31) -- line: 464
	p31.isMounted = false
end

local v41 = RoactAppPolicy.connect(function(p32, _) -- line: 468
	return {
		enablePurchasePromptIncludingWarning = p32.getPurchasePromptIncludingWarning()
	}
end)(v35)
local v42 = RoactRodux.connect(function(p34, p35) -- line: 474
	-- upvalues: u39 (ref)
	return {
		itemDataTable = u39(p34, p35.itemsToPurchase),
		userAssets = p34.AvatarExperience.Catalog.UserAssets,
		collectiblesItemInfo = p34.AvatarExperience.Common.Collectibles.CollectiblesItemInfo,
		collectiblesResellersInstances = p34.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances,
		collectiblesResellableInstances = p34.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
	}
end, function(p36) -- line: 482
	-- upvalues: SetCurrentToastMessage (copy), PurchaseProduct (copy), WearAfterOutfitPurchase (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
	return {
		setCurrentToastMessage = function(p37) -- line: 484
			-- upvalues: p36 (copy), SetCurrentToastMessage (copy)
			p36(SetCurrentToastMessage(p37))
		end,
		purchaseProduct = function(p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56) -- line: 488
			-- upvalues: p36 (copy), PurchaseProduct (copy)
			return p36(PurchaseProduct(p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56))
		end,
		wearAfterOutfitPurchase = function(p57, p58, p59) -- line: 534
			-- upvalues: p36 (copy), WearAfterOutfitPurchase (copy)
			return p36(WearAfterOutfitPurchase(p57, p58, p59))
		end,
		economicRestrictionErrorHandler = function(p60) -- line: 538
			-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p36 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
			local v161 = parseEconomicRestrictionsFailureReason(p60)
			local v162 = parseEconomicRestrictionsExpirationTimeInMinutes(p60)

			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.AvatarExperience,
				failureReason = v161
			})

			return p36(OpenCentralOverlayForEconomicRestrictionPrompt(v161, v162))
		end
	}
end)(v41)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking,
	analytics = Analytics,
	aeAnalytics = Analytics2,
	localization = RoactLocalization
})(v42))))))
