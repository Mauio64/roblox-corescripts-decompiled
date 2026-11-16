local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local LocalizationService = game:GetService("LocalizationService")

local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local enums = Foundation.Enums

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local handleTransferComplete = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferComplete")

local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferRobuxHeader")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")
local useUpdatedRobuxBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useUpdatedRobuxBalance")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function TransferRobuxSuccessModal(p2)
	local v5 = useTransferStore()
	local v6 = useTokens()

	local v7 = useUpdatedRobuxBalance(v5)
	local v8 = SignalsReact.useSignalState(v5.getSelectedAmount)
	local v9 = useScaledValue(300)

	local v10 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessModal)

	local v11 = not v8 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v8)

	local v12 = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v10.SuccessNotification, (tostring(v11)))
	end, { v11, v10.SuccessNotification })

	local function onComplete()
		handleTransferComplete(v5)
	end

	local v13, v14

	if GetFFlagCurrencyTransferFocusNavigation() then
		v13, v14 = useTransferSheetFocus(onComplete)
	end

	return React.createElement(sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { v9, 0.5 },
		onClose = onComplete,
		ref = v13
	}, {
		Header = React.createElement(sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(module7, {
				titleText = v10.SendRobux or "",
				robuxBalanceAmount = v7
			})
		}),
		Content = React.createElement(sheet.Content, { LayoutOrder = 2 }, {
			SheetContentContainer = React.createElement(
				view,
				{
					tag = "col align-x-center align-y-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
				},
				{
					SuccessIcon = React.createElement(icon, {
						name = enums.IconName.CircleCheck,
						size = v6.Size.Size_1200,
						tag = "auto-xy",
						LayoutOrder = 1
					}),
					SuccessMessage = React.createElement(text, {
						Text = v12,
						tag = "auto-y text-body-large text-wrap text-align-x-center content-emphasis",
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2
					})
				}
			)
		}),
		Actions = React.createElement(sheet.Actions, { LayoutOrder = 3 }, {
			React.createElement(
				view,
				{
					tag = "col align-x-center align-y-center gap-small size-full-0 auto-y"
				},
				{ React.createElement(view, {
						tag = "row gap-small size-full-0 auto-y"
					}, {
						React.createElement(button, {
							ref = v14,
							text = v10.OK,
							onActivated = onComplete,
							variant = buttonVariant.Emphasis,
							fillBehavior = fillBehavior.Fill
						})
					}) }
			)
		})
	})
end

return TransferRobuxSuccessModal
