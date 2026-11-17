local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent

local React = require(parent.React)
local LoggingProtocol = require(parent.LoggingProtocol)

local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local DeniedChallengeView = require(script.Parent.DeniedChallengeView)
local DeniedChallengeEvent = require(script.Parent.DeniedChallengeEvent)

local ChallengeLifecycleEventConstants = ChallengeEventConstants.ChallengeLifecycleEventConstants

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

	local v = React.useCallback(function(context)
		logging:logRobloxTelemetryEvent(DeniedChallengeEvent, {}, {
			context = context,
			challengeId = challengeId,
			reason = reason,
			prompt = prompt
		})
	end, { logging, challengeId, reason, prompt })

	React.useEffect(function()
		v(ChallengeLifecycleEventConstants.ChallengeInitialized)
		v(ChallengeLifecycleEventConstants.ChallengeDisplayed)

		if ref2.current then
			ref2.current(true)
		end
	end, { v })

	local onAcknowledge = React.useCallback(function()
		v(ChallengeLifecycleEventConstants.ChallengeAbandoned)

		if ref.current then
			ref.current()
		end
	end, { v })

	return React.createElement(DeniedChallengeView, {
		prompt = prompt,
		onAcknowledge = onAcknowledge,
		opaqueBackdrop = props.opaqueBackdrop
	})
end

return DeniedChallenge
