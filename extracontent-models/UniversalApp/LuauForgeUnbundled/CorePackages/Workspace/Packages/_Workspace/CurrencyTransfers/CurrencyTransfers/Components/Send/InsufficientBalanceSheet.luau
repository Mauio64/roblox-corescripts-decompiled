local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")
local LocalizationService = game:GetService("LocalizationService")
local WebViewServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/WebViewServiceWrapper")
local PurchaseRobuxConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/PurchaseRobuxConstants")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local getBalanceAfterPurchaseWebview = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getBalanceAfterPurchaseWebview")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local setTransferPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/setTransferPromptState")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local icon = Foundation.Icon
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local enums = Foundation.Enums

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferRobuxHeader")
local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function InsufficientBalanceSheet(p2)
	local v5 = useTransferStore()
	local v6 = useTokens()
	local v7 = useLocalization(TransferLocalizationKeys.Presets.InsufficientBalanceSheet)
	local v8 = SignalsReact.useSignalState(v5.getRobuxBalanceAmount) or 0
	local ref = React.useRef(0)
	local v9 = math.max(0, (SignalsReact.useSignalState(v5.getSelectedAmount) or 0) - v8)
	local v10 = formatNumber(LocalizationService.RobloxLocaleId, v9)
	local v11 = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v7.InsufficientBalance or "", (tostring(v10)))
	end, { v10, v7.InsufficientBalance })

	local function goBackToInputAndOpenBuyRobux()
		local transferOrigination = v5.getTransferOrigination(false)
		local purchaseRobuxUrl = PurchaseRobuxConstants.getPurchaseRobuxUrl()
		local PURCHASE_ROBUX_WEBVIEW_TITLE = PurchaseRobuxConstants.PURCHASE_ROBUX_WEBVIEW_TITLE
		WebViewServiceWrapper.new({
			url = purchaseRobuxUrl,
			title = PURCHASE_ROBUX_WEBVIEW_TITLE,
			closeCallback = function()
				local function applyPromptAfterBalance()
					if transferOrigination == TransferOrigination.InExperience then
						setTransferPromptState(v5, PromptState.TransferConfirm)
					else
						setTransferPromptState(v5, PromptState.TransferInput)
					end
				end
				ref.current += 1
				local current = ref.current
				getBalanceAfterPurchaseWebview(nil, v5.getNetworkImpl()):andThen(function(p3)
					if ref.current ~= current then
						return
					end

					v5.setRobuxBalanceAmount(p3)
					v5.setBalanceReceivedFromApi(true)

					if transferOrigination == TransferOrigination.InExperience then
						setTransferPromptState(v5, PromptState.TransferConfirm)
					else
						setTransferPromptState(v5, PromptState.TransferInput)
					end
				end):catch(function(p3)
					if ref.current ~= current then
						return
					end

					if transferOrigination == TransferOrigination.InExperience then
						setTransferPromptState(v5, PromptState.TransferConfirm)
					else
						setTransferPromptState(v5, PromptState.TransferInput)
					end
				end)
			end
		}):open()
	end

	local function handleClose()
		if v5.getTransferOrigination(false) == TransferOrigination.InExperience then
			v5.triggerOnClose()
		else
			setTransferPromptState(v5, PromptState.TransferInput)
		end
	end

	local v12, v13

	if GetFFlagCurrencyTransferFocusNavigation() then
		v12, v13 = useTransferSheetFocus(handleClose)
	end

	return React.createElement(sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { useScaledValue(300), 0.5 },
		onClose = handleClose,
		ref = v12
	}, {
		Header = React.createElement(sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(module12, {
				titleText = v7.SendRobux,
				robuxBalanceAmount = v8
			})
		}),
		Content = React.createElement(sheet.Content, { LayoutOrder = 2 }, {
			SheetContentContainer = React.createElement(
				view,
				{
					tag = "col gap-xlarge auto-y size-full-0 align-x-center align-y-center padding-top-xlarge"
				},
				{
					ErrorIconContainer = React.createElement(
						view,
						{
							tag = "size-1200-1200 radius-circle align-x-center align-y-center bg-inverse-emphasis",
							LayoutOrder = 1
						},
						{
							ErrorIcon = React.createElement(icon, {
								name = enums.IconName.TriangleExclamation,
								size = v6.Size.Size_1200,
								tag = "content-inverse-emphasis"
							})
						}
					),
					ErrorMessage = React.createElement(text, {
						Text = v11,
						tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
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
					tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
				},
				{ React.createElement(view, {
						tag = "row auto-y size-full-0 gap-small"
					}, {
						React.createElement(button, {
							ref = v13,
							text = v7.BuyRobux or "Buy",
							onActivated = goBackToInputAndOpenBuyRobux,
							variant = buttonVariant.Emphasis,
							fillBehavior = fillBehavior.Fill
						})
					}) }
			)
		})
	})
end

return InsufficientBalanceSheet
