local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local tutils = require(parent.tutils)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local BlackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local Constants = AvatarExperienceCommon.Constants
local OfferExpiryBadge = AvatarExperienceCommon.Components.OfferExpiryBadge

local CheckoutPageHeader = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPageHeader)
local CheckoutPageBody = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPageBody)
local CheckoutBuyButton = require(AvatarExperienceCatalog.Components.Checkout.CheckoutBuyButton)
local CheckoutTotalLines = require(AvatarExperienceCatalog.Components.Checkout.CheckoutTotalLines)
local CheckoutUnavailableButton = require(AvatarExperienceCatalog.Components.Checkout.CheckoutUnavailableButton)
require(AvatarExperienceCatalog.Api.PostCartPricingForOffers.CartPricingForOffersTypes)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge
local splitPaneStore

if FFlagEnableSplitPane then
	local SplitPane = require(parent.SplitPane)
	splitPaneStore = SplitPane.SplitPaneStore
else
	splitPaneStore = nil
end

local useSignalState

if FFlagEnableSplitPane then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local function selectDeviceOrientation(p)
	return p.DeviceOrientation
end

local function selectStatusBarHeight(p)
	if p and p.TopBar and p.TopBar.statusBarHeight then
		return p.TopBar.statusBarHeight
	end

	return 0
end

local function onActivated()
	RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
		onFlowComplete = function(_) end
	}, nil, SurfaceName.CatalogMultiItemCheckoutPage, SurfaceContext.InApp, nil, nil)
end

