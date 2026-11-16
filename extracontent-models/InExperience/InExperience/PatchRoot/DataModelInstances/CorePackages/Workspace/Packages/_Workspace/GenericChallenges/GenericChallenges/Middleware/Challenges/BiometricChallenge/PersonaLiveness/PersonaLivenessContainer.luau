local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local Promise = require(parent.Promise)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local IdentityVerification = require(parent.IdentityVerification)
local IDVApiProvider = IdentityVerification.IDVApiProvider
local usePollIDVStatus = IdentityVerification.usePollIDVStatus

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local PersonaLivenessServiceWrapper = require(script.Parent.PersonaLivenessServiceWrapper)
local PersonaLivenessHosted = require(script.Parent.PersonaLivenessHosted)
local Enums = require(script.Parent.Parent.Common.Enums)
local BiometricTypeEnum = Enums.BiometricTypeEnum
local TelemetryReasons = require(script.Parent.Parent.Common.TelemetryReasons)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags.AppLogging
local BiometricChallengeEvent = require(script.Parent.Parent.Common.BiometricChallengeEvent)
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnhancedPersonaLivenessEvents = SharedFlags2.GetFFlagEnhancedPersonaLivenessEvents

local defineFastInt = game:DefineFastInt("LivenessWithCallbackPollDelay", 2)
local defineFastInt2 = game:DefineFastInt("LivenessWithCallbackPollMaxRetries", 5)

local defineFastInt3 = game:DefineFastInt("LivenessBackgroundOnlyPollDelay", 6)
local defineFastInt4 = game:DefineFastInt("LivenessBackgroundOnlyPollMaxRetries", 30)

local function PersonaLivenessContainer(props)
	local v = useDispatch()

	local v2 = useAppPolicy(function(p)
		return p.getHasWebViewSupportForFAE()
	end)

	local v3 = useRoactService(AppLogging)
	local state, setState = React.useState(nil)

	local ref = React.useRef("Persona")
	local ref2 = React.useRef(nil)

	local v4 = React.useCallback(function(p: string, reason)
		props.onChallengeFailed(p)

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = reason,
				inquiryId = ref2.current
			})
		else
			v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness
			})
		end
	end, { v3, props.challengeId, props.onChallengeFailed })

	local v5 = React.useCallback(function()
		props.onChallengeAbandoned("")

		if not GetFFlagEnhancedPersonaLivenessEvents() then
			v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness
			})

			return
		end

		local reason

		if ref.current == "Hosted" then
			reason = TelemetryReasons.HostedUserAbandon
		else
			reason = TelemetryReasons.PersonaUserAbandon
		end

		v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
			challengeId = props.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness,
			reason = reason,
			inquiryId = ref2.current
		})
	end, { v3, props.challengeId, props.onChallengeAbandoned })

	local v6 = React.useCallback(function()
		props.onChallengeCompleted(HttpService:JSONEncode({
			biometricType = BiometricTypeEnum.PersonaLiveness
		}))

		if not GetFFlagEnhancedPersonaLivenessEvents() then
			v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = props.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness
			})

			return
		end

		local reason

		if ref.current == "Hosted" then
			reason = TelemetryReasons.HostedCompleted
		else
			reason = TelemetryReasons.PersonaCompleted
		end

		v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = props.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness,
			reason = reason,
			inquiryId = ref2.current
		})
	end, { v3, props.challengeId, props.onChallengeCompleted })

	local v7 = React.useCallback(function(detail, callback)
		local v7 = {
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
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v(NavigateDown(v7))
		end
	end, { v })

	local v8 = React.useMemo(function()
		if PersonaLivenessServiceWrapper.isAvailable() or v2 then
			return { delay = defineFastInt, retries = defineFastInt2 }
		end

		return { delay = defineFastInt3, retries = defineFastInt4 }
	end)

	local v9, v10 = usePollIDVStatus({ delay = v8.delay, retries = v8.retries })

	local v11 = React.useCallback(function(data)
		local sessionIdentifier = data.sessionIdentifier
		local sessionToken = data.sessionToken

		ref2.current = sessionIdentifier

		if PersonaLivenessServiceWrapper.isAvailable() then
			ref.current = "Persona"

			if GetFFlagEnhancedPersonaLivenessEvents() then
				v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = BiometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.PersonaDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return PersonaLivenessServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		elseif v2 then
			ref.current = "Hosted"

			if GetFFlagEnhancedPersonaLivenessEvents() then
				v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = BiometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.HostedDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return Promise.new(function(callback)
				v7(data.verificationLink, function()
					callback(sessionIdentifier)
				end)
			end)
		else
			ref.current = "Hosted"

			if GetFFlagEnhancedPersonaLivenessEvents() then
				v3:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = props.challengeId,
					biometricType = BiometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.HostedDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			setState(data.verificationLink)
			return Promise.resolve(sessionIdentifier)
		end
	end, { v2, v7, v3, props.challengeId })

	React.useEffect(function()
		IDVApiProvider.startLivenessVerification():andThen(function(p)
			return p
		end):andThen(function(p)
			return v11(p)
		end):andThen(function(p)
			return v9(p)
		end):andThen(function()
			return v6()
		end):catch(function(p)
			if p and p.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				v5()
				return
			end

			if not GetFFlagEnhancedPersonaLivenessEvents() then
				v4("Persona error")

				return
			end

			local v12

			if p and p.sessionStatus ~= nil then
				if ref.current == "Hosted" then
					v12 = TelemetryReasons.HostedPollingTimeout
				else
					v12 = TelemetryReasons.PersonaPollingTimeout
				end
			else
				v12 = TelemetryReasons.StartLivenessFailed
			end

			v4("Persona error", v12)
		end)

		return function()
			v10()
		end
	end, {})

	if state then
		return React.createElement(PersonaLivenessHosted, {
			sessionId = "",
			webLink = state,
			onCancel = function()
				v5()
			end
		})
	end

	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return PersonaLivenessContainer
