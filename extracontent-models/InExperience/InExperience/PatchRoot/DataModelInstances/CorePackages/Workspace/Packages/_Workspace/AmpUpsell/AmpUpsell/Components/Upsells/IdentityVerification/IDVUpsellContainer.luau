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
local GetFFlagEnableAmpIDVUpsellAnalytics = require(AmpUpsell.Flags.GetFFlagEnableAmpIDVUpsellAnalytics)
local FacialAgeEstimationServiceWrapper = require(script.Parent.Parent.FacialAgeEstimation.FacialAgeEstimationServiceWrapper)
local AuthAnalytics = require(AmpUpsellParent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local v40 = GetFIntIDVPollDelay()
local v41 = GetFIntIDVMaxRetries()

local function isFailure(p1) -- line: 65
	-- upvalues: IDVSessionStatusEnum (copy)
	return p1 == IDVSessionStatusEnum.Failure or (p1 == IDVSessionStatusEnum.RequiresManualReview or (p1 == IDVSessionStatusEnum.RequiresRetry or p1 == IDVSessionStatusEnum.Expired))
end
local function getErrorDescription(p2, p3) -- line: 72
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
local function IDVUpsellContainer(t1: {[any]: any}) -- line: 84
	-- upvalues: IDVApiProvider (copy), useDeviceType (copy), useNavigation (copy), useLocalization (copy), idvErrorScreenStrings (copy), idvWithQRCodeUpsellStrings (copy), React (copy), ActionStatusEnum (copy), GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell (copy), FacialAgeEstimationServiceWrapper (copy), GetFFlagEnableDirectLinkForTablets (copy), DeviceType (copy), useRoactService (copy), AppLinking (copy), RoactNetworking (copy), AppScreens (copy), GetFStringBiometricPrivacyPolicyLink (copy), IDVSessionStatusEnum (copy), IDVStep (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), authMsgShown (copy), v40 (copy), v41 (copy), Promise (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), authFormInteraction (copy), IDVErrorScreen (copy), Loading (copy), IconSize (copy), IDVDirectLinkUpsell (copy), IDVWithQRCodeUpsell (copy)
	local featureName = t1.featureName
	local onSuccess = t1.onSuccess
	local onFailure = t1.onFailure
	local onCancelled = t1.onCancelled
	local v53 = if not t1.idvApiProvider then IDVApiProvider else t1.idvApiProvider
	local v54 = t1.deviceType or useDeviceType()
	local v55 = useNavigation()
	local v56 = useLocalization(idvErrorScreenStrings)
	local v57 = useLocalization(idvWithQRCodeUpsellStrings)
	local v58 = t1.entryPointEventCtx or ""
	local v59 = t1.metadata and t1.metadata.sessionId or ""
	local v60, v61 = React.useState(nil)
	local v62 = React.useRef(true)
	local v63, v64 = React.useState(ActionStatusEnum.Unknown)
	local v65, v66 = React.useState(false)
	local v67, v68 = React.useState(v56.retry)
	local v69, v70 = React.useState(0)
	local v71 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
	local v72 = GetFFlagEnableDirectLinkForTablets() and v54 == DeviceType.Tablet or v54 == DeviceType.Phone
	local v73 = useRoactService(AppLinking)
	local v74 = useRoactService(RoactNetworking)
	local v75 = t1.schedulePoll or function(p4: ((...any) -> ...any), n1: number) -- line: 111
		spawn(function() -- line: 112
			-- upvalues: n1 (copy), p4 (copy)
			wait(n1)
			p4()
		end)
	end
	local v76 = t1.openIdvLink or function(p5) -- line: 118
		-- upvalues: v73 (copy)
		v73:openURL(p5)
	end

	local function v77() -- line: 122
		-- upvalues: v55 (copy), AppScreens (copy), GetFStringBiometricPrivacyPolicyLink (copy), v57 (copy)
		v55.navigate(AppScreens.GenericWebPage, {
			detail = GetFStringBiometricPrivacyPolicyLink(),
			extraProps = {
				transitionAnimation = "SlideInFromBottom",
				title = v57.privacyPageHeader
			}
		})
	end
	local function updateChecklist(p6) -- line: 132
		-- upvalues: IDVSessionStatusEnum (copy), v70 (copy), IDVStep (copy)
		if p6 == IDVSessionStatusEnum.Stored then
			v70(IDVStep.UpdatedRobloxProfile)

			return
		end

		if p6 == IDVSessionStatusEnum.Success then
			v70(IDVStep.Verified)

			return
		end

		if p6 == IDVSessionStatusEnum.Submitted then
			v70(IDVStep.GotResults)

			return
		end

		if p6 == IDVSessionStatusEnum.Started then
			v70(IDVStep.ConnectedMobile)
		end
	end
	local function reportErrorShown(s1: string) -- line: 146
		-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy)
		if GetFFlagEnableAmpIDVUpsellAnalytics() then
			authModalShown(v58, s1, "idvFailed")
		end
	end
	local function pollIDVStatus(s2: string, n2: number, s3: string) -- line: 152
		-- upvalues: v66 (copy), v68 (copy), v56 (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy), v53 (copy), updateChecklist (copy), IDVSessionStatusEnum (copy), authMsgShown (copy), v64 (copy), ActionStatusEnum (copy), v75 (copy), v62 (copy), pollIDVStatus (copy), v40 (copy)
		if n2 == 0 then
			v66(true)
			v68(v56.timeout)

			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authModalShown(v58, s3, "idvFailed")

				return
			end
		else
			v53.getVerifiedStatus(s2):andThen(function(p7) -- line: 160
				-- upvalues: updateChecklist (copy), IDVSessionStatusEnum (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authMsgShown (copy), v58 (copy), s3 (copy), v64 (copy), ActionStatusEnum (copy), v66 (copy), v68 (copy), v56 (copy), authModalShown (copy), v75 (copy), v62 (copy), pollIDVStatus (copy), s2 (copy), n2 (copy), v40 (copy)
				local isVerified = p7.isVerified
				local sessionStatus = p7.sessionStatus

				updateChecklist(sessionStatus)

				if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authMsgShown(v58, s3, "idvSuccess")
					end

					v64(ActionStatusEnum.Success)

					return
				end

				if sessionStatus == IDVSessionStatusEnum.Failure or (sessionStatus == IDVSessionStatusEnum.RequiresManualReview or (sessionStatus == IDVSessionStatusEnum.RequiresRetry or sessionStatus == IDVSessionStatusEnum.Expired)) then
					v66(true)
					v64(ActionStatusEnum.Failure)

					local v96 = v68
					local v97 = v56

					v96(if sessionStatus ~= IDVSessionStatusEnum.Failure and sessionStatus ~= IDVSessionStatusEnum.RequiresManualReview then if sessionStatus ~= IDVSessionStatusEnum.RequiresRetry then if sessionStatus ~= IDVSessionStatusEnum.Expired then v97.retry else v97.timeout else v97.retry else v97.declined)

					local v98 = s3

					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authModalShown(v58, v98, "idvFailed")

						return
					end
				else
					v75(function() -- line: 176
						-- upvalues: v62 (copy), pollIDVStatus (copy), s2 (copy), n2 (copy), s3 (copy)
						if v62.current then
							pollIDVStatus(s2, n2 - 1, s3)
						end
					end, v40)
				end
			end):catch(function(_) -- line: 183
				-- upvalues: v66 (copy), v68 (copy), v56 (copy), s3 (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy)
				v66(true)
				v68(v56.retry)

				local v100 = s3

				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authModalShown(v58, v100, "idvFailed")
				end
			end)
		end
	end

	React.useEffect(function() -- line: 191
		-- upvalues: v62 (copy), GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell (copy), FacialAgeEstimationServiceWrapper (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), v59 (copy), authModalShown (copy), v58 (copy), pollIDVStatus (copy), v41 (copy), v72 (copy), v61 (copy), Promise (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), v53 (copy), v74 (copy), authFormInteraction (copy), v64 (copy), ActionStatusEnum (copy), v66 (copy), v68 (copy), v56 (copy)
		v62.current = true

		local v89 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
		local v90 = GetFFlagEnableAmpIDVUpsellAnalytics()
		local u91 = v59

		local function afterStartVerification(p9) -- line: 198
			-- upvalues: v90 (copy), u91 (ref), v59 (copy), v89 (copy), authModalShown (copy), v58 (copy), FacialAgeEstimationServiceWrapper (copy), pollIDVStatus (copy), v41 (copy), v72 (copy), v61 (copy), Promise (copy)
			local sessionIdentifier = p9.sessionIdentifier

			if v90 then
				u91 = `{ v59 }_{ sessionIdentifier }`
			end

			if v89 then
				if v90 then
					authModalShown(v58, u91, "nativeIDV")
				end

				return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, p9.sessionToken):andThen(function() -- line: 209
					-- upvalues: pollIDVStatus (copy), sessionIdentifier (copy), v41 (copy), u91 (ref)
					pollIDVStatus(sessionIdentifier, v41, u91)
				end)
			end

			if v90 then
				local v103 = not v72 and "idvQRCode" or "idvDirectLink"

				authModalShown(v58, u91, v103)
			end

			pollIDVStatus(sessionIdentifier, v41, u91)
			v61(p9.verificationLink)

			return Promise.resolve()
		end;

		((if not GetFFlagEnableRoactNetworkingForChallengeInteception() then v53.startVerification() else v53.startVerificationWithWrappedNetworking(v74))):andThen(afterStartVerification):catch(function(p10) -- line: 227
			-- upvalues: v89 (copy), v90 (copy), authFormInteraction (copy), v58 (copy), u91 (ref), v64 (copy), ActionStatusEnum (copy), v66 (copy), v68 (copy), v56 (copy), authModalShown (copy)
			if v89 and (p10 and p10.resultType == Enum.FacialAgeEstimationResultType.Cancel) then
				if v90 then
					authFormInteraction(v58, u91, "idvCancelled")
				end

				v64(ActionStatusEnum.Cancelled)

				return
			end

			v66(true)
			v68(v56.retry)

			if v90 then
				authModalShown(v58, u91, "idvFailed")
			end
		end)

		return function() -- line: 242
			-- upvalues: v62 (copy)
			v62.current = false
		end
	end, {})
	React.useEffect(function() -- line: 248
		-- upvalues: v63 (copy), ActionStatusEnum (copy), onSuccess (copy), onCancelled (copy)
		if v63 == ActionStatusEnum.Success then
			onSuccess()

			return
		end

		if v63 == ActionStatusEnum.Cancelled then
			onCancelled()
		end
	end, { v63 })

	if v65 then
		return React.createElement(IDVErrorScreen, {
			errorTitle = v56.title,
			errorDescription = v67,
			buttonText = v56.close,
			onClose = function() -- line: 261
				-- upvalues: onFailure (copy)
				onFailure()
			end
		})
	end

	if v71 and v63 == ActionStatusEnum.Cancelled then
		return nil
	end

	if v71 and not v65 and (v63 == ActionStatusEnum.Unknown or v63 == ActionStatusEnum.Success) then
		return React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	if v72 then
		return React.createElement(IDVDirectLinkUpsell, {
			featureName = featureName,
			idvLink = v60,
			openIdvLink = v76,
			onClose = function() -- line: 283
				-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authFormInteraction (copy), v58 (copy), v59 (copy), v64 (copy), ActionStatusEnum (copy)
				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authFormInteraction(v58, v59, "idvCancelled")
				end

				v64(ActionStatusEnum.Cancelled)
			end,
			openPrivacyPolicyLink = v77,
			latestStepCompleted = v69
		})
	end

	return React.createElement(IDVWithQRCodeUpsell, {
		qrCodeLink = v60,
		featureName = featureName,
		openPrivacyPolicyLink = v77,
		latestStepCompleted = v69,
		onClose = function() -- line: 298
			-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authFormInteraction (copy), v58 (copy), v59 (copy), v64 (copy), ActionStatusEnum (copy)
			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authFormInteraction(v58, v59, "idvCancelled")
			end

			v64(ActionStatusEnum.Cancelled)
		end
	})
end

return IDVUpsellContainer
