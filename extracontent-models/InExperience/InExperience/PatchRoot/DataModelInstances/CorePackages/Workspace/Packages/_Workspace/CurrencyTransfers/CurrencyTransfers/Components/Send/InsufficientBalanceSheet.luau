local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local LocalizationService = game:GetService("LocalizationService")
local WebViewServiceWrapper = require(CurrencyTransfers.Utils.WebViewServiceWrapper)
local PurchaseRobuxConstants = require(CurrencyTransfers.Constants.PurchaseRobuxConstants)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local getBalanceAfterPurchaseWebview = require(CurrencyTransfers.NetworkRequests.getBalanceAfterPurchaseWebview)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)

local Foundation = require(parent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local Icon = Foundation.Icon
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function InsufficientBalanceSheet(_)
	local v = useTransferStore()
	local v2 = useTokens()
	local v3 = useLocalization(TransferLocalizationKeys.Presets.InsufficientBalanceSheet)
	local robuxBalanceAmount = SignalsReact.useSignalState(v.getRobuxBalanceAmount) or 0
	local ref = React.useRef(0)
	local v4 = math.max(0, (SignalsReact.useSignalState(v.getSelectedAmount) or 0) - robuxBalanceAmount)
	local v5 = formatNumber(LocalizationService.RobloxLocaleId, v4)
	local text = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v3.InsufficientBalance or "", (tostring(v5)))
	end, { v5, v3.InsufficientBalance })

	local function goBackToInputAndOpenBuyRobux()
		local transferOrigination = v.getTransferOrigination(false)
		local purchaseRobuxUrl = PurchaseRobuxConstants.getPurchaseRobuxUrl()
		local PURCHASE_ROBUX_WEBVIEW_TITLE = PurchaseRobuxConstants.PURCHASE_ROBUX_WEBVIEW_TITLE
		WebViewServiceWrapper.new({
			url = purchaseRobuxUrl,
			title = PURCHASE_ROBUX_WEBVIEW_TITLE,
			closeCallback = function()
				local function applyPromptAfterBalance() -- 2 equivalent calls inferred from this helper
					if transferOrigination == TransferOrigination.InExperience then
						setTransferPromptState(v, PromptState.TransferConfirm)
					else
						setTransferPromptState(v, PromptState.TransferInput)
					end
				end
				ref.current += 1
				local current = ref.current
				getBalanceAfterPurchaseWebview(nil, v.getNetworkImpl()):andThen(function(p)
					if ref.current ~= current then
						return
					end

					v.setRobuxBalanceAmount(p)
					v.setBalanceReceivedFromApi(true)
					applyPromptAfterBalance() -- inferred equivalent call
				end):catch(function(_)
					if ref.current ~= current then
						return
					end

					applyPromptAfterBalance() -- inferred equivalent call
				end)
			end
		}):open()
	end

	local function handleClose()
		if v.getTransferOrigination(false) == TransferOrigination.InExperience then
			v.triggerOnClose()
		else
			setTransferPromptState(v, PromptState.TransferInput)
		end
	end

	local ref2, ref3

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref2, ref3 = useTransferSheetFocus(handleClose)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { useScaledValue(300), 0.5 },
		onClose = handleClose,
		ref = ref2
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v3.SendRobux,
				robuxBalanceAmount = robuxBalanceAmount
			})
		}),
		Content = React.createElement(Sheet.Content, { LayoutOrder = 2 }, {
			SheetContentContainer = React.createElement(
				View,
				{
					tag = "col gap-xlarge auto-y size-full-0 align-x-center align-y-center padding-top-xlarge"
				},
				{
					ErrorIconContainer = React.createElement(
						View,
						{
							tag = "size-1200-1200 radius-circle align-x-center align-y-center bg-inverse-emphasis",
							LayoutOrder = 1
						},
						{
							ErrorIcon = React.createElement(Icon, {
								name = Enums.IconName.TriangleExclamation,
								size = v2.Size.Size_1200,
								tag = "content-inverse-emphasis"
							})
						}
					),
					ErrorMessage = React.createElement(Text, {
						Text = text,
						tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2
					})
				}
			)
		}),
		Actions = React.createElement(Sheet.Actions, { LayoutOrder = 3 }, {
			React.createElement(View, {
				tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
			}, {
				React.createElement(View, { tag = "row auto-y size-full-0 gap-small" }, { React.createElement(Button, {
						ref = ref3,
						text = v3.BuyRobux or "Buy",
						onActivated = goBackToInputAndOpenBuyRobux,
						variant = ButtonVariant.Emphasis,
						fillBehavior = FillBehavior.Fill
					}) })
			})
		})
	})
end

return InsufficientBalanceSheet
