local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local AppPage = require(Modules.LuaApp.AppPage)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local t = require(CorePackages.Packages.t)
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Promise = require(CorePackages.Packages.Promise)
local ItemTile = require(CorePackages.Packages.UIBlox).Tile.ItemTile
local OpenCentralOverlayForPurchasePass = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPurchasePass)
local FetchExperienceStoreProducts = require(Modules.LuaApp.Thunks.Economy.FetchExperienceStoreProducts)
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local SessionService = game:GetService("SessionService")
local FFlagEnableEdpStoreUnifiedLogging = require(Modules.LuaApp.Flags.FFlagEnableEdpStoreUnifiedLogging)
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local PassFooter = require(Modules.LuaApp.Components.Passes.PassFooter)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local FFlagEnableUnifiedPurchasePromptForEDPGamepass = require(Modules.LuaApp.Flags.FFlagEnableUnifiedPurchasePromptForEDPGamepass)
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local v39 = Roact.PureComponent:extend("PassTile")
local FFlagAddUnifiedPurchaseFlowTTIToEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddUnifiedPurchaseFlowTTIToEDP
local FFlagUnifiedPurchasePassInProductInfoEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchasePassInProductInfoEDP
local FFlagUnifiedPurchaseAddSkeleton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local v43 = game:DefineFastFlag("UnifiedPurchaseAddSkeletonLoadingForEDPGamepass", false) and FFlagUnifiedPurchaseAddSkeleton
local FFlagIntegrateDiscountsWithEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIntegrateDiscountsWithEDP
local v45 = game:DefineFastFlag("ShipUnifiedPurchaseFlowToGamepassEDP", false)
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback

v39.validateProps = t.strictInterface({
	universeId = t.string,
	pass = t.table,
	passThumbnail = t.string,
	locationType = if not GetFFlagEnableEdpStoreClickLogging() then nil else t.optional(t.string),
	gridPositionRow = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else t.optional(t.number),
	gridPositionColumn = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else t.optional(t.number),
	networking = if not FFlagEnableUnifiedPurchasePromptForEDPGamepass then nil else t.optional(t.callback),
	userRobux = t.optional(t.number),
	requestPurchasePass = t.optional(t.callback),
	requestPurchasePassWithUnifiedPurchasePrompt = t.optional(t.callback),
	navigateDown = t.optional(t.callback),
	closeCentralOverlay = t.optional(t.callback),
	apiFetchGamePasses = t.optional(t.callback),
	fetchExperienceStoreProducts = t.optional(t.callback)
})

