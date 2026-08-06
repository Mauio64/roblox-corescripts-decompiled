local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local DisplayBackground = require(ProfilePlatformParent.EditProfileBackground).DisplayBackground
local BuyActionBar = require(ProfilePlatformParent.AvatarExperienceInspectAndBuy).Components.BuyActionBar
local Dash = require(ProfilePlatformParent.Dash)
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(ProfilePlatformParent.InputHandlers)
local FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FFlagProfileInspectAvatarBuyAll = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBuyAll)
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local Divider = Foundation.Divider
local Skeleton = Foundation.Skeleton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization

require(ProfilePlatform.Common.Types)

local ItemDisplayHelpers = require(script.Parent.ItemDisplayHelpers)
local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)
local CatalogItemRowCardContainer = require(script.Parent.CatalogItemRowCardContainer)
local isItemPurchasable = InspectAvatarUtils.isItemPurchasable

local function InspectAvatarSheet(t1: {[any]: any}) -- line: 69
	-- upvalues: useLocalization (copy), ItemDisplayHelpers (copy), React (copy), Dash (copy), CatalogItemRowCardContainer (copy), isItemPurchasable (copy), FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav (copy), InputHandlers (copy), View (copy), DisplayBackground (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), FoundationText (copy), Skeleton (copy), Divider (copy), BuyActionBar (copy), FFlagProfileInspectAvatarBuyAll (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy)
	local v30 = useLocalization({
		buyItems = "Feature.Catalog.Label.BuyItems",
		buyWholeLook = "Feature.Profile.Header.BuyWholeLook",
		bundle = "Feature.Catalog.Label.Bundle",
		title = {
			"Feature.Profile.Header.InspectAndBuy",
			username = t1.username
		},
		buyHeader = {
			"Feature.Profile.Header.InspectAndBuy.BuySection",
			numberOfSelectedItems = t1.purchaseSummary.count,
			totalNumberOfItems = #t1.displayItems
		}
	})
	local v31 = useLocalization(ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS)
	local v32 = useLocalization(ItemDisplayHelpers.ASSET_TYPE_LOCALIZATION_KEYS)
	local v33 = useLocalization(ItemDisplayHelpers.BUNDLE_TYPE_LOCALIZATION_KEYS)
	local v34 = React.useMemo(function() -- line: 87
		-- upvalues: v30 (copy), Dash (copy), v32 (copy), v33 (copy)
		return {
			bundleParts = nil,
			bundle = v30.bundle,
			assetTypeNames = Dash.join(v32, v33)
		}
	end, {
		v30.bundle,
		v32,
		v33
	})
	local t2 = {}

	for v36, v37 in t1.displayItems do
		local id = v37.id

		t2[`item_{ id }`] = React.createElement(CatalogItemRowCardContainer, {
			rowHeight = 72,
			asset = v37,
			index = v36,
			isChecked = t1.selectedItems[id] == true,
			isPurchasable = isItemPurchasable(v37),
			localizedStrings = v34,
			priceStatusLocalized = v31,
			onToggleItem = t1.onToggleItem,
			openItemDetails = t1.openItemDetails
		})
	end

	local v39 = if not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then nil else React.useMemo(function() -- line: 114
		-- upvalues: InputHandlers (copy), t1 (copy)
		return InputHandlers.onRelease(function(p1) -- line: 115
			-- upvalues: t1 (copy)
			p1:cancel()
			t1.onClose()
		end)
	end, { t1.onClose })
	local t4 = {
		Scrim = React.createElement("TextButton", {
			Size = UDim2.new(1, -t1.cardWidth, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Selectable = not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav and nil,
			[React.Event.Activated] = t1.onDismiss
		}),
		Sheet = React.createElement(View, {
			tag = "col position-top-right anchor-top-right margin-bottom-small padding-x-xlarge bg-surface-0",
			Size = UDim2.new(0, t1.cardWidth, 1, 0)
		}, {
			StatusBarSpacer = if not (t1.topOffset > 0) then nil else React.createElement(View, {
				tag = "bg-surface-0",
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, t1.topOffset)
			}),
			AvatarViewport = React.createElement(View, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, t1.avatarViewportHeight)
			}, {
				Background = React.createElement(DisplayBackground, {
					height = t1.avatarViewportHeight,
					userId = tonumber(t1.profileId),
					userThumbnail = t1.avatarThumbnail
				}),
				TopBar = React.createElement(View, {
					tag = "row align-y-center size-full-0 auto-y padding-small",
					ZIndex = 2
				}, {
					BackButton = React.createElement(IconButton, {
						isCircular = true,
						icon = IconName.ChevronLargeLeft,
						size = IconSize.Medium,
						variant = ButtonVariant.Utility,
						onActivated = t1.onClose
					})
				})
			}),
			Title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y padding-y-small text-heading-small text-align-x-left",
				LayoutOrder = 2,
				Text = v30.title
			}),
			ScrollWrapper = React.createElement(View, {
				tag = "fill size-full-0",
				LayoutOrder = 3
			}, {
				ScrollContent = React.createElement("ScrollingFrame", {
					ScrollBarThickness = 0,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0)
				}, {
					ItemList = if t1.isLoading then nil else React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-top-medium"
					}, t2),
					LoadingShimmer = if not t1.isLoading then nil else React.createElement(View, {
						tag = "col size-full-0 auto-y"
					}, ((function() -- line: 193
						-- upvalues: React (copy), Skeleton (copy)
						local t3 = {}

						for i = 1, 4 do
							t3[`Shimmer{ i }`] = React.createElement(Skeleton, {
								Size = UDim2.new(1, 0, 0, 72),
								LayoutOrder = i
							})
						end

						return t3
					end)()))
				})
			}),
			FooterDivider = React.createElement(Divider, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			Footer = React.createElement(View, {
				tag = "size-full-2500 bg-surface-0",
				LayoutOrder = 5
			}, {
				ActionBar = React.createElement(BuyActionBar, {
					priceLabel = {
						leftLabel = v30.buyHeader,
						priceInRobux = tostring(t1.purchaseSummary.totalPrice)
					},
					purchaseButtonProps = {
						purchaseButtonText = if not FFlagProfileInspectAvatarBuyAll then v30.buyItems else v30.buyWholeLook,
						onPurchase = t1.onBuyAll,
						isDisabled = t1.isLoading or t1.purchaseSummary.count == 0,
						variant = ButtonVariant.Emphasis
					}
				})
			})
		})
	}

	if FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return React.createElement(AppFocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = v39
				}
			}
		}, t4)
	end

	return React.createElement(View, {
		Size = UDim2.fromScale(1, 1)
	}, t4)
end

return InspectAvatarSheet
