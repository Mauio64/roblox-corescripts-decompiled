local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")

local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)

local Foundation = require(parent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local handleTransferComplete = require(CurrencyTransfers.Actions.Send.handleTransferComplete)

local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local useUpdatedRobuxBalance = require(CurrencyTransfers.Hooks.useUpdatedRobuxBalance)

local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function TransferRobuxSuccessModal(_)
	local v = useTransferStore()
	local v2 = useTokens()

	local robuxBalanceAmount = useUpdatedRobuxBalance(v)
	local v3 = SignalsReact.useSignalState(v.getSelectedAmount)
	local v4 = useScaledValue(300)

	local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessModal)

	local v6 = not v3 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v3)

	local text = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v5.SuccessNotification, (tostring(v6)))
	end, { v6, v5.SuccessNotification })

	local function onComplete()
		handleTransferComplete(v)
	end

	local ref, ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref, ref2 = useTransferSheetFocus(onComplete)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { v4, 0.5 },
		onClose = onComplete,
		ref = ref
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v5.SendRobux or "",
				robuxBalanceAmount = robuxBalanceAmount
			})
		}),
		Content = React.createElement(Sheet.Content, { LayoutOrder = 2 }, {
			SheetContentContainer = React.createElement(
				View,
				{
					tag = "col align-x-center align-y-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
				},
				{
					SuccessIcon = React.createElement(Icon, {
						name = Enums.IconName.CircleCheck,
						size = v2.Size.Size_1200,
						tag = "auto-xy",
						LayoutOrder = 1
					}),
					SuccessMessage = React.createElement(Text, {
						Text = text,
						tag = "auto-y text-body-large text-wrap text-align-x-center content-emphasis",
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2
					})
				}
			)
		}),
		Actions = React.createElement(Sheet.Actions, { LayoutOrder = 3 }, {
			React.createElement(View, {
				tag = "col align-x-center align-y-center gap-small size-full-0 auto-y"
			}, {
				React.createElement(View, { tag = "row gap-small size-full-0 auto-y" }, { React.createElement(Button, {
						ref = ref2,
						text = v5.OK,
						onActivated = onComplete,
						variant = ButtonVariant.Emphasis,
						fillBehavior = FillBehavior.Fill
					}) })
			})
		})
	})
end

return TransferRobuxSuccessModal
