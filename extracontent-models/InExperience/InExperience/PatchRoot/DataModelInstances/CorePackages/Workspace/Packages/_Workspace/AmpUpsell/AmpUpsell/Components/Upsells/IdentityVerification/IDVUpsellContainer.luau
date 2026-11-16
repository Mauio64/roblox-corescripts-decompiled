local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Promise = require(parent.Promise)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AppScreens = require(AmpUpsell.Common.AppScreens)
local IDVWithQRCodeUpsell = require(script.Parent.IDVWithQRCodeUpsell)
local IdentityVerification = require(parent.IdentityVerification)
local IDVApiProvider = IdentityVerification.IDVApiProvider
local GetFStringBiometricPrivacyPolicyLink = require(AmpUpsell.Flags.GetFStringBiometricPrivacyPolicyLink)
local IdentityVerification2 = require(parent.IdentityVerification)
local GetFIntIDVPollDelay = IdentityVerification2.GetFIntIDVPollDelay
local IdentityVerification3 = require(parent.IdentityVerification)
local GetFIntIDVMaxRetries = IdentityVerification3.GetFIntIDVMaxRetries
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local IDVStep = Enums.IDVStep
local IdentityVerification4 = require(parent.IdentityVerification)
local IDVSessionStatusEnum = IdentityVerification4.Enums.IDVSessionStatusEnum
local ActionStatusEnum = Enums.ActionStatusEnum
local IDVErrorScreen = require(script.Parent.IDVErrorScreen)
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local idvErrorScreenStrings = LocalizationStrings.idvErrorScreenStrings
local idvWithQRCodeUpsellStrings = LocalizationStrings.idvWithQRCodeUpsellStrings
local IDVDirectLinkUpsell = require(script.Parent.IDVDirectLinkUpsell)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local GetFFlagEnableDirectLinkForTablets = require(AmpUpsell.Flags.GetFFlagEnableDirectLinkForTablets)

local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags2.RoactNetworking

local GetFFlagEnableRoactNetworkingForChallengeInteception = require(AmpUpsell.Flags.GetFFlagEnableRoactNetworkingForChallengeInteception)

local GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell = require(AmpUpsell.Flags.GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell)
local GetFFlagEnableAmpIDVUpsellAnalytics = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellAnalytics)

local FacialAgeEstimationServiceWrapper = require(script.Parent.Parent.FacialAgeEstimation.FacialAgeEstimationServiceWrapper)

