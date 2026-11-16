local parent = script:FindFirstAncestor("GenericChallenges").Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

local RoCaptchaChallengeView = require(script.Parent.RoCaptchaChallengeView)
local RoCaptchaChallengeEvent = require(script.Parent.RoCaptchaChallengeEvent)
local RoCaptchaChallengeContext = require(script.Parent.RoCaptchaChallengeContext)

local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local function RoCaptchaChallenge(props)
	local experienceService2 = props.experienceService or experienceService
	local desiredPlaceId = props.desiredPlaceId or game.PlaceId
	local logging = props.logging or default

	local challengeId = props.challengeId

	local v = React.useMemo(function()
		local decoded = Base64.Decode(props.challengeMetadata)
		local success, result = pcall(function()
			return HttpService:JSONDecode(decoded)
		end)

		return success and result and tonumber(result.challengePlaceId) or nil
	end, { props.challengeMetadata })

	local ref = React.useRef(props.onChallengeFailed)
	ref.current = props.onChallengeFailed
	local ref2 = React.useRef(props.onChallengeAbandoned)
	ref2.current = props.onChallengeAbandoned
	local ref3 = React.useRef(props.onChallengeLoaded)
	ref3.current = props.onChallengeLoaded

	local v2 = React.useCallback(function(context)
		logging:logRobloxTelemetryEvent(RoCaptchaChallengeEvent, {}, {
			context = context,
			challengeId = challengeId,
			challengePlaceId = v
		})
	end, { logging, challengeId, v })

	React.useEffect(function()
		v2(RoCaptchaChallengeContext.ChallengeInitialized)

		if v == nil then
			v2(RoCaptchaChallengeContext.ChallengeInvalidated)

			if ref3.current then
				ref3.current(false)
			end

			if ref.current then
				ref.current()
			end
		else
			v2(RoCaptchaChallengeContext.ChallengeDisplayed)

			if ref3.current then
				ref3.current(true)
			end
		end
	end, { v2, v })

	local onJoin = React.useCallback(function()
		v2(RoCaptchaChallengeContext.ChallengeLaunched)

		experienceService2:LaunchExperience({
			placeId = v,
			launchData = HttpService:JSONEncode({
				challengeId = challengeId,
				desiredPlaceId = desiredPlaceId
			})
		}, "RoCaptchaChallenge")
	end, { v2, experienceService2, challengeId, v, desiredPlaceId })

	local onAbandon = React.useCallback(function()
		v2(RoCaptchaChallengeContext.ChallengeAbandoned)

		if ref2.current then
			ref2.current()
		end
	end, { v2 })

	if v == nil then
		return nil
	end

	return React.createElement(RoCaptchaChallengeView, {
		onJoin = onJoin,
		onAbandon = onAbandon,
		waitForFrame = props.waitForFrame
	})
end

return RoCaptchaChallenge
