local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Constants = require(Modules.LuaApp.Constants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local AppPage = require(Modules.LuaApp.AppPage)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local t = require(CorePackages.Packages.t)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ItemTile = UIBlox.Tile.ItemTile
local ItemTileEnums = UIBlox.Tile.ItemTileEnums
local OpenCentralOverlayForPurchaseDeveloperProduct = require(Modules.LuaApp.Thunks.DeveloperProduct.OpenCentralOverlayForPurchaseDeveloperProduct)
local NavigateDownToRobuxUpsell = require(Modules.LuaApp.Thunks.Economy.NavigateDownToRobuxUpsell)
local RobuxUpsellTriggerContext = require(Modules.LuaApp.Components.RobuxUpsell.Enum.RobuxUpsellTriggerContext)
local DeveloperProductFooter = require(Modules.LuaApp.Components.DeveloperProduct.DeveloperProductFooter)
local PurchaseDeveloperProduct = require(Modules.LuaApp.Thunks.DeveloperProduct.PurchaseDeveloperProduct)
local ApiFetchGameDeveloperProducts = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchGameDeveloperProducts)
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local FetchExperienceStoreProducts = require(Modules.LuaApp.Thunks.Economy.FetchExperienceStoreProducts)
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local UniversalEconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = IAPExperience.Counters.EconomicRestrictionsCounter.EconomicRestrictionsSurface
local FFlagEnableUnifiedProductPurchaseFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants2 = EdpStoreAnalytics.Constants
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local SessionService = game:GetService("SessionService")
local FFlagEnableEdpStoreUnifiedLogging = require(Modules.LuaApp.Flags.FFlagEnableEdpStoreUnifiedLogging)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagUnifiedPurchaseAddSkeleton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local v49 = game:DefineFastFlag("UnifiedPurchaseAddSkeletonLoadingForDeveloperProduct", false) and FFlagUnifiedPurchaseAddSkeleton
local FFlagIntegrateDiscountsWithEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIntegrateDiscountsWithEDP
local FFlagLuaAppFixPassesPageStoreFetch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppFixPassesPageStoreFetch
local v52 = game:DefineFastFlag("ShipUnifiedPurchaseFlowToDeveloperProductEDP", false)
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback
local v55 = Roact.PureComponent:extend("DeveloperProductTile")

v55.validateProps = t.strictInterface({
	universeId = t.string,
	developerProduct = t.table,
	developerProductThumbnail = t.string,
	pendingReceipts = t.optional(t.table),
	gridPositionRow = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else t.optional(t.number),
	gridPositionColumn = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else t.optional(t.number),
	networking = t.callback,
	userRobux = t.optional(t.number),
	rootPlaceId = t.optional(t.string),
	localUserId = t.optional(t.string),
	closeCentralOverlay = t.callback,
	requestPurchaseDeveloperProduct = t.optional(t.callback),
	requestPurchaseDeveloperProductWithUnifiedPurchasePrompt = t.optional(t.callback),
	navigateDownToRobuxUpsell = t.callback,
	navigateDown = t.callback,
	purchaseDeveloperProduct = t.callback,
	fetchGameDeveloperProducts = t.callback,
	economicRestrictionErrorHandler = t.callback,
	fetchExperienceStoreProducts = t.optional(t.callback)
})

