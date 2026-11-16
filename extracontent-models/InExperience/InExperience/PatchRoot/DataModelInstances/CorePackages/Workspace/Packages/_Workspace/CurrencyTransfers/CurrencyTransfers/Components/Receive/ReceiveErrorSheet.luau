local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)
local useUserNameFromUserId = require(CurrencyTransfers.Hooks.useUserNameFromUserId)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)

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
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function getErrorMessageAndButton(p, data, p2: string?)
	if not p then
		return data.GenericError, data.TryAgain
	end

	local v = data.OK
	local v2

	if p == FailureReason.TransferDisabledForUser then
		v2 = data.AccountDisabled
	elseif p == FailureReason.TransferExpired then
		v2 = transferLocaleFormat.substituteUsername(data.TransferExpired, (tostring(p2)))
	else
		v2 = data.GenericError
		v = data.TryAgain
	end

	return v2, v
end

local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function ReceiveErrorSheet(_)
	local v = useTransferStore()
	local v2 = useTokens()
	local v3 = SignalsReact.useSignalState(v.getErrorTransferModel)
	local v4 = SignalsReact.useSignalState(v.getSender)
	local v5 = SignalsReact.useSignalState(v.getRobuxTransfer)
	local transferRequestId = SignalsReact.useSignalState(v.getTransferRequestId)
	local triggerOnClose = v.triggerOnClose
	local failureReason

	if v3 then
		failureReason = v3.failureReason
	end

	local v6 = failureReason == FailureReason.TransferExpired

	React.useEffect(function()
		if v6 and not (v4 or v5 and v5.sender) and transferRequestId then
			getTransferRequestByIdRequest({ transferRequestId = transferRequestId }, nil, v.getNetworkImpl()):andThen(function(p)
				if p and p.transfer and p.transfer.sender then
					v.setSender(p.transfer.sender)
				end
			end):catch(function() end)
		end
	end, { v6, transferRequestId, v4, v5 })

	local v7 = v4 or v5 and v5.sender or nil
	local targetId

	if v7 then
		targetId = v7.targetId
	end

	if not v6 or not targetId or targetId == 0 then
		targetId = nil
	end

	local v8 = useUserNameFromUserId(targetId)

	if v7 and (v7.targetName or v7.targetDisplayName) then
		v8 = v7.targetName or v7.targetDisplayName
	elseif not v6 or not v8 or v8 == "" then
		v8 = nil
	end

	local v9 = useLocalization(TransferLocalizationKeys.Presets.ReceiveErrorSheet)
	local text, text2

	if failureReason then
		text = v9.OK

		if failureReason == FailureReason.TransferDisabledForUser then
			text2 = v9.AccountDisabled
		elseif failureReason == FailureReason.TransferExpired then
			text2 = transferLocaleFormat.substituteUsername(v9.TransferExpired, (tostring(v8)))
		else
			text2 = v9.GenericError
			text = v9.TryAgain
		end
	else
		text2 = v9.GenericError
		text = v9.TryAgain
	end

	local ref, ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref, ref2 = useTransferSheetFocus(triggerOnClose)
	end

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { useScaledValue(300), 0.5 },
		onClose = triggerOnClose,
		ref = ref
	}, {
		Content = React.createElement(Sheet.Content, { LayoutOrder = 1 }, {
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
						Text = text2,
						tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2
					})
				}
			)
		}),
		Actions = React.createElement(Sheet.Actions, { LayoutOrder = 2 }, {
			React.createElement(View, {
				tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
			}, {
				React.createElement(View, { tag = "row auto-y size-full-0 gap-small" }, { React.createElement(Button, {
						ref = ref2,
						text = text,
						onActivated = triggerOnClose,
						variant = ButtonVariant.Emphasis,
						fillBehavior = FillBehavior.Fill
					}) })
			})
		})
	})
end

return ReceiveErrorSheet
