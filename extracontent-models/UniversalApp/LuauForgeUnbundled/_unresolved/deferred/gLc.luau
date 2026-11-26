local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
require("@luauforge/bundled/dKU")
local Promise = require(CorePackages.Packages.Promise)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/egY")

local module3 = require("@luauforge/deferred/gJI")

local module4 = require("@luauforge/deferred/gJH")
local module5 = require("@luauforge/bundled/dXh")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module6 = require("@luauforge/deferred/gKt")
local module7 = require("@luauforge/bundled/fDf")
local module8 = require("@luauforge/bundled/dPN")
local module9 = require("@luauforge/bundled/gJz")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module10 = require("@luauforge/bundled/dVl")
local module11 = require("@luauforge/deferred/gKT")
local module12 = require("@luauforge/bundled/dFm")
local module13 = require("@luauforge/bundled/dzE")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local module14 = require("@luauforge/deferred/gKx")
require("@luauforge/bundled/dPs")

local module15 = require("@luauforge/deferred/gKv")
local economicRestrictionsCounter = module15.Counters.EconomicRestrictionsCounter
local universalEconomicRestrictionsCounter = economicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local economicRestrictionsSurface = economicRestrictionsCounter.EconomicRestrictionsSurface
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module16 = require("@luauforge/deferred/gKA")
local parseEconomicRestrictionsFailureReason = module15.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = module15.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local extended = Roact.PureComponent:extend("PurchaseOutfitPrompt")

