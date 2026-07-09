local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local BiometricChallengeEvent = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.BiometricChallengeEvent)
local ChallengeEventConstants = require(Modules.LuaApp.Components.Challenge.ChallengeEventConstants)
local GenericChallenges = require(CorePackages.Workspace.Packages.GenericChallenges)
local PersonaLivenessContainer = GenericChallenges.Middleware.Challenges.PersonaLivenessContainer
local PersonaLivenessContainerV2 = GenericChallenges.Middleware.Challenges.PersonaLivenessContainerV2
local BiometricTypeEnum = GenericChallenges.Middleware.Challenges.PersonaLivenessEnums.BiometricTypeEnum
local FFlagEnablePersonaLivenessQR = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePersonaLivenessQR
local ApiFetchAccessStatus = require(Modules.LuaApp.Thunks.Moderation.ApiFetchAccessStatus)

local function BiometricChallenge(t1: {[any]: any}) -- line: 27
	-- upvalues: useRoactService (copy), AppLogging (copy), HttpService (copy), React (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy), FFlagEnablePersonaLivenessQR (copy), PersonaLivenessContainerV2 (copy), ApiFetchAccessStatus (copy), PersonaLivenessContainer (copy)
	local v17 = useRoactService(AppLogging)
	local biometricType = HttpService:JSONDecode(t1.challengeMetadata).biometricType

	React.useEffect(function() -- line: 33
		-- upvalues: v17 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), biometricType (copy), BiometricTypeEnum (copy)
		v17:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = t1.challengeId,
			biometricType = biometricType
		})

		if biometricType ~= BiometricTypeEnum.PersonaLiveness then
			v17:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = t1.challengeId,
				biometricType = biometricType
			})
			t1.onChallengeFailed(biometricType)
		end
	end, {})

	if biometricType == BiometricTypeEnum.PersonaLiveness then
		if FFlagEnablePersonaLivenessQR then
			return PersonaLivenessContainerV2({
				challengeId = t1.challengeId,
				onChallengeCompleted = t1.onChallengeCompleted,
				onChallengeAbandoned = t1.onChallengeAbandoned,
				onChallengeFailed = t1.onChallengeFailed,
				ApiFetchAccessStatus = ApiFetchAccessStatus
			})
		end

		return PersonaLivenessContainer({
			challengeId = t1.challengeId,
			onChallengeCompleted = t1.onChallengeCompleted,
			onChallengeAbandoned = t1.onChallengeAbandoned,
			onChallengeFailed = t1.onChallengeFailed
		})
	end

	return React.createElement(React.Fragment, nil, {})
end

return BiometricChallenge
