local ContentProvider = game:GetService("ContentProvider")
local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)
local useUserNameFromUserId = require(CurrencyTransfers.Hooks.useUserNameFromUserId)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local useDispatch = require(CurrencyTransfersParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(CurrencyTransfersParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(CurrencyTransfersParent.RobloxAppEnums).AppPage
local UrlBuilder = require(CurrencyTransfersParent.UrlBuilder).UrlBuilder
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local WebViewServiceWrapper = require(CurrencyTransfers.Utils.WebViewServiceWrapper)
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
local GetFFlagEnableLimitHit2SVUpsell = require(CurrencyTransfers.Flags.GetFFlagEnableLimitHit2SVUpsell)
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function getErrorMessageAndButton(p1, p2, p3, p4, p5, p6) -- line: 58
	-- upvalues: GetFFlagEnableLimitHit2SVUpsell (copy), FailureReason (copy), GetFFlagCurrencyTransferReceiveLimitExceededError (copy), transferLocaleFormat (copy)
	if not p1 then
		return p2.GenericError, p2.TryAgain
	end

	local OK = p2.OK
	local DailyLimitTwoStepVerificationUpsell

	if GetFFlagEnableLimitHit2SVUpsell() then
		if p1 == FailureReason.TransferDailyLimitExceeded then
			if p6 then
				DailyLimitTwoStepVerificationUpsell = p2.DailyLimitTwoStepVerificationUpsell
				OK = p2.TurnOnTwoStepVerification
			else
				DailyLimitTwoStepVerificationUpsell = p2.DailyLimitExceeded
			end
		elseif p1 == FailureReason.TransferMonthlyLimitExceeded then
			if p6 then
				DailyLimitTwoStepVerificationUpsell = p2.MonthlyLimitTwoStepVerificationUpsell
				OK = p2.TurnOnTwoStepVerification
			else
				DailyLimitTwoStepVerificationUpsell = p2.MonthlyLimitExceeded
			end
		elseif p1 == FailureReason.TransferDisabledForUser then
			DailyLimitTwoStepVerificationUpsell = p2.AccountDisabled
		elseif GetFFlagCurrencyTransferReceiveLimitExceededError() and p1 == FailureReason.ReceiveLimitExceeded then
			DailyLimitTwoStepVerificationUpsell = p2.ReceiveLimitExceeded
		elseif p1 == FailureReason.ReceiverNotAllowed then
			DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteUsername(p2.ReceiverNotAllowed, p3 or "")
		elseif p1 == FailureReason.TransferAmountBelowMinimum then
			DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMinAmount(p2.TransferAmountBelowMinimum, (tostring(p4)))
			OK = p2.TryAgain
		elseif p1 == FailureReason.TransferAmountExceedsMaximum then
			DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
			OK = p2.TryAgain
		elseif p1 == FailureReason.TransferAmountExceedsNonSecuredMaximum then
			DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
			OK = p2.TryAgain
		else
			DailyLimitTwoStepVerificationUpsell = p2.GenericError
			OK = p2.TryAgain
		end
	elseif p1 == FailureReason.TransferDailyLimitExceeded then
		DailyLimitTwoStepVerificationUpsell = p2.DailyLimitExceeded
	elseif p1 == FailureReason.TransferMonthlyLimitExceeded then
		DailyLimitTwoStepVerificationUpsell = p2.MonthlyLimitExceeded
	elseif p1 == FailureReason.TransferDisabledForUser then
		DailyLimitTwoStepVerificationUpsell = p2.AccountDisabled
	elseif GetFFlagCurrencyTransferReceiveLimitExceededError() and p1 == FailureReason.ReceiveLimitExceeded then
		DailyLimitTwoStepVerificationUpsell = p2.ReceiveLimitExceeded
	elseif p1 == FailureReason.ReceiverNotAllowed then
		DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteUsername(p2.ReceiverNotAllowed, p3 or "")
	elseif p1 == FailureReason.TransferAmountBelowMinimum then
		DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMinAmount(p2.TransferAmountBelowMinimum, (tostring(p4)))
		OK = p2.TryAgain
	elseif p1 == FailureReason.TransferAmountExceedsMaximum then
		DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
		OK = p2.TryAgain
	elseif p1 == FailureReason.TransferAmountExceedsNonSecuredMaximum then
		DailyLimitTwoStepVerificationUpsell = transferLocaleFormat.substituteMaxAmount(p2.TransferAmountExceedsMaximum, (tostring(p5)))
		OK = p2.TryAgain
	else
		DailyLimitTwoStepVerificationUpsell = p2.GenericError
		OK = p2.TryAgain
	end

	return DailyLimitTwoStepVerificationUpsell, OK
end
local function TransferRobuxErrorSheet(_: {[any]: any}) -- line: 163
	-- upvalues: useTransferStore (copy), useTokens (copy), SignalsReact (copy), GetFFlagEnableLimitHit2SVUpsell (copy), useDispatch (copy), FailureReason (copy), useUserNameFromUserId (copy), Enums (copy), TransferOrigination (copy), ContentProvider (copy), WebViewServiceWrapper (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy), React (copy), getBalanceRequest (copy), useLocalization (copy), TransferLocalizationKeys (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), GetFIntCurrencyTransferMinAmount (copy), GetFIntCurrencyTransferMaxAmount (copy), getErrorMessageAndButton (copy), Sheet (copy), useScaledValue (copy), TransferRobuxHeader (copy), View (copy), Icon (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v47 = useTransferStore()
	local v48 = useTokens()
	local v49 = SignalsReact.useSignalState(v47.getRobuxBalanceAmount) or 0
	local v50 = v47.getBalanceReceivedFromApi(false)
	local v51 = v47.getErrorTransferModel(false)
	local v52 = v47.getRecipient(false)
	local v53 = v47.getRecipientUserId(false)
	local triggerOnClose = v47.triggerOnClose

	if GetFFlagEnableLimitHit2SVUpsell() then
		local v55 = useDispatch()
		local v56 = if not v51 then nil else v51.failureReason
		local v57 = v56 == FailureReason.ReceiverNotAllowed and (not v52 and (v53 and v53 ~= 0))
		local v58 = useUserNameFromUserId(if not v57 or (not v53 or v53 == 0) then nil else v53)
		local v59 = not not v51 and v51.isEligibleForElevatedLimitUpsell
		local v60 = (v56 == FailureReason.TransferDailyLimitExceeded or v56 == FailureReason.TransferMonthlyLimitExceeded) and v59
		local v61 = if not v60 then Enums.IconName.TriangleExclamation else Enums.IconName.CircleArrowUp

		local function handleButtonActivated() -- line: 195
			-- upvalues: triggerOnClose (copy), v60 (copy), v47 (copy), TransferOrigination (copy), ContentProvider (copy), WebViewServiceWrapper (copy), v55 (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy)
			triggerOnClose()

			if v60 then
				if v47.getTransferOrigination(false) == TransferOrigination.InExperience then
					local v82 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
					local v83 = string.gsub(v82, "http:", "https:") .. "my/account#!/robux"

					WebViewServiceWrapper.new({
						title = "Robux",
						url = v83
					}):open()

					return
				end

				v55(NavigateDown({
					name = AppPage.SettingsSubPage,
					detail = UrlBuilder.static.settings.robux(),
					extraProps = {
						titleKey = "Feature.AccountSettings.Heading.Tab.Robux"
					}
				}))
			end
		end

		React.useEffect(function() -- line: 224
			-- upvalues: v50 (copy), getBalanceRequest (copy), v47 (copy)
			if v50 then
				return
			end

			getBalanceRequest(nil, v47.getNetworkImpl()):andThen(function(p7) -- line: 229
				-- upvalues: v47 (copy)
				v47.setRobuxBalanceAmount(p7)
				v47.setBalanceReceivedFromApi(true)
			end):catch(function() -- line: 233
			end)
		end, { v50 })

		local v63 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)
		local v64 = SignalsReact.useSignalState(v47.getMinimumTransferAmount)
		local v65 = SignalsReact.useSignalState(v47.getMaximumTransferAmount)
		local v66 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v64 or GetFIntCurrencyTransferMinAmount()
		local v67 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v65 or GetFIntCurrencyTransferMaxAmount()
		local v68 = if not v52 or not v52.targetName and not v52.targetDisplayName then if not v57 or (not v58 or v58 == "") then nil else v58 else v52.targetName or v52.targetDisplayName
		local v69, v70 = getErrorMessageAndButton(v56, v63, v68 or "", v66, v67, v59)

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
					titleText = v63.SendRobux or "",
					robuxBalanceAmount = v49
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
							name = v61,
							size = v48.Size.Size_1200
						})
					}),
					ErrorMessage = React.createElement(FoundationText, {
						tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
						LayoutOrder = 2,
						Text = v69,
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
				text = v70,
				onActivated = handleButtonActivated,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill
			}) }) }) })
		})
	end

	local v71 = if not v51 then nil else v51.failureReason
	local v72 = v71 == FailureReason.ReceiverNotAllowed and (not v52 and (v53 and v53 ~= 0))
	local v73 = useUserNameFromUserId(if not v72 or (not v53 or v53 == 0) then nil else v53)

	React.useEffect(function() -- line: 340
		-- upvalues: v50 (copy), getBalanceRequest (copy), v47 (copy)
		if v50 then
			return
		end

		getBalanceRequest(nil, v47.getNetworkImpl()):andThen(function(p8) -- line: 345
			-- upvalues: v47 (copy)
			v47.setRobuxBalanceAmount(p8)
			v47.setBalanceReceivedFromApi(true)
		end):catch(function() -- line: 349
		end)
	end, { v50 })

	local v74 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxErrorSheet)
	local v75 = SignalsReact.useSignalState(v47.getMinimumTransferAmount)
	local v76 = SignalsReact.useSignalState(v47.getMaximumTransferAmount)
	local v77 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v75 or GetFIntCurrencyTransferMinAmount()
	local v78 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v76 or GetFIntCurrencyTransferMaxAmount()
	local v79 = if not v52 or not v52.targetName and not v52.targetDisplayName then if not v72 or (not v73 or v73 == "") then nil else v73 else v52.targetName or v52.targetDisplayName
	local v80, v81 = getErrorMessageAndButton(v71, v74, v79 or "", v77, v78, false)

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
				titleText = v74.SendRobux or "",
				robuxBalanceAmount = v49
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
						size = v48.Size.Size_1200
					})
				}),
				ErrorMessage = React.createElement(FoundationText, {
					tag = "text-body-large content-emphasis text-align-x-center auto-y text-wrap",
					LayoutOrder = 2,
					Text = v80,
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
			text = v81,
			onActivated = triggerOnClose,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}) }) }) })
	})
end

return TransferRobuxErrorSheet
