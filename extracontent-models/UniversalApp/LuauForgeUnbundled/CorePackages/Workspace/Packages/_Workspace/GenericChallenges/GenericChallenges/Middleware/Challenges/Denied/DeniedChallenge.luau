local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol")

local ChallengeEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants")
local DeniedChallengeView = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedChallengeView")
local DeniedChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedChallengeEvent")

local challengeLifecycleEventConstants = ChallengeEventConstants.ChallengeLifecycleEventConstants

local default = LoggingProtocol.default

local function DeniedChallenge(props)
	local logging = props.logging or default
	local challengeId = props.challengeId
	local reason = props.reason
	local prompt = props.prompt

	local ref = React.useRef(props.onChallengeAbandoned)
	ref.current = props.onChallengeAbandoned
	local ref2 = React.useRef(props.onChallengeLoaded)
	ref2.current = props.onChallengeLoaded

	local v5 = React.useCallback(function(p2)
		logging:logRobloxTelemetryEvent(DeniedChallengeEvent, {}, {
			context = p2,
			challengeId = challengeId,
			reason = reason,
			prompt = prompt
		})
	end, { logging, challengeId, reason, prompt })

	React.useEffect(function()
		v5(challengeLifecycleEventConstants.ChallengeInitialized)
		v5(challengeLifecycleEventConstants.ChallengeDisplayed)

		if ref2.current then
			ref2.current(true)
		end
	end, { v5 })

	local v6 = React.useCallback(function()
		v5(challengeLifecycleEventConstants.ChallengeAbandoned)

		if ref.current then
			ref.current()
		end
	end, { v5 })

	return React.createElement(DeniedChallengeView, {
		prompt = prompt,
		onAcknowledge = v6,
		opaqueBackdrop = props.opaqueBackdrop
	})
end

return DeniedChallenge
