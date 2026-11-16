local ContentProvider = game:GetService("ContentProvider")

local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)
local useUserNameFromUserId = require(CurrencyTransfers.Hooks.useUserNameFromUserId)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local WebViewServiceWrapper = require(CurrencyTransfers.Utils.WebViewServiceWrapper)

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

local GetFIntCurrencyTransferMinAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMinAmount)
local GetFIntCurrencyTransferMaxAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMaxAmount)

local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)

local GetFFlagCurrencyTransferReceiveLimitExceededError = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferReceiveLimitExceededError)
local GetFFlagEnableLimitHit2SVUpsell = require(CurrencyTransfers.Flags.GetFFlagEnableLimitHit2SVUpsell)

local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function getErrorMessageAndButton(failureReason, data, value, p, p2, p3)
	if not failureReason then
		return data.GenericError, data.TryAgain
	end

	local v = data.OK
	local v2

	if GetFFlagEnableLimitHit2SVUpsell() then
		if failureReason == FailureReason.TransferDailyLimitExceeded then
			if p3 then
				v2 = data.DailyLimitTwoStepVerificationUpsell
				v = data.TurnOnTwoStepVerification
			else
				v2 = data.DailyLimitExceeded
			end
		elseif failureReason == FailureReason.TransferMonthlyLimitExceeded then
			if p3 then
				v2 = data.MonthlyLimitTwoStepVerificationUpsell
				v = data.TurnOnTwoStepVerification
			else
				v2 = data.MonthlyLimitExceeded
			end
		elseif failureReason == FailureReason.TransferDisabledForUser then
			v2 = data.AccountDisabled
		elseif
			GetFFlagCurrencyTransferReceiveLimitExceededError()
			and failureReason == FailureReason.ReceiveLimitExceeded
		then
			v2 = data.ReceiveLimitExceeded
		elseif failureReason == FailureReason.ReceiverNotAllowed then
			v2 = transferLocaleFormat.substituteUsername(data.ReceiverNotAllowed, value or "")
		else
			if failureReason == FailureReason.TransferAmountBelowMinimum then
				v2 = transferLocaleFormat.substituteMinAmount(data.TransferAmountBelowMinimum, (tostring(p)))
			elseif failureReason == FailureReason.TransferAmountExceedsMaximum then
				v2 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p2)))
			elseif failureReason == FailureReason.TransferAmountExceedsNonSecuredMaximum then
				v2 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p2)))
			else
				v2 = data.GenericError
			end

			v = data.TryAgain
		end
	elseif failureReason == FailureReason.TransferDailyLimitExceeded then
		v2 = data.DailyLimitExceeded
	elseif failureReason == FailureReason.TransferMonthlyLimitExceeded then
		v2 = data.MonthlyLimitExceeded
	elseif failureReason == FailureReason.TransferDisabledForUser then
		v2 = data.AccountDisabled
	elseif
		GetFFlagCurrencyTransferReceiveLimitExceededError()
		and failureReason == FailureReason.ReceiveLimitExceeded
	then
		v2 = data.ReceiveLimitExceeded
	elseif failureReason == FailureReason.ReceiverNotAllowed then
		v2 = transferLocaleFormat.substituteUsername(data.ReceiverNotAllowed, value or "")
	else
		if failureReason == FailureReason.TransferAmountBelowMinimum then
			v2 = transferLocaleFormat.substituteMinAmount(data.TransferAmountBelowMinimum, (tostring(p)))
		elseif failureReason == FailureReason.TransferAmountExceedsMaximum then
			v2 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p2)))
		elseif failureReason == FailureReason.TransferAmountExceedsNonSecuredMaximum then
			v2 = transferLocaleFormat.substituteMaxAmount(data.TransferAmountExceedsMaximum, (tostring(p2)))
		else
			v2 = data.GenericError
		end

		v = data.TryAgain
	end

	return v2, v
end

