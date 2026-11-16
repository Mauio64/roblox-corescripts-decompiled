local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent

local Players = game:GetService("Players")

local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local PersonaLivenessContainer = require(script.Parent.PersonaLivenessContainer)
local PersonaLivenessServiceWrapper = require(script.Parent.PersonaLivenessServiceWrapper)
local IdentityVerification = require(parent.IdentityVerification)
local QRDeepLinkDialog = IdentityVerification.QRDeepLinkDialog
local Enums = require(script.Parent.Parent.Common.Enums)
local BiometricTypeEnum = Enums.BiometricTypeEnum
local TelemetryReasons = require(script.Parent.Parent.Common.TelemetryReasons)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags.AppLogging
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags2.RoactNetworking
local BiometricChallengeEvent = require(script.Parent.Parent.Common.BiometricChallengeEvent)
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnhancedPersonaLivenessEvents = SharedFlags.GetFFlagEnhancedPersonaLivenessEvents
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUseSignalsForUserAccess = SharedFlags2.FFlagUseSignalsForUserAccess

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getUserAccessStore

if FFlagUseSignalsForUserAccess then
	local UserAccessStore = require(parent.UserAccessStore)
	getUserAccessStore = UserAccessStore.GetUserAccessStore
else
	getUserAccessStore = nil
end

local defineFastInt = game:DefineFastInt("PersonaLivenessV2QrPollDelaySec", 6)
local defineFastInt2 = game:DefineFastInt("PersonaLivenessV2QrPollMaxRetries", 60)

local function defaultGetLocalUserId()
	local localPlayer = Players.LocalPlayer

	return if localPlayer then localPlayer.UserId else nil
end

local function buildDeeplink(p: number) -- 1 equivalent call inferred from this helper
	return "https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=liveness_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(p) .. "&deep_link_value=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(p)
end

local function PersonaLivenessQRFlow(props)
	local v = useDispatch()
	local v2 = useRoactService(AppLogging)
	local v3 = useRoactService(RoactNetworking)
	local v4

	if FFlagUseSignalsForUserAccess then
		v4 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
	else
		v4 = useSelector(function(p)
			return p.UserAccess and p.UserAccess.restrictionDetail
		end)
	end

	local v5 = (props.getLocalUserId or defaultGetLocalUserId)()
	local deeplink

	if v5 and v5 > 0 then
		deeplink = buildDeeplink(v5) -- inferred equivalent call
	else
		deeplink = nil
	end

	local v6 = useLocalization({
		title = "Feature.BiometricChallenge.Title.QRHandoff",
		description = "Feature.BiometricChallenge.Content.ScanQR",
		footer = {
			"Feature.BiometricChallenge.Content.QRHelpFull",
			prompt = "<b>" .. useLocalization({
				prompt = "Feature.BiometricChallenge.Content.QRHelpPrompt"
			}).prompt .. "</b>"
		}
	})

	local ref = React.useRef(false)

	local v7 = React.useCallback(function(reason)
		if ref.current then
			return
		end

		ref.current = true
		props.onChallengeAbandoned("")

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = reason
			})
		else
			v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness
			})
		end
	end, { v2, props.challengeId, props.onChallengeAbandoned })

	local v8 = React.useCallback(function(p: string, reason)
		if ref.current then
			return
		end

		ref.current = true
		props.onChallengeFailed(p)

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = reason
			})
		else
			v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness
			})
		end
	end, {})

	React.useEffect(function()
		if not deeplink then
			if GetFFlagEnhancedPersonaLivenessEvents() then
				v8("MissingLocalUserId", TelemetryReasons.NullUserId)
			else
				v8("MissingLocalUserId")
			end
		end
	end, { deeplink, v8 })

	React.useEffect(function()
		if not deeplink or v4 ~= nil then
			return
		end

		if not GetFFlagEnhancedPersonaLivenessEvents() then
			v7()

			return
		end

		if ref.current then
			return
		end

		ref.current = true

		v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = props.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness,
			reason = TelemetryReasons.QRCompleted
		})

		props.onChallengeAbandoned("")
	end, { v4, deeplink, v7, v2, props.challengeId, props.onChallengeAbandoned })

	React.useEffect(function()
		if not deeplink then
			return
		end

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v2:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = TelemetryReasons.QRDisplayed
			})
		end

		local flag = false
		task.spawn(function()
			for _ = 1, defineFastInt2 do
				task.wait(defineFastInt)

				if flag then
					return
				end

				if props.ApiFetchAccessStatus then
					v(props.ApiFetchAccessStatus(v3))
				end
			end

			if not flag then
				if GetFFlagEnhancedPersonaLivenessEvents() then
					v8("Timeout", TelemetryReasons.QRPollingTimeout)
				else
					v8("Timeout")
				end
			end
		end)

		return function()
			flag = true
		end
	end, {})

	if deeplink then
		return React.createElement(
			"ScreenGui",
			{
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 200,
				IgnoreGuiInset = true
			},
			{
				Overlay = React.createElement(
					FullscreenPageWithSafeArea,
					{ includeStatusBar = false, useFullScalePage = true },
					{
						FocusNavigableSurface = React.createElement(
							FocusNavigableSurfaceWrapper,
							{
								surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
								isIsolated = true
							},
							{
								Dialog = React.createElement(QRDeepLinkDialog, {
									deeplink = deeplink,
									title = v6.title,
									description = v6.description,
									footer = v6.footer,
									onClose = GetFFlagEnhancedPersonaLivenessEvents() and function()
										v7(TelemetryReasons.QRUserAbandon)
									end or v7
								})
							}
						)
					}
				)
			}
		)
	end

	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

local function PersonaLivenessContainerV2(props)
	if PersonaLivenessServiceWrapper.isAvailable() then
		return React.createElement(PersonaLivenessContainer, {
			challengeId = props.challengeId,
			onChallengeCompleted = props.onChallengeCompleted,
			onChallengeAbandoned = props.onChallengeAbandoned,
			onChallengeFailed = props.onChallengeFailed
		})
	end

	return React.createElement(PersonaLivenessQRFlow, props)
end

return PersonaLivenessContainerV2
