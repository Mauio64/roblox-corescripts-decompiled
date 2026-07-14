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

local function isFailure(p1) -- line: 64
	-- upvalues: IDVSessionStatusEnum (copy)
	return p1 == IDVSessionStatusEnum.Failure or (p1 == IDVSessionStatusEnum.RequiresManualReview or (p1 == IDVSessionStatusEnum.RequiresRetry or p1 == IDVSessionStatusEnum.Expired))
end
local function getErrorDescription(p2, p3) -- line: 71
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
local function IDVUpsellContainer(t1: {[any]: any}) -- line: 83
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
	local v62, v63 = React.useState(true)
	local v64, v65 = React.useState(ActionStatusEnum.Unknown)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(v56.retry)
	local v70, v71 = React.useState(0)
	local v72 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
	local v73 = GetFFlagEnableDirectLinkForTablets() and v54 == DeviceType.Tablet or v54 == DeviceType.Phone
	local v74 = useRoactService(AppLinking)
	local v75 = useRoactService(RoactNetworking)
	local v76 = t1.openIdvLink or function(p4) -- line: 110
		-- upvalues: v74 (copy)
		v74:openURL(p4)
	end

	local function v77() -- line: 114
		-- upvalues: v55 (copy), AppScreens (copy), GetFStringBiometricPrivacyPolicyLink (copy), v57 (copy)
		v55.navigate(AppScreens.GenericWebPage, {
			detail = GetFStringBiometricPrivacyPolicyLink(),
			extraProps = {
				transitionAnimation = "SlideInFromBottom",
				title = v57.privacyPageHeader
			}
		})
	end
	local function updateChecklist(p5) -- line: 124
		-- upvalues: IDVSessionStatusEnum (copy), v71 (copy), IDVStep (copy)
		if p5 == IDVSessionStatusEnum.Stored then
			v71(IDVStep.UpdatedRobloxProfile)

			return
		end

		if p5 == IDVSessionStatusEnum.Success then
			v71(IDVStep.Verified)

			return
		end

		if p5 == IDVSessionStatusEnum.Submitted then
			v71(IDVStep.GotResults)

			return
		end

		if p5 == IDVSessionStatusEnum.Started then
			v71(IDVStep.ConnectedMobile)
		end
	end
	local function reportErrorShown(s1: string) -- line: 138
		-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy)
		if GetFFlagEnableAmpIDVUpsellAnalytics() then
			authModalShown(v58, s1, "idvFailed")
		end
	end
	local function pollIDVStatus(s2: string, n1: number, s3: string) -- line: 144
		-- upvalues: v67 (copy), v69 (copy), v56 (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy), v53 (copy), updateChecklist (copy), IDVSessionStatusEnum (copy), authMsgShown (copy), v65 (copy), ActionStatusEnum (copy), v40 (copy), v62 (copy), pollIDVStatus (copy)
		if n1 == 0 then
			v67(true)
			v69(v56.timeout)

			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authModalShown(v58, s3, "idvFailed")

				return
			end
		else
			v53.getVerifiedStatus(s2):andThen(function(p6) -- line: 152
				-- upvalues: updateChecklist (copy), IDVSessionStatusEnum (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authMsgShown (copy), v58 (copy), s3 (copy), v65 (copy), ActionStatusEnum (copy), v67 (copy), v69 (copy), v56 (copy), authModalShown (copy), v40 (copy), v62 (copy), pollIDVStatus (copy), s2 (copy), n1 (copy)
				local isVerified = p6.isVerified
				local sessionStatus = p6.sessionStatus

				updateChecklist(sessionStatus)

				if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authMsgShown(v58, s3, "idvSuccess")
					end

					v65(ActionStatusEnum.Success)

					return
				end

				if sessionStatus == IDVSessionStatusEnum.Failure or (sessionStatus == IDVSessionStatusEnum.RequiresManualReview or (sessionStatus == IDVSessionStatusEnum.RequiresRetry or sessionStatus == IDVSessionStatusEnum.Expired)) then
					v67(true)
					v65(ActionStatusEnum.Failure)

					local v94 = v69
					local v95 = v56

					v94(if sessionStatus ~= IDVSessionStatusEnum.Failure and sessionStatus ~= IDVSessionStatusEnum.RequiresManualReview then if sessionStatus ~= IDVSessionStatusEnum.RequiresRetry then if sessionStatus ~= IDVSessionStatusEnum.Expired then v95.retry else v95.timeout else v95.retry else v95.declined)

					local v96 = s3

					if GetFFlagEnableAmpIDVUpsellAnalytics() then
						authModalShown(v58, v96, "idvFailed")

						return
					end
				else
					spawn(function() -- line: 168
						-- upvalues: v40 (copy), v62 (copy), pollIDVStatus (copy), s2 (copy), n1 (copy), s3 (copy)
						wait(v40)

						if v62 then
							pollIDVStatus(s2, n1 - 1, s3)
						end
					end)
				end
			end):catch(function(_) -- line: 176
				-- upvalues: v67 (copy), v69 (copy), v56 (copy), s3 (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), authModalShown (copy), v58 (copy)
				v67(true)
				v69(v56.retry)

				local v98 = s3

				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authModalShown(v58, v98, "idvFailed")
				end
			end)
		end
	end

	React.useEffect(function() -- line: 184
		-- upvalues: v63 (copy), GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell (copy), FacialAgeEstimationServiceWrapper (copy), GetFFlagEnableAmpIDVUpsellAnalytics (copy), v59 (copy), authModalShown (copy), v58 (copy), pollIDVStatus (copy), v41 (copy), v73 (copy), v61 (copy), Promise (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), v53 (copy), v75 (copy), authFormInteraction (copy), v65 (copy), ActionStatusEnum (copy), v67 (copy), v69 (copy), v56 (copy)
		v63(true)

		local v87 = GetFFlagEnableNativePersonaInquiryForAmpIDVUpsell() and FacialAgeEstimationServiceWrapper.isAvailable()
		local v88 = GetFFlagEnableAmpIDVUpsellAnalytics()
		local u89 = v59

		local function afterStartVerification(p8) -- line: 191
			-- upvalues: v88 (copy), u89 (ref), v59 (copy), v87 (copy), authModalShown (copy), v58 (copy), FacialAgeEstimationServiceWrapper (copy), pollIDVStatus (copy), v41 (copy), v73 (copy), v61 (copy), Promise (copy)
			local sessionIdentifier = p8.sessionIdentifier

			if v88 then
				u89 = `{ v59 }_{ sessionIdentifier }`
			end

			if v87 then
				if v88 then
					authModalShown(v58, u89, "nativeIDV")
				end

				return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, p8.sessionToken):andThen(function() -- line: 202
					-- upvalues: pollIDVStatus (copy), sessionIdentifier (copy), v41 (copy), u89 (ref)
					pollIDVStatus(sessionIdentifier, v41, u89)
				end)
			end

			if v88 then
				local v101 = not v73 and "idvQRCode" or "idvDirectLink"

				authModalShown(v58, u89, v101)
			end

			pollIDVStatus(sessionIdentifier, v41, u89)
			v61(p8.verificationLink)

			return Promise.resolve()
		end;

		((if not GetFFlagEnableRoactNetworkingForChallengeInteception() then v53.startVerification() else v53.startVerificationWithWrappedNetworking(v75))):andThen(afterStartVerification):catch(function(p9) -- line: 220
			-- upvalues: v87 (copy), v88 (copy), authFormInteraction (copy), v58 (copy), u89 (ref), v65 (copy), ActionStatusEnum (copy), v67 (copy), v69 (copy), v56 (copy), authModalShown (copy)
			if v87 and (p9 and p9.resultType == Enum.FacialAgeEstimationResultType.Cancel) then
				if v88 then
					authFormInteraction(v58, u89, "idvCancelled")
				end

				v65(ActionStatusEnum.Cancelled)

				return
			end

			v67(true)
			v69(v56.retry)

			if v88 then
				authModalShown(v58, u89, "idvFailed")
			end
		end)

		return function() -- line: 235
			-- upvalues: v63 (copy)
			v63(false)
		end
	end, {})
	React.useEffect(function() -- line: 241
		-- upvalues: v64 (copy), ActionStatusEnum (copy), onSuccess (copy), onCancelled (copy)
		if v64 == ActionStatusEnum.Success then
			onSuccess()

			return
		end

		if v64 == ActionStatusEnum.Cancelled then
			onCancelled()
		end
	end, { v64 })

	if v66 then
		return React.createElement(IDVErrorScreen, {
			errorTitle = v56.title,
			errorDescription = v68,
			buttonText = v56.close,
			onClose = function() -- line: 254
				-- upvalues: onFailure (copy)
				onFailure()
			end
		})
	end

	if v72 and v64 == ActionStatusEnum.Cancelled then
		return nil
	end

	if v72 and not v66 and (v64 == ActionStatusEnum.Unknown or v64 == ActionStatusEnum.Success) then
		return React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	if v73 then
		return React.createElement(IDVDirectLinkUpsell, {
			featureName = featureName,
			idvLink = v60,
			openIdvLink = v76,
			onClose = function() -- line: 276
				-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authFormInteraction (copy), v58 (copy), v59 (copy), v65 (copy), ActionStatusEnum (copy)
				if GetFFlagEnableAmpIDVUpsellAnalytics() then
					authFormInteraction(v58, v59, "idvCancelled")
				end

				v65(ActionStatusEnum.Cancelled)
			end,
			openPrivacyPolicyLink = v77,
			latestStepCompleted = v70
		})
	end

	return React.createElement(IDVWithQRCodeUpsell, {
		qrCodeLink = v60,
		featureName = featureName,
		openPrivacyPolicyLink = v77,
		latestStepCompleted = v70,
		onClose = function() -- line: 291
			-- upvalues: GetFFlagEnableAmpIDVUpsellAnalytics (copy), authFormInteraction (copy), v58 (copy), v59 (copy), v65 (copy), ActionStatusEnum (copy)
			if GetFFlagEnableAmpIDVUpsellAnalytics() then
				authFormInteraction(v58, v59, "idvCancelled")
			end

			v65(ActionStatusEnum.Cancelled)
		end
	})
end

return IDVUpsellContainer
