local parent = script:FindFirstAncestor("GenericChallenges").Parent

local React = require(parent.React)

local DeniedChallenge = require(script.Parent.DeniedChallenge)
local DeniedMetadata = require(script.Parent.DeniedMetadata)
local dismissDefaultLoadingGui = require(script.Parent.Parent.Common.dismissDefaultLoadingGui)
local mountNativeChallenge = require(script.Parent.Parent.Common.mountNativeChallenge)

local function shouldShutdownOnTeardown(data): boolean -- 1 equivalent call inferred from this helper
	return data.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect
end

local function shouldUseOpaqueBackdrop(data): boolean -- 1 equivalent call inferred from this helper
	return data.prompt == DeniedMetadata.DeniedPrompt.WasmGameJoinRedirect
end

return function(data)
	local shutdownOnTeardown = shouldShutdownOnTeardown(data) -- inferred equivalent call
	mountNativeChallenge({
		challengeId = data.challengeId,
		shutdownOnTeardown = shutdownOnTeardown,
		mount = data.mount,
		render = function(callback)
			return React.createElement(DeniedChallenge, {
				challengeId = data.challengeId,
				reason = data.reason,
				prompt = data.prompt,
				opaqueBackdrop = shouldUseOpaqueBackdrop(data), -- inferred equivalent call
				logging = data.logging,
				onChallengeLoaded = function(flag: boolean)
					if data.onChallengeLoaded then
						data.onChallengeLoaded(flag)
					end

					if flag then
						dismissDefaultLoadingGui(data.replicatedFirst)
					end
				end,
				onChallengeAbandoned = function()
					if data.onChallengeAbandoned and not shutdownOnTeardown then
						data.onChallengeAbandoned()
					end

					callback()
				end
			})
		end
	})
end
