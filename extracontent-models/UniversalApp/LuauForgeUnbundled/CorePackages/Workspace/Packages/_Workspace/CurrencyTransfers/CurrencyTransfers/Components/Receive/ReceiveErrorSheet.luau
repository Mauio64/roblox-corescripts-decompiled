local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")

local getTransferRequestByIdRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getTransferRequestByIdRequest")
local useUserNameFromUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useUserNameFromUserId")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")

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
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/FailureReason")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local function getErrorMessageAndButton(p2, data, p3)
	if not p2 then
		return data.GenericError, data.TryAgain
	end

	local v5 = data.OK
	local v6

	if p2 == FailureReason.TransferDisabledForUser then
		v6 = data.AccountDisabled
	elseif p2 == FailureReason.TransferExpired then
		v6 = transferLocaleFormat.substituteUsername(data.TransferExpired, (tostring(p3)))
	else
		v6 = data.GenericError
		v5 = data.TryAgain
	end

	return v6, v5
end

local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function ReceiveErrorSheet(p2)
	local v5 = useTransferStore()
	local v6 = useTokens()
	local v7 = SignalsReact.useSignalState(v5.getErrorTransferModel)
	local v8 = SignalsReact.useSignalState(v5.getSender)
	local v9 = SignalsReact.useSignalState(v5.getRobuxTransfer)
	local v10 = SignalsReact.useSignalState(v5.getTransferRequestId)
	local triggerOnClose = v5.triggerOnClose

	local failureReason = if v7 then v7.failureReason else nil
	local v11 = failureReason == FailureReason.TransferExpired

	React.useEffect(function()
		if v11 and not (v8 or v9 and v9.sender) and v10 then
			getTransferRequestByIdRequest({ transferRequestId = v10 }, nil, v5.getNetworkImpl()):andThen(function(p3)
				if p3 and p3.transfer and p3.transfer.sender then
					v5.setSender(p3.transfer.sender)
				end
			end):catch(function() end)
		end
	end, { v11, v10, v8, v9 })

	local v12 = v8 or v9 and v9.sender or nil
	local targetId = if v12 then v12.targetId else nil

	if not v11 or not targetId or targetId == 0 then
		targetId = nil
	end

	local v14 = useUserNameFromUserId(targetId)

	if v12 and (v12.targetName or v12.targetDisplayName) then
		v14 = v12.targetName or v12.targetDisplayName
	elseif not v11 or not v14 or v14 == "" then
		v14 = nil
	end

	local v15 = useLocalization(TransferLocalizationKeys.Presets.ReceiveErrorSheet)
	local v16, v17

	if failureReason then
		v16 = v15.OK

		if failureReason == FailureReason.TransferDisabledForUser then
			v17 = v15.AccountDisabled
		elseif failureReason == FailureReason.TransferExpired then
			v17 = transferLocaleFormat.substituteUsername(v15.TransferExpired, (tostring(v14)))
		else
			v17 = v15.GenericError
			v16 = v15.TryAgain
		end
	else
		v17 = v15.GenericError
		v16 = v15.TryAgain
	end

	local v18, v19

	if GetFFlagCurrencyTransferFocusNavigation() then
		v18, v19 = useTransferSheetFocus(triggerOnClose)
	end

	return React.createElement(sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { useScaledValue(300), 0.5 },
		onClose = triggerOnClose,
		ref = v18
	}, {
		Content = React.createElement(sheet.Content, { LayoutOrder = 1 }, {
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
						Text = v17,
						tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2
					})
				}
			)
		}),
		Actions = React.createElement(sheet.Actions, { LayoutOrder = 2 }, {
			React.createElement(
				view,
				{
					tag = "col auto-y align-y-center align-x-center size-full-0 gap-small"
				},
				{ React.createElement(view, {
						tag = "row auto-y size-full-0 gap-small"
					}, {
						React.createElement(button, {
							ref = v19,
							text = v16,
							onActivated = triggerOnClose,
							variant = buttonVariant.Emphasis,
							fillBehavior = fillBehavior.Fill
						})
					}) }
			)
		})
	})
end

return ReceiveErrorSheet
