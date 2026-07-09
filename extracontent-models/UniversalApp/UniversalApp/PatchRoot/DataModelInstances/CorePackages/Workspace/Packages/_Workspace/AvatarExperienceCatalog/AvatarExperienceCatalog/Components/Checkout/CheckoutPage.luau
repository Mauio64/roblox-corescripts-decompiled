local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local React = require(AvatarExperienceCatalogParent.React)
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local Responsive = require(AvatarExperienceCatalogParent.Responsive)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local tutils = require(AvatarExperienceCatalogParent.tutils)
local SharedFlags = require(AvatarExperienceCatalogParent.SharedFlags)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local useSelector = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useSelector
local RobloxSubscriptionPurchaseApp = require(AvatarExperienceCatalogParent.RobloxSubscriptionPurchaseApp)
local BlackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local Constants = AvatarExperienceCommon.Constants
local CheckoutPageHeader = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPageHeader)
local CheckoutPageBody = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPageBody)
local CheckoutBuyButton = require(AvatarExperienceCatalog.Components.Checkout.CheckoutBuyButton)
local CheckoutTotalLines = require(AvatarExperienceCatalog.Components.Checkout.CheckoutTotalLines)
local CheckoutUnavailableButton = require(AvatarExperienceCatalog.Components.Checkout.CheckoutUnavailableButton)

require(AvatarExperienceCatalog.Api.PostCartPricingForOffers.CartPricingForOffersTypes)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers

local function selectDeviceOrientation(p1) -- line: 41
	return p1.DeviceOrientation
end
local function selectStatusBarHeight(p2) -- line: 68
	if p2 and (p2.TopBar and p2.TopBar.statusBarHeight) then
		return p2.TopBar.statusBarHeight
	end

	return 0
end
local function v29() -- line: 72
	-- upvalues: RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), SurfaceContext (copy)
	RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({
		showBackButton = true
	}, {
		onFlowComplete = function(_) -- line: 76
		end
	}, nil, SurfaceName.CatalogMultiItemCheckoutPage, SurfaceContext.InApp, nil, nil)
