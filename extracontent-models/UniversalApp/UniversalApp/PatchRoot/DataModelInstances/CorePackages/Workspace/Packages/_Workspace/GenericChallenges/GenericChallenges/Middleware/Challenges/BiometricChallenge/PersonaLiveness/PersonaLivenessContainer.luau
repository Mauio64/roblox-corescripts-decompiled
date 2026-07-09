local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericChallengesParent = GenericChallenges.Parent
local HttpService = game:GetService("HttpService")
local React = require(GenericChallengesParent.React)
local Promise = require(GenericChallengesParent.Promise)
local AppPage = require(GenericChallengesParent.RobloxAppEnums).AppPage
local useDispatch = require(GenericChallengesParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(GenericChallengesParent.UniversalAppPolicy).useAppPolicy
local NavigateDown = require(GenericChallengesParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(GenericChallengesParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(GenericChallengesParent.RobloxAppNavigation).NavigationCommands
local IdentityVerification = require(GenericChallengesParent.IdentityVerification)
local IDVApiProvider = IdentityVerification.IDVApiProvider
local usePollIDVStatus = IdentityVerification.usePollIDVStatus
local Foundation = require(GenericChallengesParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local PersonaLivenessServiceWrapper = require(script.Parent.PersonaLivenessServiceWrapper)
local PersonaLivenessHosted = require(script.Parent.PersonaLivenessHosted)
local BiometricTypeEnum = require(script.Parent.Parent.Common.Enums).BiometricTypeEnum
local TelemetryReasons = require(script.Parent.Parent.Common.TelemetryReasons)
local useRoactService = require(GenericChallengesParent.RobloxAppHooks).useRoactService
local AppLogging = require(GenericChallengesParent.RoactServiceTags).AppLogging
local BiometricChallengeEvent = require(script.Parent.Parent.Common.BiometricChallengeEvent)
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local GetFFlagEnhancedPersonaLivenessEvents = require(GenericChallengesParent.SharedFlags).GetFFlagEnhancedPersonaLivenessEvents
local v27 = game:DefineFastInt("LivenessWithCallbackPollDelay", 2)
local v28 = game:DefineFastInt("LivenessWithCallbackPollMaxRetries", 5)
local v29 = game:DefineFastInt("LivenessBackgroundOnlyPollDelay", 6)
local v30 = game:DefineFastInt("LivenessBackgroundOnlyPollMaxRetries", 30)

local function PersonaLivenessContainer(t1: {[any]: any}) -- line: 58
	-- upvalues: useDispatch (copy), useAppPolicy (copy), useRoactService (copy), AppLogging (copy), React (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy), TelemetryReasons (copy), HttpService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), PersonaLivenessServiceWrapper (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy), usePollIDVStatus (copy), Promise (copy), IDVApiProvider (copy), PersonaLivenessHosted (copy), Loading (copy), IconSize (copy)
	local v33 = useDispatch()
	local v34 = useAppPolicy(function(p1) -- line: 62
		return p1.getHasWebViewSupportForFAE()
	end)
	local v35 = useRoactService(AppLogging)
	local v36, v37 = React.useState(nil)
	local v38 = React.useRef("Persona")
	local v39 = React.useRef(nil)
	local v40 = React.useCallback(function(s1: string, p2) -- line: 76
		-- upvalues: t1 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v35 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy), v39 (copy)
		t1.onChallengeFailed(s1)

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = p2,
				inquiryId = v39.current
			})

			return
		end

		v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = t1.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness
		})
	end, {
		v35,
		t1.challengeId,
		t1.onChallengeFailed
	})
	local v41 = React.useCallback(function() -- line: 95
		-- upvalues: t1 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v38 (copy), TelemetryReasons (copy), v35 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy), v39 (copy)
		t1.onChallengeAbandoned("")

		if GetFFlagEnhancedPersonaLivenessEvents() then
			local v51 = if v38.current ~= "Hosted" then TelemetryReasons.PersonaUserAbandon else TelemetryReasons.HostedUserAbandon

			v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = v51,
				inquiryId = v39.current
			})

			return
		end

		v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
			challengeId = t1.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness
		})
	end, {
		v35,
		t1.challengeId,
		t1.onChallengeAbandoned
	})
	local v42 = React.useCallback(function() -- line: 117
		-- upvalues: t1 (copy), HttpService (copy), BiometricTypeEnum (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v38 (copy), TelemetryReasons (copy), v35 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), v39 (copy)
		t1.onChallengeCompleted(HttpService:JSONEncode({
			biometricType = BiometricTypeEnum.PersonaLiveness
		}))

		if GetFFlagEnhancedPersonaLivenessEvents() then
			local v52 = if v38.current ~= "Hosted" then TelemetryReasons.PersonaCompleted else TelemetryReasons.HostedCompleted

			v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = v52,
				inquiryId = v39.current
			})

			return
		end

		v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
			challengeId = t1.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness
		})
	end, {
		v35,
		t1.challengeId,
		t1.onChallengeCompleted
	})
	local v43 = React.useCallback(function(p3, p4) -- line: 141
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v33 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.GenericWebPage,
			detail = p3,
			extraProps = {
				title = "",
				onClose = function() -- line: 147
					-- upvalues: p4 (copy)
					p4()
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v11.down(v11.fromLegacyPage(t2))

			return
		end

		v33(NavigateDown(t2))
	end, { v33 })
	local v44 = React.useMemo(function() -- line: 159
		-- upvalues: PersonaLivenessServiceWrapper (copy), v34 (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy)
		if PersonaLivenessServiceWrapper.isAvailable() or v34 then
			return {
				delay = v27,
				retries = v28
			}
		end

		return {
			delay = v29,
			retries = v30
		}
	end)
	local v45, v46 = usePollIDVStatus({
		delay = v44.delay,
		retries = v44.retries
	})
	local v47 = React.useCallback(function(p5) -- line: 176
		-- upvalues: v39 (copy), PersonaLivenessServiceWrapper (copy), v38 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v35 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), BiometricTypeEnum (copy), TelemetryReasons (copy), v34 (copy), Promise (copy), v43 (copy), v37 (copy)
		local sessionIdentifier = p5.sessionIdentifier
		local sessionToken = p5.sessionToken

		v39.current = sessionIdentifier

		if PersonaLivenessServiceWrapper.isAvailable() then
			v38.current = "Persona"

			if GetFFlagEnhancedPersonaLivenessEvents() then
				v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = t1.challengeId,
					biometricType = BiometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.PersonaDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return PersonaLivenessServiceWrapper.startFlow(sessionIdentifier, sessionToken)
		end

		if v34 then
			v38.current = "Hosted"

			if GetFFlagEnhancedPersonaLivenessEvents() then
				v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
					challengeId = t1.challengeId,
					biometricType = BiometricTypeEnum.PersonaLiveness,
					reason = TelemetryReasons.HostedDisplayed,
					inquiryId = sessionIdentifier
				})
			end

			return Promise.new(function(resolve) -- line: 208
				-- upvalues: sessionIdentifier (copy), v43 (copy), p5 (copy)
				v43(p5.verificationLink, function() -- line: 209
					-- upvalues: resolve (copy), sessionIdentifier (copy)
					resolve(sessionIdentifier)
				end)
			end)
		end

		v38.current = "Hosted"

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v35:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = TelemetryReasons.HostedDisplayed,
				inquiryId = sessionIdentifier
			})
		end

		v37(p5.verificationLink)

		return Promise.resolve(sessionIdentifier)
	end, {
		v34,
		v43,
		v35,
		t1.challengeId
	})

	React.useEffect(function() -- line: 236
		-- upvalues: IDVApiProvider (copy), v47 (copy), v45 (copy), v42 (copy), v41 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v38 (copy), TelemetryReasons (copy), v40 (copy), v46 (copy)
		IDVApiProvider.startLivenessVerification():andThen(function(p6) -- line: 238
			return p6
		end):andThen(function(p7) -- line: 241
			-- upvalues: v47 (copy)
			return v47(p7)
		end):andThen(function(p8) -- line: 244
			-- upvalues: v45 (copy)
			return v45(p8)
		end):andThen(function() -- line: 247
			-- upvalues: v42 (copy)
			return v42()
		end):catch(function(p9) -- line: 250
			-- upvalues: v41 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v38 (copy), TelemetryReasons (copy), v40 (copy)
			if p9 and p9.resultType == Enum.FacialAgeEstimationResultType.Cancel then
				v41()

				return
			end

			if GetFFlagEnhancedPersonaLivenessEvents() then
				local v64 = if not p9 or p9.sessionStatus == nil then TelemetryReasons.StartLivenessFailed else if v38.current ~= "Hosted" then TelemetryReasons.PersonaPollingTimeout else TelemetryReasons.HostedPollingTimeout

				v40("Persona error", v64)

				return
			end

			v40("Persona error")
		end)

		return function() -- line: 268
			-- upvalues: v46 (copy)
			v46()
		end
	end, {})

	if v36 then
		return React.createElement(PersonaLivenessHosted, {
			sessionId = "",
			webLink = v36,
			onCancel = function() -- line: 277
				-- upvalues: v41 (copy)
				v41()
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
