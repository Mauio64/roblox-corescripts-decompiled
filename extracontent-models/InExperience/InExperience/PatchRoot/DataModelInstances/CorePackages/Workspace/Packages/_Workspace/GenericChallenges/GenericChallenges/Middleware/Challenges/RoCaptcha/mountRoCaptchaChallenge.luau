local parent = script:FindFirstAncestor("GenericChallenges").Parent

local CoreGui = game:GetService("CoreGui")

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local RoCaptchaChallenge = require(script.Parent.RoCaptchaChallenge)

local function defaultShutdownGame()
	game:Shutdown()
end

local function defaultMount(p)
	local root = ReactRoblox.createRoot(CoreGui)
	root:render(p)

	return function()
		root:unmount()
	end
end

local v = {}

return function(props)
	local challengeId = props.challengeId

	if v[challengeId] then
		return
	end

	v[challengeId] = true

	local shutdownGame = props.shutdownGame or defaultShutdownGame
	local mount = props.mount or defaultMount

	local function v2() end
	local function teardown() -- 3 equivalent calls inferred from this helper
		v[challengeId] = nil
		v2()
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

			teardown() -- inferred equivalent call
		end,
		onChallengeAbandoned = function()
			if props.onChallengeAbandoned then
				props.onChallengeAbandoned()
			end

			teardown() -- inferred equivalent call
		end,
		onChallengeCompleted = function()
			if props.onChallengeCompleted then
				props.onChallengeCompleted()
			end

			teardown() -- inferred equivalent call
		end
	})

	local success, result = pcall(mount, element)

	if not success then
		v[challengeId] = nil
		error(result)
	end

	v2 = result
end
