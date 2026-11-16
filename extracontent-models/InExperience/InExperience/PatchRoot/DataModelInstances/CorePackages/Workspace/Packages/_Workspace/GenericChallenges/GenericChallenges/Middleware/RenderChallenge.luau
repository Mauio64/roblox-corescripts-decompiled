local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
require(GenericChallenges.Types.ChallengeParameters)
local BuildHybridCallback = require(script.Parent.BuildHybridCallback)
local getLocalizedTitle = require(GenericChallenges.Utils.getLocalizedTitle)
local ChallengeWebView = require(script.Parent.ChallengeWebView)
local ChallengeError = require(script.Parent.ChallengeError)
local InitializeHybridCallback = require(script.Parent.InitializeHybridCallback)
local constants = require(GenericChallenges.Utils.constants)
local BuildCredentialsProtocolHook = require(script.Parent.Hooks.BuildCredentialsProtocolHook)
local ErrorKind = require(GenericChallenges.Types.ErrorKind)
local completionDataToRawHeaders = require(GenericChallenges.Utils.completionDataToRawHeaders)
local defineFastFlag = game:DefineFastFlag("EnableRejectPromiseOnWebviewClosed", false)

local parent = GenericChallenges.Parent
require(parent.LuauPolyfill)

return function(data)
	if data.rawResponseHeaders == nil then
		assert(data.callbacks ~= nil, "Callbacks must be specified in manual challenge mode")
		assert(data.challengeParameters ~= nil, "Challenge parameters must be specified in manual challenge mode")
		assert(data.challengeType ~= nil, "Challenge type must be specified in manual challenge mode")
		local v = ChallengeWebView.new({
			title = getLocalizedTitle(data.title),
			challengeType = data.challengeType,
			challengeParameters = data.challengeParameters,
			modal = data.renderWebViewInModal
		})

		local v2 = false
		v:setHybridCallback(BuildHybridCallback({
			Hooks = { BuildCredentialsProtocolHook() },
			OnChallengeLoadFailed = function(p)
				data.callbacks.OnChallengeLoadFailed(p)
				v:close()
			end,
			OnChallengeInvalidated = function(p)
				data.callbacks.OnChallengeInvalidated(p)
				v:close()
			end,
			OnChallengeCompleted = function(p)
				v2 = true
				data.callbacks.OnChallengeCompleted(p)
				v:close()
			end
		}))

		v:setCloseCallback(function()
			if not v2 and data.callbacks.OnChallengeAbandoned ~= nil then
				data.callbacks.OnChallengeAbandoned()
			end
		end)

		if data.onWebViewOpen ~= nil then
			v:setOpenCallback(data.onWebViewOpen)
		end

		v:open()
	else
		assert(data.retryRequestCallback ~= nil, "Retry request callback must be defined for generic handling")
		assert(data.resolve ~= nil, "Promise resolution method must be provided for generic handling")
		assert(data.reject ~= nil, "Promise rejection method must be provided for generic handling")
		local v = ChallengeWebView.new({
			title = getLocalizedTitle(data.title),
			rawResponseHeaders = data.rawResponseHeaders,
			modal = data.renderWebViewInModal
		})

		if defineFastFlag then
			local rawResponseHeader = data.rawResponseHeaders[constants.challengeTypeHeader]
			local rawResponseHeader2 = data.rawResponseHeaders[constants.challengeIdHeader]

			local v2 = false
			v:setHybridCallback(BuildHybridCallback({
				Hooks = { BuildCredentialsProtocolHook() },
				OnChallengeLoadFailed = function(_)
					if data.challengeErrorCallback ~= nil then
						data.challengeErrorCallback()
					end

					data.reject(ChallengeError.new(ErrorKind.LoadFailed, {
						challengeType = rawResponseHeader
					}))

					v:close()
				end,
				OnChallengeInvalidated = function(p)
					if data.challengeErrorCallback ~= nil and p.data ~= nil then
						data.challengeErrorCallback(p.data)
					end

					data.reject(ChallengeError.new(ErrorKind.Invalidated, p.data))
					v:close()
				end,
				OnChallengeDisplayed = function(_)
					v:setVisible(true)
				end,
				OnChallengeCompleted = function(p)
					if p.data ~= nil and p.data.challengeType ~= nil and p.data.metadata ~= nil then
						data.resolve(data.retryRequestCallback(completionDataToRawHeaders({
							challengeId = rawResponseHeader2,
							challengeType = p.data.challengeType,
							metadata = p.data.metadata
						})))
					end

					v2 = true
					v:close()
				end
			}))

			v:setCloseCallback(function()
				if not v2 then
					data.reject(ChallengeError.new(ErrorKind.Invalidated, {
						challengeType = rawResponseHeader
					}))
				end
			end)
		else
			v:setHybridCallback(InitializeHybridCallback(
				data.rawResponseHeaders[constants.challengeIdHeader],
				data.rawResponseHeaders[constants.challengeTypeHeader],
				v,
				data.retryRequestCallback,
				data.challengeErrorCallback,
				data.resolve,
				data.reject
			))
		end

		v:open()
	end
end
