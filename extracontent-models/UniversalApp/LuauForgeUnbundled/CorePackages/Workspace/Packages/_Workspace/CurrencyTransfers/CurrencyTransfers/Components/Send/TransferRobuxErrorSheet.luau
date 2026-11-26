local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")

local getBalanceRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getBalanceRequest")
local useUserNameFromUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useUserNameFromUserId")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RobloxAppEnums").AppPage
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UrlBuilder").UrlBuilder
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local WebViewServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/WebViewServiceWrapper")

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

local GetFIntCurrencyTransferMinAmount = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferMinAmount")
local GetFIntCurrencyTransferMaxAmount = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferMaxAmount")

local GetFFlagCurrencyTransferUseBackendTransferLimits = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferUseBackendTransferLimits")

local GetFFlagCurrencyTransferReceiveLimitExceededError = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferReceiveLimitExceededError")
local GetFFlagEnableLimitHit2SVUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagEnableLimitHit2SVUpsell")

local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferRobuxHeader")
local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local function getErrorMessageAndButton(failureReason, data, value, p2, p3, p4)
	if not failureReason then
		return data.GenericError, data.TryAgain
	end

	local v5 = data.OK
	local v6

	if GetFFlagEnableLimitHit2SVUpsell() then
		if failureReason == FailureReason.TransferDailyLimitExceeded then
			if p4 then
				v6 = data.DailyLimitTwoStepVerificationUpsell
				v5 = data.TurnOnTwoStepVerification
			else
				v6 = data.DailyLimitExceeded
			end
		elseif failureReason == FailureReason.TransferMonthlyLimitExceeded then
			if p4 then
				v6 = data.MonthlyLimitTwoStepVerificationUpsell
				v5 = data.TurnOnTwoStepVerification
			else
				v6 = data.MonthlyLimitExceeded
			end
		elseif failureReason == FailureReason.TransferDisabledForUser then
			v6 = data.AccountDisabled
		elseif GetFFlagCurrencyTransferReceiveLimitExceededError() and failureReason == FailureReason.ReceiveLimitExceeded then
			v6 = data.ReceiveLimitExceeded
		elseif failureReason == FailureReason.ReceiverNotAllowed then
			v6 = transferLocaleFormat.substituteUsername(data.ReceiverNotAllowed, value or "")
		else
			if failureReason == FailureReason.TransferAmountBelowMinimum then
				v6 = transferLocaleFormat.substituteMinAmount(data.TransferAmountBelowMinimum, (tostring(p2)))
			elseif failureReason == FailureReason.TransferAmountExceedsMaximum then
				v6 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p3)))
			elseif failureReason == FailureReason.TransferAmountExceedsNonSecuredMaximum then
				v6 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p3)))
			else
				v6 = data.GenericError
			end

			v5 = data.TryAgain
		end
	elseif failureReason == FailureReason.TransferDailyLimitExceeded then
		v6 = data.DailyLimitExceeded
	elseif failureReason == FailureReason.TransferMonthlyLimitExceeded then
		v6 = data.MonthlyLimitExceeded
	elseif failureReason == FailureReason.TransferDisabledForUser then
		v6 = data.AccountDisabled
	elseif GetFFlagCurrencyTransferReceiveLimitExceededError() and failureReason == FailureReason.ReceiveLimitExceeded then
		v6 = data.ReceiveLimitExceeded
	elseif failureReason == FailureReason.ReceiverNotAllowed then
		v6 = transferLocaleFormat.substituteUsername(data.ReceiverNotAllowed, value or "")
	else
		if failureReason == FailureReason.TransferAmountBelowMinimum then
			v6 = transferLocaleFormat.substituteMinAmount(data.TransferAmountBelowMinimum, (tostring(p2)))
		elseif failureReason == FailureReason.TransferAmountExceedsMaximum then
			v6 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p3)))
		elseif failureReason == FailureReason.TransferAmountExceedsNonSecuredMaximum then
			v6 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p3)))
		else
			v6 = data.GenericError
		end

		v5 = data.TryAgain
	end

	return v6, v5
end

