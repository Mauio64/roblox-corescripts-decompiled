local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local Foundation = require(CurrencyTransfersParent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local handleTransferComplete = require(CurrencyTransfers.Actions.Send.handleTransferComplete)
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local useUpdatedRobuxBalance = require(CurrencyTransfers.Hooks.useUpdatedRobuxBalance)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function TransferRobuxSuccessModal(_: {[any]: any}) -- line: 46
	-- upvalues: useTransferStore (copy), useTokens (copy), useUpdatedRobuxBalance (copy), SignalsReact (copy), useScaledValue (copy), useLocalization (copy), TransferLocalizationKeys (copy), formatNumber (copy), LocalizationService (copy), React (copy), transferLocaleFormat (copy), handleTransferComplete (copy), Sheet (copy), TransferRobuxHeader (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v27 = useTransferStore()
	local v28 = useTokens()
	local v29 = useUpdatedRobuxBalance(v27)
	local v30 = SignalsReact.useSignalState(v27.getSelectedAmount)
	local v31 = useScaledValue(300)
	local v32 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessModal)
	local v33 = not v30 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v30)
	local v34 = React.useMemo(function() -- line: 60
		-- upvalues: transferLocaleFormat (copy), v32 (copy), v33 (copy)
		return transferLocaleFormat.substituteAmount(v32.SuccessNotification, (tostring(v33)))
	end, {
		v33,
		v32.SuccessNotification
	})

	local function onComplete() -- line: 67
		-- upvalues: handleTransferComplete (copy), v27 (copy)
		handleTransferComplete(v27)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = {
			v31,
			0.5
		},
		onClose = onComplete
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v32.SendRobux or "",
				robuxBalanceAmount = v29
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col align-x-center align-y-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
			}, {
				SuccessIcon = React.createElement(Icon, {
					tag = "auto-xy",
					LayoutOrder = 1,
					name = Enums.IconName.CircleCheck,
					size = v28.Size.Size_1200
				}),
				SuccessMessage = React.createElement(FoundationText, {
					tag = "auto-y text-body-large text-wrap text-align-x-center content-emphasis",
					LayoutOrder = 2,
					Text = v34,
					Size = UDim2.new(1, 0, 0, 0)
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "col align-x-center align-y-center gap-small size-full-0 auto-y"
		}, { React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y"
		}, { React.createElement(Button, {
			text = v32.OK,
			onActivated = onComplete,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return TransferRobuxSuccessModal
