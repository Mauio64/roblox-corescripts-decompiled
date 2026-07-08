local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local Promise = require(AmpUpsellParent.Promise)
local Foundation = require(AmpUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local AppScreens = require(AmpUpsell.Common.AppScreens)
local IDVWithQRCodeUpsell = require(script.Parent.IDVWithQRCodeUpsell)
local IDVApiProvider = require(AmpUpsellParent.IdentityVerification).IDVApiProvider
local GetFStringBiometricPrivacyPolicyLink = require(AmpUpsell.Flags.GetFStringBiometricPrivacyPolicyLink)
local GetFIntIDVPollDelay = require(AmpUpsellParent.IdentityVerification).GetFIntIDVPollDelay
local GetFIntIDVMaxRetries = require(AmpUpsellParent.IdentityVerification).GetFIntIDVMaxRetries
local useNavigation = require(AmpUpsellParent.Navigation).useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local IDVStep = Enums.IDVStep
local IDVSessionStatusEnum = require(AmpUpsellParent.IdentityVerification).Enums.IDVSessionStatusEnum
local ActionStatusEnum = Enums.ActionStatusEnum
local IDVErrorScreen = require(script.Parent.IDVErrorScreen)
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local idvErrorScreenStrings = LocalizationStrings.idvErrorScreenStrings
local idvWithQRCodeUpsellStrings = LocalizationStrings.idvWithQRCodeUpsellStrings
local IDVDirectLinkUpsell = require(script.Parent.IDVDirectLinkUpsell)
local RobloxAppHooks = require(AmpUpsellParent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local useRoactService = RobloxAppHooks.useRoactService
local AppLinking = require(AmpUpsellParent.RoactServiceTags).AppLinking
local DeviceType = require(AmpUpsellParent.RobloxAppEnums).DeviceType
local GetFFlagEnableDirectLinkForTablets = require(AmpUpsell.Flags.GetFFlagEnableDirectLinkForTablets)
local RoactNetworking = require(AmpUpsellParent.RoactServiceTags).RoactNetworking
local GetFFlagEnableRoactNetworkingForChallengeInteception = require(AmpUpsell.Flags.GetFFlagEnableRoactNetworkingForChallengeInteception)
local GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell = require(AmpUpsell.Flags.GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell)
local FacialAgeEstimationServiceWrapper = require(script.Parent.Parent.FacialAgeEstimation.FacialAgeEstimationServiceWrapper)
local v35 = GetFIntIDVPollDelay()
local v36 = GetFIntIDVMaxRetries()

local function isFailure(p1) -- line: 54
	-- upvalues: IDVSessionStatusEnum (copy)
	return p1 == IDVSessionStatusEnum.Failure or (p1 == IDVSessionStatusEnum.RequiresManualReview or (p1 == IDVSessionStatusEnum.RequiresRetry or p1 == IDVSessionStatusEnum.Expired))
end
local function getErrorDescription(p2, p3) -- line: 61
	-- upvalues: IDVSessionStatusEnum (copy)
	if p2 == IDVSessionStatusEnum.Failure or p2 == IDVSessionStatusEnum.RequiresManualReview then
		return p3.declined
	end

	if p2 == IDVSessionStatusEnum.RequiresRetry then
		return p3.retry
	end

	if p2 == IDVSessionStatusEnum.Expired then
		return p3.timeout
	end

	return p3.retry
end
local function IDVUpsellContainer(t1: {[any]: any}) -- line: 73
	-- upvalues: IDVApiProvider (copy), useDeviceType (copy), useNavigation (copy), useLocalization (copy), idvErrorScreenStrings (copy), idvWithQRCodeUpsellStrings (copy), React (copy), ActionStatusEnum (copy), GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell (copy), FacialAgeEstimationServiceWrapper (copy), GetFFlagEnableDirectLinkForTablets (copy), DeviceType (copy), useRoactService (copy), AppLinking (copy), RoactNetworking (copy), AppScreens (copy), GetFStringBiometricPrivacyPolicyLink (copy), IDVSessionStatusEnum (copy), IDVStep (copy), v35 (copy), v36 (copy), Promise (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), IDVErrorScreen (copy), Loading (copy), IconSize (copy), IDVDirectLinkUpsell (copy), IDVWithQRCodeUpsell (copy)
	local featureName = t1.featureName
	local onSuccess = t1.onSuccess
	local onFailure = t1.onFailure
	local onCancelled = t1.onCancelled
	local v48 = if not t1.idvApiProvider then IDVApiProvider else t1.idvApiProvider
	local v49 = t1.deviceType or useDeviceType()
	local v50 = useNavigation()
	local v51 = useLocalization(idvErrorScreenStrings)
	local v52 = useLocalization(idvWithQRCodeUpsellStrings)
	local v53, v54 = React.useState(nil)
	local v55, v56 = React.useState(true)
	local v57, v58 = React.useState(ActionStatusEnum.Unknown)
	local v59, v60 = React.useState(false)
	local v61, v62 = React.useState(v51.retry)
	local v63, v64 = React.useState(0)
	local v65 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
	local v66 = GetFFlagEnableDirectLinkForTablets() and v49 == DeviceType.Tablet or v49 == DeviceType.Phone
	local v67 = useRoactService(AppLinking)
	local v68 = useRoactService(RoactNetworking)
	local v69 = t1.openIdvLink or function(p4) -- line: 97
		-- upvalues: v67 (copy)
		v67:openURL(p4)
	end

	local function v70() -- line: 101
		-- upvalues: v50 (copy), AppScreens (copy), GetFStringBiometricPrivacyPolicyLink (copy), v52 (copy)
		v50.navigate(AppScreens.GenericWebPage, {
			detail = GetFStringBiometricPrivacyPolicyLink(),
			extraProps = {
				transitionAnimation = "SlideInFromBottom",
				title = v52.privacyPageHeader
			}
		})
	end
	local function updateChecklist(p5) -- line: 111
		-- upvalues: IDVSessionStatusEnum (copy), v64 (copy), IDVStep (copy)
		if p5 == IDVSessionStatusEnum.Stored then
			v64(IDVStep.UpdatedRobloxProfile)

			return
		end

		if p5 == IDVSessionStatusEnum.Success then
			v64(IDVStep.Verified)

			return
		end

		if p5 == IDVSessionStatusEnum.Submitted then
			v64(IDVStep.GotResults)

			return
		end

		if p5 == IDVSessionStatusEnum.Started then
			v64(IDVStep.ConnectedMobile)
		end
	end
	local function pollIDVStatus(s1: string, n1: number) -- line: 125
		-- upvalues: v60 (copy), v62 (copy), v51 (copy), v48 (copy), updateChecklist (copy), IDVSessionStatusEnum (copy), v58 (copy), ActionStatusEnum (copy), v35 (copy), v55 (copy), pollIDVStatus (copy)
		if n1 == 0 then
			v60(true)
			v62(v51.timeout)

			return
		end

		v48.getVerifiedStatus(s1):andThen(function(p6) -- line: 132
			-- upvalues: updateChecklist (copy), IDVSessionStatusEnum (copy), v58 (copy), ActionStatusEnum (copy), v60 (copy), v62 (copy), v51 (copy), v35 (copy), v55 (copy), pollIDVStatus (copy), s1 (copy), n1 (copy)
			local isVerified = p6.isVerified
			local sessionStatus = p6.sessionStatus

			updateChecklist(sessionStatus)

			if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
				v58(ActionStatusEnum.Success)

				return
			end

			if sessionStatus == IDVSessionStatusEnum.Failure or (sessionStatus == IDVSessionStatusEnum.RequiresManualReview or (sessionStatus == IDVSessionStatusEnum.RequiresRetry or sessionStatus == IDVSessionStatusEnum.Expired)) then
				v60(true)
				v58(ActionStatusEnum.Failure)

				local v82 = v62
				local v83 = v51

				v82(if sessionStatus ~= IDVSessionStatusEnum.Failure and sessionStatus ~= IDVSessionStatusEnum.RequiresManualReview then if sessionStatus ~= IDVSessionStatusEnum.RequiresRetry then if sessionStatus ~= IDVSessionStatusEnum.Expired then v83.retry else v83.timeout else v83.retry else v83.declined)

				return
			end

			spawn(function() -- line: 144
				-- upvalues: v35 (copy), v55 (copy), pollIDVStatus (copy), s1 (copy), n1 (copy)
				wait(v35)

				if v55 then
					pollIDVStatus(s1, n1 - 1)
				end
			end)
		end):catch(function(_) -- line: 152
			-- upvalues: v60 (copy), v62 (copy), v51 (copy)
			v60(true)
			v62(v51.retry)
		end)
	end

	React.useEffect(function() -- line: 159
		-- upvalues: v56 (copy), GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell (copy), FacialAgeEstimationServiceWrapper (copy), pollIDVStatus (copy), v36 (copy), v54 (copy), Promise (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), v48 (copy), v68 (copy), v58 (copy), ActionStatusEnum (copy), v60 (copy), v62 (copy), v51 (copy)
		v56(true)

		local v77 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()

		local function afterStartVerification(p8) -- line: 164
			-- upvalues: v77 (copy), FacialAgeEstimationServiceWrapper (copy), pollIDVStatus (copy), v36 (copy), v54 (copy), Promise (copy)
			local sessionIdentifier = p8.sessionIdentifier

			if v77 then
				return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, p8.sessionToken):andThen(function() -- line: 168
					-- upvalues: pollIDVStatus (copy), sessionIdentifier (copy), v36 (copy)
					pollIDVStatus(sessionIdentifier, v36)
				end)
			end

			pollIDVStatus(sessionIdentifier, v36)
			v54(p8.verificationLink)

			return Promise.resolve()
		end;

		((if not GetFFlagEnableRoactNetworkingForChallengeInteception() then v48.startVerification() else v48.startVerificationWithWrappedNetworking(v68))):andThen(afterStartVerification):catch(function(p9) -- line: 182
			-- upvalues: v77 (copy), v58 (copy), ActionStatusEnum (copy), v60 (copy), v62 (copy), v51 (copy)
			if v77 and (p9 and p9.resultType == Enum.FacialAgeEstimationResultType.Cancel) then
				v58(ActionStatusEnum.Cancelled)

				return
			end

			v60(true)
			v62(v51.retry)
		end)

		return function() -- line: 191
			-- upvalues: v56 (copy)
			v56(false)
		end
	end, {})
	React.useEffect(function() -- line: 197
		-- upvalues: v57 (copy), ActionStatusEnum (copy), onSuccess (copy), onCancelled (copy)
		if v57 == ActionStatusEnum.Success then
			onSuccess()

			return
		end

		if v57 == ActionStatusEnum.Cancelled then
			onCancelled()
		end
	end, { v57 })

	if v59 then
		return React.createElement(IDVErrorScreen, {
			errorTitle = v51.title,
			errorDescription = v61,
			buttonText = v51.close,
			onClose = function() -- line: 210
				-- upvalues: onFailure (copy)
				onFailure()
			end
		})
	end

	if v65 and v57 == ActionStatusEnum.Cancelled then
		return nil
	end

	if v65 and not v59 and (v57 == ActionStatusEnum.Unknown or v57 == ActionStatusEnum.Success) then
		return React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	if v66 then
		return React.createElement(IDVDirectLinkUpsell, {
			featureName = featureName,
			idvLink = v53,
			openIdvLink = v69,
			onClose = function() -- line: 232
				-- upvalues: v58 (copy), ActionStatusEnum (copy)
				v58(ActionStatusEnum.Cancelled)
			end,
			openPrivacyPolicyLink = v70,
			latestStepCompleted = v63
		})
	end

	return React.createElement(IDVWithQRCodeUpsell, {
		qrCodeLink = v53,
		featureName = featureName,
		openPrivacyPolicyLink = v70,
		latestStepCompleted = v63,
		onClose = function() -- line: 244
			-- upvalues: v58 (copy), ActionStatusEnum (copy)
			v58(ActionStatusEnum.Cancelled)
		end
	})
end

return IDVUpsellContainer
