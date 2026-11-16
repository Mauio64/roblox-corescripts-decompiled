local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)

local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local NumberLocalization = Localization2.NumberLocalization

local useOpenRobuxUpsell = require(script.Parent.useOpenRobuxUpsell)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)

local FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase)
local FFlagProfileInspectAndBuyAutoFocus = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyAutoFocus)

local FFlagProfileInspectAndBuyKeepUpsellDialogOpen = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyKeepUpsellDialogOpen)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require(ProfilePlatform.Flags.FFlagSocialEnableProfileInspectAndBuyAnalyticsV2)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local View = Foundation.View
local Text = Foundation.Text
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function AmountLine(props)
	local localize = NumberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId)
	local v = props.isAlert and "text-title-medium content-alert" or "text-body-medium content-default"

	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, tag = "row align-y-center gap-large size-full-0 auto-y" },
		{
			Label = React.createElement(View, { LayoutOrder = 1, tag = "fill auto-y" }, {
				Text = React.createElement(Text, {
					Text = props.label,
					tag = `auto-xy text-align-x-left {v}`
				})
			}),
			Amount = React.createElement(View, { LayoutOrder = 2, tag = "auto-xy" }, {
				Text = React.createElement(Text, {
					Text = `{getIconRichText(IconName.Robux)} {localize}`,
					RichText = true,
					tag = `auto-xy text-align-x-right {v}`
				})
			})
		}
	)
end

local function InsufficientRobuxDialog(p)
	local v = useNavigation()
	local v2

	if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		v2 = useProfileAnalyticsContext()
	else
		v2 = nil
	end

	local params = p.navigation.state.params or {}
	local totalPrice = params.totalPrice or 0
	local v3

	if FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase then
		v3 = RobloxAppHooks.useLocalRobuxBalance()
	end

	local robuxBalance = (not FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase or v3 == nil)
		and (params.robuxBalance or 0)
		or v3
	local amount = math.max(totalPrice - robuxBalance, 0)

	if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		React.useEffect(function()
			v2.fireAnalyticsEvent(EventNames.InspectAvatarInsufficientRobuxShown, {
				totalPrice = totalPrice
			})
		end, { v2, totalPrice })
	end

	local v4 = useLocalization({
		title = "IAPExperience.InsufficientRobux.Title.InsufficientRobux",
		currentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance",
		missingRobux = "IAPExperience.InsufficientRobux.Text.MissingRobux",
		orderTotal = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		buyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local onClose = React.useCallback(function()
		v.goBack()
	end, { v })

	local v5 = useOpenRobuxUpsell(totalPrice)
	local onActivated

	if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		onActivated = React.useCallback(function()
			v2.fireAnalyticsEvent(EventNames.InspectAvatarBuyRobuxClicked, {
				totalPrice = totalPrice
			})

			v5()
		end, { v5, v2, totalPrice })
	end

	if FFlagProfileInspectAndBuyKeepUpsellDialogOpen then
		React.useEffect(function()
			if totalPrice <= robuxBalance then
				onClose()
			end
		end, { robuxBalance, totalPrice, onClose })
	end

	local ref, ref2

	if FFlagProfileInspectAndBuyAutoFocus then
		ref, ref2 = ReactFocusNavigation.useDefaultFocusBehavior()
	end

	local customEventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					object:cancel()
					onClose()
				end)
			}
		}
	end, { onClose })

	local createElement = React.createElement
	local v6 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = customEventHandlers
	}

	local createElement2 = React.createElement
	local root = Dialog.Root
	local v7 = { size = DialogSize.Small, onClose = onClose, hasBackdrop = true, ref = 0 }

	if not FFlagProfileInspectAndBuyAutoFocus then
		ref2 = nil
	end

	v7.ref = ref2
	local v8 = {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v4.title }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			PriceBoxPadding = React.createElement(View, {
				tag = "size-full-0 auto-y padding-xxsmall"
			}, {
				PriceBox = React.createElement(
					View,
					{
						tag = "col gap-large size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium"
					},
					{
						BalanceLines = React.createElement(
							View,
							{ LayoutOrder = 1, tag = "col gap-xsmall size-full-0 auto-y" },
							{
								CurrentBalance = React.createElement(AmountLine, {
									layoutOrder = 1,
									label = v4.currentBalance,
									amount = robuxBalance
								}),
								MissingRobux = React.createElement(AmountLine, {
									layoutOrder = 2,
									label = v4.missingRobux,
									amount = amount,
									isAlert = true
								})
							}
						),
						OrderTotal = React.createElement(AmountLine, {
							layoutOrder = 2,
							label = v4.orderTotal,
							amount = totalPrice
						})
					}
				)
			})
		}),
		Actions = 0
	}

	local createElement3 = React.createElement
	local actions = Dialog.Actions
	local v9 = { LayoutOrder = 3, orientation = Orientation.Horizontal, actions = 0 }

	local v10 = { text = v4.buyRobux, variant = ButtonVariant.Emphasis, ref = 0, onActivated = 0 }

	if not FFlagProfileInspectAndBuyAutoFocus then
		ref = nil
	end

	v10.ref = ref

	if not FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
		onActivated = v5
	end

	v10.onActivated = onActivated
	v9.actions = { v10 }
	v8.Actions = createElement3(actions, v9)
	return createElement(AppFocusRoot, v6, { Dialog = createElement2(root, v7, v8) })
end

return InsufficientRobuxDialog
