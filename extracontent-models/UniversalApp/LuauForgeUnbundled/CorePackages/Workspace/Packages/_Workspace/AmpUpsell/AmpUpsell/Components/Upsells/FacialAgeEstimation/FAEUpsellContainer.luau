local Players = game:GetService("Players")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").AppLinking
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Promise")

local idvApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").IDVApiProvider
local usePollIDVStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").usePollIDVStatus

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UniversalAppPolicy").useAppPolicy
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppEnums").AppPage
local UrlUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/UrlUtils")

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppNavigation").NavigationCommands else nil

local FacialAgeEstimationServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FacialAgeEstimationServiceWrapper")
local FAEDirectLinkUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAEDirectLinkUpsell")
local FAEWithQRCodeUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAEWithQRCodeUpsell")
local FAEFailedModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAEFailedModal")
local FAELoadingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAELoadingModal")

local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics")
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authModalShown = AuthAnalytics.Events.authModalShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").RoactNetworking

local GetFFlagEnableRoactNetworkingForChallengeInteception = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableRoactNetworkingForChallengeInteception")
local GetFFlagShowFAELoadingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagShowFAELoadingModal")
local defineFastFlag = game:DefineFastFlag("EnableFAECancellationAnalytics", false)
local defineFastFlag2 = game:DefineFastFlag("EnableValidateFAEVerificationLink", false)
local getFFlagMoveAmpUpsellOffNavigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").GetFFlagMoveAmpUpsellOffNavigateDown
local GetFFlagEnableWebAmpWizardForFAEHandoff = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableWebAmpWizardForFAEHandoff")
local GetFFlagEnableFAEQRCodeHandoff = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableFAEQRCodeHandoff")
local logEventOnceIfEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LoggingUtils").logEventOnceIfEnabled

local defineFastInt = game:DefineFastInt("FAEWithCallbackPollDelay", 2)
local defineFastInt2 = game:DefineFastInt("FAEWithCallbackPollMaxRetries", 5)

local defineFastInt3 = game:DefineFastInt("FAEBackgroundOnlyPollDelay", 15)
local defineFastInt4 = game:DefineFastInt("FAEBackgroundOnlyPollMaxRetries", 40)

local defineFastInt5 = game:DefineFastInt("FAEWithWebViewCallbackPollDelay", 2)
local defineFastInt6 = game:DefineFastInt("FAEWithWebViewCallbackPollMaxRetries", 15)

