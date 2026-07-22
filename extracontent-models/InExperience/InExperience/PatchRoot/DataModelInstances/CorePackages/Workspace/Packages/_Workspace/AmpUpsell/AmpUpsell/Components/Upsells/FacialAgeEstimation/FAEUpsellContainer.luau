local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local Players = game:GetService("Players")
local AppLinking = require(AmpUpsellParent.RoactServiceTags).AppLinking
local React = require(AmpUpsellParent.React)
local Promise = require(AmpUpsellParent.Promise)
local IDVApiProvider = require(AmpUpsellParent.IdentityVerification).IDVApiProvider
local usePollIDVStatus = require(AmpUpsellParent.IdentityVerification).usePollIDVStatus
local Foundation = require(AmpUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useNavigation = require(AmpUpsellParent.Navigation).useNavigation
local useDispatch = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(AmpUpsellParent.UniversalAppPolicy).useAppPolicy
local NavigateDown = require(AmpUpsellParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(AmpUpsellParent.RobloxAppEnums).AppPage
local UrlUtils = require(AmpUpsell.Common.UrlUtils)
local FFlagSignalsNavP3Dispatch = require(AmpUpsellParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(AmpUpsellParent.RobloxAppNavigation).NavigationCommands
local FacialAgeEstimationServiceWrapper = require(script.Parent.FacialAgeEstimationServiceWrapper)
local FAEDirectLinkUpsell = require(script.Parent.FAEDirectLinkUpsell)
local FAEWithQRCodeUpsell = require(script.Parent.FAEWithQRCodeUpsell)
local FAEFailedModal = require(script.Parent.FAEFailedModal)
local FAELoadingModal = require(script.Parent.FAELoadingModal)
local AuthAnalytics = require(AmpUpsellParent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local useRoactService = require(AmpUpsellParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AmpUpsellParent.RoactServiceTags).RoactNetworking
local GetFFlagEnableRoactNetworkingForChallengeInteception = require(AmpUpsell.Flags.GetFFlagEnableRoactNetworkingForChallengeInteception)
local GetFFlagShowFAELoadingModal = require(AmpUpsell.Flags.GetFFlagShowFAELoadingModal)
local v33 = game:DefineFastFlag("EnableFAECancellationAnalytics", false)
local v34 = game:DefineFastFlag("EnableValidateFAEVerificationLink", false)
local GetFFlagMoveAmpUpsellOffNavigateDown = require(AmpUpsellParent.SharedFlags).GetFFlagMoveAmpUpsellOffNavigateDown
local GetFFlagEnableWebAmpWizardForFAEHandoff = require(AmpUpsell.Flags.GetFFlagEnableWebAmpWizardForFAEHandoff)
local GetFFlagEnableFAEQRCodeHandoff = require(AmpUpsell.Flags.GetFFlagEnableFAEQRCodeHandoff)
local logEventOnceIfEnabled = require(AmpUpsell.Common.LoggingUtils).logEventOnceIfEnabled
local v39 = game:DefineFastInt("FAEWithCallbackPollDelay", 2)
local v40 = game:DefineFastInt("FAEWithCallbackPollMaxRetries", 5)
local v41 = game:DefineFastInt("FAEBackgroundOnlyPollDelay", 15)
local v42 = game:DefineFastInt("FAEBackgroundOnlyPollMaxRetries", 40)
local v43 = game:DefineFastInt("FAEWithWebViewCallbackPollDelay", 2)
local v44 = game:DefineFastInt("FAEWithWebViewCallbackPollMaxRetries", 15)

local function FAEUpsellContainer() -- line: 76
	-- upvalues: useNavigation (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useAppPolicy (copy), AppLinking (copy), GetFFlagEnableFAEQRCodeHandoff (copy), React (copy), authModalShown (copy), authFormInteraction (copy), authMsgShown (copy), GetFFlagMoveAmpUpsellOffNavigateDown (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), FacialAgeEstimationServiceWrapper (copy), v39 (copy), v40 (copy), v41 (copy), v42 (copy), GetFFlagEnableWebAmpWizardForFAEHandoff (copy), v43 (copy), v44 (copy), usePollIDVStatus (copy), Players (copy), Promise (copy), UrlUtils (copy), v34 (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), logEventOnceIfEnabled (copy), IDVApiProvider (copy), v33 (copy), FAEFailedModal (copy), FAEWithQRCodeUpsell (copy), FAEDirectLinkUpsell (copy), GetFFlagShowFAELoadingModal (copy), FAELoadingModal (copy), Loading (copy), IconSize (copy)
	local v46 = useNavigation()
	local v47 = useDispatch()
	local v48 = useRoactService(RoactNetworking)
	local v49 = useAppPolicy(function(p1) -- line: 81
		return p1.getHasWebViewSupportForFAE()
	end)
	local v50 = v46.getParam("extraProps")
	local entryPointEventCtx = v50.entryPointEventCtx
	local metadata = v50.metadata
	local skipFacialAgeEstimationWebLinkModal = v50.skipFacialAgeEstimationWebLinkModal
	local v54 = useRoactService(AppLinking)
	local onSuccess = v50.onSuccess
	local onCancel = v50.onCancel
	local onFailure = v50.onFailure
	local onRetry = v50.onRetry
	local v59 = v49 and GetFFlagEnableFAEQRCodeHandoff()
	local v60, v61 = React.useState(false)
	local v62, v63 = React.useState(nil)
	local v64, v65 = React.useState(nil)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(false)
	local v70 = metadata and metadata.sessionId or ""
	local v71, v72 = React.useState(v70)
	local v73 = React.useCallback(function(p2) -- line: 108
		-- upvalues: authModalShown (copy), entryPointEventCtx (copy), v61 (copy)
		authModalShown(entryPointEventCtx, p2, "faeFailed")
		v61(true)
	end, { entryPointEventCtx })
	local v74 = React.useCallback(function(p3) -- line: 113
		-- upvalues: authFormInteraction (copy), entryPointEventCtx (copy), onCancel (copy)
		authFormInteraction(entryPointEventCtx, p3, "faeCancelled")
		onCancel()
	end, {
		onCancel,
		entryPointEventCtx
	})
	local v75 = React.useCallback(function(p4) -- line: 118
		-- upvalues: authMsgShown (copy), entryPointEventCtx (copy), onSuccess (copy)
		authMsgShown(entryPointEventCtx, p4, "faeSuccess")
		onSuccess()
	end, {
		onSuccess,
		entryPointEventCtx
	})
	local v76 = React.useCallback(function(p5, p6) -- line: 123
		-- upvalues: GetFFlagMoveAmpUpsellOffNavigateDown (copy), v46 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), v47 (copy), NavigateDown (copy)
		if GetFFlagMoveAmpUpsellOffNavigateDown() then
			v46.push(AppPage.GenericWebPage, {
				detail = p5,
				extraProps = {
					title = "",
					onClose = function() -- line: 129
						-- upvalues: p6 (copy)
						p6()
					end
				}
			})

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = p5,
			extraProps = {
				title = "",
				onClose = function() -- line: 140
					-- upvalues: p6 (copy)
					p6()
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v19.down(v19.fromLegacyPage(t1))

			return
		end

		v47(NavigateDown(t1))
	end, { GetFFlagMoveAmpUpsellOffNavigateDown() and v46 or v47 })
	local v77 = React.useMemo(function() -- line: 153
		-- upvalues: FacialAgeEstimationServiceWrapper (copy), v39 (copy), v40 (copy), v59 (copy), v41 (copy), v42 (copy), v49 (copy), GetFFlagEnableWebAmpWizardForFAEHandoff (copy), v43 (copy), v44 (copy)
		if FacialAgeEstimationServiceWrapper.isAvailable() then
			return {
				delay = v39,
				retries = v40
			}
		end

		if v59 then
			return {
				delay = v41,
				retries = v42
			}
		end

		if v49 and not GetFFlagEnableWebAmpWizardForFAEHandoff() then
			return {
				delay = v43,
				retries = v44
			}
		end

		return {
			delay = v41,
			retries = v42
		}
	end, {
		v49,
		v59
	})
	local v78, v79 = usePollIDVStatus({
		delay = v77.delay,
		retries = v77.retries
	})
	local v80 = React.useCallback(function(p7, p8) -- line: 179
		-- upvalues: FacialAgeEstimationServiceWrapper (copy), authModalShown (copy), entryPointEventCtx (copy), v67 (copy), v59 (copy), Players (copy), v65 (copy), Promise (copy), GetFFlagEnableWebAmpWizardForFAEHandoff (copy), v63 (copy), UrlUtils (copy), v34 (copy), v49 (copy), v76 (copy), skipFacialAgeEstimationWebLinkModal (copy), v54 (copy)
		local sessionIdentifier = p7.sessionIdentifier
		local verificationLink = p7.verificationLink
		local sessionToken = p7.sessionToken

		if FacialAgeEstimationServiceWrapper.isAvailable() then
			authModalShown(entryPointEventCtx, p8, "nativeFae")
			v67(true)

			return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		end

		if v59 then
			v67(false)
			authModalShown(entryPointEventCtx, p8, "faeQRCodeHandoff")

			local str = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
			local v94 = "roblox%3A%2F%2Fnavigation%2Famp_wizard%3Ffeature_name=TriggerFacialAgeEstimationRecourse%26namespace=account_identity%252FAgeCheck%26entry_point=" .. entryPointEventCtx .. "%26user_id=" .. str

			v65("https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=fae_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. v94 .. "&deep_link_value=" .. v94)

			return Promise.resolve(sessionIdentifier)
		end

		if GetFFlagEnableWebAmpWizardForFAEHandoff() then
			authModalShown(entryPointEventCtx, p8, "webHandoffFAE")
			v67(false)
			v63(UrlUtils.buildAmpWizardUrl("TriggerAgeVerifyRecourse", "social%2FUpsells", entryPointEventCtx, "my%2Faccount"))

			return Promise.resolve(sessionIdentifier)
		end

		if v34 and (not verificationLink or verificationLink == "") then
			return Promise.reject("Invalid verification link")
		end

		authModalShown(entryPointEventCtx, p8, "noNativeFae")
		v67(false)

		if v49 then
			return Promise.new(function(resolve) -- line: 232
				-- upvalues: sessionIdentifier (copy), v76 (copy), verificationLink (copy)
				v76(verificationLink, function() -- line: 233
					-- upvalues: resolve (copy), sessionIdentifier (copy)
					resolve(sessionIdentifier)
				end)
			end)
		end

		if skipFacialAgeEstimationWebLinkModal then
			v54:openURL(verificationLink)
		else
			v63(verificationLink)
		end

		return Promise.resolve(sessionIdentifier)
	end, {
		entryPointEventCtx,
		v49,
		v76,
		v67,
		skipFacialAgeEstimationWebLinkModal,
		v54,
		v59
	})

	React.useEffect(function() -- line: 260
		-- upvalues: v70 (copy), GetFFlagEnableRoactNetworkingForChallengeInteception (copy), logEventOnceIfEnabled (copy), IDVApiProvider (copy), v48 (copy), v72 (copy), v80 (copy), v69 (copy), v78 (copy), v75 (copy), v33 (copy), v74 (copy), v73 (copy), v79 (copy)
		local u95 = v70

		if GetFFlagEnableRoactNetworkingForChallengeInteception() then
			logEventOnceIfEnabled("start_verification_init")
			IDVApiProvider.startVerificationWithWrappedNetworking(v48, {
				ageEstimation = true
			}):andThen(function(p9) -- line: 265
				-- upvalues: u95 (ref), v72 (copy), logEventOnceIfEnabled (copy)
				u95 = `{ u95 }_{ p9.sessionIdentifier }`
				v72(u95)
				logEventOnceIfEnabled("start_verification_end")

				return p9
			end):andThen(function(p10) -- line: 271
				-- upvalues: logEventOnceIfEnabled (copy), v80 (copy), u95 (ref)
				logEventOnceIfEnabled("persona_flow_init")

				return v80(p10, u95)
			end):andThen(function(p11) -- line: 275
				-- upvalues: logEventOnceIfEnabled (copy), v69 (copy), v78 (copy)
				logEventOnceIfEnabled("persona_flow_end")
				v69(true)
				logEventOnceIfEnabled("status_polling_init")

				return v78(p11)
			end):andThen(function() -- line: 281
				-- upvalues: logEventOnceIfEnabled (copy), v75 (copy), u95 (ref)
				logEventOnceIfEnabled("status_polling_end")

				return v75(u95)
			end):catch(function(p12) -- line: 285
				-- upvalues: logEventOnceIfEnabled (copy), v33 (copy), v74 (copy), u95 (ref), v73 (copy)
				logEventOnceIfEnabled("status_polling_end")

				if v33 and (p12 and p12.resultType == Enum.FacialAgeEstimationResultType.Cancel) then
					v74(u95)

					return
				end

				v73(u95)
			end)

			return function() -- line: 298
				-- upvalues: v79 (copy)
				v79()
			end
		end

		IDVApiProvider.startVerification({
			ageEstimation = true
		}):andThen(function(p13) -- line: 303
			-- upvalues: u95 (ref), v72 (copy)
			u95 = `{ u95 }_{ p13.sessionIdentifier }`
			v72(u95)

			return p13
		end):andThen(function(p14) -- line: 308
			-- upvalues: v80 (copy), u95 (ref)
			return v80(p14, u95)
		end):andThen(function(p15) -- line: 311
			-- upvalues: v69 (copy), v78 (copy)
			v69(true)

			return v78(p15)
		end):andThen(function() -- line: 315
			-- upvalues: v75 (copy), u95 (ref)
			return v75(u95)
		end):catch(function(p16) -- line: 318
			-- upvalues: v33 (copy), v74 (copy), u95 (ref), v73 (copy)
			if v33 and (p16 and p16.resultType == Enum.FacialAgeEstimationResultType.Cancel) then
				v74(u95)

				return
			end

			v73(u95)
		end)

		return function() -- line: 330
			-- upvalues: v79 (copy)
			v79()
		end
	end, {})

	if v60 then
		return React.createElement(FAEFailedModal, {
			sessionId = v71,
			entryPointEventCtx = entryPointEventCtx,
			onClose = onFailure,
			onRetry = onRetry
		})
	end

	if v64 then
		return React.createElement(FAEWithQRCodeUpsell, {
			appsFlyerLink = v64,
			sessionId = v71,
			entryPointEventCtx = entryPointEventCtx,
			onCancel = onCancel
		})
	end

	if v62 then
		return React.createElement(FAEDirectLinkUpsell, {
			sessionId = v71,
			entryPointEventCtx = entryPointEventCtx,
			webLink = v62,
			onCancel = onCancel
		})
	end

	if GetFFlagShowFAELoadingModal() and v68 and not v66 then
		return React.createElement(FAELoadingModal, {
			sessionId = v71,
			entryPointEventCtx = entryPointEventCtx,
			onCancel = onCancel
		})
	end

	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return FAEUpsellContainer
