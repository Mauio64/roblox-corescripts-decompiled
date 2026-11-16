local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Responsive")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RobloxSubscriptionPurchaseApp")
local blackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local constants = AvatarExperienceCommon.Constants
local offerExpiryBadge = AvatarExperienceCommon.Components.OfferExpiryBadge

local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPageHeader")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPageBody")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutBuyButton")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutTotalLines")
local CheckoutUnavailableButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutUnavailableButton")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/CartPricingForOffersTypes")
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local fFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge
local splitPaneStore = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SplitPane").SplitPaneStore else nil
local useSignalState = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState else nil

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function selectStatusBarHeight(p2)
	if p2 and p2.TopBar and p2.TopBar.statusBarHeight then
		return p2.TopBar.statusBarHeight
	end

	return 0
end

local function onActivated()
	RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
		onFlowComplete = function(p2) end
	}, nil, surfaceName.CatalogMultiItemCheckoutPage, surfaceContext.InApp, nil, nil)
end

local function CheckoutPage(props)
	local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/IAPExperience")
	local PurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/PurchasePrompt")

	local v5 = Foundation.Hooks.useTokens()
	local v6

	if fFlagEnableSplitPane then
		v6 = useSignalState(splitPaneStore.getStore().getIsBreakpointEnabled)
	else
		v6 = false
	end

	local v7

	if fFlagEnableSplitPane then
		v7 = useSignalState(splitPaneStore.getStore().getSupportWidthFraction)
	end

	local v8 = useSelector(selectDeviceOrientation)

	if fFlagEnableSplitPane and v6 then
		v8 = Responsive.Keys.Landscape
	end

	local v9 = v8 == Responsive.Keys.Portrait

	local v10 = useSelector(selectStatusBarHeight)

	local v11 = useLocalization({
		buyLabel = "Feature.Catalog.Action.Buy",
		wearAfterPurchaseLabel = "Feature.Catalog.Checkout.WearAfterPurchase",
		addToMyAvatarsLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
		addToMyMakeupLooksLabel = "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
		saveOptionsLabel = fFlagAXMISWithOffers and "Feature.Catalog.Label.SaveOptions" or nil
	})

	local v12 = React.useMemo(function(): boolean
		for k, cartItem in props.cartItems do
			if not constants.MAKEUP_LOOK_ASSET_TYPES[cartItem.itemSubType] then
				return true
			end
		end

		return false
	end, { props.cartItems })

	local v13 = if fFlagEnableSplitPane and v6 then v7 else constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE

	local v14 = if fFlagEnableSplitPane and v6 then 1 - v7 else constants.LANDSCAPE_UI_WIDTH_PERCENTAGE

	local udim = if v9 then UDim2.fromScale(1, 1) else UDim2.fromScale(v13, 1)
	local udim2 = if v9 then UDim2.fromScale(0, 0) else UDim2.fromScale(v14, 0)

	local v15 = React.useMemo(function()
		if not fFlagAXMISWithOffers then
			return nil
		end

		local children = {}

		if not props.offersAvailable then
			return children
		end

		for k, v16 in props.offersAvailable do
			local v17 = "Offer_" .. k
			local createElement = React.createElement

			local v19 = {
				Text = "",
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				LayoutOrder = 0,
				[React.Event.Activated] = function()
					if props.handleDeselectOfferId then
						props.handleDeselectOfferId(k)
					end
				end
			}
			local v21

			if fFlagAXUpdateOffersEndsUIWithBadge then
				local createElement2 = React.createElement
				local view = Foundation.View
				local v22 = {
					tag = "row gap-medium auto-xy align-y-center",
					Position = UDim2.fromOffset(v5.Stroke.Standard, 0)
				}
				local v23 = {
					Checkbox = React.createElement(Foundation.Checkbox, {
						label = v16.localizedDescription,
						isChecked = v16.selected,
						onActivated = function()
							if props.handleDeselectOfferId then
								props.handleDeselectOfferId(k)
							end
						end,
						size = Foundation.Enums.InputSize.Small,
						LayoutOrder = 1
					}),
					ExpiryBadge = 0
				}

				local v24 = if v16.expirationTimeUtc then React.createElement(offerExpiryBadge, {
					layoutOrder = 2,
					expirationTimeInUTC = v16.expirationTimeUtc
				}) else nil
				v23.ExpiryBadge = v24
				v21 = createElement2(view, v22, v23)
			else
				v21 = React.createElement(
					Foundation.View,
					{
						tag = "row gap-medium auto-xy align-y-center",
						Position = UDim2.fromOffset(v5.Stroke.Standard, 0)
					},
					{
						Checkbox = React.createElement(Foundation.Checkbox, {
							label = "",
							isChecked = v16.selected,
							onActivated = function()
								if props.handleDeselectOfferId then
									props.handleDeselectOfferId(k)
								end
							end,
							size = Foundation.Enums.InputSize.Small,
							LayoutOrder = 1
						}),
						Label = React.createElement(Foundation.Text, {
							Text = "<b>" .. v16.localizedDescription .. "</b>",
							RichText = true,
							tag = "text-body-small content-default auto-xy",
							LayoutOrder = 2
						})
					}
				)
			end

			children[v17] = createElement("TextButton", v19, { Content = v21 })
		end

		return children
	end, { props.offersAvailable, props.handleDeselectOfferId })

	if fFlagAXMISWithBlackbird then
		local blackbirdUpsellBannerProductInfo = PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo(props.robloxSubscriptionProducts)

		local createElement = React.createElement
		local v17 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0,
			Transparency = 1,
			[React.Tag] = fFlagEnableSplitPane and "data-testid=CheckoutPage" or nil,
			Size = udim,
			Position = udim2,
			Active = true,
			Visible = props.isVisible,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v10)
			}),
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CheckoutPageHeader = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				isDisabled = not props.isVisible,
				LayoutOrder = 1,
				testId = "CheckoutPageHeaderContainer"
			}, {
				Header = React.createElement(module10)
			}),
			CheckoutPageBodyScrollView = 0,
			CheckoutPageBuySection = 0
		}

		local createElement2 = React.createElement
		local scrollView = Foundation.ScrollView
		local v18 = {
			LayoutOrder = 2,
			isDisabled = props.isPurchasing,
			scroll = {
				scrollBarVisibility = Foundation.Enums.Visibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			},
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 1),
			selection = { Selectable = false }
		}

		local v19 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CheckoutPageBody = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y", LayoutOrder = 1 },
				{
					Body = React.createElement(module11, {
						cartItems = props.cartItems,
						erroredItemCount = props.erroredItemCount
					})
				}
			),
			CheckoutPageBuyOptions = 0
		}
		local v20

		if fFlagAXEnableExpiredUserLookCheckout and props.hideBuyOptions then
			local createElement3 = React.createElement
			local view = Foundation.View

			local v23 = if fFlagAXMISWithOffers and v15 and #Cryo.Dictionary.keys(v15) > 0 then React.createElement(React.Fragment, nil, v15) else nil
			v20 = createElement3(view, {
				tag = fFlagAXDurables2Option and "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium" or "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
				LayoutOrder = 3
			}, { OfferCheckboxes = v23 })
		else
			local createElement3 = React.createElement
			local view = Foundation.View

			local v23 = if fFlagAXMISWithOffers and v15 and #Cryo.Dictionary.keys(v15) > 0 then React.createElement(React.Fragment, nil, v15) else nil

			local v24 = if not fFlagAXMISWithOffers then React.createElement(Foundation.Checkbox, {
				label = v11.wearAfterPurchaseLabel,
				size = Foundation.Enums.InputSize.Small,
				isChecked = props.isWearAfterPurchaseChecked,
				onActivated = props.onWearAfterPurchaseToggle,
				isDisabled = props.isPurchasing,
				LayoutOrder = 1
			}) else nil
			local v25

			if not fFlagAXMISWithOffers then
				local createElement4 = React.createElement
				local checkbox = Foundation.Checkbox

				local v27 = if v12 then v11.addToMyAvatarsLabel else v11.addToMyMakeupLooksLabel
				v25 = createElement4(checkbox, {
					label = v27,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isAddToMyAvatarsChecked,
					onActivated = props.onAddToMyAvatarsToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 2
				})
			end

			local v26

			if fFlagAXMISWithOffers then
				local createElement4 = React.createElement
				local view2 = Foundation.View
				local v27 = {
					tag = "row align-y-center auto-xy",
					onActivated = props.onSaveOptionsOpenToggle,
					stateLayer = {
						affordance = Foundation.Enums.StateLayerAffordance.None
					},
					LayoutOrder = 1
				}

				local v28 = {
					Label = React.createElement(Foundation.Text, {
						Text = v11.saveOptionsLabel,
						tag = "auto-xy text-body-small",
						LayoutOrder = 1
					}),
					Chevron = 0
				}

				local createElement5 = React.createElement
				local icon = Foundation.Icon
				local v30 = if props.isSaveOptionsOpen then Foundation.Enums.IconName.ChevronSmallUp else Foundation.Enums.IconName.ChevronSmallDown
				v28.Chevron = createElement5(icon, {
					name = v30,
					size = Foundation.Enums.IconSize.Medium,
					LayoutOrder = 2
				})
				v26 = createElement4(view2, v27, v28)
			end

			local v27 = if fFlagAXMISWithOffers and props.isSaveOptionsOpen then React.createElement(Foundation.Checkbox, {
				label = v11.wearAfterPurchaseLabel,
				size = Foundation.Enums.InputSize.Small,
				isChecked = props.isWearAfterPurchaseChecked,
				onActivated = props.onWearAfterPurchaseToggle,
				isDisabled = props.isPurchasing,
				LayoutOrder = 2
			}) else nil
			local v28

			if fFlagAXMISWithOffers and props.isSaveOptionsOpen then
				local createElement4 = React.createElement
				local checkbox = Foundation.Checkbox

				local v30 = if v12 then v11.addToMyAvatarsLabel else v11.addToMyMakeupLooksLabel
				v28 = createElement4(checkbox, {
					label = v30,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isAddToMyAvatarsChecked,
					onActivated = props.onAddToMyAvatarsToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 3
				})
			end

			v20 = createElement3(view, {
				tag = fFlagAXDurables2Option and "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium" or "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
				LayoutOrder = 3
			}, {
				OfferCheckboxes = v23,
				CheckoutPageWearAfterPurchase = v24,
				AddToMyAvatars = v25,
				SaveOptions = v26,
				WearAfterPurchaseCheckbox = v27,
				AddToMyAvatarsCheckbox = v28
			})
		end

		v19.CheckoutPageBuyOptions = v20
		children.CheckoutPageBodyScrollView = createElement2(scrollView, v18, v19)

		local createElement3 = React.createElement
		local view = Foundation.View
		local v21 = {
			tag = "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-xxlarge padding-top-medium",
			LayoutOrder = 4,
			isDisabled = props.isPurchasing
		}
		local v22 = {
			CheckoutTotalLines = React.createElement(module13, {
				itemCount = tutils.fieldCount(props.cartItems),
				totalPrice = props.purchasableItemsTotalPriceInRobux,
				totalOriginalPrice = props.purchasableItemsTotalOriginalPriceInRobux,
				userRobuxBalance = 0,
				LayoutOrder = fFlagAXMISSmallUIChanges and 2 or 1
			}),
			DiscountSummary = 0,
			CheckoutBuyButton = 0,
			BlackbirdUpsellBanner = 0
		}

		local v23 = if props.discountSummaryProps then React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = fFlagAXMISSmallUIChanges and 1 or 2
		}, {
			Content = React.createElement(IAPExperience.DiscountSummary, props.discountSummaryProps)
		}) else nil
		v22.DiscountSummary = v23

		local v24 = if props.canPurchase then React.createElement(module12, {
			onCheckoutButtonActivated = props.onCheckoutButtonActivated,
			isPurchasing = props.isPurchasing,
			label = v11.buyLabel,
			LayoutOrder = 3
		}) else React.createElement(CheckoutUnavailableButton, {
			onActivated = props.onUnavailableButtonActivated,
			label = v11.buyLabel,
			LayoutOrder = 3
		})
		v22.CheckoutBuyButton = v24

		local v25 = if props.shouldShowBlackbirdUpsellBanner and blackbirdUpsellBannerProductInfo then React.createElement(blackbirdUpsellBanner, {
			productInfo = blackbirdUpsellBannerProductInfo,
			onActivated = onActivated,
			LayoutOrder = 4
		}) else nil
		v22.BlackbirdUpsellBanner = v25
		children.CheckoutPageBuySection = createElement3(view, v21, v22)
		return createElement("Frame", v17, children)
	else
		local createElement = React.createElement
		local v17 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0,
			Transparency = 1,
			[React.Tag] = fFlagEnableSplitPane and "data-testid=CheckoutPage" or nil,
			Size = udim,
			Position = udim2,
			Active = true,
			Visible = props.isVisible,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v10)
			}),
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CheckoutPageHeader = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				isDisabled = not props.isVisible,
				LayoutOrder = 1,
				testId = "CheckoutPageHeaderContainer"
			}, {
				Header = React.createElement(module10)
			}),
			CheckoutPageBodyScrollView = React.createElement(Foundation.ScrollView, {
				LayoutOrder = 2,
				isDisabled = props.isPurchasing,
				scroll = {
					scrollBarVisibility = Foundation.Enums.Visibility.None,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 1)
				},
				flexItem = { FlexMode = Enum.UIFlexMode.Fill },
				Size = UDim2.fromScale(1, 1),
				selection = { Selectable = false }
			}, {
				CheckoutPageBody = React.createElement(module11, {
					cartItems = props.cartItems,
					erroredItemCount = props.erroredItemCount
				})
			}),
			CheckoutPageBuyOptions = 0,
			CheckoutPageBuyBorder = 0,
			CheckoutPageBuySection = 0
		}
		local v18

		if not (fFlagAXEnableExpiredUserLookCheckout and props.hideBuyOptions) then
			local createElement2 = React.createElement
			local view = Foundation.View

			local v20 = {
				CheckoutPageWearAfterPurchase = React.createElement(Foundation.Checkbox, {
					label = v11.wearAfterPurchaseLabel,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isWearAfterPurchaseChecked,
					onActivated = props.onWearAfterPurchaseToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 1
				}),
				AddToMyAvatars = 0
			}

			local createElement3 = React.createElement
			local checkbox = Foundation.Checkbox

			local v22 = if v12 then v11.addToMyAvatarsLabel else v11.addToMyMakeupLooksLabel
			v20.AddToMyAvatars = createElement3(checkbox, {
				label = v22,
				size = Foundation.Enums.InputSize.Small,
				isChecked = props.isAddToMyAvatarsChecked,
				onActivated = props.onAddToMyAvatarsToggle,
				isDisabled = props.isPurchasing,
				LayoutOrder = 2
			})
			v18 = createElement2(
				view,
				{
					tag = "size-full-0 auto-y col gap-medium padding-x-xxlarge padding-y-medium",
					LayoutOrder = 3
				},
				v20
			)
		end

		children.CheckoutPageBuyOptions = v18

		children.CheckoutPageBuyBorder = React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 0, 1),
			backgroundStyle = v5.Color.Stroke.Muted,
			LayoutOrder = 4
		})

		local createElement2 = React.createElement
		local view = Foundation.View
		local v19 = {
			tag = "size-full-0 auto-y col gap-medium padding-xxlarge",
			LayoutOrder = 5,
			isDisabled = props.isPurchasing
		}
		local v20 = {
			CheckoutTotalLines = React.createElement(module13, {
				itemCount = tutils.fieldCount(props.cartItems),
				totalPrice = props.purchasableItemsTotalPriceInRobux,
				totalOriginalPrice = props.purchasableItemsTotalOriginalPriceInRobux,
				userRobuxBalance = 0
			}),
			CheckoutBuyButton = 0
		}

		local v21 = if props.canPurchase then React.createElement(module12, {
			onCheckoutButtonActivated = props.onCheckoutButtonActivated,
			isPurchasing = props.isPurchasing,
			label = v11.buyLabel
		}) else React.createElement(CheckoutUnavailableButton, {
			onActivated = props.onUnavailableButtonActivated,
			label = v11.buyLabel
		})
		v20.CheckoutBuyButton = v21
		children.CheckoutPageBuySection = createElement2(view, v19, v20)
		return createElement("Frame", v17, children)
	end
end

return React.memo(CheckoutPage, tutils.deepEqual)