local function FAEUpsellContainer()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local v8 = useAppPolicy(function(p2)
		return p2.getHasWebViewSupportForFAE()
	end)

	local param = v5.getParam("extraProps")
	local entryPointEventCtx = param.entryPointEventCtx
	local metadata = param.metadata
	local skipFacialAgeEstimationWebLinkModal = param.skipFacialAgeEstimationWebLinkModal

	local v9 = useRoactService(appLinking)

	local onSuccess = param.onSuccess
	local onCancel = param.onCancel
	local onFailure = param.onFailure
	local onRetry = param.onRetry

	local v10 = v8 and GetFFlagEnableFAEQRCodeHandoff()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)

	local sessionId = metadata and metadata.sessionId or ""
	local state6, setState6 = React.useState(sessionId)

	local v11 = React.useCallback(function(p2)
		authModalShown(entryPointEventCtx, p2, "faeFailed")
		setState(true)
	end, { entryPointEventCtx })

	local v12 = React.useCallback(function(p2)
		authFormInteraction(entryPointEventCtx, p2, "faeCancelled")
		onCancel()
	end, { onCancel, entryPointEventCtx })

	local v13 = React.useCallback(function(p2)
		authMsgShown(entryPointEventCtx, p2, "faeSuccess")
		onSuccess()
	end, { onSuccess, entryPointEventCtx })

	local function fn(p2, callback)
		if getFFlagMoveAmpUpsellOffNavigateDown() then
			v5.push(appPage.GenericWebPage, {
				detail = p2,
				extraProps = {
					title = "",
					onClose = function()
						callback()
					end
				}
			})
			return
		end

		local v14 = {
			name = appPage.GenericWebPage,
			detail = p2,
			extraProps = {
				title = "",
				onClose = function()
					callback()
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v6(navigateDown(v14))
		end
	end

	local v16 = React.useCallback(fn, { if getFFlagMoveAmpUpsellOffNavigateDown() then v5 or v6 else v6 })

	local v17 = React.useMemo(function()
		if FacialAgeEstimationServiceWrapper.isAvailable() then
			return { delay = defineFastInt, retries = defineFastInt2 }
		end

		if v10 then
			return { delay = defineFastInt3, retries = defineFastInt4 }
		end

		if v8 and not GetFFlagEnableWebAmpWizardForFAEHandoff() then
			return { delay = defineFastInt5, retries = defineFastInt6 }
		end

		return { delay = defineFastInt3, retries = defineFastInt4 }
	end, { v8, v10 })

	local v18, v19 = usePollIDVStatus({ delay = v17.delay, retries = v17.retries })

	local v20 = React.useCallback(function(data, p2)
		local sessionIdentifier = data.sessionIdentifier
		local verificationLink = data.verificationLink
		local sessionToken = data.sessionToken

		if FacialAgeEstimationServiceWrapper.isAvailable() then
			authModalShown(entryPointEventCtx, p2, "nativeFae")
			setState4(true)
			return FacialAgeEstimationServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		elseif v10 then
			setState4(false)
			authModalShown(entryPointEventCtx, p2, "faeQRCodeHandoff")
			local v21 = "roblox%3A%2F%2Fnavigation%2Famp_wizard%3Ffeature_name=TriggerFacialAgeEstimationRecourse%26namespace=account_identity%252FAgeCheck%26entry_point=" .. entryPointEventCtx .. "%26user_id=" .. tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
			setState3("https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=fae_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. v21 .. "&deep_link_value=" .. v21)

			return Promise.resolve(sessionIdentifier)
		else
			if GetFFlagEnableWebAmpWizardForFAEHandoff() then
				authModalShown(entryPointEventCtx, p2, "webHandoffFAE")
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

				authModalShown(entryPointEventCtx, p2, "noNativeFae")
				setState4(false)

				if v8 then
					return Promise.new(function(callback)
						v16(verificationLink, function()
							callback(sessionIdentifier)
						end)
					end)
				end

				if skipFacialAgeEstimationWebLinkModal then
					v9:openURL(verificationLink)
				else
					setState2(verificationLink)
				end
			end

			return Promise.resolve(sessionIdentifier)
		end
	end, {
		entryPointEventCtx,
		v8,
		v16,
		setState4,
		skipFacialAgeEstimationWebLinkModal,
		v9,
		v10
	})

	React.useEffect(function()
		local v21 = sessionId

		if not GetFFlagEnableRoactNetworkingForChallengeInteception() then
			idvApiProvider.startVerification({ ageEstimation = true }):andThen(function(p2)
				v21 = `{v21}_{p2.sessionIdentifier}`
				setState6(v21)
				return p2
			end):andThen(function(p2)
				return v20(p2, v21)
			end):andThen(function(p2)
				setState5(true)
				return v18(p2)
			end):andThen(function()
				return v13(v21)
			end):catch(function(p2)
				if defineFastFlag and p2 and p2.resultType == Enum.FacialAgeEstimationResultType.Cancel then
					v12(v21)
				else
					v11(v21)
				end
			end)

			return function()
				v19()
			end
		end

		logEventOnceIfEnabled("start_verification_init")
		idvApiProvider.startVerificationWithWrappedNetworking(v7, {
			ageEstimation = true
		}):andThen(function(p2)
			v21 = `{v21}_{p2.sessionIdentifier}`
			setState6(v21)
			logEventOnceIfEnabled("start_verification_end")
			return p2
		end):andThen(function(p2)
			logEventOnceIfEnabled("persona_flow_init")
			return v20(p2, v21)
		end):andThen(function(p2)
			logEventOnceIfEnabled("persona_flow_end")
			setState5(true)
			logEventOnceIfEnabled("status_polling_init")
			return v18(p2)
		end):andThen(function()
			logEventOnceIfEnabled("status_polling_end")
			return v13(v21)
		end):catch(function(p2)
			logEventOnceIfEnabled("status_polling_end")

			if defineFastFlag and p2 and p2.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				v12(v21)
			else
				v11(v21)
			end
		end)

		return function()
			v19()
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

	return React.createElement(loading, {
		size = iconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return FAEUpsellContainer