end
local function CheckoutPage(p4) -- line: 82
	-- upvalues: AvatarExperienceCatalogParent (copy), Foundation (copy), useSelector (copy), selectDeviceOrientation (copy), Responsive (copy), selectStatusBarHeight (copy), useLocalization (copy), FFlagAXMISWithOffers (copy), React (copy), Constants (copy), FFlagAXMISWithBlackbird (copy), CheckoutPageHeader (copy), CheckoutPageBody (copy), FFlagAXEnableExpiredUserLookCheckout (copy), Cryo (copy), CheckoutTotalLines (copy), tutils (copy), FFlagAXMISSmallUIChanges (copy), CheckoutBuyButton (copy), CheckoutUnavailableButton (copy), BlackbirdUpsellBanner (copy), v29 (copy)
	local IAPExperience = require(AvatarExperienceCatalogParent.IAPExperience)
	local PurchasePrompt = require(AvatarExperienceCatalogParent.PurchasePrompt)
	local v36 = Foundation.Hooks.useTokens()
	local v37 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v38 = useSelector(selectStatusBarHeight)
	local v39 = useLocalization({
		buyLabel = "Feature.Catalog.Action.Buy",
		wearAfterPurchaseLabel = "Feature.Catalog.Checkout.WearAfterPurchase",
		addToMyAvatarsLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
		addToMyMakeupLooksLabel = "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
		saveOptionsLabel = if not FFlagAXMISWithOffers then nil else "Feature.Catalog.Label.SaveOptions"
	})
	local v40 = React.useMemo(function() -- line: 101
		-- upvalues: p4 (copy), Constants (copy)
		for _, v47 in p4.cartItems do
			if not Constants.MAKEUP_LOOK_ASSET_TYPES[v47.itemSubType] then
				return true
			end
		end

		return false
	end, { p4.cartItems })
	local v41 = if not v37 then UDim2.fromScale(Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE, 1) else UDim2.fromScale(1, 1)
	local v42 = if not v37 then UDim2.fromScale(Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 0) else UDim2.fromScale(0, 0)
	local v43 = React.useMemo(function() -- line: 117
		-- upvalues: FFlagAXMISWithOffers (copy), p4 (copy), React (copy), Foundation (copy), v36 (copy)
		if not FFlagAXMISWithOffers then
			return nil
		end

		local t1 = {}

		if p4.offersAvailable then
			for v49, v50 in p4.offersAvailable do
				t1["Offer_" .. v49] = React.createElement("TextButton", {
					Text = "",
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Selectable = false,
					LayoutOrder = 0,
					[React.Event.Activated] = function() -- line: 135
						-- upvalues: p4 (copy), v49 (copy)
						if p4.handleDeselectOfferId then
							p4.handleDeselectOfferId(v49)
						end
					end
				}, {
					Content = React.createElement(Foundation.View, {
						tag = "row gap-medium auto-xy align-y-center",
						Position = UDim2.fromOffset(v36.Stroke.Standard, 0)
					}, {
						Checkbox = React.createElement(Foundation.Checkbox, {
							label = "",
							LayoutOrder = 1,
							isChecked = v50.selected,
							onActivated = function() -- line: 149
								-- upvalues: p4 (copy), v49 (copy)
								if p4.handleDeselectOfferId then
									p4.handleDeselectOfferId(v49)
								end
							end,
							size = Foundation.Enums.InputSize.Small
						}),
						Label = React.createElement(Foundation.Text, {
							RichText = true,
							tag = "text-body-small content-default auto-xy",
							LayoutOrder = 2,
							Text = "<b>" .. v50.localizedDescription .. "</b>"
						})
					})
				})
			end
		end

		return t1
	end, {
		p4.offersAvailable,
		p4.handleDeselectOfferId
	})

	if FFlagAXMISWithBlackbird then
		local v44 = PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo(p4.robloxSubscriptionProducts)

		return React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Transparency = 1,
			Active = true,
			SelectionGroup = true,
			BackgroundColor3 = v36.Color.Surface.Surface_0.Color3,
			Size = v41,
			Position = v42,
			Visible = p4.isVisible,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v38)
			}),
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CheckoutPageHeader = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 1,
				testId = "CheckoutPageHeaderContainer",
				isDisabled = not p4.isVisible
			}, {
				Header = React.createElement(CheckoutPageHeader)
			}),
			CheckoutPageBodyScrollView = React.createElement(Foundation.ScrollView, {
				LayoutOrder = 2,
				isDisabled = p4.isPurchasing,
				scroll = {
					scrollBarVisibility = Foundation.Enums.Visibility.None,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 1)
				},
				flexItem = {
					FlexMode = Enum.UIFlexMode.Fill
				},
				Size = UDim2.fromScale(1, 1),
				selection = {
					Selectable = false
				}
			}, {
				ListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				CheckoutPageBody = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					Body = React.createElement(CheckoutPageBody, {
						cartItems = p4.cartItems,
						erroredItemCount = p4.erroredItemCount
					})
				}),
				CheckoutPageBuyOptions = if not FFlagAXEnableExpiredUserLookCheckout or not p4.hideBuyOptions then React.createElement(Foundation.View, {
					tag = "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
					LayoutOrder = 3
				}, {
					OfferCheckboxes = if not FFlagAXMISWithOffers or (not v43 or not (#Cryo.Dictionary.keys(v43) > 0)) then nil else React.createElement(React.Fragment, nil, v43),
					CheckoutPageWearAfterPurchase = if FFlagAXMISWithOffers then nil else React.createElement(Foundation.Checkbox, {
						LayoutOrder = 1,
						label = v39.wearAfterPurchaseLabel,
						size = Foundation.Enums.InputSize.Small,
						isChecked = p4.isWearAfterPurchaseChecked,
						onActivated = p4.onWearAfterPurchaseToggle,
						isDisabled = p4.isPurchasing
					}),
					AddToMyAvatars = if FFlagAXMISWithOffers then nil else React.createElement(Foundation.Checkbox, {
						LayoutOrder = 2,
						label = if not v40 then v39.addToMyMakeupLooksLabel else v39.addToMyAvatarsLabel,
						size = Foundation.Enums.InputSize.Small,
						isChecked = p4.isAddToMyAvatarsChecked,
						onActivated = p4.onAddToMyAvatarsToggle,
						isDisabled = p4.isPurchasing
					}),
					SaveOptions = if not FFlagAXMISWithOffers then nil else React.createElement(Foundation.View, {
						tag = "row align-y-center auto-xy",
						LayoutOrder = 1,
						onActivated = p4.onSaveOptionsOpenToggle,
						stateLayer = {
							affordance = Foundation.Enums.StateLayerAffordance.None
						}
					}, {
						Label = React.createElement(Foundation.Text, {
							tag = "auto-xy text-body-small",
							LayoutOrder = 1,
							Text = v39.saveOptionsLabel
						}),
						Chevron = React.createElement(Foundation.Icon, {
							LayoutOrder = 2,
							name = if not p4.isSaveOptionsOpen then Foundation.Enums.IconName.ChevronSmallDown else Foundation.Enums.IconName.ChevronSmallUp,
							size = Foundation.Enums.IconSize.Medium
						})
					}),
					WearAfterPurchaseCheckbox = if not FFlagAXMISWithOffers or not p4.isSaveOptionsOpen then nil else React.createElement(Foundation.Checkbox, {
						LayoutOrder = 2,
						label = v39.wearAfterPurchaseLabel,
						size = Foundation.Enums.InputSize.Small,
						isChecked = p4.isWearAfterPurchaseChecked,
						onActivated = p4.onWearAfterPurchaseToggle,
						isDisabled = p4.isPurchasing
					}),
					AddToMyAvatarsCheckbox = if not FFlagAXMISWithOffers or not p4.isSaveOptionsOpen then nil else React.createElement(Foundation.Checkbox, {
						LayoutOrder = 3,
						label = if not v40 then v39.addToMyMakeupLooksLabel else v39.addToMyAvatarsLabel,
						size = Foundation.Enums.InputSize.Small,
						isChecked = p4.isAddToMyAvatarsChecked,
						onActivated = p4.onAddToMyAvatarsToggle,
						isDisabled = p4.isPurchasing
					})
				}) else React.createElement(Foundation.View, {
					tag = "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-medium padding-top-xxlarge",
					LayoutOrder = 3
				}, {
					OfferCheckboxes = if not FFlagAXMISWithOffers or (not v43 or not (#Cryo.Dictionary.keys(v43) > 0)) then nil else React.createElement(React.Fragment, nil, v43)
				})
			}),
			CheckoutPageBuySection = React.createElement(Foundation.View, {
				tag = "col gap-medium size-full-0 auto-y padding-x-xxlarge padding-bottom-xxlarge padding-top-medium",
				LayoutOrder = 4,
				isDisabled = p4.isPurchasing
			}, {
				CheckoutTotalLines = React.createElement(CheckoutTotalLines, {
					userRobuxBalance = 0,
					itemCount = tutils.fieldCount(p4.cartItems),
					totalPrice = p4.purchasableItemsTotalPriceInRobux,
					totalOriginalPrice = p4.purchasableItemsTotalOriginalPriceInRobux,
					LayoutOrder = not FFlagAXMISSmallUIChanges and 1 or 2
				}),
				DiscountSummary = if not p4.discountSummaryProps then nil else React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					LayoutOrder = not FFlagAXMISSmallUIChanges and 2 or 1
				}, {
					Content = React.createElement(IAPExperience.DiscountSummary, p4.discountSummaryProps)
				}),
				CheckoutBuyButton = if not p4.canPurchase then React.createElement(CheckoutUnavailableButton, {
					LayoutOrder = 3,
					onActivated = p4.onUnavailableButtonActivated,
					label = v39.buyLabel
				}) else React.createElement(CheckoutBuyButton, {
					LayoutOrder = 3,
					onCheckoutButtonActivated = p4.onCheckoutButtonActivated,
					isPurchasing = p4.isPurchasing,
					label = v39.buyLabel
				}),
				BlackbirdUpsellBanner = if not p4.shouldShowBlackbirdUpsellBanner or not v44 then nil else React.createElement(BlackbirdUpsellBanner, {
					LayoutOrder = 4,
					productInfo = v44,
					onActivated = v29
				})
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Transparency = 1,
		Active = true,
		SelectionGroup = true,
		BackgroundColor3 = v36.Color.Surface.Surface_0.Color3,
		Size = v41,
		Position = v42,
		Visible = p4.isVisible,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v38)
		}),
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		CheckoutPageHeader = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1,
			testId = "CheckoutPageHeaderContainer",
			isDisabled = not p4.isVisible
		}, {
			Header = React.createElement(CheckoutPageHeader)
		}),
		CheckoutPageBodyScrollView = React.createElement(Foundation.ScrollView, {
			LayoutOrder = 2,
			isDisabled = p4.isPurchasing,
			scroll = {
				scrollBarVisibility = Foundation.Enums.Visibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			},
			flexItem = {
				FlexMode = Enum.UIFlexMode.Fill
			},
			Size = UDim2.fromScale(1, 1),
			selection = {
				Selectable = false
			}
		}, {
			CheckoutPageBody = React.createElement(CheckoutPageBody, {
				cartItems = p4.cartItems,
				erroredItemCount = p4.erroredItemCount
			})
		}),
		CheckoutPageBuyOptions = if not FFlagAXEnableExpiredUserLookCheckout or not p4.hideBuyOptions then React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col gap-medium padding-x-xxlarge padding-y-medium",
			LayoutOrder = 3
		}, {
			CheckoutPageWearAfterPurchase = React.createElement(Foundation.Checkbox, {
				LayoutOrder = 1,
				label = v39.wearAfterPurchaseLabel,
				size = Foundation.Enums.InputSize.Small,
				isChecked = p4.isWearAfterPurchaseChecked,
				onActivated = p4.onWearAfterPurchaseToggle,
				isDisabled = p4.isPurchasing
			}),
			AddToMyAvatars = React.createElement(Foundation.Checkbox, {
				LayoutOrder = 2,
				label = if not v40 then v39.addToMyMakeupLooksLabel else v39.addToMyAvatarsLabel,
				size = Foundation.Enums.InputSize.Small,
				isChecked = p4.isAddToMyAvatarsChecked,
				onActivated = p4.onAddToMyAvatarsToggle,
				isDisabled = p4.isPurchasing
			})
		}) else nil,
		CheckoutPageBuyBorder = React.createElement(Foundation.View, {
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, 1),
			backgroundStyle = v36.Color.Stroke.Muted
		}),
		CheckoutPageBuySection = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col gap-medium padding-xxlarge",
			LayoutOrder = 5,
			isDisabled = p4.isPurchasing
		}, {
			CheckoutTotalLines = React.createElement(CheckoutTotalLines, {
				userRobuxBalance = 0,
				itemCount = tutils.fieldCount(p4.cartItems),
				totalPrice = p4.purchasableItemsTotalPriceInRobux,
				totalOriginalPrice = p4.purchasableItemsTotalOriginalPriceInRobux
			}),
			CheckoutBuyButton = if not p4.canPurchase then React.createElement(CheckoutUnavailableButton, {
				onActivated = p4.onUnavailableButtonActivated,
				label = v39.buyLabel
			}) else React.createElement(CheckoutBuyButton, {
				onCheckoutButtonActivated = p4.onCheckoutButtonActivated,
				isPurchasing = p4.isPurchasing,
				label = v39.buyLabel
			})
		})
	})
end

return React.memo(CheckoutPage, tutils.deepEqual)
