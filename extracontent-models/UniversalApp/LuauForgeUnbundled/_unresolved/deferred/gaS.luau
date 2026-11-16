local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/eda")
local module3 = require("@luauforge/bundled/fue")
local module4 = require("@luauforge/bundled/dCp")
local module5 = require("@luauforge/bundled/fsq")
local t = require(CorePackages.Packages.t)

local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTile = UIBlox.Tile.ItemTile
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local module6 = require("@luauforge/deferred/gaT")
local module7 = require("@luauforge/bundled/fXw")

local module8 = require("@luauforge/deferred/fvm")
local productPurchaseSurface = require("@luauforge/deferred/fvp").Enums.ProductPurchaseSurface
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module9 = require("@luauforge/bundled/fXv")

local module10 = require("@luauforge/deferred/fXQ")

local module11 = require("@luauforge/deferred/fXs")

local module12 = require("@luauforge/deferred/fXN")
local constants = module12.Constants

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local SessionService = game:GetService("SessionService")
local module14 = require("@luauforge/deferred/fXO")

local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchaseAddSkeleton
local v5 = game:DefineFastFlag("UnifiedPurchaseAddSkeletonLoadingForDeveloperProduct", false)
	and fFlagUnifiedPurchaseAddSkeleton

local fFlagIntegrateDiscountsWithEDP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagIntegrateDiscountsWithEDP

local fFlagLuaAppFixPassesPageStoreFetch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppFixPassesPageStoreFetch

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

local extended = Roact.PureComponent:extend("DeveloperProductTile")

local strictInterface = t.strictInterface
local v6 = {
	universeId = t.string,
	developerProduct = t.table,
	developerProductThumbnail = t.string,
	pendingReceipts = t.optional(t.table),
	gridPositionRow = 0,
	gridPositionColumn = 0,
	networking = 0,
	rootPlaceId = 0,
	localUserId = 0,
	closeCentralOverlay = 0,
	requestPurchaseDeveloperProductWithUnifiedPurchasePrompt = 0,
	navigateDown = 0,
	fetchGameDeveloperProducts = 0,
	fetchExperienceStoreProducts = 0
}
local v7 = if module11() then t.optional(t.number) else nil
v6.gridPositionRow = v7
local v8 = if module11() then t.optional(t.number) else nil
v6.gridPositionColumn = v8

v6.networking = t.callback

v6.rootPlaceId = t.optional(t.string)
v6.localUserId = t.optional(t.string)

v6.closeCentralOverlay = t.callback
v6.requestPurchaseDeveloperProductWithUnifiedPurchasePrompt = t.optional(t.callback)
v6.navigateDown = t.callback
v6.fetchGameDeveloperProducts = t.callback
v6.fetchExperienceStoreProducts = t.optional(t.callback)
extended.validateProps = strictInterface(v6)

function extended:init()
	if module14 then
		self.ref = Roact.createRef()
	end

	local v9

	if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then
		v9 = getSubscriptionPurchaseCloseCallback()
	else
		v9 = nil
	end

	function self.viewDeveloperProductDetails(p2)
		return function()
			if module10() then
				module12.EdpStoreAnalyticsLogger.logEvent(
					constants.StoreEnums.ActionType.ItemClick,
					constants.StoreEnums.ProductType.DeveloperProducts,
					constants.StoreEnums.LocationType.Store,
					tonumber(self.props.universeId),
					p2.productId,
					(tostring(p2.productId))
				)
			end

			if self.isMounted then
				self.props.navigateDown({
					name = module4.GenericWebPage,
					detail = module5.economy.info.developerProduct({
						universeId = self.props.universeId,
						productId = p2.productId
					}),
					extraProps = {
						title = p2.name,
						transitionAnimation = module3.SlideInFromRight,
						onClose = if fFlagEnableBlackbirdPageCloseCallback then v9 else nil
					}
				})
			end
		end
	end

	function self.promptPurchaseWithUnifiedPurchasePrompt(p2, p3)
		local networking = self.props.networking
		local rootPlaceId = self.props.rootPlaceId
		local localUserId = self.props.localUserId
		local function onFlowComplete()
			self.props.closeCentralOverlay()
		end
		local function onPurchaseSuccess(p4)
			if p4 and p4.purchased then
				self.props.fetchGameDeveloperProducts(networking, p3, rootPlaceId, localUserId)
			end
		end
		local function onRobloxSubscriptionUpsellSuccess()
			self.props.fetchExperienceStoreProducts(self.props.networking, p3)
		end
		return function()
			self.props.requestPurchaseDeveloperProductWithUnifiedPurchasePrompt(
				p2,
				p3,
				onFlowComplete,
				onPurchaseSuccess,
				if fFlagIntegrateDiscountsWithEDP then onRobloxSubscriptionUpsellSuccess else nil
			)
		end
	end

	function self.onActivated()
		local developerProduct = self.props.developerProduct
		local universeId = self.props.universeId

		if module10() then
			module12.EdpStoreAnalyticsLogger.logEvent(
				constants.StoreEnums.ActionType.PurchaseAttemptClick,
				constants.StoreEnums.ProductType.DeveloperProducts,
				constants.StoreEnums.LocationType.Store,
				tonumber(universeId),
				developerProduct.productId,
				(tostring(developerProduct.productId))
			)
		end

		return self.promptPurchaseWithUnifiedPurchasePrompt(developerProduct, universeId)()
	end
