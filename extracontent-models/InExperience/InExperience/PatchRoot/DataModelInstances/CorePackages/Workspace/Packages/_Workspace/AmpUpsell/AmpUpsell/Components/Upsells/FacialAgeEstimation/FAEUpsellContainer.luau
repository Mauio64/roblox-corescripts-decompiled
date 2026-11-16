local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local Players = game:GetService("Players")

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local React = require(parent.React)
local Promise = require(parent.Promise)

local IdentityVerification = require(parent.IdentityVerification)
local IDVApiProvider = IdentityVerification.IDVApiProvider
local IdentityVerification2 = require(parent.IdentityVerification)
local usePollIDVStatus = IdentityVerification2.usePollIDVStatus

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlUtils = require(AmpUpsell.Common.UrlUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local FacialAgeEstimationServiceWrapper = require(script.Parent.FacialAgeEstimationServiceWrapper)
local FAEDirectLinkUpsell = require(script.Parent.FAEDirectLinkUpsell)
local FAEWithQRCodeUpsell = require(script.Parent.FAEWithQRCodeUpsell)
local FAEFailedModal = require(script.Parent.FAEFailedModal)
local FAELoadingModal = require(script.Parent.FAELoadingModal)

local AuthAnalytics = require(parent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags2.RoactNetworking

local GetFFlagEnableRoactNetworkingForChallengeInteception = require(AmpUpsell.Flags.GetFFlagEnableRoactNetworkingForChallengeInteception)
local GetFFlagShowFAELoadingModal = require(AmpUpsell.Flags.GetFFlagShowFAELoadingModal)
local defineFastFlag = game:DefineFastFlag("EnableFAECancellationAnalytics", false)
local defineFastFlag2 = game:DefineFastFlag("EnableValidateFAEVerificationLink", false)
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagMoveAmpUpsellOffNavigateDown = SharedFlags2.GetFFlagMoveAmpUpsellOffNavigateDown
local GetFFlagEnableWebAmpWizardForFAEHandoff = require(AmpUpsell.Flags.GetFFlagEnableWebAmpWizardForFAEHandoff)
local GetFFlagEnableFAEQRCodeHandoff = require(AmpUpsell.Flags.GetFFlagEnableFAEQRCodeHandoff)
local LoggingUtils = require(AmpUpsell.Common.LoggingUtils)
local logEventOnceIfEnabled = LoggingUtils.logEventOnceIfEnabled

local defineFastInt = game:DefineFastInt("FAEWithCallbackPollDelay", 2)
local defineFastInt2 = game:DefineFastInt("FAEWithCallbackPollMaxRetries", 5)

local defineFastInt3 = game:DefineFastInt("FAEBackgroundOnlyPollDelay", 15)
local defineFastInt4 = game:DefineFastInt("FAEBackgroundOnlyPollMaxRetries", 40)

local defineFastInt5 = game:DefineFastInt("FAEWithWebViewCallbackPollDelay", 2)
local defineFastInt6 = game:DefineFastInt("FAEWithWebViewCallbackPollMaxRetries", 15)

local function FAEUpsellContainer()
	local v = useNavigation()
	local v2 = useDispatch()
	local v3 = useRoactService(RoactNetworking)

	local v4 = useAppPolicy(function(p)
		return p.getHasWebViewSupportForFAE()
	end)

	local param = v.getParam("extraProps")
	local entryPointEventCtx = param.entryPointEventCtx
	local metadata = param.metadata
	local skipFacialAgeEstimationWebLinkModal = param.skipFacialAgeEstimationWebLinkModal

	local v5 = useRoactService(AppLinking)

	local onSuccess = param.onSuccess
	local onCancel = param.onCancel
	local onFailure = param.onFailure
	local onRetry = param.onRetry

	local v6 = v4 and GetFFlagEnableFAEQRCodeHandoff()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)

	local sessionId = metadata and metadata.sessionId or ""
	local state6, setState6 = React.useState(sessionId)

	local v7 = React.useCallback(function(p)
		authModalShown(entryPointEventCtx, p, "faeFailed")
		setState(true)
	end, { entryPointEventCtx })

	local v8 = React.useCallback(function(p)
		authFormInteraction(entryPointEventCtx, p, "faeCancelled")
		onCancel()
	end, { onCancel, entryPointEventCtx })

	local v9 = React.useCallback(function(p)
		authMsgShown(entryPointEventCtx, p, "faeSuccess")
		onSuccess()
	end, { onSuccess, entryPointEventCtx })

	local useCallback = React.useCallback
	local function fn(detail, callback)
		if GetFFlagMoveAmpUpsellOffNavigateDown() then
			v.push(AppPage.GenericWebPage, {
				detail = detail,
				extraProps = {
					title = "",
					onClose = function()
						callback()
					end
				}
			})
			return
		end

		local v10 = {
			name = AppPage.GenericWebPage,
			detail = detail,
			extraProps = {
				title = "",
				onClose = function()
					callback()
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v10))
		else
			v2(NavigateDown(v10))
		end
	end

	local v10

	if GetFFlagMoveAmpUpsellOffNavigateDown() then
		v10 = v or v2
	else
		v10 = v2
	end

	local v11 = useCallback(fn, { v10 })

	local v12 = React.useMemo(function()
		if FacialAgeEstimationServiceWrapper.isAvailable() then
			return { delay = defineFastInt, retries = defineFastInt2 }
		end

		if v6 then
			return { delay = defineFastInt3, retries = defineFastInt4 }
		end

		if v4 and not GetFFlagEnableWebAmpWizardForFAEHandoff() then
			return { delay = defineFastInt5, retries = defineFastInt6 }
		end

		return { delay = defineFastInt3, retries = defineFastInt4 }
	end, { v4, v6 })

	local v13, v14 = usePollIDVStatus({ delay = v12.delay, retries = v12.retries })

	local v15 = React.useCallback(function(data, p)
		local sessionIdentifier = data.sessionIdentifier
		local verificationLink = data.verificationLink
		local sessionToken = data.sessionToken

		if FacialAgeEstimationServiceWrapper.isAvailable() then
			authModalShown(entryPointEventCtx, p, "nativeFae")
			setState4(true)
			return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		elseif v6 then
			setState4(false)
			authModalShown(entryPointEventCtx, p, "faeQRCodeHandoff")
			local v15 = "roblox%3A%2F%2Fnavigation%2Famp_wizard%3Ffeature_name=TriggerFacialAgeEstimationRecourse%26namespace=account_identity%252FAgeCheck%26entry_point=" .. entryPointEventCtx .. "%26user_id=" .. tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
			setState3("https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=fae_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. v15 .. "&deep_link_value=" .. v15)

			return Promise.resolve(sessionIdentifier)
		else
			if GetFFlagEnableWebAmpWizardForFAEHandoff() then
				authModalShown(entryPointEventCtx, p, "webHandoffFAE")
				setState4(false)

				setState2(UrlUtils.buildAmpWizardUrl(
					"TriggerAgeVerifyRecourse",
					"social%2FUpsells",
					entryPointEventCtx,
					"my%2Faccount"
				))
			else
				if defineFastFlag2 and (not verificationLink or verificationLink == "") then
					return Promise.reject("Invalid verification link")
				end

				authModalShown(entryPointEventCtx, p, "noNativeFae")
				setState4(false)

				if v4 then
					return Promise.new(function(callback)
						v11(verificationLink, function()
							callback(sessionIdentifier)
						end)
					end)
				end

				if skipFacialAgeEstimationWebLinkModal then
					v5:openURL(verificationLink)
				else
					setState2(verificationLink)
				end
			end

			return Promise.resolve(sessionIdentifier)
		end
	end, { entryPointEventCtx, v4, v11, setState4, skipFacialAgeEstimationWebLinkModal, v5, v6 })

	React.useEffect(function()
		local v16 = sessionId

		if not GetFFlagEnableRoactNetworkingForChallengeInteception() then
			IDVApiProvider.startVerification({ ageEstimation = true }):andThen(function(p)
				v16 = `{v16}_{p.sessionIdentifier}`
				setState6(v16)
				return p
			end):andThen(function(p)
				return v15(p, v16)
			end):andThen(function(p)
				setState5(true)
				return v13(p)
			end):andThen(function()
				return v9(v16)
			end):catch(function(p)
				if defineFastFlag and p and p.resultType == Enum.FacialAgeEstimationResultType.Cancel then
					v8(v16)
				else
					v7(v16)
				end
			end)

			return function()
				v14()
			end
		end

		logEventOnceIfEnabled("start_verification_init")
		IDVApiProvider.startVerificationWithWrappedNetworking(v3, { ageEstimation = true }):andThen(function(p)
			v16 = `{v16}_{p.sessionIdentifier}`
			setState6(v16)
			logEventOnceIfEnabled("start_verification_end")
			return p
		end):andThen(function(p)
			logEventOnceIfEnabled("persona_flow_init")
			return v15(p, v16)
		end):andThen(function(p)
			logEventOnceIfEnabled("persona_flow_end")
			setState5(true)
			logEventOnceIfEnabled("status_polling_init")
			return v13(p)
		end):andThen(function()
			logEventOnceIfEnabled("status_polling_end")
			return v9(v16)
		end):catch(function(p)
			logEventOnceIfEnabled("status_polling_end")

			if defineFastFlag and p and p.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				v8(v16)
			else
				v7(v16)
			end
		end)

		return function()
			v14()
		end
	end, {})

	if state then
		return React.createElement(FAEFailedModal, {
			sessionId = state6,
			entryPointEventCtx = entryPointEventCtx,
			onClose = onFailure,
			onRetry = onRetry
		})
	end

	if state3 then
		return React.createElement(FAEWithQRCodeUpsell, {
			appsFlyerLink = state3,
			sessionId = state6,
			entryPointEventCtx = entryPointEventCtx,
			onCancel = onCancel
		})
	end

	if state2 then
		return React.createElement(FAEDirectLinkUpsell, {
			sessionId = state6,
			entryPointEventCtx = entryPointEventCtx,
			webLink = state2,
			onCancel = onCancel
		})
	end

	if GetFFlagShowFAELoadingModal() and state5 and not state4 then
		return React.createElement(FAELoadingModal, {
			sessionId = state6,
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