function v55.init(p1) -- line: 112
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), Roact (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants2 (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), Constants (copy), FFlagIntegrateDiscountsWithEDP (copy), v52 (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
	if FFlagEnableEdpStoreUnifiedLogging then
		p1.ref = Roact.createRef()
	end

	local v58 = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()

	function p1.viewDeveloperProductDetails(p2) -- line: 120
		-- upvalues: GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants2 (copy), p1 (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v58 (copy)
		return function() -- line: 121
			-- upvalues: GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants2 (copy), p1 (copy), p2 (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v58 (copy)
			if GetFFlagEnableEdpStoreClickLogging() then
				EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants2.StoreEnums.ActionType.ItemClick, Constants2.StoreEnums.ProductType.DeveloperProducts, Constants2.StoreEnums.LocationType.Store, tonumber(p1.props.universeId), p2.productId, (tostring(p2.productId)))
			end

			if p1.isMounted then
				p1.props.navigateDown({
					name = AppPage.GenericWebPage,
					detail = UrlBuilder.economy.info.developerProduct({
						universeId = p1.props.universeId,
						productId = p2.productId
					}),
					extraProps = {
						title = p2.name,
						transitionAnimation = TransitionAnimation.SlideInFromRight,
						onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else v58
					}
				})
			end
		end
	end
	function p1.customPurchaseErrorHandler(p3) -- line: 149
		-- upvalues: p1 (copy)
		if p3.errorCode == "PendingProductsLimitExceeded" then
			p1.props.openPendingProductsLimitExceededPrompt()
		end
	end
	function p1.fetchGameDeveloperProducts(p4, p5, p6, p7) -- line: 155
		-- upvalues: p1 (copy)
		p1.props.fetchGameDeveloperProducts(p4, p5, p6, p7)
	end
	function p1.promptPurchase(p8, _) -- line: 159
		-- upvalues: p1 (copy), Constants (copy)
		return function() -- line: 160
			-- upvalues: p1 (copy), Constants (copy), p8 (copy)
			local networking = p1.props.networking
			local userRobux = p1.props.userRobux
			local universeId = p1.props.universeId
			local rootPlaceId = p1.props.rootPlaceId
			local localUserId = p1.props.localUserId
			local t1 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = p8.priceInRobux,
				saleLocationId = universeId
			}

			if userRobux < p8.priceInRobux then
				p1.props.navigateDownToRobuxUpsell(p8.priceInRobux, userRobux, p8.name, nil, function() -- line: 177
					-- upvalues: p1 (copy), networking (copy), p8 (copy), t1 (copy), universeId (copy), rootPlaceId (copy), localUserId (copy)
					local v127 = p1.props.purchaseDeveloperProduct(networking, p8.productId, t1, p1.customPurchaseErrorHandler, p1.props.economicRestrictionErrorHandler)

					v127:andThen(function(_) -- line: 185
						-- upvalues: p1 (copy), networking (copy), universeId (copy), rootPlaceId (copy), localUserId (copy)
						p1.fetchGameDeveloperProducts(networking, universeId, rootPlaceId, localUserId)
					end, function(_) -- line: 187
					end)

					return v127
				end, p8.productId)

				return
			end

			p1.props.requestPurchaseDeveloperProduct(p8, universeId)
		end
	end
	function p1.promptPurchaseWithUnifiedPurchasePrompt(p12, p13) -- line: 198
		-- upvalues: p1 (copy), FFlagIntegrateDiscountsWithEDP (copy)
		local networking = p1.props.networking
		local rootPlaceId = p1.props.rootPlaceId
		local localUserId = p1.props.localUserId

		local function onFlowComplete() -- line: 202
			-- upvalues: p1 (copy)
			p1.props.closeCentralOverlay()
		end
		local function onPurchaseSuccess(p14) -- line: 205
			-- upvalues: p1 (copy), networking (copy), p13 (copy), rootPlaceId (copy), localUserId (copy)
			if p14 and p14.purchased then
				p1.props.fetchGameDeveloperProducts(networking, p13, rootPlaceId, localUserId)
			end
		end
		local function onRobloxSubscriptionUpsellSuccess() -- line: 210
			-- upvalues: p1 (copy), p13 (copy)
			p1.props.fetchExperienceStoreProducts(p1.props.networking, p13)
		end

		return function() -- line: 213
			-- upvalues: p1 (copy), p12 (copy), p13 (copy), onFlowComplete (copy), onPurchaseSuccess (copy), FFlagIntegrateDiscountsWithEDP (copy), onRobloxSubscriptionUpsellSuccess (copy)
			p1.props.requestPurchaseDeveloperProductWithUnifiedPurchasePrompt(p12, p13, onFlowComplete, onPurchaseSuccess, if not FFlagIntegrateDiscountsWithEDP then nil else onRobloxSubscriptionUpsellSuccess)
		end
	end
	function p1.onActivated() -- line: 224
		-- upvalues: p1 (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants2 (copy), v52 (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
		local developerProduct = p1.props.developerProduct
		local universeId = p1.props.universeId

		if GetFFlagEnableEdpStoreClickLogging() then
			EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants2.StoreEnums.ActionType.PurchaseAttemptClick, Constants2.StoreEnums.ProductType.DeveloperProducts, Constants2.StoreEnums.LocationType.Store, tonumber(universeId), developerProduct.productId, (tostring(developerProduct.productId)))
		end

		if v52 then
			return p1.promptPurchaseWithUnifiedPurchasePrompt(developerProduct, universeId)()
		end

		return getIsUserEligibleForUnifiedPurchaseFlow(p1.props.networking):andThen(function(p15) -- line: 241
			-- upvalues: p1 (copy), developerProduct (copy), universeId (copy)
			if p15 then
				return p1.promptPurchaseWithUnifiedPurchasePrompt(developerProduct, universeId)()
			end

			return p1.promptPurchase(developerProduct, universeId)()
		end):catch(function(_) -- line: 248
			-- upvalues: p1 (copy), developerProduct (copy), universeId (copy)
			return p1.promptPurchase(developerProduct, universeId)()
		end)
	end
end
function v55.render(p17) -- line: 255
	-- upvalues: Roact (copy), ItemTile (copy), FFlagEnableEdpStoreUnifiedLogging (copy), DeveloperProductFooter (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), ItemTileEnums (copy)
	local developerProduct = p17.props.developerProduct
	local pendingReceipts = p17.props.pendingReceipts
	local v62 = if pendingReceipts ~= nil then "x" .. tostring(#pendingReceipts) else nil

	return Roact.createElement(ItemTile, {
		[Roact.Ref] = if not FFlagEnableEdpStoreUnifiedLogging then nil else p17.ref,
		name = developerProduct.name,
		titleTextLineCount = 1,
		thumbnail = p17.props.developerProductThumbnail,
		onActivated = p17.viewDeveloperProductDetails(developerProduct),
		footer = Roact.createElement(DeveloperProductFooter, {
			price = developerProduct.priceInRobux,
			onActivated = if not FFlagEnableUnifiedProductPurchaseFlow then p17.promptPurchase(developerProduct, p17.props.universeId) else p17.onActivated
		}),
		statusText = v62,
		statusStyle = ItemTileEnums.StatusStyle.Info
	})
end
function v55.didMount(p18) -- line: 276
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), UnifiedEventLogEnums (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), addUnifiedEventLogging (copy), SessionService (copy)
	p18.isMounted = true

	if FFlagEnableEdpStoreUnifiedLogging then
		task.delay(0, function() -- line: 279
			-- upvalues: p18 (copy), UnifiedEventLogEnums (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), addUnifiedEventLogging (copy), SessionService (copy)
			local t2 = {
				universeId = tonumber(p18.props.universeId),
				itemId = p18.props.developerProduct.productId,
				targetId = tonumber(p18.props.developerProduct.id),
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.DEVELOPER_PRODUCT
			}

			if GetFFlagEnableEdpStoreGridPositionLogging() then
				t2.gridPositionRow = p18.props.gridPositionRow
				t2.gridPositionColumn = p18.props.gridPositionColumn
			end

			addUnifiedEventLogging(p18.ref, t2, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end
end
function v55.willUnmount(p19) -- line: 297
	p19.isMounted = false
end

local v56 = RoactRodux.connect(function(p20, p21) -- line: 301
	-- upvalues: FFlagLuaAppFixPassesPageStoreFetch (copy)
	local productId = p21.developerProduct.productId
	local v69

	if FFlagLuaAppFixPassesPageStoreFetch then
		local v68 = p20.DeveloperProductStatuses[p21.universeId]

		v69 = if not v68 then nil else v68[tostring(productId)]
	else
		v69 = p20.DeveloperProductStatuses[p21.universeId][tostring(productId)]
	end

	return {
		userRobux = p20.UserRobux[p20.LocalUserId],
		pendingReceipts = v69,
		rootPlaceId = if not p20.GameDetails or not p20.GameDetails[p21.universeId] then nil else p20.GameDetails[p21.universeId].rootPlaceId,
		localUserId = p20.LocalUserId
	}
end, function(p22) -- line: 318
	-- upvalues: CloseCentralOverlay (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagIntegrateDiscountsWithEDP (copy), ProductPurchaseSurface (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), v49 (copy), OpenCentralOverlayForPurchaseDeveloperProduct (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy), NavigateDownToRobuxUpsell (copy), RobuxUpsellTriggerContext (copy), PurchaseDeveloperProduct (copy), ApiFetchGameDeveloperProducts (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), FetchExperienceStoreProducts (copy)
	return {
		closeCentralOverlay = function() -- line: 320
			-- upvalues: p22 (copy), CloseCentralOverlay (copy)
			return p22(CloseCentralOverlay())
		end,
		requestPurchaseDeveloperProductWithUnifiedPurchasePrompt = function(p23, p24, p25, p26, p27) -- line: 323
			-- upvalues: p22 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagIntegrateDiscountsWithEDP (copy), ProductPurchaseSurface (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), v49 (copy)
			return p22(OpenCentralOverlayForUnifiedPurchasePrompt({
				productPayload = {
					kind = "Product",
					equipIfPurchased = false,
					id = p23.productId,
					universeId = p24
				},
				purchaseCallbacks = {
					onFlowComplete = p25,
					onPurchaseSuccess = p26,
					onRobloxSubscriptionUpsellSuccess = if not FFlagIntegrateDiscountsWithEDP then nil else p27
				},
				purchaseAnalyticsMetadata = {
					surface = ProductPurchaseSurface.EDP,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else p24
				},
				purchaseOptions = if not v49 then nil else {
					enablePreloadedPurchaseUI = true
				}
			}))
		end,
		requestPurchaseDeveloperProduct = function(p28, p29) -- line: 355
			-- upvalues: p22 (copy), OpenCentralOverlayForPurchaseDeveloperProduct (copy)
			return p22(OpenCentralOverlayForPurchaseDeveloperProduct(p28, p29))
		end,
		navigateDown = function(p30) -- line: 358
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v7 (copy), p22 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v7.down(v7.fromLegacyPage(p30))
			end

			return p22(NavigateDown(p30))
		end,
		navigateDownToRobuxUpsell = function(n1: number, n2: number, s1: string, s2: string, p31: ((...any) -> ...any), s3: string?) -- line: 365
			-- upvalues: p22 (copy), NavigateDownToRobuxUpsell (copy), RobuxUpsellTriggerContext (copy)
			return p22(NavigateDownToRobuxUpsell(RobuxUpsellTriggerContext.UADeveloperProduct, n1, n2, s1, s2, p31, s3))
		end,
		purchaseDeveloperProduct = function(p32, p33, p34, p35, p36) -- line: 385
			-- upvalues: p22 (copy), PurchaseDeveloperProduct (copy)
			return p22(PurchaseDeveloperProduct.Post(p32, p33, p34, p35, p36))
		end,
		fetchGameDeveloperProducts = function(p37, p38, p39, p40) -- line: 402
			-- upvalues: p22 (copy), ApiFetchGameDeveloperProducts (copy)
			return p22(ApiFetchGameDeveloperProducts(p37, p38, p39, p40))
		end,
		economicRestrictionErrorHandler = function(p41) -- line: 405
			-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p22 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
			local v114 = parseEconomicRestrictionsFailureReason(p41)
			local v115 = parseEconomicRestrictionsExpirationTimeInMinutes(p41)

			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.DeveloperProduct,
				failureReason = v114
			})

			return p22(OpenCentralOverlayForEconomicRestrictionPrompt(v114, v115))
		end,
		fetchExperienceStoreProducts = function(p42, p43) -- line: 414
			-- upvalues: p22 (copy), FetchExperienceStoreProducts (copy)
			return p22(FetchExperienceStoreProducts(p42, p43))
		end
	}
end)(v55)

return (RoactServices.connect({
	networking = RoactNetworking
})(v56))
