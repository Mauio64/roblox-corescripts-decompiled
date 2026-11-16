local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Promise")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local IDVWithQRCodeUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/IDVWithQRCodeUpsell")
local idvApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").IDVApiProvider
local GetFStringBiometricPrivacyPolicyLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFStringBiometricPrivacyPolicyLink")
local getFIntIDVPollDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").GetFIntIDVPollDelay
local getFIntIDVMaxRetries = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").GetFIntIDVMaxRetries
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Navigation").useNavigation
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")
local idvStep = Enums.IDVStep
local idvSessionStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").Enums.IDVSessionStatusEnum
local actionStatusEnum = Enums.ActionStatusEnum
local IDVErrorScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/IDVErrorScreen")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings")
local idvErrorScreenStrings = LocalizationStrings.idvErrorScreenStrings
local idvWithQRCodeUpsellStrings = LocalizationStrings.idvWithQRCodeUpsellStrings
local IDVDirectLinkUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/IDVDirectLinkUpsell")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks")
local useDeviceType = RobloxAppHooks.useDeviceType
local useRoactService = RobloxAppHooks.useRoactService
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").AppLinking
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppEnums").DeviceType
local GetFFlagEnableDirectLinkForTablets = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableDirectLinkForTablets")

local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").RoactNetworking

local GetFFlagEnableRoactNetworkingForChallengeInteception = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableRoactNetworkingForChallengeInteception")

local GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell")
local GetFFlagEnableAmpIDVUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpIDVUpsellAnalytics")

local FacialAgeEstimationServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FacialAgeEstimationServiceWrapper")

local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics")
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction

local fIntIDVPollDelay = getFIntIDVPollDelay()
local fIntIDVMaxRetries = getFIntIDVMaxRetries()

local function isFailure(p2): boolean
	return p2 == idvSessionStatusEnum.Failure
		or p2 == idvSessionStatusEnum.RequiresManualReview
		or p2 == idvSessionStatusEnum.RequiresRetry
		or p2 == idvSessionStatusEnum.Expired
end

local function getErrorDescription(p2, data)
	if p2 == idvSessionStatusEnum.Failure or p2 == idvSessionStatusEnum.RequiresManualReview then
		return data.declined
	end

	if p2 == idvSessionStatusEnum.RequiresRetry then
		return data.retry
	end

	if p2 == idvSessionStatusEnum.Expired then
		return data.timeout
	end

	return data.retry
end

