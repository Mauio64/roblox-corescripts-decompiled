local GuiService = game:GetService("GuiService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local React = require(PurchasePromptParent.React)

require(PurchasePromptParent.IAPExperience)
game:GetService("CoreGui"):WaitForChild("RobloxGui")

local CoreScriptsRootProvider = require(PurchasePromptParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(PurchasePromptParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Navigation = require(PurchasePromptParent.Navigation)
local Cryo = require(PurchasePromptParent.Cryo)
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

require(PurchasePrompt.Models.RobuxUpsell)

local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local purchaseItem = require(PurchasePrompt.Thunks.purchaseItem)
local launchRobuxUpsell = require(PurchasePrompt.Thunks.launchRobuxUpsell)
local openRobuxStore = require(PurchasePrompt.Thunks.openRobuxStore)
local openSecuritySettings = require(PurchasePrompt.Thunks.openSecuritySettings)
local openTermsOfUse = require(PurchasePrompt.Thunks.openTermsOfUse)

require(PurchasePrompt.Thunks.initiatePurchasePrecheck)

local initiateUserPurchaseSettingsPrecheck = require(PurchasePrompt.Thunks.initiateUserPurchaseSettingsPrecheck)
local fetchCartPricing = require(PurchasePrompt.Thunks.fetchCartPricing)
local selectCartPricingResponse = require(PurchasePrompt.Selectors.selectCartPricingResponse)
local selectIsCartPricingFetching = require(PurchasePrompt.Selectors.selectIsCartPricingFetching)
local sendEvent = require(PurchasePrompt.Thunks.sendEvent)
local isMockingPurchases = require(PurchasePrompt.Utils.isMockingPurchases)
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local isLinksAllowed = require(PurchasePrompt.Utils.isLinksAllowed)
local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local connectToStore = require(PurchasePrompt.connectToStore)
local ExternalEventConnection = require(PurchasePrompt.Components.Connection.ExternalEventConnection)
local GetFFLagUseCoreScriptsRootProviderForUpsellModal = require(PurchasePrompt.Flags.GetFFLagUseCoreScriptsRootProviderForUpsellModal)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)
local UpsellSuggestionsAPIMaxPackages = require(PurchasePromptParent.SharedFlags).UpsellSuggestionsAPIMaxPackages
local RobuxUpsellOverlay = require(script.Parent.RobuxUpsellOverlay)
local AppPage = require(PurchasePromptParent.RobloxAppEnums).AppPage
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local FFlagSkipBuyDelayForExperienceShop = require(PurchasePrompt.Flags.FFlagSkipBuyDelayForExperienceShop)
local v42 = Roact.Component:extend(script.Name)

function v42.init(p1) -- line: 63
	-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagPurchasePromptCartPricingEnabled (copy), AppPage (copy)
	p1.state = {
		screenSize = Vector2.new(0, 0)
	}

	function p1.changeScreenSize(p2) -- line: 71
		-- upvalues: p1 (copy)
		if p1.state.screenSize ~= p2.AbsoluteSize then
			p1:setState({
				screenSize = p2.AbsoluteSize
			})
		end
	end

	if FFlagEnableUnifiedProductPurchaseFlow then
		if FFlagPurchasePromptCartPricingEnabled then
			function p1.fetchCartPricingForPurchasePrompt(_: boolean, t1: {[any]: any}?) -- line: 81
				-- upvalues: p1 (copy)
				if t1 == nil then
					return nil
				end

				return p1.props.fetchCartPricing(t1)
			end
		end

		function p1.navigateToBuyRobux() -- line: 91
			-- upvalues: p1 (copy), AppPage (copy)
			p1.props.navigation.navigate(AppPage.PurchaseRobux)
		end
		function p1.navigateToTermsOfUse() -- line: 95
			-- upvalues: p1 (copy)
			p1.props.openTermsOfUse(p1.props.navigation)
		end
	end
end
function v42.createElement(p3) -- line: 101
	-- upvalues: PurchaseFlow (copy), isLinksAllowed (copy), Roact (copy), RobuxUpsellOverlay (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), UpsellSuggestionsAPIMaxPackages (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagPurchasePromptCartPricingEnabled (copy), getPlayerPrice (copy), FFlagSkipBuyDelayForExperienceShop (copy), ExternalEventConnection (copy), GuiService (copy), FFlagSetMenuOnPurchasePrompt (copy)
	local props = p3.props
	local state = p3.state

	if props.purchaseFlow ~= PurchaseFlow.RobuxUpsellV2 and props.purchaseFlow ~= PurchaseFlow.LargeRobuxUpsell then
		return nil
	end

	local v48 = isLinksAllowed()
	local imageUrl = props.productInfo.imageUrl

	if string.find(props.productInfo.imageUrl, "assetid=0") then
		imageUrl = nil
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = p3.changeScreenSize,
		BackgroundTransparency = 1
	}, {
		Prompt = Roact.createElement(RobuxUpsellOverlay, {
			screenSize = state.screenSize,
			virtualItemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else props.virtualItemPrice,
			requestType = props.requestType,
			promptState = props.promptState,
			purchaseFlow = props.purchaseFlow,
			purchaseError = props.purchaseError,
			economicRestrictionError = props.economicRestrictionError,
			useUpsellSuggestions = UpsellSuggestionsAPIMaxPackages > 1,
			upsellSuggestions = props.robuxSuggestions,
			selectedUpsellIndex = props.robuxPackageSelection,
			virtualItemBadgeType = props.virtualItemBadgeType,
			onUpsellSuggestionsSelected = function(n1: number) -- line: 137
				-- upvalues: props (copy)
				props.onUpsellSuggestionsSelected(props.robuxSuggestions, n1, props.virtualItemBadgeType)
			end,
			useUnifiedProductPurchaseModal = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p3.props.isUserEligibleForUnifiedPurchaseFlow,
			purchaseAnalyticsMetadata = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p3.props.purchaseAnalyticsMetadata,
			cartPricingResponse = if not FFlagPurchasePromptCartPricingEnabled then nil else props.cartPricingResponse,
			collectibleItemId = if not FFlagPurchasePromptCartPricingEnabled then nil else props.collectibleItemId,
			isCartPricingLoading = if not FFlagPurchasePromptCartPricingEnabled then nil else props.isCartPricingLoading,
			onCartOfferAppliedChanged = if not FFlagPurchasePromptCartPricingEnabled then nil else p3.fetchCartPricingForPurchasePrompt,
			postPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else props.postPurchaseActions,
			setPostPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else props.setPostPurchaseActions,
			robuxProviderId = props.robuxProductId,
			robuxProductId = props.productId,
			itemIcon = imageUrl,
			itemProductId = props.productInfo.productId,
			itemName = props.productInfo.name,
			itemRobuxCost = getPlayerPrice(props.productInfo, props.accountInfo.membershipType == 4, props.expectedPrice),
			iapRobuxAmount = props.robuxPurchaseAmount or 0,
			iapCostStr = props.price,
			beforeRobuxBalance = props.accountInfo.balance,
			isTestPurchase = props.isTestPurchase,
			isGamepadEnabled = props.isGamepadEnabled,
			isFromInExperienceShop = if not FFlagSkipBuyDelayForExperienceShop then nil else props.isFromInExperienceShop,
			purchaseItem = props.purchaseItem,
			promptRobuxPurchase = props.promptRobuxPurchase,
			openRobuxStore = if not FFlagEnableUnifiedProductPurchaseFlow or not p3.props.isUserEligibleForUnifiedPurchaseFlow then props.openRobuxStore else p3.navigateToBuyRobux,
			openTermsOfUse = v48 and (if not FFlagEnableUnifiedProductPurchaseFlow then props.openTermsOfUse else p3.navigateToTermsOfUse) or nil,
			openSecuritySettings = v48 and props.openSecuritySettings or nil,
			dispatchFetchPurchaseWarning = props.dispatchFetchPurchaseWarning,
			endPurchase = props.completeRequest,
			onAnalyticEvent = props.onAnalyticEvent,
			humanoidModel = props.humanoidModel
		}),
		ModalFix = Roact.createElement("ImageButton", {
			BackgroundTransparency = 0,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function() -- line: 203
				-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), p3 (copy), props (copy)
				if FFlagSetMenuOnPurchasePrompt and p3.menuOpenedBySelf then
					p3.menuOpenedBySelf = false

					return
				end

				props.completeRequest()
			end
		})
	})
