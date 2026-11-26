local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").NumberLocalization

local useOpenRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/useOpenRobuxUpsell")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")

local FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase")
local FFlagProfileInspectAndBuyAutoFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyAutoFocus")

local FFlagProfileInspectAndBuyKeepUpsellDialogOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyKeepUpsellDialogOpen")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ReactFocusNavigation")

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagSocialEnableProfileInspectAndBuyAnalyticsV2")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")

local view = Foundation.View
local text = Foundation.Text
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function AmountLine(props)
	local localize = numberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId)
	local v5 = props.isAlert and "text-title-medium content-alert" or "text-body-medium content-default"

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center gap-large size-full-0 auto-y"
		},
		{
			Label = React.createElement(view, { LayoutOrder = 1, tag = "fill auto-y" }, {
				Text = React.createElement(text, {
					Text = props.label,
					tag = `auto-xy text-align-x-left {v5}`
				})
			}),
			Amount = React.createElement(view, { LayoutOrder = 2, tag = "auto-xy" }, {
				Text = React.createElement(text, {
					Text = `{getIconRichText(iconName.Robux)} {localize}`,
					RichText = true,
					tag = `auto-xy text-align-x-right {v5}`
				})
			})
		}
	)
end

local function InsufficientRobuxDialog(p2)
	local v5 = useNavigation()

	local v6 = if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then useProfileAnalyticsContext() else nil

	local params = p2.navigation.state.params or {}
	local totalPrice = params.totalPrice or 0

	local v7 = if FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase then RobloxAppHooks.useLocalRobuxBalance() else nil

	local robuxBalance = (not FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase or v7 == nil) and (params.robuxBalance or 0) or v7
	local v8 = math.max(totalPrice - robuxBalance, 0)

	if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		React.useEffect(function()
			v6.fireAnalyticsEvent(EventNames.InspectAvatarInsufficientRobuxShown, {
				totalPrice = totalPrice
			})
		end, { v6, totalPrice })
	end

	local v9 = useLocalization({
		title = "IAPExperience.InsufficientRobux.Title.InsufficientRobux",
		currentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance",
		missingRobux = "IAPExperience.InsufficientRobux.Text.MissingRobux",
		orderTotal = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		buyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local v10 = React.useCallback(function()
		v5.goBack()
	end, { v5 })

	local v11 = useOpenRobuxUpsell(totalPrice)
	local v12

	if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		v12 = React.useCallback(function()
			v6.fireAnalyticsEvent(EventNames.InspectAvatarBuyRobuxClicked, {
				totalPrice = totalPrice
			})

			v11()
		end, { v11, v6, totalPrice })
	end

	if FFlagProfileInspectAndBuyKeepUpsellDialogOpen then
		React.useEffect(function()
			if totalPrice <= robuxBalance then
				v10()
			end
		end, { robuxBalance, totalPrice, v10 })
	end

	local v13, v14

	if FFlagProfileInspectAndBuyAutoFocus then
		v13, v14 = ReactFocusNavigation.useDefaultFocusBehavior()
	end

	local v15 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					object:cancel()
					v10()
				end)
			}
		}
	end, { v10 })

	local createElement = React.createElement
	local v17 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = v15
	}

	local createElement2 = React.createElement
	local root = dialog.Root
	local v19 = { size = dialogSize.Small, onClose = v10, hasBackdrop = true, ref = 0 }

	if not FFlagProfileInspectAndBuyAutoFocus then
		v14 = nil
	end

	v19.ref = v14
	local v20 = {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v9.title }),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			PriceBoxPadding = React.createElement(view, {
				tag = "size-full-0 auto-y padding-xxsmall"
			}, {
				PriceBox = React.createElement(
					view,
					{
						tag = "col gap-large size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium"
					},
					{
						BalanceLines = React.createElement(
							view,
							{
								LayoutOrder = 1,
								tag = "col gap-xsmall size-full-0 auto-y"
							},
							{
								CurrentBalance = React.createElement(AmountLine, {
									layoutOrder = 1,
									label = v9.currentBalance,
									amount = robuxBalance
								}),
								MissingRobux = React.createElement(AmountLine, {
									layoutOrder = 2,
									label = v9.missingRobux,
									amount = v8,
									isAlert = true
								})
							}
						),
						OrderTotal = React.createElement(AmountLine, {
							layoutOrder = 2,
							label = v9.orderTotal,
							amount = totalPrice
						})
					}
				)
			})
		}),
		Actions = 0
	}

	local createElement3 = React.createElement
	local actions = dialog.Actions
	local v21 = { LayoutOrder = 3, orientation = orientation.Horizontal, actions = 0 }

	local v23 = {
		text = v9.buyRobux,
		variant = buttonVariant.Emphasis,
		ref = 0,
		onActivated = 0
	}

	if not FFlagProfileInspectAndBuyAutoFocus then
		v13 = nil
	end

	v23.ref = v13

	if not FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		v12 = v11
	end

	v23.onActivated = v12
	v21.actions = { v23 }
	v20.Actions = createElement3(actions, v21)
	return createElement(appFocusRoot, v17, { Dialog = createElement2(root, v19, v20) })
end

return InsufficientRobuxDialog