function v39.init(p1) -- line: 99
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), Roact (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), Promise (copy), FFlagIntegrateDiscountsWithEDP (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), FFlagEnableUnifiedPurchasePromptForEDPGamepass (copy), v45 (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy)
	if FFlagEnableEdpStoreUnifiedLogging then
		p1.ref = Roact.createRef()
	end

	function p1.promptPurchase(p2, p3) -- line: 103
		-- upvalues: p1 (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), Promise (copy), FFlagIntegrateDiscountsWithEDP (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), FFlagEnableUnifiedPurchasePromptForEDPGamepass (copy), v45 (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
		local function onFlowComplete() -- line: 104
			-- upvalues: p1 (copy)
			p1.props.closeCentralOverlay()
		end
		local function onPurchaseSuccess() -- line: 107
			-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), p3 (copy), p1 (copy)
			if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
				DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(p3)

				return
			end

			p1.props.apiFetchGamePasses(p1.props.networking, p3)
		end
		local function onRobloxSubscriptionUpsellSuccess() -- line: 114
			-- upvalues: p1 (copy), p3 (copy)
			p1.props.fetchExperienceStoreProducts(p1.props.networking, p3)
		end
		local function fetchProductInfo() -- line: 117
			-- upvalues: Promise (copy), p2 (copy), p1 (copy), FFlagIntegrateDiscountsWithEDP (copy)
			return Promise.resolve({
				IsForSale = true,
				TargetId = p2.id,
				Name = p2.displayName,
				Description = p2.displayDescription,
				PriceInRobux = p2.price,
				ImageUrl = p1.props.passThumbnail,
				ProductId = p2.productId,
				PriceDiscountDetails = if not FFlagIntegrateDiscountsWithEDP then nil else p2.priceDiscountDetails,
				BasePriceInRobux = if not FFlagIntegrateDiscountsWithEDP then nil else p2.userBasePriceInRobux
			})
		end

		return function() -- line: 130
			-- upvalues: GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), p1 (copy), p2 (copy), FFlagEnableUnifiedPurchasePromptForEDPGamepass (copy), v45 (copy), p3 (copy), onFlowComplete (copy), onPurchaseSuccess (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), fetchProductInfo (copy), FFlagIntegrateDiscountsWithEDP (copy), onRobloxSubscriptionUpsellSuccess (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
			if GetFFlagEnableEdpStoreClickLogging() then
				EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants.StoreEnums.ActionType.PurchaseAttemptClick, Constants.StoreEnums.ProductType.GamePasses, p1.props.locationType, tonumber(p1.props.universeId), tonumber(p2.id), (tostring(p2.id)))
			end

			if not p2.isOwned then
				if FFlagEnableUnifiedPurchasePromptForEDPGamepass then
					if v45 then
						p1.props.requestPurchasePassWithUnifiedPurchasePrompt(p2, p3, onFlowComplete, onPurchaseSuccess, if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else fetchProductInfo, if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else p1.props.userRobux, if not FFlagIntegrateDiscountsWithEDP then nil else onRobloxSubscriptionUpsellSuccess)

						return
					end

					getIsUserEligibleForUnifiedPurchaseFlow(p1.props.networking):andThen(function(p4) -- line: 156
						-- upvalues: p1 (copy), p2 (copy), p3 (copy), onFlowComplete (copy), onPurchaseSuccess (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), fetchProductInfo (copy), FFlagIntegrateDiscountsWithEDP (copy), onRobloxSubscriptionUpsellSuccess (copy)
						if p4 then
							p1.props.requestPurchasePassWithUnifiedPurchasePrompt(p2, p3, onFlowComplete, onPurchaseSuccess, if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else fetchProductInfo, if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else p1.props.userRobux, if not FFlagIntegrateDiscountsWithEDP then nil else onRobloxSubscriptionUpsellSuccess)

							return
						end

						p1.props.requestPurchasePass(p2, p3)
					end):catch(function() -- line: 171
						-- upvalues: p1 (copy), p2 (copy), p3 (copy)
						p1.props.requestPurchasePass(p2, p3)
					end)

					return
				end

				p1.props.requestPurchasePass(p2, p3)
			end
		end
	end

	local v50 = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()

	function p1.viewPassDetails(p5) -- line: 185
		-- upvalues: p1 (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v50 (copy)
		return function() -- line: 186
			-- upvalues: p1 (copy), GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), p5 (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), v50 (copy)
			if p1.isMounted then
				if GetFFlagEnableEdpStoreClickLogging() then
					EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants.StoreEnums.ActionType.ItemClick, Constants.StoreEnums.ProductType.GamePasses, p1.props.locationType, tonumber(p1.props.universeId), tonumber(p5.id), (tostring(p5.id)))
				end

				p1.props.navigateDown({
					name = AppPage.GenericWebPage,
					detail = UrlBuilder.game.info.pass({
						passId = p5.id
					}),
					extraProps = {
						title = p5.displayName,
						transitionAnimation = TransitionAnimation.SlideInFromRight,
						passOwned = p5.isOwned,
						onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else v50
					}
				})
			end
		end
	end
end
function v39.render(p6) -- line: 215
	-- upvalues: Roact (copy), ItemTile (copy), FFlagEnableEdpStoreUnifiedLogging (copy), PassFooter (copy)
	local pass = p6.props.pass

	return Roact.createElement(ItemTile, {
		[Roact.Ref] = if not FFlagEnableEdpStoreUnifiedLogging then nil else p6.ref,
		name = pass.displayName,
		titleTextLineCount = 1,
		thumbnail = p6.props.passThumbnail,
		onActivated = p6.viewPassDetails(pass),
		footer = Roact.createElement(PassFooter, {
			price = pass.price,
			userOwnsPass = pass.isOwned,
			onActivated = p6.promptPurchase(pass, p6.props.universeId)
		})
	})
