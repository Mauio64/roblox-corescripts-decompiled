local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/ReactRoblox")

local RoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/RoCaptchaChallenge")

local function defaultShutdownGame()
	game:Shutdown()
end

local function defaultMount(p2)
	local root = ReactRoblox.createRoot(CoreGui)
	root:render(p2)

	return function()
		root:unmount()
	end
end

local v5 = {}

return function(props)
	local challengeId = props.challengeId

	if v5[challengeId] then
		return
	end

	v5[challengeId] = true

	local shutdownGame = props.shutdownGame or defaultShutdownGame
	local mount = props.mount or defaultMount

	local function v6() end
	local function teardown()
		v5[challengeId] = nil
		v6()
		shutdownGame()
	end

	local element = React.createElement(RoCaptchaChallenge, {
		challengeId = challengeId,
		challengeMetadata = props.challengeMetadata,
		experienceService = props.experienceService,
		desiredPlaceId = props.desiredPlaceId,
		logging = props.logging,
		onChallengeLoaded = props.onChallengeLoaded,
		onChallengeFailed = function()
			if props.onChallengeFailed then
				props.onChallengeFailed()
			end

			v5[challengeId] = nil
			v6()
			shutdownGame()
		end,
		onChallengeAbandoned = function()
			if props.onChallengeAbandoned then
				props.onChallengeAbandoned()
			end

			v5[challengeId] = nil
			v6()
			shutdownGame()
		end,
		onChallengeCompleted = function()
			if props.onChallengeCompleted then
				props.onChallengeCompleted()
			end

			v5[challengeId] = nil
			v6()
			shutdownGame()
		end
	})

	local success, result = pcall(mount, element)

	if not success then
		v5[challengeId] = nil
		error(result)
	end

	v6 = result
end
