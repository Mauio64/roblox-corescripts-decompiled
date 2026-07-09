local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)
local useUserNameFromUserId = require(CurrencyTransfers.Hooks.useUserNameFromUserId)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
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
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local GetFIntCurrencyTransferMinAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMinAmount)
local GetFIntCurrencyTransferMaxAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMaxAmount)
local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)
local GetFFlagCurrencyTransferReceiveLimitExceededError = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferReceiveLimitExceededError)
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function getErrorMessageAndButton(p1, p2, p3, p4, p5) -- line: 48
	-- upvalues: FailureReason (copy), GetFFlagCurrencyTransferReceiveLimitExceededError (copy), transferLocaleFormat (copy)
	if not p1 then
		return p2.GenericError, p2.TryAgain
	end

	local OK = p2.OK
	local DailyLimitExceeded

	if p1 == FailureReason.TransferDailyLimitExceeded then
		DailyLimitExceeded = p2.DailyLimitExceeded
	elseif p1 == FailureReason.TransferMonthlyLimitExceeded then
		DailyLimitExceeded = p2.MonthlyLimitExceeded
	elseif p1 == FailureReason.TransferDisabledForUser then
		DailyLimitExceeded = p2.AccountDisabled
	elseif GetFFlagCurrencyTransferReceiveLimitExceededError() and p1 == FailureReason.ReceiveLimitExceeded then
		DailyLimitExceeded = p2.ReceiveLimitExceeded
	elseif p1 == FailureReason.ReceiverNotAllowed then
		DailyLimitExceeded = transferLocaleFormat.substituteUsername(p2.ReceiverNotAllowed, p3 or "")
	elseif p1 == FailureReason.TransferAmountBelowMinimum then
		DailyLimitExceeded = transferLocaleFormat.substituteMinAmount(p2.TransferAmountBelowMinimum, (tostring(p4)))
		OK = p2.TryAgain
	elseif p1 == FailureReason.TransferAmountExceedsMaximum then
		DailyLimitExceeded = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
		OK = p2.TryAgain
	elseif p1 == FailureReason.TransferAmountExceedsNonSecuredMaximum then
		DailyLimitExceeded = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
		OK = p2.TryAgain
	else
		DailyLimitExceeded = p2.GenericError
		OK = p2.TryAgain
	end

	return DailyLimitExceeded, OK
end
local function TransferRobuxErrorSheet(_: {[any]: any}) -- line: 90
	-- upvalues: useTransferStore (copy), useTokens (copy), SignalsReact (copy), FailureReason (copy), useUserNameFromUserId (copy), React (copy), getBalanceRequest (copy), useLocalization (copy), TransferLocalizationKeys (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), GetFIntCurrencyTransferMinAmount (copy), GetFIntCurrencyTransferMaxAmount (copy), getErrorMessageAndButton (copy), Sheet (copy), useScaledValue (copy), TransferRobuxHeader (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v38 = useTransferStore()
	local v39 = useTokens()
	local v40 = SignalsReact.useSignalState(v38.getRobuxBalanceAmount) or 0
	local v41 = v38.getBalanceReceivedFromApi(false)
	local v42 = v38.getErrorTransferModel(false)
	local v43 = v38.getRecipient(false)
	local v44 = v38.getRecipientUserId(false)
	local triggerOnClose = v38.triggerOnClose
	local v46 = if not v42 then nil else v42.failureReason
	local v47 = v46 == FailureReason.ReceiverNotAllowed and (not v43 and (v44 and v44 ~= 0))
	local v48 = useUserNameFromUserId(if not v47 or (not v44 or v44 == 0) then nil else v44)

	React.useEffect(function() -- line: 110
		-- upvalues: v41 (copy), getBalanceRequest (copy), v38 (copy)
		if v41 then
			return
		end

		getBalanceRequest():andThen(function(p6) -- line: 115
			-- upvalues: v38 (copy)
			v38.setRobuxBalanceAmount(p6)
			v38.setBalanceReceivedFromApi(true)
		end):catch(function() -- line: 119
		end)
	end, { v41 })

	local v49 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)
	local v50 = SignalsReact.useSignalState(v38.getMinimumTransferAmount)
	local v51 = SignalsReact.useSignalState(v38.getMaximumTransferAmount)
	local v52 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v50 or GetFIntCurrencyTransferMinAmount()
	local v53 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v51 or GetFIntCurrencyTransferMaxAmount()
	local v54 = if not v43 or not v43.targetName and not v43.targetDisplayName then if not v47 or (not v48 or v48 == "") then nil else v48 else v43.targetName or v43.targetDisplayName
	local v55, v56 = getErrorMessageAndButton(v46, v49, v54 or "", v52, v53)

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = {
			useScaledValue(300),
			0.5
		},
		onClose = triggerOnClose
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v49.SendRobux or "",
				robuxBalanceAmount = v40
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
						size = v39.Size.Size_1200
					})
				}),
				ErrorMessage = React.createElement(FoundationText, {
					tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
					LayoutOrder = 2,
					Text = v55,
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
			text = v56,
			onActivated = triggerOnClose,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return TransferRobuxErrorSheet
