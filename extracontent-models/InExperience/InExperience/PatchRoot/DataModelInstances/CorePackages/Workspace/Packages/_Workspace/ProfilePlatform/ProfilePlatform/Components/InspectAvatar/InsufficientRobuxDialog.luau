local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useNavigation = require(Parent.Navigation).useNavigation
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local NumberLocalization = require(Parent.Localization).NumberLocalization
local useOpenRobuxUpsell = require(script.Parent.useOpenRobuxUpsell)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(Parent.InputHandlers)
local View = Foundation.View
local FoundationText = Foundation.Text
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function AmountLine(t1: {[any]: any}) -- line: 31
	-- upvalues: NumberLocalization (copy), LocalizationService (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), IconName (copy)
	local v25 = NumberLocalization.localize(t1.amount, LocalizationService.RobloxLocaleId)
	local v26 = not t1.isAlert and "text-body-medium content-default" or "text-title-medium content-alert"

	return React.createElement(View, {
		tag = "row align-y-center gap-large size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		Label = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill auto-y"
		}, {
			Text = React.createElement(FoundationText, {
				Text = t1.label,
				tag = `auto-xy text-align-x-left { v26 }`
			})
		}),
		Amount = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-xy"
		}, {
			Text = React.createElement(FoundationText, {
				RichText = true,
				Text = `{ getIconRichText(IconName.Robux) } { v25 }`,
				tag = `auto-xy text-align-x-right { v26 }`
			})
		})
	})
end
local function InsufficientRobuxDialog(t2: {[any]: any}) -- line: 70
	-- upvalues: useNavigation (copy), useLocalization (copy), React (copy), useOpenRobuxUpsell (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), Dialog (copy), DialogSize (copy), View (copy), AmountLine (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v28 = useNavigation()
	local v29 = t2.navigation.state.params or {}
	local v30 = v29.totalPrice or 0
	local v31 = v29.robuxBalance or 0
	local v32 = math.max(v30 - v31, 0)
	local v33 = useLocalization({
		title = "IAPExperience.InsufficientRobux.Title.InsufficientRobux",
		currentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance",
		missingRobux = "IAPExperience.InsufficientRobux.Text.MissingRobux",
		orderTotal = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		buyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})
	local v34 = React.useCallback(function() -- line: 85
		-- upvalues: v28 (copy)
		v28.goBack()
	end, { v28 })
	local v35 = useOpenRobuxUpsell(v30)
	local v36 = React.useMemo(function() -- line: 91
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v34 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 94
					-- upvalues: v34 (copy)
					p1:cancel()
					v34()
				end)
			}
		}
	end, { v34 })

	return React.createElement(AppFocusRoot, {
		isAutoFocusRoot = true,
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		customEventHandlers = v36
	}, {
		Dialog = React.createElement(Dialog.Root, {
			hasBackdrop = true,
			size = DialogSize.Small,
			onClose = v34
		}, {
			Title = React.createElement(Dialog.Title, {
				LayoutOrder = 1,
				text = v33.title
			}),
			Content = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				PriceBoxPadding = React.createElement(View, {
					tag = "size-full-0 auto-y padding-xxsmall"
				}, {
					PriceBox = React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium"
					}, {
						BalanceLines = React.createElement(View, {
							LayoutOrder = 1,
							tag = "col gap-xsmall size-full-0 auto-y"
						}, {
							CurrentBalance = React.createElement(AmountLine, {
								layoutOrder = 1,
								label = v33.currentBalance,
								amount = v31
							}),
							MissingRobux = React.createElement(AmountLine, {
								layoutOrder = 2,
								isAlert = true,
								label = v33.missingRobux,
								amount = v32
							})
						}),
						OrderTotal = React.createElement(AmountLine, {
							layoutOrder = 2,
							label = v33.orderTotal,
							amount = v30
						})
					})
				})
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				orientation = EnumsOrientation.Horizontal,
				actions = {{
					text = v33.buyRobux,
					variant = ButtonVariant.Emphasis,
					onActivated = v35
				}}
			})
		})
	})
end

return InsufficientRobuxDialog
