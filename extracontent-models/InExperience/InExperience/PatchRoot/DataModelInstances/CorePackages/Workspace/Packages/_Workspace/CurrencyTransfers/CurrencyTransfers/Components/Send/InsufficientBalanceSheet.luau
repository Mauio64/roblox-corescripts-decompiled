local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local LocalizationService = game:GetService("LocalizationService")
local WebViewServiceWrapper = require(CurrencyTransfers.Utils.WebViewServiceWrapper)
local PurchaseRobuxConstants = require(CurrencyTransfers.Constants.PurchaseRobuxConstants)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local getBalanceAfterPurchaseWebview = require(CurrencyTransfers.NetworkRequests.getBalanceAfterPurchaseWebview)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)
local GetFFlagCurrencyTransferFixBalanceReRender = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixBalanceReRender)
local Foundation = require(CurrencyTransfersParent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local Icon = Foundation.Icon
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function InsufficientBalanceSheet(_: {[any]: any}) -- line: 46
	-- upvalues: useTransferStore (copy), useTokens (copy), useLocalization (copy), TransferLocalizationKeys (copy), GetFFlagCurrencyTransferFixBalanceReRender (copy), SignalsReact (copy), React (copy), formatNumber (copy), LocalizationService (copy), transferLocaleFormat (copy), PurchaseRobuxConstants (copy), WebViewServiceWrapper (copy), TransferOrigination (copy), setTransferPromptState (copy), PromptState (copy), getBalanceAfterPurchaseWebview (copy), getBalanceRequest (copy), Sheet (copy), useScaledValue (copy), TransferRobuxHeader (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v33 = useTransferStore()
	local v34 = useTokens()
	local v35 = useLocalization(TransferLocalizationKeys.Presets.InsufficientBalanceSheet)
	local v36 = if not GetFFlagCurrencyTransferFixBalanceReRender() then v33.getRobuxBalanceAmount(false) else SignalsReact.useSignalState(v33.getRobuxBalanceAmount) or 0
	local v37 = React.useRef(0)
	local v38 = math.max(0, (((if not GetFFlagCurrencyTransferFixBalanceReRender() then v33.getSelectedAmount(false) or 0 else SignalsReact.useSignalState(v33.getSelectedAmount) or 0)) or 0) - v36)
	local v39 = formatNumber(LocalizationService.RobloxLocaleId, v38)
	local v40 = React.useMemo(function() -- line: 59
		-- upvalues: transferLocaleFormat (copy), v35 (copy), v39 (copy)
		return transferLocaleFormat.substituteAmount(v35.InsufficientBalance or "", (tostring(v39)))
	end, {
		v39,
		v35.InsufficientBalance
	})

	local function goBackToInputAndOpenBuyRobux() -- line: 63
		-- upvalues: v33 (copy), PurchaseRobuxConstants (copy), WebViewServiceWrapper (copy), TransferOrigination (copy), setTransferPromptState (copy), PromptState (copy), GetFFlagCurrencyTransferFixBalanceReRender (copy), v37 (copy), getBalanceAfterPurchaseWebview (copy), getBalanceRequest (copy)
		local v43 = v33.getTransferOrigination(false)
		local v44 = PurchaseRobuxConstants.getPurchaseRobuxUrl()
		local PURCHASE_ROBUX_WEBVIEW_TITLE = PurchaseRobuxConstants.PURCHASE_ROBUX_WEBVIEW_TITLE

		WebViewServiceWrapper.new({
			url = v44,
			title = PURCHASE_ROBUX_WEBVIEW_TITLE,
			closeCallback = function() -- line: 70
				-- upvalues: v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), v33 (copy), PromptState (copy), GetFFlagCurrencyTransferFixBalanceReRender (copy), v37 (copy), getBalanceAfterPurchaseWebview (copy), getBalanceRequest (copy)
				local function applyPromptAfterBalance() -- line: 71
					-- upvalues: v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), v33 (copy), PromptState (copy)
					if v43 == TransferOrigination.InExperience then
						setTransferPromptState(v33, PromptState.TransferConfirm)

						return
					end

					setTransferPromptState(v33, PromptState.TransferInput)
				end

				if GetFFlagCurrencyTransferFixBalanceReRender() then
					v37.current = v37.current + 1

					local current = v37.current

					getBalanceAfterPurchaseWebview():andThen(function(p1) -- line: 82
						-- upvalues: v37 (copy), current (copy), v33 (copy), v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), PromptState (copy)
						if v37.current ~= current then
							return
						end

						v33.setRobuxBalanceAmount(p1)
						v33.setBalanceReceivedFromApi(true)

						if v43 == TransferOrigination.InExperience then
							setTransferPromptState(v33, PromptState.TransferConfirm)

							return
						end

						setTransferPromptState(v33, PromptState.TransferInput)
					end):catch(function(_) -- line: 90
						-- upvalues: v37 (copy), current (copy), v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), v33 (copy), PromptState (copy)
						if v37.current ~= current then
							return
						end

						if v43 == TransferOrigination.InExperience then
							setTransferPromptState(v33, PromptState.TransferConfirm)

							return
						end

						setTransferPromptState(v33, PromptState.TransferInput)
					end)

					return
				end

				getBalanceRequest():andThen(function(p3) -- line: 98
					-- upvalues: v33 (copy), v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), PromptState (copy)
					v33.setRobuxBalanceAmount(p3)
					v33.setBalanceReceivedFromApi(true)

					if v43 == TransferOrigination.InExperience then
						setTransferPromptState(v33, PromptState.TransferConfirm)

						return
					end

					setTransferPromptState(v33, PromptState.TransferInput)
				end):catch(function(_) -- line: 103
					-- upvalues: v43 (copy), TransferOrigination (copy), setTransferPromptState (copy), v33 (copy), PromptState (copy)
					if v43 == TransferOrigination.InExperience then
						setTransferPromptState(v33, PromptState.TransferConfirm)

						return
					end

					setTransferPromptState(v33, PromptState.TransferInput)
				end)
			end
		}):open()
	end
	local function handleClose() -- line: 112
		-- upvalues: v33 (copy), TransferOrigination (copy), setTransferPromptState (copy), PromptState (copy)
		if v33.getTransferOrigination(false) == TransferOrigination.InExperience then
			v33.triggerOnClose()

			return
		end

		setTransferPromptState(v33, PromptState.TransferInput)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = {
			useScaledValue(300),
			0.5
		},
		onClose = handleClose
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v35.SendRobux,
				robuxBalanceAmount = v36
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col gap-xlarge auto-y size-full-0 align-x-center align-y-center padding-top-xlarge"
			}, {
				ErrorIconContainer = React.createElement(View, {
					tag = "size-1200-1200 radius-circle align-x-center align-y-center bg-inverse-emphasis",
					LayoutOrder = 1
				}, {
					ErrorIcon = React.createElement(Icon, {
						tag = "content-inverse-emphasis",
						name = Enums.IconName.TriangleExclamation,
						size = v34.Size.Size_1200
					})
				}),
				ErrorMessage = React.createElement(FoundationText, {
					tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
					LayoutOrder = 2,
					Text = v40,
					Size = UDim2.new(1, 0, 0, 0)
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
		}, { React.createElement(View, {
			tag = "row auto-y size-full-0 gap-small"
		}, { React.createElement(Button, {
			text = v35.BuyRobux or "Buy",
			onActivated = goBackToInputAndOpenBuyRobux,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return InsufficientBalanceSheet