local AuthAnalytics = require(parent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction

local fIntIDVPollDelay = GetFIntIDVPollDelay()
local fIntIDVMaxRetries = GetFIntIDVMaxRetries()

local function isFailure(sessionStatus): boolean -- 1 equivalent call inferred from this helper
	return sessionStatus == IDVSessionStatusEnum.Failure
		or sessionStatus == IDVSessionStatusEnum.RequiresManualReview
		or sessionStatus == IDVSessionStatusEnum.RequiresRetry
		or sessionStatus == IDVSessionStatusEnum.Expired
end

local function getErrorDescription(sessionStatus, data) -- 1 equivalent call inferred from this helper
	if sessionStatus == IDVSessionStatusEnum.Failure or sessionStatus == IDVSessionStatusEnum.RequiresManualReview then
		return data.declined
	end

	if sessionStatus == IDVSessionStatusEnum.RequiresRetry then
		return data.retry
	end

	if sessionStatus == IDVSessionStatusEnum.Expired then
		return data.timeout
	end

	return data.retry
end

local function IDVUpsellContainer(props)
	local featureName = props.featureName
	local onSuccess = props.onSuccess
	local onFailure = props.onFailure
	local onCancelled = props.onCancelled
	local v

	if props.idvApiProvider then
		v = props.idvApiProvider
	else
		v = IDVApiProvider
	end

	local deviceType = props.deviceType or useDeviceType()
	local v2 = useNavigation()
	local v3 = useLocalization(idvErrorScreenStrings)
	local v4 = useLocalization(idvWithQRCodeUpsellStrings)

	local entryPointEventCtx = props.entryPointEventCtx or ""
	local sessionId = props.metadata and props.metadata.sessionId or ""

	local state, setState = React.useState(nil)
	local ref = React.useRef(true)
	local state2, setState2 = React.useState(ActionStatusEnum.Unknown)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(v3.retry)
	local state5, setState5 = React.useState(0)
	local v5 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
	local v6 = GetFFlagEnableDirectLinkForTablets() and deviceType == DeviceType.Tablet and true
		or deviceType == DeviceType.Phone
	local v7 = useRoactService(AppLinking)
	local v8 = useRoactService(RoactNetworking)
	local schedulePoll = props.schedulePoll or function(callback, p: number)
		spawn(function()
			wait(p)
			callback()
		end)
	end

	local openIdvLink = props.openIdvLink or function(p)
		v7:openURL(p)
	end

	local function fn()
		v2.navigate(AppScreens.GenericWebPage, {
			detail = GetFStringBiometricPrivacyPolicyLink(),
			extraProps = { title = v4.privacyPageHeader, transitionAnimation = "SlideInFromBottom" }
		})
	end

	local function updateChecklist(sessionStatus)
		if sessionStatus == IDVSessionStatusEnum.Stored then
			setState5(IDVStep.UpdatedRobloxProfile)
		elseif sessionStatus == IDVSessionStatusEnum.Success then
			setState5(IDVStep.Verified)
		elseif sessionStatus == IDVSessionStatusEnum.Submitted then
			setState5(IDVStep.GotResults)
		elseif sessionStatus == IDVSessionStatusEnum.Started then
			setState5(IDVStep.ConnectedMobile)
		end
	end

	local function reportErrorShown(p: string) -- 3 equivalent calls inferred from this helper
		if GetFFlagEnableAmpIDVUpsellAnalytics() then
			authModalShown(entryPointEventCtx, p, "idvFailed")
		end
	end

	local function pollIDVStatus(sessionIdentifier: string, fIntIDVMaxRetries2: number, p: string)
		if fIntIDVMaxRetries2 == 0 then
			setState3(true)
			setState4(v3.timeout)
			reportErrorShown(p) -- inferred equivalent call
		else
			v.getVerifiedStatus(sessionIdentifier):andThen(function(p2)
				local isVerified = p2.isVerified
				local sessionStatus = p2.sessionStatus
				updateChecklist(sessionStatus)

				if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authMsgShown(entryPointEventCtx, p, "idvSuccess")
					end

					setState2(ActionStatusEnum.Success)
				elseif isFailure(sessionStatus) then -- inferred equivalent call
					setState3(true)
					setState2(ActionStatusEnum.Failure)
					setState4(getErrorDescription(sessionStatus, v3)) -- inferred equivalent call
					reportErrorShown(p) -- inferred equivalent call
				else
					schedulePoll(function()
						if ref.current then
							pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries2 - 1, p)
						end
					end, fIntIDVPollDelay)
				end
			end):catch(function(_)
				setState3(true)
				setState4(v3.retry)
				reportErrorShown(p) -- inferred equivalent call
			end)
		end
	end

	React.useEffect(function()
		ref.current = true
		local v9 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell()
			and FacialAgeEstimationServiceWrapper.isAvailable()
		local fFlagEnableAmpIDVUpsellAnalytics = GetFFlagEnableAmpIDVUpsellAnalytics()
		local v10 = sessionId

		local function afterStartVerification(data)
			local sessionIdentifier = data.sessionIdentifier

			if fFlagEnableAmpIDVUpsellAnalytics then
				v10 = `{sessionId}_{sessionIdentifier}`
			end

			if v9 then
				if fFlagEnableAmpIDVUpsellAnalytics then
					authModalShown(entryPointEventCtx, v10, "nativeIDV")
				end

				return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, data.sessionToken):andThen(function()
					pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries, v10)
				end)
			end

			if fFlagEnableAmpIDVUpsellAnalytics then
				authModalShown(entryPointEventCtx, v10, v6 and "idvDirectLink" or "idvQRCode")
			end

			pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries, v10)
			setState(data.verificationLink)
			return Promise.resolve()
		end

		local v11

		if GetFFlagEnableRoactNetworkingForChallengeInteception() then
			v11 = v.startVerificationWithWrappedNetworking(v8)
		else
			v11 = v.startVerification()
		end

		v11:andThen(afterStartVerification):catch(function(p)
			if v9 and p and p.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				if fFlagEnableAmpIDVUpsellAnalytics then
					authFormInteraction(entryPointEventCtx, v10, "idvCancelled")
				end

				setState2(ActionStatusEnum.Cancelled)
			else
				setState3(true)
				setState4(v3.retry)

				if fFlagEnableAmpIDVUpsellAnalytics then
					authModalShown(entryPointEventCtx, v10, "idvFailed")
				end
			end
		end)

		return function()
			ref.current = false
		end
	end, {})

	React.useEffect(function()
		if state2 == ActionStatusEnum.Success then
			onSuccess()
		elseif state2 == ActionStatusEnum.Cancelled then
			onCancelled()
		end
	end, { state2 })

	if state3 then
		return React.createElement(IDVErrorScreen, {
			errorTitle = v3.title,
			errorDescription = state4,
			buttonText = v3.close,
			onClose = function()
				onFailure()
			end
		})
	end

	if v5 and state2 == ActionStatusEnum.Cancelled then
		return nil
	end

	if v5 and not state3 and (state2 == ActionStatusEnum.Unknown or state2 == ActionStatusEnum.Success) then
		return React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	if v6 then
		return React.createElement(IDVDirectLinkUpsell, {
			featureName = featureName,
			idvLink = state,
			openIdvLink = openIdvLink,
			onClose = function()
				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authFormInteraction(entryPointEventCtx, sessionId, "idvCancelled")
				end

				setState2(ActionStatusEnum.Cancelled)
			end,
			openPrivacyPolicyLink = fn,
			latestStepCompleted = state5
		})
	end

	return React.createElement(IDVWithQRCodeUpsell, {
		qrCodeLink = state,
		featureName = featureName,
		openPrivacyPolicyLink = fn,
		latestStepCompleted = state5,
		onClose = function()
			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authFormInteraction(entryPointEventCtx, sessionId, "idvCancelled")
			end

			setState2(ActionStatusEnum.Cancelled)
		end
	})
end

return IDVUpsellContainer
