local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local DeniedChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedChallenge")
local DeniedMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedMetadata")
local dismissDefaultLoadingGui = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Common/dismissDefaultLoadingGui")
local mountNativeChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Common/mountNativeChallenge")

local function shouldShutdownOnTeardown(p2): boolean
	return p2.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect
end

local function shouldUseOpaqueBackdrop(p2): boolean
	return p2.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect
end

return function(data)
	local v5 = data.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect

	mountNativeChallenge({
		challengeId = data.challengeId,
		shutdownOnTeardown = v5,
		mount = data.mount,
		render = function(callback)
			return React.createElement(DeniedChallenge, {
				challengeId = data.challengeId,
				reason = data.reason,
				prompt = data.prompt,
				opaqueBackdrop = data.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect,
				logging = data.logging,
				onChallengeLoaded = function(p2)
					if data.onChallengeLoaded then
						data.onChallengeLoaded(p2)
					end

					if p2 then
						dismissDefaultLoadingGui(data.replicatedFirst)
					end
				end,
				onChallengeAbandoned = function()
					if data.onChallengeAbandoned and not v5 then
						data.onChallengeAbandoned()
					end

					callback()
				end
			})
		end
	})
end