local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function TransferRobuxErrorSheet(p2)
	local v5 = useTransferStore()
	local v6 = useTokens()
	local v7 = SignalsReact.useSignalState(v5.getRobuxBalanceAmount) or 0
	local balanceReceivedFromApi = v5.getBalanceReceivedFromApi(false)
	local errorTransferModel = v5.getErrorTransferModel(false)
	local recipient = v5.getRecipient(false)
	local recipientUserId = v5.getRecipientUserId(false)
	local triggerOnClose = v5.triggerOnClose
	local v8, v9

	if GetFFlagCurrencyTransferFocusNavigation() then
		v8, v9 = useTransferSheetFocus(triggerOnClose)
	end

	if GetFFlagEnableLimitHit2SVUpsell() then
		local v10 = useDispatch()

		local failureReason = if errorTransferModel then errorTransferModel.failureReason else nil
		local v11

		if failureReason == FailureReason.ReceiverNotAllowed then
			v11 = not recipient and recipientUserId and recipientUserId ~= 0
		else
			v11 = false
		end

		if not v11 or not recipientUserId or recipientUserId == 0 then
			recipientUserId = nil
		end

		local v13 = useUserNameFromUserId(recipientUserId)

		local v14 = if errorTransferModel then errorTransferModel.isEligibleForElevatedLimitUpsell else false
		local v15

		if
			failureReason == FailureReason.TransferDailyLimitExceeded
			or failureReason == FailureReason.TransferMonthlyLimitExceeded
		then
			v15 = v14
		else
			v15 = false
		end

		local v16 = if v15 then enums.IconName.CircleArrowUp else enums.IconName.TriangleExclamation

		local function handleButtonActivated()
			triggerOnClose()

			if v15 then
				if v5.getTransferOrigination(false) == TransferOrigination.InExperience then
					local v17 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
					local v18 = string.gsub(v17, "http:", "https:") .. "my/account#!/robux"
					WebViewServiceWrapper.new({ url = v18, title = "Robux" }):open()
				else
					v10(navigateDown({
						name = appPage.SettingsSubPage,
						detail = urlBuilder.static.settings.robux(),
						extraProps = {
							titleKey = "Feature.AccountSettings.Heading.Tab.Robux"
						}
					}))
				end
			end
		end

		React.useEffect(function()
			if balanceReceivedFromApi then
				return
			end

			getBalanceRequest(nil, v5.getNetworkImpl()):andThen(function(p3)
				v5.setRobuxBalanceAmount(p3)
				v5.setBalanceReceivedFromApi(true)
			end):catch(function() end)
		end, { balanceReceivedFromApi })

		local v17 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)

		local v18 = SignalsReact.useSignalState(v5.getMinimumTransferAmount)
		local v19 = SignalsReact.useSignalState(v5.getMaximumTransferAmount)
		local v20 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v18 or GetFIntCurrencyTransferMinAmount()
		local v21 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v19 or GetFIntCurrencyTransferMaxAmount()

		if recipient and (recipient.targetName or recipient.targetDisplayName) then
			v13 = recipient.targetName or recipient.targetDisplayName
		elseif not v11 or not v13 or v13 == "" then
			v13 = nil
		end

		local errorMessageAndButton, v22 = getErrorMessageAndButton(
			failureReason,
			v17,
			v13 or "",
			v20,
			v21,
			v14
		)

		return React.createElement(sheet.Root, {
			preferCenterSheet = true,
			snapPoints = { useScaledValue(300), 0.5 },
			onClose = triggerOnClose,
			ref = v8
		}, {
			Header = React.createElement(sheet.Header, {}, {
				TransferRobuxHeader = React.createElement(module16, {
					titleText = v17.SendRobux or "",
					robuxBalanceAmount = v7
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
									name = v16,
									size = v6.Size.Size_1200,
									tag = "content-inverse-emphasis"
								})
							}
						),
						ErrorMessage = React.createElement(text, {
							Text = errorMessageAndButton,
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
								ref = v9,
								text = v22,
								onActivated = handleButtonActivated,
								variant = buttonVariant.Emphasis,
								fillBehavior = fillBehavior.Fill
							})
						}) }
				)
			})
		})
	else
		local failureReason = if errorTransferModel then errorTransferModel.failureReason else nil
		local v10

		if failureReason == FailureReason.ReceiverNotAllowed then
			v10 = not recipient and recipientUserId and recipientUserId ~= 0
		else
			v10 = false
		end

		if not v10 or not recipientUserId or recipientUserId == 0 then
			recipientUserId = nil
		end

		local v12 = useUserNameFromUserId(recipientUserId)

		React.useEffect(function()
			if balanceReceivedFromApi then
				return
			end

			getBalanceRequest(nil, v5.getNetworkImpl()):andThen(function(p3)
				v5.setRobuxBalanceAmount(p3)
				v5.setBalanceReceivedFromApi(true)
			end):catch(function() end)
		end, { balanceReceivedFromApi })

		local v13 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)

		local v14 = SignalsReact.useSignalState(v5.getMinimumTransferAmount)
		local v15 = SignalsReact.useSignalState(v5.getMaximumTransferAmount)
		local v16 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v14 or GetFIntCurrencyTransferMinAmount()
		local v17 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v15 or GetFIntCurrencyTransferMaxAmount()

		if recipient and (recipient.targetName or recipient.targetDisplayName) then
			v12 = recipient.targetName or recipient.targetDisplayName
		elseif not v10 or not v12 or v12 == "" then
			v12 = nil
		end

		local errorMessageAndButton, v18 = getErrorMessageAndButton(
			failureReason,
			v13,
			v12 or "",
			v16,
			v17,
			false
		)

		return React.createElement(sheet.Root, {
			preferCenterSheet = true,
			snapPoints = { useScaledValue(300), 0.5 },
			onClose = triggerOnClose,
			ref = v8
		}, {
			Header = React.createElement(sheet.Header, {}, {
				TransferRobuxHeader = React.createElement(module16, {
					titleText = v13.SendRobux or "",
					robuxBalanceAmount = v7
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
							Text = errorMessageAndButton,
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
								ref = v9,
								text = v18,
								onActivated = triggerOnClose,
								variant = buttonVariant.Emphasis,
								fillBehavior = fillBehavior.Fill
							})
						}) }
				)
			})
		})
	end
end

return TransferRobuxErrorSheet
