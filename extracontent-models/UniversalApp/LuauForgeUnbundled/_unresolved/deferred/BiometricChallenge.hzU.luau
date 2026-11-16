local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local module = require("@luauforge/deferred/hzV")
local module2 = require("@luauforge/deferred/hzN")
local module3 = require("@luauforge/deferred/hzW")
local personaLivenessContainer = module3.Middleware.Challenges.PersonaLivenessContainer
local personaLivenessContainerV2 = module3.Middleware.Challenges.PersonaLivenessContainerV2
local biometricTypeEnum = module3.Middleware.Challenges.PersonaLivenessEnums.BiometricTypeEnum

local fFlagEnablePersonaLivenessQR = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePersonaLivenessQR

local module4 = require("@luauforge/bundled/gxq")

local function BiometricChallenge(props)
	local v5 = useRoactService(appLogging)

	local biometricType = HttpService:JSONDecode(props.challengeMetadata).biometricType

	React.useEffect(function()
		v5:logRobloxTelemetryEvent(module, {}, {
			context = module2.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = props.challengeId,
			biometricType = biometricType
		})

		if biometricType ~= biometricTypeEnum.PersonaLiveness then
			v5:logRobloxTelemetryEvent(module, {}, {
				context = module2.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				biometricType = biometricType
			})

			props.onChallengeFailed(biometricType)
		end
	end, {})

	if biometricType ~= biometricTypeEnum.PersonaLiveness then
		return React.createElement(React.Fragment, nil, {})
	end

	if fFlagEnablePersonaLivenessQR then
		return personaLivenessContainerV2({
			challengeId = props.challengeId,
			onChallengeCompleted = props.onChallengeCompleted,
			onChallengeAbandoned = props.onChallengeAbandoned,
			onChallengeFailed = props.onChallengeFailed,
			ApiFetchAccessStatus = module4
		})
	end

	return personaLivenessContainer({
		challengeId = props.challengeId,
		onChallengeCompleted = props.onChallengeCompleted,
		onChallengeAbandoned = props.onChallengeAbandoned,
		onChallengeFailed = props.onChallengeFailed
	})
end

return BiometricChallenge
