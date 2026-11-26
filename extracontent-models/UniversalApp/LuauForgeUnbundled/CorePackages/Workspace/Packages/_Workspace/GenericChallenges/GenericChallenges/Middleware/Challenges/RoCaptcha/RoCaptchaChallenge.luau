local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local RoCaptchaChallengeView = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/RoCaptchaChallengeView")
local RoCaptchaChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/RoCaptchaChallengeEvent")
local RoCaptchaChallengeContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/RoCaptchaChallengeContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeMetadata")

local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/ExperienceService").ExperienceService
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol").default

local function RoCaptchaChallenge(props)
	local experienceService2 = props.experienceService or experienceService
	local desiredPlaceId = props.desiredPlaceId or game.PlaceId
	local logging = props.logging or default

	local challengeId = props.challengeId

	local v5 = React.useMemo(function()
		local challengeMetadata = props.challengeMetadata

		if challengeMetadata then
			return (tonumber(challengeMetadata.challengePlaceId))
		end

		return nil
	end, { props.challengeMetadata })

	local ref = React.useRef(props.onChallengeFailed)
	ref.current = props.onChallengeFailed
	local ref2 = React.useRef(props.onChallengeAbandoned)
	ref2.current = props.onChallengeAbandoned
	local ref3 = React.useRef(props.onChallengeLoaded)
	ref3.current = props.onChallengeLoaded

	local v6 = React.useCallback(function(p2)
		logging:logRobloxTelemetryEvent(RoCaptchaChallengeEvent, {}, {
			context = p2,
			challengeId = challengeId,
			challengePlaceId = v5
		})
	end, { logging, challengeId, v5 })

	React.useEffect(function()
		v6(RoCaptchaChallengeContext.ChallengeInitialized)

		if v5 == nil then
			v6(RoCaptchaChallengeContext.ChallengeInvalidated)

			if ref3.current then
				ref3.current(false)
			end

			if ref.current then
				ref.current()
			end
		else
			v6(RoCaptchaChallengeContext.ChallengeDisplayed)

			if ref3.current then
				ref3.current(true)
			end
		end
	end, { v6, v5 })

	local v7 = React.useCallback(function()
		v6(RoCaptchaChallengeContext.ChallengeLaunched)

		experienceService2:LaunchExperience({
			placeId = v5,
			launchData = HttpService:JSONEncode({
				challengeId = challengeId,
				desiredPlaceId = desiredPlaceId
			})
		}, "RoCaptchaChallenge")
	end, { v6, experienceService2, challengeId, v5, desiredPlaceId })

	local v8 = React.useCallback(function()
		v6(RoCaptchaChallengeContext.ChallengeAbandoned)

		if ref2.current then
			ref2.current()
		end
	end, { v6 })

	if v5 == nil then
		return nil
	end

	return React.createElement(RoCaptchaChallengeView, {
		onJoin = v7,
		onAbandon = v8,
		waitForFrame = props.waitForFrame
	})
end

return RoCaptchaChallenge
