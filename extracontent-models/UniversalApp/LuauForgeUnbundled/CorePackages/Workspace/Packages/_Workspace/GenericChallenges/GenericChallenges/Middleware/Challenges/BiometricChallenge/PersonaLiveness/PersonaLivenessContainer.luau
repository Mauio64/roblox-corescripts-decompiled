local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Promise")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppEnums").AppPage
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactUtils").Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/UniversalAppPolicy").useAppPolicy
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppNavigation").NavigationCommands else nil

local IdentityVerification = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/IdentityVerification")
local idvApiProvider = IdentityVerification.IDVApiProvider
local usePollIDVStatus = IdentityVerification.usePollIDVStatus

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local PersonaLivenessServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/PersonaLiveness/PersonaLivenessServiceWrapper")
local PersonaLivenessHosted = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/PersonaLiveness/PersonaLivenessHosted")
local biometricTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/Enums").BiometricTypeEnum
local TelemetryReasons = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/TelemetryReasons")

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppHooks").useRoactService
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").AppLogging
local BiometricChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/BiometricChallenge/Common/BiometricChallengeEvent")
local ChallengeEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants")
local getFFlagEnhancedPersonaLivenessEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SharedFlags").GetFFlagEnhancedPersonaLivenessEvents

local defineFastInt = game:DefineFastInt("LivenessWithCallbackPollDelay", 2)
local defineFastInt2 = game:DefineFastInt("LivenessWithCallbackPollMaxRetries", 5)

local defineFastInt3 = game:DefineFastInt("LivenessBackgroundOnlyPollDelay", 6)
local defineFastInt4 = game:DefineFastInt("LivenessBackgroundOnlyPollMaxRetries", 30)

local function PersonaLivenessContainer(props)
	local v5 = useDispatch()

	local v6 = useAppPolicy(function(p2)
		return p2.getHasWebViewSupportForFAE()
	end)

	local v7 = useRoactService(appLogging)
	local state, setState = React.useState(nil)

	local ref = React.useRef("Persona")
	local ref2 = React.useRef(nil)

	local v8 = React.useCallback(function(p2, p3)
		props.onChallengeFailed(p2)

		if getFFlagEnhancedPersonaLivenessEvents() then
			v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness,
				reason = p3,
				inquiryId = ref2.current
			})
		else
			v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness
			})
		end
	end, { v7, props.challengeId, props.onChallengeFailed })

	local v9 = React.useCallback(function()
		props.onChallengeAbandoned("")

		if not getFFlagEnhancedPersonaLivenessEvents() then
			v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness
			})

			return
		end

		local v10 = if ref.current == "Hosted" then TelemetryReasons.HostedUserAbandon else TelemetryReasons.PersonaUserAbandon
		v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
			challengeId = props.challengeId,
			biometricType = biometricTypeEnum.PersonaLiveness,
			reason = v10,
			inquiryId = ref2.current
		})
	end, { v7, props.challengeId, props.onChallengeAbandoned })

	local v10 = React.useCallback(function()
		props.onChallengeCompleted(HttpService:JSONEncode({
			biometricType = biometricTypeEnum.PersonaLiveness
		}))

		if not getFFlagEnhancedPersonaLivenessEvents() then
			v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = props.challengeId,
				biometricType = biometricTypeEnum.PersonaLiveness
			})

			return
		end

		local v11 = if ref.current == "Hosted" then TelemetryReasons.HostedCompleted else TelemetryReasons.PersonaCompleted
		v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = props.challengeId,
			biometricType = biometricTypeEnum.PersonaLiveness,
			reason = v11,
			inquiryId = ref2.current
		})
	end, { v7, props.challengeId, props.onChallengeCompleted })

	local v11 = React.useCallback(function(p2, callback)
		local v12 = {
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
			navigationCommands.down(navigationCommands.fromLegacyPage(v12))
		else
			v5(navigateDown(v12))
		end
	end, { v5 })

	local v12 = React.useMemo(function()
		if PersonaLivenessServiceWrapper.isAvailable() or v6 then
			return { delay = defineFastInt, retries = defineFastInt2 }
		end

		return { delay = defineFastInt3, retries = defineFastInt4 }
	end)

	local v13, v14 = usePollIDVStatus({ delay = v12.delay, retries = v12.retries })

	local v15 = React.useCallback(function(data)
		local sessionIdentifier = data.sessionIdentifier
		local sessionToken = data.sessionToken

		ref2.current = sessionIdentifier

		if PersonaLivenessServiceWrapper.isAvailable() then
			ref.current = "Persona"

			if getFFlagEnhancedPersonaLivenessEvents() then
				v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = biometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.PersonaDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return PersonaLivenessServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		elseif v6 then
			ref.current = "Hosted"

			if getFFlagEnhancedPersonaLivenessEvents() then
				v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = biometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.HostedDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return Promise.new(function(callback)
				local function fn()
					callback(sessionIdentifier)
				end

				v11(data.verificationLink, fn)
			end)
		else
			ref.current = "Hosted"

			if getFFlagEnhancedPersonaLivenessEvents() then
				v7:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = biometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.HostedDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			setState(data.verificationLink)
			return Promise.resolve(sessionIdentifier)
		end
	end, { v6, v11, v7, props.challengeId })

	React.useEffect(function()
		idvApiProvider.startLivenessVerification():andThen(function(p2)
			return p2
		end):andThen(function(p2)
			return v15(p2)
		end):andThen(function(p2)
			return v13(p2)
		end):andThen(function()
			return v10()
		end):catch(function(p2)
			if p2 and p2.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				v9()
				return
			end

			if not getFFlagEnhancedPersonaLivenessEvents() then
				v8("Persona error")

				return
			end

			local v16

			if p2 and p2.sessionStatus ~= nil then
				if ref.current == "Hosted" then
					v16 = TelemetryReasons.HostedPollingTimeout
				else
					v16 = TelemetryReasons.PersonaPollingTimeout
				end
			else
				v16 = TelemetryReasons.StartLivenessFailed
			end

			v8("Persona error", v16)
		end)

		return function()
			v14()
		end
	end, {})

	if state then
		return React.createElement(PersonaLivenessHosted, {
			sessionId = "",
			webLink = state,
			onCancel = function()
				v9()
			end
		})
	end

	return React.createElement(loading, {
		size = iconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return PersonaLivenessContainer
