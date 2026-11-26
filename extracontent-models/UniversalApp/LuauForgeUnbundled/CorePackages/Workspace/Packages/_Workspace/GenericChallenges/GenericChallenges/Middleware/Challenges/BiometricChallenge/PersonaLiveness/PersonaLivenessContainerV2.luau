local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AppBlox").FullscreenPageWithSafeArea

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local PersonaLivenessContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/PersonaLiveness/PersonaLivenessContainer")
local PersonaLivenessServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/PersonaLiveness/PersonaLivenessServiceWrapper")
local qrDeepLinkDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/IdentityVerification").QRDeepLinkDialog
local biometricTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/Enums").BiometricTypeEnum
local TelemetryReasons = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/TelemetryReasons")

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppHooks").useRoactService
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").AppLogging
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").RoactNetworking
local BiometricChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/BiometricChallengeEvent")
local ChallengeEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants")
local getFFlagEnhancedPersonaLivenessEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SharedFlags").GetFFlagEnhancedPersonaLivenessEvents
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SharedFlags").FFlagUseSignalsForUserAccess

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SignalsReact").useSignalState

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/UserAccessStore").GetUserAccessStore else nil

local defineFastInt = game:DefineFastInt("PersonaLivenessV2QrPollDelaySec", 6)
local defineFastInt2 = game:DefineFastInt("PersonaLivenessV2QrPollMaxRetries", 60)

local function defaultGetLocalUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return nil
end

local function buildDeeplink(p2)
	return "https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=liveness_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(p2) .. "&deep_link_value=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(p2)
end

local function PersonaLivenessQRFlow(props)
	local v5 = useDispatch()
	local v6 = useRoactService(appLogging)
	local v7 = useRoactService(roactNetworking)
	local v8

	if fFlagUseSignalsForUserAccess then
		v8 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
	else
		v8 = useSelector(function(p2)
			return p2.UserAccess and p2.UserAccess.restrictionDetail
		end)
	end

	local v9 = (props.getLocalUserId or defaultGetLocalUserId)()
	local v10

	if v9 and v9 > 0 then
		v10 = "https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=liveness_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(v9) .. "&deep_link_value=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(v9)
	else
		v10 = nil
	end

	local v12 = useLocalization({
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

	local v13 = React.useCallback(function(p2)
		if ref.current then
			return
		end

		ref.current = true
		props.onChallengeAbandoned("")

		if getFFlagEnhancedPersonaLivenessEvents() then
			v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness,
				reason = p2
			})
		else
			v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness
			})
		end
	end, { v6, props.challengeId, props.onChallengeAbandoned })

	local v14 = React.useCallback(function(p2, p3)
		if ref.current then
			return
		end

		ref.current = true
		props.onChallengeFailed(p2)

		if getFFlagEnhancedPersonaLivenessEvents() then
			v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness,
				reason = p3
			})
		else
			v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness
			})
		end
	end, {})

	React.useEffect(function()
		if not v10 then
			if getFFlagEnhancedPersonaLivenessEvents() then
				v14("MissingLocalUserId", TelemetryReasons.NullUserId)
			else
				v14("MissingLocalUserId")
			end
		end
	end, { v10, v14 })

	React.useEffect(function()
		if not v10 or v8 ~= nil then
			return
		end

		if not getFFlagEnhancedPersonaLivenessEvents() then
			v13()

			return
		end

		if ref.current then
			return
		end

		ref.current = true

		v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = props.challengeId,
			biometricType = biometricTypeEnum.PersonaLiveness,
			reason = TelemetryReasons.QRCompleted
		})

		props.onChallengeAbandoned("")
	end, { v8, v10, v13, v6, props.challengeId, props.onChallengeAbandoned })

	React.useEffect(function()
		if not v10 then
			return
		end

		if getFFlagEnhancedPersonaLivenessEvents() then
			v6:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness,
				reason = TelemetryReasons.QRDisplayed
			})
		end

		local flag = false
		task.spawn(function()
			for i = 1, defineFastInt2 do
				task.wait(defineFastInt)

				if flag then
					return
				end

				if props.ApiFetchAccessStatus then
					v5(props.ApiFetchAccessStatus(v7))
				end
			end

			if not flag then
				if getFFlagEnhancedPersonaLivenessEvents() then
					v14("Timeout", TelemetryReasons.QRPollingTimeout)
				else
					v14("Timeout")
				end
			end
		end)

		return function()
			flag = true
		end
	end, {})

	if v10 then
		return React.createElement(
			"ScreenGui",
			{
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 200,
				IgnoreGuiInset = true
			},
			{
				Overlay = React.createElement(
					fullscreenPageWithSafeArea,
					{ includeStatusBar = false, useFullScalePage = true },
					{
						FocusNavigableSurface = React.createElement(
							focusNavigableSurfaceWrapper,
							{
								surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ModerationOverlay,
								isIsolated = true
							},
							{
								Dialog = React.createElement(qrDeepLinkDialog, {
									deeplink = v10,
									title = v12.title,
									description = v12.description,
									footer = v12.footer,
									onClose = getFFlagEnhancedPersonaLivenessEvents() and function()
										v13(TelemetryReasons.QRUserAbandon)
									end or v13
								})
							}
						)
					}
				)
			}
		)
	end

	return React.createElement(loading, {
		size = iconSize.Medium,
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