local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function TransferRobuxErrorSheet(_)
	local v = useTransferStore()
	local v2 = useTokens()
	local robuxBalanceAmount = SignalsReact.useSignalState(v.getRobuxBalanceAmount) or 0
	local balanceReceivedFromApi = v.getBalanceReceivedFromApi(false)
	local errorTransferModel = v.getErrorTransferModel(false)
	local recipient = v.getRecipient(false)
	local recipientUserId = v.getRecipientUserId(false)
	local triggerOnClose = v.triggerOnClose
	local ref, ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref, ref2 = useTransferSheetFocus(triggerOnClose)
	end

	if GetFFlagEnableLimitHit2SVUpsell() then
		local v3 = useDispatch()
		local failureReason

		if errorTransferModel then
			failureReason = errorTransferModel.failureReason
		end

		local v4

		if failureReason == FailureReason.ReceiverNotAllowed then
			v4 = not recipient and recipientUserId and recipientUserId ~= 0
		else
			v4 = false
		end

		if not v4 or not recipientUserId or recipientUserId == 0 then
			recipientUserId = nil
		end

		local v5 = useUserNameFromUserId(recipientUserId)
		local v6

		if errorTransferModel then
			v6 = errorTransferModel.isEligibleForElevatedLimitUpsell
		else
			v6 = false
		end

		local v7

		if
			failureReason == FailureReason.TransferDailyLimitExceeded
			or failureReason == FailureReason.TransferMonthlyLimitExceeded
		then
			v7 = v6
		else
			v7 = false
		end

		local name

		if v7 then
			name = Enums.IconName.CircleArrowUp
		else
			name = Enums.IconName.TriangleExclamation
		end

		local function handleButtonActivated()
			triggerOnClose()

			if v7 then
				if v.getTransferOrigination(false) == TransferOrigination.InExperience then
					local v8 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
					local url = string.gsub(v8, "http:", "https:") .. "my/account#!/robux"
					WebViewServiceWrapper.new({ url = url, title = "Robux" }):open()
				else
					v3(NavigateDown({
						name = AppPage.SettingsSubPage,
						detail = urlBuilder.static.settings.robux(),
						extraProps = { titleKey = "Feature.AccountSettings.Heading.Tab.Robux" }
					}))
				end
			end
		end

		React.useEffect(function()
			if balanceReceivedFromApi then
				return
			end

			getBalanceRequest(nil, v.getNetworkImpl()):andThen(function(p)
				v.setRobuxBalanceAmount(p)
				v.setBalanceReceivedFromApi(true)
			end):catch(function() end)
		end, { balanceReceivedFromApi })

		local v8 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)

		local v9 = SignalsReact.useSignalState(v.getMinimumTransferAmount)
		local v10 = SignalsReact.useSignalState(v.getMaximumTransferAmount)
		local v11 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v9 or GetFIntCurrencyTransferMinAmount()
		local v12 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v10 or GetFIntCurrencyTransferMaxAmount()

		if recipient and (recipient.targetName or recipient.targetDisplayName) then
			v5 = recipient.targetName or recipient.targetDisplayName
		elseif not v4 or not v5 or v5 == "" then
			v5 = nil
		end

		local errorMessageAndButton, text = getErrorMessageAndButton(failureReason, v8, v5 or "", v11, v12, v6)

		return React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			snapPoints = { useScaledValue(300), 0.5 },
			onClose = triggerOnClose,
			ref = ref
		}, {
			Header = React.createElement(Sheet.Header, {}, {
				TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
					titleText = v8.SendRobux or "",
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
									name = name,
									size = v2.Size.Size_1200,
									tag = "content-inverse-emphasis"
								})
							}
						),
						ErrorMessage = React.createElement(Text, {
							Text = errorMessageAndButton,
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
					React.createElement(View, { tag = "row auto-y size-full-0 gap-small" }, {
						React.createElement(Button, {
							ref = ref2,
							text = text,
							onActivated = handleButtonActivated,
							variant = ButtonVariant.Emphasis,
							fillBehavior = FillBehavior.Fill
						})
					})
				})
			})
		})
	else
		local failureReason

		if errorTransferModel then
			failureReason = errorTransferModel.failureReason
		end

		local v3

		if failureReason == FailureReason.ReceiverNotAllowed then
			v3 = not recipient and recipientUserId and recipientUserId ~= 0
		else
			v3 = false
		end

		if not v3 or not recipientUserId or recipientUserId == 0 then
			recipientUserId = nil
		end

		local v4 = useUserNameFromUserId(recipientUserId)

		React.useEffect(function()
			if balanceReceivedFromApi then
				return
			end

			getBalanceRequest(nil, v.getNetworkImpl()):andThen(function(p)
				v.setRobuxBalanceAmount(p)
				v.setBalanceReceivedFromApi(true)
			end):catch(function() end)
		end, { balanceReceivedFromApi })

		local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)

		local v6 = SignalsReact.useSignalState(v.getMinimumTransferAmount)
		local v7 = SignalsReact.useSignalState(v.getMaximumTransferAmount)
		local v8 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v6 or GetFIntCurrencyTransferMinAmount()
		local v9 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v7 or GetFIntCurrencyTransferMaxAmount()

		if recipient and (recipient.targetName or recipient.targetDisplayName) then
			v4 = recipient.targetName or recipient.targetDisplayName
		elseif not v3 or not v4 or v4 == "" then
			v4 = nil
		end

		local errorMessageAndButton, text = getErrorMessageAndButton(failureReason, v5, v4 or "", v8, v9, false)

		return React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			snapPoints = { useScaledValue(300), 0.5 },
			onClose = triggerOnClose,
			ref = ref
		}, {
			Header = React.createElement(Sheet.Header, {}, {
				TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
					titleText = v5.SendRobux or "",
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
							Text = errorMessageAndButton,
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
					React.createElement(View, { tag = "row auto-y size-full-0 gap-small" }, {
						React.createElement(Button, {
							ref = ref2,
							text = text,
							onActivated = triggerOnClose,
							variant = ButtonVariant.Emphasis,
							fillBehavior = FillBehavior.Fill
						})
					})
				})
			})
		})
	end
end

return TransferRobuxErrorSheet