end
function v39.didMount(p7) -- line: 232
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), UnifiedEventLogEnums (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), addUnifiedEventLogging (copy), SessionService (copy)
	p7.isMounted = true

	if FFlagEnableEdpStoreUnifiedLogging then
		task.delay(0, function() -- line: 235
			-- upvalues: p7 (copy), UnifiedEventLogEnums (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), addUnifiedEventLogging (copy), SessionService (copy)
			local t1 = {
				universeId = tonumber(p7.props.universeId),
				itemId = p7.props.pass.id,
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.GAME_PASS
			}

			if GetFFlagEnableEdpStoreGridPositionLogging() then
				t1.gridPositionRow = p7.props.gridPositionRow
				t1.gridPositionColumn = p7.props.gridPositionColumn
			end

			addUnifiedEventLogging(p7.ref, t1, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end
end
function v39.willUnmount(p8) -- line: 252
	p8.isMounted = false
end

local v48 = RoactRodux.connect((if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else function(p9, _) -- line: 257
	return {
		userRobux = p9.UserRobux[p9.LocalUserId]
	}
end), function(p11) -- line: 262
	-- upvalues: FFlagAddUnifiedPurchaseFlowTTIToEDP (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), OpenCentralOverlayForPurchasePass (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagIntegrateDiscountsWithEDP (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), v43 (copy), CorePackages (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), ApiFetchGamePasses (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy), FetchExperienceStoreProducts (copy)
	return {
		requestPurchasePass = function(p12, p13) -- line: 264
			-- upvalues: FFlagAddUnifiedPurchaseFlowTTIToEDP (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), p11 (copy), OpenCentralOverlayForPurchasePass (copy)
			if FFlagAddUnifiedPurchaseFlowTTIToEDP then
				local v68 = getTTIEventName(ProductPurchaseSurface.EDP)

				TimeToInteractiveTracker.trackStart(v68)
				TimeToInteractiveTracker.updateMetadata(v68, {
					category = "legacy_purchase_modal",
					page = ProductPurchaseSurface.EDP
				})
			end

			return p11(OpenCentralOverlayForPurchasePass(p12, p13))
		end,
		requestPurchasePassWithUnifiedPurchasePrompt = function(p14, p15, p16, p17, p18, p19, p20) -- line: 275
			-- upvalues: p11 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagIntegrateDiscountsWithEDP (copy), FFlagUnifiedPurchasePassInProductInfoEDP (copy), ProductPurchaseSurface (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), v43 (copy), FFlagAddUnifiedPurchaseFlowTTIToEDP (copy)
			return p11(OpenCentralOverlayForUnifiedPurchasePrompt({
				productPayload = {
					kind = "Gamepass",
					id = p14.id
				},
				purchaseCallbacks = {
					onFlowComplete = p16,
					onPurchaseSuccess = p17,
					onRobloxSubscriptionUpsellSuccess = if not FFlagIntegrateDiscountsWithEDP then nil else p20,
					fetchProductInfo = if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else p18
				},
				purchaseAnalyticsMetadata = {
					surface = ProductPurchaseSurface.EDP,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else p15
				},
				purchaseOptions = if not FFlagUnifiedPurchasePassInProductInfoEDP then nil else {
					shouldSkipOwnershipCheck = not p14.isOwned,
					providedRobuxBalance = p19,
					enablePreloadedPurchaseUI = not not v43 or nil
				}
			}, not not FFlagAddUnifiedPurchaseFlowTTIToEDP or nil))
		end,
		closeCentralOverlay = function() -- line: 309
			-- upvalues: CorePackages (copy), p11 (copy)
			local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay

			return p11(CloseCentralOverlay())
		end,
		apiFetchGamePasses = not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p21, p22) -- line: 316
			-- upvalues: p11 (copy), ApiFetchGamePasses (copy)
			return p11(ApiFetchGamePasses(p21, p22))
		end or nil,
		navigateDown = function(p23) -- line: 319
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v7 (copy), p11 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v7.down(v7.fromLegacyPage(p23))
			end

			return p11(NavigateDown(p23))
		end,
		fetchExperienceStoreProducts = if not FFlagIntegrateDiscountsWithEDP then nil else function(p24, p25) -- line: 327
			-- upvalues: p11 (copy), FetchExperienceStoreProducts (copy)
			return p11(FetchExperienceStoreProducts(p24, p25))
		end
	}
end)(v39)

if FFlagEnableUnifiedPurchasePromptForEDPGamepass then
	v48 = RoactServices.connect({
		networking = RoactNetworking
	})(v48)
end

return v48