end

function extended.render(props)
	local developerProduct = props.props.developerProduct
	local pendingReceipts = props.props.pendingReceipts
	local v9 = if pendingReceipts ~= nil then "x" .. tostring(#pendingReceipts) else nil
	local createElement = Roact.createElement
	local ref = Roact.Ref
	local v12 = if module14 then props.ref else nil
	return createElement(itemTile, {
		[ref] = v12,
		name = developerProduct.name,
		titleTextLineCount = 1,
		thumbnail = props.props.developerProductThumbnail,
		onActivated = props.viewDeveloperProductDetails(developerProduct),
		footer = Roact.createElement(module6, {
			price = developerProduct.priceInRobux,
			onActivated = props.onActivated
		}),
		statusText = v9,
		statusStyle = itemTileEnums.StatusStyle.Info
	})
end

function extended:didMount()
	self.isMounted = true

	if module14 then
		task.delay(0, function()
			local v9 = {
				universeId = tonumber(self.props.universeId),
				itemId = self.props.developerProduct.productId,
				targetId = tonumber(self.props.developerProduct.id),
				itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.DEVELOPER_PRODUCT
			}

			if module11() then
				v9.gridPositionRow = self.props.gridPositionRow
				v9.gridPositionColumn = self.props.gridPositionColumn
			end

			addUnifiedEventLogging(self.ref, v9, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

local v9 = RoactRodux.connect(function(data, p2)
	local productId = p2.developerProduct.productId
	local v10

	if fFlagLuaAppFixPassesPageStoreFetch then
		local developerProductStatus = data.DeveloperProductStatuses[p2.universeId]

		if developerProductStatus then
			v10 = developerProductStatus[tostring(productId)]
		end
	else
		v10 = data.DeveloperProductStatuses[p2.universeId][tostring(productId)]
	end

	local v12 = if data.GameDetails and data.GameDetails[p2.universeId] then data.GameDetails[p2.universeId].rootPlaceId else nil
	return { pendingReceipts = v10, rootPlaceId = v12, localUserId = data.LocalUserId }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(closeCentralOverlay())
		end,
		requestPurchaseDeveloperProductWithUnifiedPurchasePrompt = function(p2, p3, onFlowComplete, onPurchaseSuccess, onRobloxSubscriptionUpsellSuccess)
			local v12 = {
				productPayload = {
					kind = "Product",
					id = p2.productId,
					equipIfPurchased = false,
					universeId = p3
				},
				purchaseCallbacks = 0,
				purchaseAnalyticsMetadata = 0,
				purchaseOptions = 0
			}

			if not fFlagIntegrateDiscountsWithEDP then
				onRobloxSubscriptionUpsellSuccess = nil
			end

			v12.purchaseCallbacks = {
				onFlowComplete = onFlowComplete,
				onPurchaseSuccess = onPurchaseSuccess,
				onRobloxSubscriptionUpsellSuccess = onRobloxSubscriptionUpsellSuccess
			}

			v12.purchaseAnalyticsMetadata = {
				surface = productPurchaseSurface.EDP,
				productUniverseId = p3
			}

			v12.purchaseOptions = v5 and { enablePreloadedPurchaseUI = true } or nil
			return callback(module8(v12))
		end,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module(p2))
		end,
		fetchGameDeveloperProducts = function(p2, p3, p4, p5)
			return callback(module7(p2, p3, p4, p5))
		end,
		fetchExperienceStoreProducts = function(p2, p3)
			return callback(module9(p2, p3))
		end
	}
end)(extended)

return (roactServices.connect({ networking = module2 })(v9))