extended.validateProps = t.strictInterface({
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

local function closePrompt(p2)
	module5.closeOverlay(p2)
end

local function purchaseResolveNav(p2)
	module5.closeOverlay(p2)

	module5.closeFocusedScreen(p2)
end

local v5 = memoize(function(p2, items)
	local result = {}

	for k, item in items do
		result[k] = itemData(p2, k, item.itemType)
	end

	return result
end)

local function fn(p2, itemsToPurchase)
	return v5(p2.AvatarExperience.Common, itemsToPurchase)
end

function extended:getToast(p3, p4, p5)
	local localization = self.props.localization

	local v6 = { numItems = p3 }

	local formatted = localization:Format("Feature.Avatar.Label.OutfitPurchaseSuccess", v6)
	local v7 = localization:Format("Feature.Avatar.Label.OutfitPurchaseFailure", v6)
	local v8

	if p4 then
		v8 = module13.InformationMessage
		v7 = formatted
	else
		v8 = module13.NetworkingError
	end

	return { toastMessage = v7, isLocalized = true, toastType = v8 }
end

local function getSuccessAndFailureCounts(items)
	local count = 0
	local count2 = 0

	for k, item in items do
		if item == true then
			count2 += 1
		else
			count += 1
		end
	end

	return count2, count
end

function extended:showToasts(items, p2)
	local count = 0
	local count2 = 0

	for k, item in items do
		if item == true then
			count2 += 1
		else
			count += 1
		end
	end

	if count2 > 0 then
		self.props.setCurrentToastMessage(self:getToast(count2, true, p2))
	end

	if count > 0 then
		self.props.setCurrentToastMessage(self:getToast(count, false, p2))
	end
end

function extended:formatOwnedItemForWearAfterPurchase(assetId, data)
	local v6 = data.itemType == module8.ItemType.Bundle

	local v8 = if v6 then data.bundleInfo or nil else nil
	local v7 = {
		purchased = false,
		owned = true,
		assetIsWearable = not v6,
		bundleId = v6 and assetId or nil,
		tryOnBundleInfo = v8,
		assetId = nil,
		assetType = 0,
		overrideOrder = 0,
		itemSubType = 0
	}

	if v6 or not assetId then
		assetId = nil
	end

	v7.assetId = assetId
	v7.assetType = v6 and module8.ItemType.Bundle or nil
	v7.overrideOrder = data.order
	v7.itemSubType = data.itemSubType
	return v7
end

function extended:handleWearAfterPurchase(items, p2)
	if not self.state.isWearAfterPurchaseChecked then
		return
	end

	local v6 = {}

	for k, ownedTryOnItem in self.props.ownedTryOnItems do
		table.insert(v6, self:formatOwnedItemForWearAfterPurchase(k, ownedTryOnItem))
	end

	for k, item in items do
		if item == true and p2[k].purchased == true then
			table.insert(v6, p2[k])
		end
	end

	self.props.wearAfterOutfitPurchase(v6, self.props.navigation, self.props.aeAnalytics)
end

function extended:init()
	self.isMounted = false

	self.state = { isWearAfterPurchaseChecked = true, isPurchasing = false }

	function self.onCancel()
		if self.state.isPurchasing then
			return
		end

		local navigation = self.props.navigation
		module5.closeOverlay(navigation)
	end

	function self.onConfirm(p2)
		if self.state.isPurchasing then
			return
		end

		local networking = self.props.networking
		local analytics = self.props.analytics
		local navigation = self.props.navigation

		local entryPoint = self.props.entryPoint
		local v6 = {}

		for k, v7 in self.props.itemsToPurchase do
			local itemType = v7.itemType
			local itemSubType = v7.itemSubType
			local v8 = v7.expectedPrice

			local v9 = self.props.itemDataTable[k]

			local id = v9.product.id
			local v10 = v9.expectedSellerId
			local resellerUserAssetIds = v9.resellerUserAssetIds
			local isResellable = module10.IsResellable(v9)
			local collectibleItemId = v9 and v9.collectibleItemId
			local kind = v9 and v9.creator and v9.creator.type

			local v11 = resellerUserAssetIds and resellerUserAssetIds[1]
			local userAsset = self.props.userAssets[v11]
			local userAssetId

			if isResellable and userAsset then
				userAssetId = userAsset.userAssetId
				v10 = userAsset.userId
			end

			local collectibleInstanceId = nil

			if collectibleItemId then
				local collectiblesItemInfo = self.props.collectiblesItemInfo
				local collectiblesResellersInstances = self.props.collectiblesResellersInstances
				local collectiblesResellableInstances = self.props.collectiblesResellableInstances
				local cheapestCollectiblePurchaseInfoV2 = module10.findCheapestCollectiblePurchaseInfoV2(
					collectibleItemId,
					isResellable,
					collectiblesItemInfo,
					collectiblesResellersInstances,
					collectiblesResellableInstances
				)

				if cheapestCollectiblePurchaseInfoV2.price then
					v8 = cheapestCollectiblePurchaseInfoV2.price
				end

				if cheapestCollectiblePurchaseInfoV2.collectibleInstanceId then
					collectibleInstanceId = cheapestCollectiblePurchaseInfoV2.collectibleInstanceId
					v10 = cheapestCollectiblePurchaseInfoV2.expectedSellerId
				end
			end

			table.insert(
				v6,
				self.props.purchaseProduct(
					networking,
					id,
					v8 or 0,
					v10,
					k,
					itemType,
					itemSubType,
					false,
					userAssetId,
					analytics,
					navigation,
					false,
					true,
					entryPoint,
					collectibleItemId,
					collectibleInstanceId,
					kind,
					self.props.economicRestrictionErrorHandler
				)
			)
		end

		self:setState({ isPurchasing = true })

		Promise.new(function(callback, p3)
			local v7 = {}
			local v8 = {}

			for k, v9 in v6 do
				local v10, v11 = v9:await()
				table.insert(v7, v10)
				table.insert(v8, v11)
			end

			callback(v7, v8)
		end):andThen(function(p3, p4)
			if self.isMounted then
				self:setState({ isPurchasing = false })

				self:showToasts(p3, p2)
				self:handleWearAfterPurchase(p3, p4)

				local navigation2 = self.props.navigation
				module5.closeOverlay(navigation2)

				module5.closeFocusedScreen(navigation2)
			else
				self:showToasts(p3, p2)
				self:handleWearAfterPurchase(p3, p4)
			end
		end)
	end

	function self.toggleWearAfterPurchase()
		self:setState({
			isWearAfterPurchaseChecked = not self.state.isWearAfterPurchaseChecked
		})
	end
end

function extended:renderAlertLocalized(props2)
	local totalOutfitPrice = self.props.totalOutfitPrice
	local fieldCount = tutils.fieldCount(self.props.itemsToPurchase)
	local v6 = totalOutfitPrice == 0
	local v7 = nil

	local localization = self.props.localization

	local v8 = { numItems = fieldCount }

	local formatted = localization:Format("Feature.Avatar.Label.GetOutfitMultiple", v8)
	local formatted2 = localization:Format("Feature.Avatar.Label.BuyOutfitMultiple", v8)
	local formatted3 = localization:Format("Feature.Avatar.Label.BuyOutfitLuobuMultiple", v8)
	local v9, v10

	if v6 then
		v9 = props2.getOutfit

		if fieldCount > 1 then
			v7 = formatted
		elseif fieldCount == 1 then
			v7 = props2.getOutfitOne
		end

		v10 = props2.get
	else
		v9 = props2.buyOutfit

		if self.props.enablePurchasePromptIncludingWarning then
			if fieldCount > 1 then
				v7 = formatted3
			elseif fieldCount == 1 then
				v7 = props2.buyOutfitLuobuSingle
			end
		elseif fieldCount > 1 then
			v7 = formatted2
		elseif fieldCount == 1 then
			v7 = props2.buyOutfitSingle
		end

		v10 = props2.buyOutfit
	end

	return Roact.createElement(module14, {
		priceInRobux = totalOutfitPrice,
		showWearAfterPurchase = true,
		isWearAfterPurchaseChecked = self.state.isWearAfterPurchaseChecked,
		toggleWearAfterPurchase = self.toggleWearAfterPurchase,
		titleText = v9,
		bodyText = v7,
		confirmButtonText = v10,
		onConfirm = function()
			return self.onConfirm(props2)
		end,
		onCancel = self.onCancel,
		isLoading = self.state.isPurchasing,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		getOutfit = "Feature.Avatar.Title.GetOutfit",
		buyOutfit = "Feature.Avatar.Title.BuyOutfit",
		get = "Feature.Catalog.Label.Get",
		getOutfitOne = "Feature.Avatar.Label.GetOutfitOne",
		buyOutfitSingle = "Feature.Avatar.Label.BuyOutfitSingle",
		buyOutfitLuobuSingle = "Feature.Avatar.Label.BuyOutfitLuobuSingle"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

local v6 = roactAppPolicy.connect(function(p2, p3)
	return {
		enablePurchasePromptIncludingWarning = p2.getPurchasePromptIncludingWarning()
	}
end)(extended)

local v7 = RoactRodux.connect(function(p2, p3)
	return {
		itemDataTable = fn(p2, p3.itemsToPurchase),
		userAssets = p2.AvatarExperience.Catalog.UserAssets,
		collectiblesItemInfo = p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo,
		collectiblesResellersInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances,
		collectiblesResellableInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
	}
end, function(callback)
	return {
		setCurrentToastMessage = function(p2)
			callback(module12(p2))
		end,
		purchaseProduct = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20)
			return callback(module6(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				p11,
				p12,
				p13,
				p14,
				p15,
				p16,
				p17,
				p18,
				p19,
				p20
			))
		end,
		wearAfterOutfitPurchase = function(p2, p3, p4)
			return callback(module11(p2, p3, p4))
		end,
		economicRestrictionErrorHandler = function(p2)
			local v8 = parseEconomicRestrictionsFailureReason(p2)
			local v9 = parseEconomicRestrictionsExpirationTimeInMinutes(p2)
			default:logRobloxTelemetryCounter(universalEconomicRestrictionsCounter, 1, {
				surface = economicRestrictionsSurface.AvatarExperience,
				failureReason = v8
			})

			return callback(module16(v8, v9))
		end
	}
end)(v6)

return (module4((module3((roactServices.connect({
	networking = module,
	analytics = module7,
	aeAnalytics = module9,
	localization = module2
})(v7))))))