local function IDVUpsellContainer(props)
	local featureName = props.featureName
	local onSuccess = props.onSuccess
	local onFailure = props.onFailure
	local onCancelled = props.onCancelled
	local v5 = if props.idvApiProvider then props.idvApiProvider else idvApiProvider
	local deviceType2 = props.deviceType or useDeviceType()
	local v6 = useNavigation()
	local v7 = useLocalization(idvErrorScreenStrings)
	local v8 = useLocalization(idvWithQRCodeUpsellStrings)

	local entryPointEventCtx = props.entryPointEventCtx or ""
	local sessionId = props.metadata and props.metadata.sessionId or ""

	local state, setState = React.useState(nil)
	local ref = React.useRef(true)
	local state2, setState2 = React.useState(actionStatusEnum.Unknown)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(v7.retry)
	local state5, setState5 = React.useState(0)
	local v9 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
	local v10 = GetFFlagEnableDirectLinkForTablets() and deviceType2 == deviceType.Tablet and true or deviceType2 == deviceType.Phone
	local v11 = useRoactService(appLinking)
	local v12 = useRoactService(roactNetworking)
	local schedulePoll = props.schedulePoll or function(callback, p2)
		spawn(function()
			wait(p2)
			callback()
		end)
	end

	local openIdvLink = props.openIdvLink or function(p2)
		v11:openURL(p2)
	end

	local function fn()
		v6.navigate(AppScreens.GenericWebPage, {
			detail = GetFStringBiometricPrivacyPolicyLink(),
			extraProps = {
				title = v8.privacyPageHeader,
				transitionAnimation = "SlideInFromBottom"
			}
		})
	end

	local function updateChecklist(sessionStatus)
		if sessionStatus == idvSessionStatusEnum.Stored then
			setState5(idvStep.UpdatedRobloxProfile)
		elseif sessionStatus == idvSessionStatusEnum.Success then
			setState5(idvStep.Verified)
		elseif sessionStatus == idvSessionStatusEnum.Submitted then
			setState5(idvStep.GotResults)
		elseif sessionStatus == idvSessionStatusEnum.Started then
			setState5(idvStep.ConnectedMobile)
		end
	end

	local function reportErrorShown(p2)
		if GetFFlagEnableAmpIDVUpsellAnalytics() then
			authModalShown(entryPointEventCtx, p2, "idvFailed")
		end
	end

	local function pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries2, p2)
		if fIntIDVMaxRetries2 == 0 then
			setState3(true)
			setState4(v7.timeout)

			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authModalShown(entryPointEventCtx, p2, "idvFailed")
			end
		else
			v5.getVerifiedStatus(sessionIdentifier):andThen(function(p3)
				local isVerified = p3.isVerified
				local sessionStatus = p3.sessionStatus
				updateChecklist(sessionStatus)

				if isVerified and sessionStatus == idvSessionStatusEnum.Stored then
					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authMsgShown(entryPointEventCtx, p2, "idvSuccess")
					end

					setState2(actionStatusEnum.Success)
				elseif
					sessionStatus == idvSessionStatusEnum.Failure
					or sessionStatus == idvSessionStatusEnum.RequiresManualReview
					or sessionStatus == idvSessionStatusEnum.RequiresRetry
					or sessionStatus == idvSessionStatusEnum.Expired
				then
					setState3(true)
					setState2(actionStatusEnum.Failure)
					local v14 = v7
					local v15

					if
						sessionStatus == idvSessionStatusEnum.Failure
						or sessionStatus == idvSessionStatusEnum.RequiresManualReview
					then
						v15 = v14.declined
					elseif sessionStatus == idvSessionStatusEnum.RequiresRetry then
						v15 = v14.retry
					else
						v15 = if sessionStatus == idvSessionStatusEnum.Expired then v14.timeout else v14.retry
					end

					setState4(v15)
					local v16 = p2

					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authModalShown(entryPointEventCtx, v16, "idvFailed")
					end
				else
					schedulePoll(function()
						if ref.current then
							pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries2 - 1, p2)
						end
					end, fIntIDVPollDelay)
				end
			end):catch(function(p3)
				setState3(true)
				setState4(v7.retry)
				local v13 = p2

				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authModalShown(entryPointEventCtx, v13, "idvFailed")
				end
			end)
		end
	end

	React.useEffect(function()
		ref.current = true
		local v13 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
		local v14 = GetFFlagEnableAmpIDVUpsellAnalytics()
		local v15 = sessionId

		local function afterStartVerification(data)
			local sessionIdentifier = data.sessionIdentifier

			if v14 then
				v15 = `{sessionId}_{sessionIdentifier}`
			end

			if v13 then
				if v14 then
					authModalShown(entryPointEventCtx, v15, "nativeIDV")
				end

				return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, data.sessionToken):andThen(function()
					pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries, v15)
				end)
			end

			if v14 then
				authModalShown(entryPointEventCtx, v15, v10 and "idvDirectLink" or "idvQRCode")
			end

			pollIDVStatus(sessionIdentifier, fIntIDVMaxRetries, v15)
			setState(data.verificationLink)
			return Promise.resolve()
		end

		local v16

		if GetFFlagEnableRoactNetworkingForChallengeInteception() then
			v16 = v5.startVerificationWithWrappedNetworking(v12)
		else
			v16 = v5.startVerification()
		end

		v16:andThen(afterStartVerification):catch(function(p2)
			if v13 and p2 and p2.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				if v14 then
					authFormInteraction(entryPointEventCtx, v15, "idvCancelled")
				end

				setState2(actionStatusEnum.Cancelled)
			else
				setState3(true)
				setState4(v7.retry)

				if v14 then
					authModalShown(entryPointEventCtx, v15, "idvFailed")
				end
			end
		end)

		return function()
			ref.current = false
		end
	end, {})

	React.useEffect(function()
		if state2 == actionStatusEnum.Success then
			onSuccess()
		elseif state2 == actionStatusEnum.Cancelled then
			onCancelled()
		end
	end, { state2 })

	if state3 then
		return React.createElement(IDVErrorScreen, {
			errorTitle = v7.title,
			errorDescription = state4,
			buttonText = v7.close,
			onClose = function()
				onFailure()
			end
		})
	end

	if v9 and state2 == actionStatusEnum.Cancelled then
		return nil
	end

	if v9 and not state3 and (state2 == actionStatusEnum.Unknown or state2 == actionStatusEnum.Success) then
		return React.createElement(loading, {
			size = iconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	if v10 then
		return React.createElement(IDVDirectLinkUpsell, {
			featureName = featureName,
			idvLink = state,
			openIdvLink = openIdvLink,
			onClose = function()
				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authFormInteraction(entryPointEventCtx, sessionId, "idvCancelled")
				end

				setState2(actionStatusEnum.Cancelled)
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

			setState2(actionStatusEnum.Cancelled)
		end
	})
end

return IDVUpsellContainer
