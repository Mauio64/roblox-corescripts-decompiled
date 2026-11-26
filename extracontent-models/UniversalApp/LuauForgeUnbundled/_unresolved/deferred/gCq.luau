local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module2 = require("@luauforge/bundled/fBF")
local module3 = require("@luauforge/bundled/dFu")
local module4 = require("@luauforge/bundled/fzK")
local t = require(CorePackages.Packages.t)
local module5 = require("@luauforge/bundled/gCf")
local module6 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local Promise = require(CorePackages.Packages.Promise)

local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTile = UIBlox.Tile.ItemTile

local module7 = require("@luauforge/bundled/gCr")
local module8 = require("@luauforge/deferred/gCJ")
local constants = module8.Constants

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local SessionService = game:GetService("SessionService")
local module10 = require("@luauforge/deferred/gCK")

local module11 = require("@luauforge/deferred/fCN")
local productPurchaseSurface = require("@luauforge/deferred/fCQ").Enums.ProductPurchaseSurface

local module12 = require("@luauforge/deferred/gCL")
local module13 = require("@luauforge/bundled/dSY")

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local module14 = require("@luauforge/deferred/gCM")

local module15 = require("@luauforge/deferred/gCo")
local extended = Roact.PureComponent:extend("PassTile")

local fFlagAddUnifiedPurchaseFlowTTIToEDP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddUnifiedPurchaseFlowTTIToEDP

local fFlagUnifiedPurchasePassInProductInfoEDP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchasePassInProductInfoEDP

local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchaseAddSkeleton
local v5 = game:DefineFastFlag("UnifiedPurchaseAddSkeletonLoadingForEDPGamepass", false)
	and fFlagUnifiedPurchaseAddSkeleton

local fFlagIntegrateDiscountsWithEDP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagIntegrateDiscountsWithEDP

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fHh").Utils.getSubscriptionPurchaseCloseCallback

local strictInterface = t.strictInterface
local v6 = {
	universeId = t.string,
	pass = t.table,
	passThumbnail = t.string,
	locationType = 0,
	gridPositionRow = 0,
	gridPositionColumn = 0,
	networking = 0,
	userRobux = 0,
	requestPurchasePassWithUnifiedPurchasePrompt = 0,
	navigateDown = 0,
	closeCentralOverlay = 0,
	apiFetchGamePasses = 0,
	fetchExperienceStoreProducts = 0
}
local v7 = if module14() then t.optional(t.string) else nil
v6.locationType = v7
local v8 = if module15() then t.optional(t.number) else nil
v6.gridPositionRow = v8
local v9 = if module15() then t.optional(t.number) else nil
v6.gridPositionColumn = v9

v6.networking = t.optional(t.callback)

v6.userRobux = t.optional(t.number)

v6.requestPurchasePassWithUnifiedPurchasePrompt = t.optional(t.callback)
v6.navigateDown = t.optional(t.callback)
v6.closeCentralOverlay = t.optional(t.callback)
v6.apiFetchGamePasses = t.optional(t.callback)
v6.fetchExperienceStoreProducts = t.optional(t.callback)
extended.validateProps = strictInterface(v6)

function extended:init()
	if module10 then
		self.ref = Roact.createRef()
	end

	function self.promptPurchase(data, p2)
		local function onFlowComplete()
			self.props.closeCentralOverlay()
		end
		local function onPurchaseSuccess()
			if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
				module13.Game.getGamePassStore(false).fetchPassesForUniverse(p2)
			else
				self.props.apiFetchGamePasses(self.props.networking, p2)
			end
		end
		local function onRobloxSubscriptionUpsellSuccess()
			self.props.fetchExperienceStoreProducts(self.props.networking, p2)
		end
		local function fetchProductInfo()
			local resolve = Promise.resolve
			local v10 = {
				TargetId = data.id,
				IsForSale = true,
				Name = data.displayName,
				Description = data.displayDescription,
				PriceInRobux = data.price,
				ImageUrl = self.props.passThumbnail,
				ProductId = data.productId,
				PriceDiscountDetails = 0,
				BasePriceInRobux = 0
			}
			local v11 = if fFlagIntegrateDiscountsWithEDP then data.priceDiscountDetails else nil
			v10.PriceDiscountDetails = v11
			local v12 = if fFlagIntegrateDiscountsWithEDP then data.userBasePriceInRobux else nil
			v10.BasePriceInRobux = v12
			return resolve(v10)
		end

		return function()
			if module14() then
				module8.EdpStoreAnalyticsLogger.logEvent(
					constants.StoreEnums.ActionType.PurchaseAttemptClick,
					constants.StoreEnums.ProductType.GamePasses,
					self.props.locationType,
					tonumber(self.props.universeId),
					tonumber(data.id),
					(tostring(data.id))
				)
			end

			if not data.isOwned then
				local requestPurchasePassWithUnifiedPurchasePrompt = self.props.requestPurchasePassWithUnifiedPurchasePrompt
				local v14 = if fFlagUnifiedPurchasePassInProductInfoEDP then fetchProductInfo else nil
				local userRobux = if fFlagUnifiedPurchasePassInProductInfoEDP then self.props.userRobux else nil
				requestPurchasePassWithUnifiedPurchasePrompt(
					data,
					p2,
					onFlowComplete,
					onPurchaseSuccess,
					v14,
					userRobux,
					if fFlagIntegrateDiscountsWithEDP then onRobloxSubscriptionUpsellSuccess else nil
				)
			end
		end
	end

	local v10

	if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then
		v10 = getSubscriptionPurchaseCloseCallback()
	else
		v10 = nil
	end

	function self.viewPassDetails(data)
		return function()
			if self.isMounted then
				if module14() then
					module8.EdpStoreAnalyticsLogger.logEvent(
						constants.StoreEnums.ActionType.ItemClick,
						constants.StoreEnums.ProductType.GamePasses,
						self.props.locationType,
						tonumber(self.props.universeId),
						tonumber(data.id),
						(tostring(data.id))
					)
				end

				self.props.navigateDown({
					name = module3.GenericWebPage,
					detail = module4.game.info.pass({ passId = data.id }),
					extraProps = {
						title = data.displayName,
						transitionAnimation = module2.SlideInFromRight,
						passOwned = data.isOwned,
						onClose = if fFlagEnableBlackbirdPageCloseCallback then v10 else nil
					}
				})
			end
		end
	end
