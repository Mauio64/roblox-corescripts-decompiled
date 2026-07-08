local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)
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
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function getErrorMessageAndButton(p1, t1: {[any]: any}, s1: string?) -- line: 38
	-- upvalues: FailureReason (copy), transferLocaleFormat (copy)
	if not p1 then
		return t1.GenericError, t1.TryAgain
	end

	local OK = t1.OK
	local AccountDisabled

	if p1 == FailureReason.TransferDisabledForUser then
		AccountDisabled = t1.AccountDisabled
	elseif p1 == FailureReason.TransferExpired then
		AccountDisabled = transferLocaleFormat.substituteUsername(t1.TransferExpired, (tostring(s1)))
	else
		AccountDisabled = t1.GenericError
		OK = t1.TryAgain
	end

	return AccountDisabled, OK
end
local function ReceiveErrorSheet(_: {[any]: any}) -- line: 64
	-- upvalues: useTransferStore (copy), useTokens (copy), SignalsReact (copy), FailureReason (copy), React (copy), getTransferRequestByIdRequest (copy), useUserNameFromUserId (copy), useLocalization (copy), TransferLocalizationKeys (copy), transferLocaleFormat (copy), Sheet (copy), useScaledValue (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v31 = useTransferStore()
	local v32 = useTokens()
	local v33 = SignalsReact.useSignalState(v31.getErrorTransferModel)
	local v34 = SignalsReact.useSignalState(v31.getSender)
	local v35 = SignalsReact.useSignalState(v31.getRobuxTransfer)
	local v36 = SignalsReact.useSignalState(v31.getTransferRequestId)
	local triggerOnClose = v31.triggerOnClose
	local v38 = if not v33 then nil else v33.failureReason
	local v39 = v38 == FailureReason.TransferExpired

	React.useEffect(function() -- line: 76
		-- upvalues: v39 (copy), v34 (copy), v35 (copy), v36 (copy), getTransferRequestByIdRequest (copy), v31 (copy)
		if not v39 or v34 or (v35 and v35.sender or not v36) then
			return
		end

		getTransferRequestByIdRequest({
			transferRequestId = v36
		}):andThen(function(p2) -- line: 86
			-- upvalues: v31 (copy)
			if p2 and (p2.transfer and p2.transfer.sender) then
				v31.setSender(p2.transfer.sender)
			end
		end):catch(function() -- line: 91
		end)
	end, {
		v39,
		v36,
		v34,
		v35
	})

	local v40 = v34 or (v35 and v35.sender or nil)
	local v41 = if not v40 then nil else v40.targetId
	local v42 = useUserNameFromUserId(if not v39 or (not v41 or v41 == 0) then nil else v41)
	local v43 = if not v40 or not v40.targetName and not v40.targetDisplayName then if not v39 or (not v42 or v42 == "") then nil else v42 else v40.targetName or v40.targetDisplayName
	local v44 = useLocalization(TransferLocalizationKeys.Presets.ReceiveErrorSheet)
	local GenericError, TryAgain

	if not v38 then
		GenericError = v44.GenericError
		TryAgain = v44.TryAgain
	else
		TryAgain = v44.OK

		if v38 == FailureReason.TransferDisabledForUser then
			GenericError = v44.AccountDisabled
		elseif v38 == FailureReason.TransferExpired then
			GenericError = transferLocaleFormat.substituteUsername(v44.TransferExpired, (tostring(v43)))
		else
			GenericError = v44.GenericError
			TryAgain = v44.TryAgain
		end
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = {
			useScaledValue(300),
			0.5
		},
		onClose = triggerOnClose
	}, {
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 1
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
						size = v32.Size.Size_1200
					})
				}),
				ErrorMessage = React.createElement(FoundationText, {
					tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
					LayoutOrder = 2,
					Text = GenericError,
					Size = UDim2.new(1, 0, 0, 0)
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 2
		}, { React.createElement(View, {
			tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
		}, { React.createElement(View, {
			tag = "row auto-y size-full-0 gap-small"
		}, { React.createElement(Button, {
			text = TryAgain,
			onActivated = triggerOnClose,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return ReceiveErrorSheet
