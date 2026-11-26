require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeParameters")
local BuildHybridCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/BuildHybridCallback")
local getLocalizedTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/getLocalizedTitle")
local ChallengeWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeWebView")
local ChallengeError = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeError")
local InitializeHybridCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/InitializeHybridCallback")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/constants")
local BuildCredentialsProtocolHook = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Hooks/BuildCredentialsProtocolHook")
local ErrorKind = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ErrorKind")
local completionDataToRawHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/completionDataToRawHeaders")
local defineFastFlag = game:DefineFastFlag("EnableRejectPromiseOnWebviewClosed", false)

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LuauPolyfill")

return function(data)
	if data.rawResponseHeaders == nil then
		assert(data.callbacks ~= nil, "Callbacks must be specified in manual challenge mode")
		assert(
			data.challengeParameters ~= nil,
			"Challenge parameters must be specified in manual challenge mode"
		)
		assert(data.challengeType ~= nil, "Challenge type must be specified in manual challenge mode")
		local v5 = ChallengeWebView.new({
			title = getLocalizedTitle(data.title),
			challengeType = data.challengeType,
			challengeParameters = data.challengeParameters,
			modal = data.renderWebViewInModal
		})

		local v6 = false
		v5:setHybridCallback(BuildHybridCallback({
			Hooks = { BuildCredentialsProtocolHook() },
			OnChallengeLoadFailed = function(p2)
				data.callbacks.OnChallengeLoadFailed(p2)
				v5:close()
			end,
			OnChallengeInvalidated = function(p2)
				data.callbacks.OnChallengeInvalidated(p2)
				v5:close()
			end,
			OnChallengeCompleted = function(p2)
				v6 = true
				data.callbacks.OnChallengeCompleted(p2)
				v5:close()
			end
		}))

		v5:setCloseCallback(function()
			if not v6 and data.callbacks.OnChallengeAbandoned ~= nil then
				data.callbacks.OnChallengeAbandoned()
			end
		end)

		if data.onWebViewOpen ~= nil then
			v5:setOpenCallback(data.onWebViewOpen)
		end

		v5:open()
	else
		assert(
			data.retryRequestCallback ~= nil,
			"Retry request callback must be defined for generic handling"
		)
		assert(data.resolve ~= nil, "Promise resolution method must be provided for generic handling")
		assert(data.reject ~= nil, "Promise rejection method must be provided for generic handling")
		local v5 = ChallengeWebView.new({
			title = getLocalizedTitle(data.title),
			rawResponseHeaders = data.rawResponseHeaders,
			modal = data.renderWebViewInModal
		})

		if defineFastFlag then
			local rawResponseHeader = data.rawResponseHeaders[constants.challengeTypeHeader]
			local rawResponseHeader2 = data.rawResponseHeaders[constants.challengeIdHeader]

			local v6 = false
			v5:setHybridCallback(BuildHybridCallback({
				Hooks = { BuildCredentialsProtocolHook() },
				OnChallengeLoadFailed = function(p2)
					if data.challengeErrorCallback ~= nil then
						data.challengeErrorCallback()
					end

					data.reject(ChallengeError.new(ErrorKind.LoadFailed, {
						challengeType = rawResponseHeader
					}))

					v5:close()
				end,
				OnChallengeInvalidated = function(p2)
					if data.challengeErrorCallback ~= nil and p2.data ~= nil then
						data.challengeErrorCallback(p2.data)
					end

					data.reject(ChallengeError.new(ErrorKind.Invalidated, p2.data))
					v5:close()
				end,
				OnChallengeDisplayed = function(p2)
					v5:setVisible(true)
				end,
				OnChallengeCompleted = function(p2)
					if p2.data ~= nil and p2.data.challengeType ~= nil and p2.data.metadata ~= nil then
						data.resolve(data.retryRequestCallback(completionDataToRawHeaders({
							challengeId = rawResponseHeader2,
							challengeType = p2.data.challengeType,
							metadata = p2.data.metadata
						})))
					end

					v6 = true
					v5:close()
				end
			}))

			v5:setCloseCallback(function()
				if not v6 then
					data.reject(ChallengeError.new(ErrorKind.Invalidated, {
						challengeType = rawResponseHeader
					}))
				end
			end)
		else
			v5:setHybridCallback(InitializeHybridCallback(
				data.rawResponseHeaders[constants.challengeIdHeader],
				data.rawResponseHeaders[constants.challengeTypeHeader],
				v5,
				data.retryRequestCallback,
				data.challengeErrorCallback,
				data.resolve,
				data.reject
			))
		end

		v5:open()
	end
end