end

function extended.render(props)
	local pass = props.props.pass

	local createElement = Roact.createElement
	local ref = Roact.Ref
	local v12 = if module10 then props.ref else nil
	return createElement(itemTile, {
		[ref] = v12,
		name = pass.displayName,
		titleTextLineCount = 1,
		thumbnail = props.props.passThumbnail,
		onActivated = props.viewPassDetails(pass),
		footer = Roact.createElement(module12, {
			price = pass.price,
			userOwnsPass = pass.isOwned,
			onActivated = props.promptPurchase(pass, props.props.universeId)
		})
	})
end

function extended:didMount()
	self.isMounted = true

	if module10 then
		task.delay(0, function()
			local v10 = {
				universeId = tonumber(self.props.universeId),
				itemId = self.props.pass.id,
				itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.GAME_PASS
			}

			if module15() then
				v10.gridPositionRow = self.props.gridPositionRow
				v10.gridPositionColumn = self.props.gridPositionColumn
			end

			addUnifiedEventLogging(self.ref, v10, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

local v10 = RoactRodux.connect(fFlagUnifiedPurchasePassInProductInfoEDP and function(p2, p3)
	return { userRobux = p2.UserRobux[p2.LocalUserId] }
end or nil, function(callback)
	return {
		requestPurchasePassWithUnifiedPurchasePrompt = function(p2, p3, onFlowComplete, onPurchaseSuccess, fetchProductInfo, p4, onRobloxSubscriptionUpsellSuccess)
			local v13 = {
				productPayload = { id = p2.id, kind = "Gamepass" },
				purchaseCallbacks = 0,
				purchaseAnalyticsMetadata = 0,
				purchaseOptions = 0
			}

			if not fFlagIntegrateDiscountsWithEDP then
				onRobloxSubscriptionUpsellSuccess = nil
			end

			if not fFlagUnifiedPurchasePassInProductInfoEDP then
				fetchProductInfo = nil
			end

			v13.purchaseCallbacks = {
				onFlowComplete = onFlowComplete,
				onPurchaseSuccess = onPurchaseSuccess,
				onRobloxSubscriptionUpsellSuccess = onRobloxSubscriptionUpsellSuccess,
				fetchProductInfo = fetchProductInfo
			}

			v13.purchaseAnalyticsMetadata = {
				surface = productPurchaseSurface.EDP,
				productUniverseId = p3
			}

			v13.purchaseOptions = fFlagUnifiedPurchasePassInProductInfoEDP and {
				shouldSkipOwnershipCheck = not p2.isOwned,
				providedRobuxBalance = p4,
				enablePreloadedPurchaseUI = v5 and true or nil
			} or nil
			return callback(module11(v13, fFlagAddUnifiedPurchaseFlowTTIToEDP and true or nil))
		end,
		closeCentralOverlay = function()
			return callback(require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay())
		end,
		apiFetchGamePasses = not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p2, p3)
			return callback(module5(p2, p3))
		end or nil,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module(p2))
		end,
		fetchExperienceStoreProducts = fFlagIntegrateDiscountsWithEDP and function(p2, p3)
			return callback(module7(p2, p3))
		end or nil
	}
end)(extended)

return (roactServices.connect({ networking = module6 })(v10))