local function CheckoutPage(props)
	local IAPExperience = require(parent.IAPExperience)
	local PurchasePrompt = require(parent.PurchasePrompt)

	local v = Foundation.Hooks.useTokens()
	local v2

	if FFlagEnableSplitPane then
		v2 = useSignalState(splitPaneStore.getStore().getIsBreakpointEnabled)
	else
		v2 = false
	end

	local v3

	if FFlagEnableSplitPane then
		v3 = useSignalState(splitPaneStore.getStore().getSupportWidthFraction)
	end

	local v4 = useSelector(selectDeviceOrientation)

	if FFlagEnableSplitPane and v2 then
		v4 = Responsive.Keys.Landscape
	end

	local v5 = v4 == Responsive.Keys.Portrait

	local v6 = useSelector(selectStatusBarHeight)

	local v7 = useLocalization({
		buyLabel = "Feature.Catalog.Action.Buy",
		wearAfterPurchaseLabel = "Feature.Catalog.Checkout.WearAfterPurchase",
		addToMyAvatarsLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
		addToMyMakeupLooksLabel = "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
		saveOptionsLabel = FFlagAXMISWithOffers and "Feature.Catalog.Label.SaveOptions" or nil
	})

	local v8 = React.useMemo(function(): boolean
		for _, cartItem in props.cartItems do
			if not Constants.MAKEUP_LOOK_ASSET_TYPES[cartItem.itemSubType] then
				return true
			end
		end

		return false
	end, { props.cartItems })
	local v9

	if FFlagEnableSplitPane and v2 then
		v9 = v3
	else
		v9 = Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE
	end

	local v10

	if FFlagEnableSplitPane and v2 then
		v10 = 1 - v3
	else
		v10 = Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
	end

	local udim

	if v5 then
		udim = UDim2.fromScale(1, 1)
	else
		udim = UDim2.fromScale(v9, 1)
	end

	local udim2

	if v5 then
		udim2 = UDim2.fromScale(0, 0)
	else
		udim2 = UDim2.fromScale(v10, 0)
	end

	local v11 = React.useMemo(function()
		if not FFlagAXMISWithOffers then
			return nil
		end

		local children = {}

		if not props.offersAvailable then
			return children
		end

		for k, v11 in props.offersAvailable do
			local v12 = "Offer_" .. k
			local createElement = React.createElement

			local v13 = {
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
			local content

			if FFlagAXUpdateOffersEndsUIWithBadge then
				local createElement2 = React.createElement
				local view = Foundation.View
				local v14 = {
					tag = "row gap-medium auto-xy align-y-center",
					Position = UDim2.fromOffset(v.Stroke.Standard, 0)
				}
				local v15 = {
					Checkbox = React.createElement(Foundation.Checkbox, {
						label = v11.localizedDescription,
						isChecked = v11.selected,
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
				local expiryBadge

				if v11.expirationTimeUtc then
					expiryBadge = React.createElement(OfferExpiryBadge, {
						layoutOrder = 2,
						expirationTimeInUTC = v11.expirationTimeUtc
					})
				end

				v15.ExpiryBadge = expiryBadge
				content = createElement2(view, v14, v15)
			else
				content = React.createElement(
					Foundation.View,
					{
						tag = "row gap-medium auto-xy align-y-center",
						Position = UDim2.fromOffset(v.Stroke.Standard, 0)
					},
					{
						Checkbox = React.createElement(Foundation.Checkbox, {
							label = "",
							isChecked = v11.selected,
							onActivated = function()
								if props.handleDeselectOfferId then
									props.handleDeselectOfferId(k)
								end
							end,
							size = Foundation.Enums.InputSize.Small,
							LayoutOrder = 1
						}),
						Label = React.createElement(Foundation.Text, {
							Text = "<b>" .. v11.localizedDescription .. "</b>",
							RichText = true,
							tag = "text-body-small content-default auto-xy",
							LayoutOrder = 2
						})
					}
				)
			end

			children[v12] = createElement("TextButton", v13, { Content = content })
		end

		return children
	end, { props.offersAvailable, props.handleDeselectOfferId })

	if FFlagAXMISWithBlackbird then
		local blackbirdUpsellBannerProductInfo = PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo(props.robloxSubscriptionProducts)

		local createElement = React.createElement
		local v12 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0,
			Transparency = 1,
			[React.Tag] = FFlagEnableSplitPane and "data-testid=CheckoutPage" or nil,
			Size = udim,
			Position = udim2,
			Active = true,
			Visible = props.isVisible,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}
		local children = {
			UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, v6) }),
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
				Header = React.createElement(CheckoutPageHeader)
			}),
			CheckoutPageBodyScrollView = 0,
			CheckoutPageBuySection = 0
		}

		local createElement2 = React.createElement
		local scrollView = Foundation.ScrollView
		local v13 = {
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

		local v14 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CheckoutPageBody = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Body = React.createElement(CheckoutPageBody, {
					cartItems = props.cartItems,
					erroredItemCount = props.erroredItemCount
				})
			}),
			CheckoutPageBuyOptions = 0
		}
		local checkoutPageBuyOptions

		if FFlagAXEnableExpiredUserLookCheckout and props.hideBuyOptions then
			local createElement3 = React.createElement
			local view = Foundation.View
			local offerCheckboxes

			if FFlagAXMISWithOffers and v11 and #Cryo.Dictionary.keys(v11) > 0 then
				offerCheckboxes = React.createElement(React.Fragment, nil, v11)
			end

			checkoutPageBuyOptions = createElement3(view, {
				tag = FFlagAXDurables2Option and "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium" or "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
				LayoutOrder = 3
			}, { OfferCheckboxes = offerCheckboxes })
		else
			local createElement3 = React.createElement
			local view = Foundation.View
			local offerCheckboxes

			if FFlagAXMISWithOffers and v11 and #Cryo.Dictionary.keys(v11) > 0 then
				offerCheckboxes = React.createElement(React.Fragment, nil, v11)
			end

			local checkoutPageWearAfterPurchase

			if not FFlagAXMISWithOffers then
				checkoutPageWearAfterPurchase = React.createElement(Foundation.Checkbox, {
					label = v7.wearAfterPurchaseLabel,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isWearAfterPurchaseChecked,
					onActivated = props.onWearAfterPurchaseToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 1
				})
			end

			local addToMyAvatars

			if not FFlagAXMISWithOffers then
				local createElement4 = React.createElement
				local checkbox = Foundation.Checkbox
				local label

				if v8 then
					label = v7.addToMyAvatarsLabel
				else
					label = v7.addToMyMakeupLooksLabel
				end

				addToMyAvatars = createElement4(checkbox, {
					label = label,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isAddToMyAvatarsChecked,
					onActivated = props.onAddToMyAvatarsToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 2
				})
			end

			local saveOptions

			if FFlagAXMISWithOffers then
				local createElement4 = React.createElement
				local view2 = Foundation.View
				local v15 = {
					tag = "row align-y-center auto-xy",
					onActivated = props.onSaveOptionsOpenToggle,
					stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
					LayoutOrder = 1
				}

				local v16 = {
					Label = React.createElement(Foundation.Text, {
						Text = v7.saveOptionsLabel,
						tag = "auto-xy text-body-small",
						LayoutOrder = 1
					}),
					Chevron = 0
				}

				local createElement5 = React.createElement
				local icon = Foundation.Icon
				local name

				if props.isSaveOptionsOpen then
					name = Foundation.Enums.IconName.ChevronSmallUp
				else
					name = Foundation.Enums.IconName.ChevronSmallDown
				end

				v16.Chevron = createElement5(icon, {
					name = name,
					size = Foundation.Enums.IconSize.Medium,
					LayoutOrder = 2
				})
				saveOptions = createElement4(view2, v15, v16)
			end

			local wearAfterPurchaseCheckbox

			if FFlagAXMISWithOffers and props.isSaveOptionsOpen then
				wearAfterPurchaseCheckbox = React.createElement(Foundation.Checkbox, {
					label = v7.wearAfterPurchaseLabel,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isWearAfterPurchaseChecked,
					onActivated = props.onWearAfterPurchaseToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 2
				})
			end

			local addToMyAvatarsCheckbox

			if FFlagAXMISWithOffers and props.isSaveOptionsOpen then
				local createElement4 = React.createElement
				local checkbox = Foundation.Checkbox
				local label

				if v8 then
					label = v7.addToMyAvatarsLabel
				else
					label = v7.addToMyMakeupLooksLabel
				end

				addToMyAvatarsCheckbox = createElement4(checkbox, {
					label = label,
					size = Foundation.Enums.InputSize.Small,
					isChecked = props.isAddToMyAvatarsChecked,
					onActivated = props.onAddToMyAvatarsToggle,
					isDisabled = props.isPurchasing,
					LayoutOrder = 3
				})
			end

			checkoutPageBuyOptions = createElement3(view, {
				tag = FFlagAXDurables2Option and "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium" or "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
				LayoutOrder = 3
			}, {
				OfferCheckboxes = offerCheckboxes,
				CheckoutPageWearAfterPurchase = checkoutPageWearAfterPurchase,
				AddToMyAvatars = addToMyAvatars,
				SaveOptions = saveOptions,
				WearAfterPurchaseCheckbox = wearAfterPurchaseCheckbox,
				AddToMyAvatarsCheckbox = addToMyAvatarsCheckbox
			})
		end

		v14.CheckoutPageBuyOptions = checkoutPageBuyOptions
		children.CheckoutPageBodyScrollView = createElement2(scrollView, v13, v14)

		local createElement3 = React.createElement
		local view = Foundation.View
		local v15 = {
			tag = "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-xxlarge padding-top-medium",
			LayoutOrder = 4,
			isDisabled = props.isPurchasing
		}
		local v16 = {
			CheckoutTotalLines = React.createElement(CheckoutTotalLines, {
				itemCount = tutils.fieldCount(props.cartItems),
				totalPrice = props.purchasableItemsTotalPriceInRobux,
				totalOriginalPrice = props.purchasableItemsTotalOriginalPriceInRobux,
				userRobuxBalance = 0,
				LayoutOrder = FFlagAXMISSmallUIChanges and 2 or 1
			}),
			DiscountSummary = 0,
			CheckoutBuyButton = 0,
			BlackbirdUpsellBanner = 0
		}
		local discountSummary

		if props.discountSummaryProps then
			discountSummary = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = FFlagAXMISSmallUIChanges and 1 or 2
			}, {
				Content = React.createElement(IAPExperience.DiscountSummary, props.discountSummaryProps)
			})
		end

		v16.DiscountSummary = discountSummary
		local checkoutBuyButton

		if props.canPurchase then
			checkoutBuyButton = React.createElement(CheckoutBuyButton, {
				onCheckoutButtonActivated = props.onCheckoutButtonActivated,
				isPurchasing = props.isPurchasing,
				label = v7.buyLabel,
				LayoutOrder = 3
			})
		else
			checkoutBuyButton = React.createElement(CheckoutUnavailableButton, {
				onActivated = props.onUnavailableButtonActivated,
				label = v7.buyLabel,
				LayoutOrder = 3
			})
		end

		v16.CheckoutBuyButton = checkoutBuyButton
		local blackbirdUpsellBanner

		if props.shouldShowBlackbirdUpsellBanner and blackbirdUpsellBannerProductInfo then
			blackbirdUpsellBanner = React.createElement(BlackbirdUpsellBanner, {
				productInfo = blackbirdUpsellBannerProductInfo,
				onActivated = onActivated,
				LayoutOrder = 4
			})
		end

		v16.BlackbirdUpsellBanner = blackbirdUpsellBanner
		children.CheckoutPageBuySection = createElement3(view, v15, v16)
		return createElement("Frame", v12, children)
	else
		local createElement = React.createElement
		local v12 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0,
			Transparency = 1,
			[React.Tag] = FFlagEnableSplitPane and "data-testid=CheckoutPage" or nil,
			Size = udim,
			Position = udim2,
			Active = true,
			Visible = props.isVisible,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}
		local children = {
			UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, v6) }),
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
				Header = React.createElement(CheckoutPageHeader)
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
				CheckoutPageBody = React.createElement(CheckoutPageBody, {
					cartItems = props.cartItems,
					erroredItemCount = props.erroredItemCount
				})
			}),
			CheckoutPageBuyOptions = 0,
			CheckoutPageBuyBorder = 0,
			CheckoutPageBuySection = 0
		}
		local checkoutPageBuyOptions

		if not (FFlagAXEnableExpiredUserLookCheckout and props.hideBuyOptions) then
			local createElement2 = React.createElement
			local view = Foundation.View

			local v13 = {
				CheckoutPageWearAfterPurchase = React.createElement(Foundation.Checkbox, {
					label = v7.wearAfterPurchaseLabel,
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
			local label

			if v8 then
				label = v7.addToMyAvatarsLabel
			else
				label = v7.addToMyMakeupLooksLabel
			end

			v13.AddToMyAvatars = createElement3(checkbox, {
				label = label,
				size = Foundation.Enums.InputSize.Small,
				isChecked = props.isAddToMyAvatarsChecked,
				onActivated = props.onAddToMyAvatarsToggle,
				isDisabled = props.isPurchasing,
				LayoutOrder = 2
			})
			checkoutPageBuyOptions = createElement2(
				view,
				{
					tag = "size-full-0 auto-y col gap-medium padding-x-xxlarge padding-y-medium",
					LayoutOrder = 3
				},
				v13
			)
		end

		children.CheckoutPageBuyOptions = checkoutPageBuyOptions

		children.CheckoutPageBuyBorder = React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 0, 1),
			backgroundStyle = v.Color.Stroke.Muted,
			LayoutOrder = 4
		})

		local createElement2 = React.createElement
		local view = Foundation.View
		local v13 = {
			tag = "size-full-0 auto-y col gap-medium padding-xxlarge",
			LayoutOrder = 5,
			isDisabled = props.isPurchasing
		}
		local v14 = {
			CheckoutTotalLines = React.createElement(CheckoutTotalLines, {
				itemCount = tutils.fieldCount(props.cartItems),
				totalPrice = props.purchasableItemsTotalPriceInRobux,
				totalOriginalPrice = props.purchasableItemsTotalOriginalPriceInRobux,
				userRobuxBalance = 0
			}),
			CheckoutBuyButton = 0
		}
		local checkoutBuyButton

		if props.canPurchase then
			checkoutBuyButton = React.createElement(CheckoutBuyButton, {
				onCheckoutButtonActivated = props.onCheckoutButtonActivated,
				isPurchasing = props.isPurchasing,
				label = v7.buyLabel
			})
		else
			checkoutBuyButton = React.createElement(CheckoutUnavailableButton, {
				onActivated = props.onUnavailableButtonActivated,
				label = v7.buyLabel
			})
		end

		v14.CheckoutBuyButton = checkoutBuyButton
		children.CheckoutPageBuySection = createElement2(view, v13, v14)
		return createElement("Frame", v12, children)
	end
end

return React.memo(CheckoutPage, tutils.deepEqual)