end
function v42.render(p4) -- line: 214
	-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), GuiService (copy), GetFFLagUseCoreScriptsRootProviderForUpsellModal (copy), Roact (copy), CoreScriptsRootProvider (copy), React (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v51 = p4:createElement()

	if FFlagSetMenuOnPurchasePrompt then
		if v51 ~= nil then
			p4.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(v51 ~= nil, "RobuxUpsellContainer")
	end

	if GetFFLagUseCoreScriptsRootProviderForUpsellModal() then
		return Roact.createElement(CoreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
			}, {
				RobuxUpsellContainer = v51
			})
		})
	end

	return v51
end

if FFlagEnableUnifiedProductPurchaseFlow then
	local v43 = v42

	function v42(p5) -- line: 240
		-- upvalues: Navigation (copy), Roact (copy), v43 (copy), Cryo (copy)
		local v53 = Navigation.useNavigation()

		return Roact.createElement(v43, Cryo.Dictionary.join(p5, {
			navigation = v53
		}))
	end
end

return (connectToStore(function(p6) -- line: 253
	-- upvalues: isMockingPurchases (copy), FFlagPurchasePromptCartPricingEnabled (copy), SelectedRobuxPackage (copy), FFlagSkipBuyDelayForExperienceShop (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), selectPrice (copy), selectCartPricingResponse (copy), selectIsCartPricingFetching (copy)
	local v55 = isMockingPurchases(p6.promptRequest.requestType)
	local collectibleItemId = nil

	if FFlagPurchasePromptCartPricingEnabled then
		collectibleItemId = p6.productInfo.collectibleItemId

		if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
			local collectibleItemId2 = p6.promptRequest.collectibleItemId

			collectibleItemId = if type(collectibleItemId2) ~= "string" or collectibleItemId2 == "" then nil else collectibleItemId2
		end
	end

	return {
		purchaseFlow = p6.purchaseFlow,
		requestType = p6.promptRequest.requestType,
		expectedPrice = p6.promptRequest.expectedPrice,
		promptState = p6.promptState,
		purchaseError = p6.purchaseError,
		economicRestrictionError = p6.economicRestrictionError,
		productInfo = p6.productInfo,
		accountInfo = p6.accountInfo,
		robuxSuggestions = p6.robuxUpsellSuggestions.products,
		robuxPackageSelection = p6.robuxUpsellSuggestions.selection,
		virtualItemBadgeType = p6.robuxUpsellSuggestions.virtualItemBadgeType,
		robuxProductId = SelectedRobuxPackage.getRobuxProductId(p6),
		productId = SelectedRobuxPackage.getProductId(p6),
		robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(p6),
		robuxAmountBeforeBonus = SelectedRobuxPackage.getRobuxAmountBeforeBonus(p6),
		price = SelectedRobuxPackage.getPrice(p6),
		isTestPurchase = v55,
		isGamepadEnabled = p6.gamepadEnabled,
		isFromInExperienceShop = if not FFlagSkipBuyDelayForExperienceShop then nil else p6.productPayload and p6.productPayload.isFromInExperienceShop,
		humanoidModel = p6.promptRequest.humanoidModel,
		isUserEligibleForUnifiedPurchaseFlow = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p6.isUserEligibleForUnifiedPurchaseFlow,
		purchaseAnalyticsMetadata = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p6.purchaseAnalyticsMetadata,
		virtualItemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else selectPrice(p6),
		collectibleItemId = if not FFlagPurchasePromptCartPricingEnabled then nil else collectibleItemId,
		cartPricingResponse = if not FFlagPurchasePromptCartPricingEnabled then nil else selectCartPricingResponse(p6),
		isCartPricingLoading = if not FFlagPurchasePromptCartPricingEnabled then nil else selectIsCartPricingFetching(p6),
		postPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else p6.postPurchaseActions
	}
end, function(p7) -- line: 310
	-- upvalues: purchaseItem (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy), launchRobuxUpsell (copy), openRobuxStore (copy), openSecuritySettings (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), openTermsOfUse (copy), initiateUserPurchaseSettingsPrecheck (copy), GuiService (copy), completeRequest (copy), PromptNativeUpsellSuggestions (copy), sendEvent (copy), SetPostPurchaseActions (copy)
	return {
		purchaseItem = function() -- line: 312
			-- upvalues: p7 (copy), purchaseItem (copy)
			return p7(purchaseItem())
		end,
		fetchCartPricing = if not FFlagPurchasePromptCartPricingEnabled then nil else function(t2: {[any]: any}?) -- line: 316
			-- upvalues: p7 (copy), fetchCartPricing (copy)
			return p7(fetchCartPricing(t2))
		end,
		promptRobuxPurchase = function() -- line: 320
			-- upvalues: p7 (copy), launchRobuxUpsell (copy)
			return p7(launchRobuxUpsell())
		end,
		openRobuxStore = function() -- line: 323
			-- upvalues: p7 (copy), openRobuxStore (copy)
			return p7(openRobuxStore())
		end,
		openSecuritySettings = function() -- line: 326
			-- upvalues: p7 (copy), openSecuritySettings (copy)
			return p7(openSecuritySettings())
		end,
		openTermsOfUse = function(p8) -- line: 329
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p7 (copy), openTermsOfUse (copy)
			if FFlagEnableUnifiedProductPurchaseFlow then
				return p7(openTermsOfUse(p8))
			end

			return p7(openTermsOfUse())
		end,
		dispatchFetchPurchaseWarning = function() -- line: 335
			-- upvalues: p7 (copy), initiateUserPurchaseSettingsPrecheck (copy)
			return p7(initiateUserPurchaseSettingsPrecheck())
		end,
		completeRequest = function() -- line: 338
			-- upvalues: GuiService (copy), p7 (copy), completeRequest (copy)
			GuiService.SelectedCoreObject = nil

			return p7(completeRequest())
		end,
		onUpsellSuggestionsSelected = function(t3: {[any]: any}, n2: number, s1: string) -- line: 342
			-- upvalues: p7 (copy), PromptNativeUpsellSuggestions (copy)
			return p7(PromptNativeUpsellSuggestions(t3, n2, s1))
		end,
		onAnalyticEvent = function(p9, p10) -- line: 349
			-- upvalues: p7 (copy), sendEvent (copy)
			return p7(sendEvent(p9, p10))
		end,
		setPostPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else function(p11) -- line: 353
			-- upvalues: p7 (copy), SetPostPurchaseActions (copy)
			p7(SetPostPurchaseActions(p11))
		end
	}
end)(v42))
