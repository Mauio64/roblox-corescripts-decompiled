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
local v11 = game:DefineFastFlag("EnableRejectPromiseOnWebviewClosed", false)
local GenericChallengesParent = GenericChallenges.Parent

require(GenericChallengesParent.LuauPolyfill)

return function(t1: {[any]: any}) -- line: 41
	-- upvalues: ChallengeWebView (copy), getLocalizedTitle (copy), v11 (copy), constants (copy), BuildHybridCallback (copy), BuildCredentialsProtocolHook (copy), ChallengeError (copy), ErrorKind (copy), completionDataToRawHeaders (copy), InitializeHybridCallback (copy)
	if t1.rawResponseHeaders ~= nil then
		assert(t1.retryRequestCallback ~= nil, "Retry request callback must be defined for generic handling")
		assert(t1.resolve ~= nil, "Promise resolution method must be provided for generic handling")
		assert(t1.reject ~= nil, "Promise rejection method must be provided for generic handling")

		local v14 = ChallengeWebView.new({
			title = getLocalizedTitle(t1.title),
			rawResponseHeaders = t1.rawResponseHeaders,
			modal = t1.renderWebViewInModal
		})

		if v11 then
			local v15 = t1.rawResponseHeaders[constants.challengeTypeHeader]
			local v16 = t1.rawResponseHeaders[constants.challengeIdHeader]
			local u17 = false

			v14:setHybridCallback(BuildHybridCallback({
				Hooks = { BuildCredentialsProtocolHook() },
				OnChallengeLoadFailed = function(_: {[any]: any}) -- line: 61
					-- upvalues: t1 (copy), ChallengeError (copy), ErrorKind (copy), v15 (copy), v14 (copy)
					if t1.challengeErrorCallback ~= nil then
						t1.challengeErrorCallback()
					end

					t1.reject(ChallengeError.new(ErrorKind.LoadFailed, {
						challengeType = v15
					}))
					v14:close()
				end,
				OnChallengeInvalidated = function(t3: {[any]: any}) -- line: 70
					-- upvalues: t1 (copy), ChallengeError (copy), ErrorKind (copy), v14 (copy)
					if t1.challengeErrorCallback ~= nil and t3.data ~= nil then
						t1.challengeErrorCallback(t3.data)
					end

					t1.reject(ChallengeError.new(ErrorKind.Invalidated, t3.data))
					v14:close()
				end,
				OnChallengeCompleted = function(t4: {[any]: any}) -- line: 77
					-- upvalues: t1 (copy), completionDataToRawHeaders (copy), v16 (copy), u17 (ref), v14 (copy)
					if t4.data ~= nil and (t4.data.challengeType ~= nil and t4.data.metadata ~= nil) then
						t1.resolve(t1.retryRequestCallback(completionDataToRawHeaders({
							challengeId = v16,
							challengeType = t4.data.challengeType,
							metadata = t4.data.metadata
						})))
					end

					u17 = true
					v14:close()
				end
			}))
			v14:setCloseCallback(function() -- line: 91
				-- upvalues: u17 (ref), t1 (copy), ChallengeError (copy), ErrorKind (copy), v15 (copy)
				if not u17 then
					t1.reject(ChallengeError.new(ErrorKind.Invalidated, {
						challengeType = v15
					}))
				end
			end)
		else
			v14:setHybridCallback(InitializeHybridCallback(t1.rawResponseHeaders[constants.challengeIdHeader], t1.rawResponseHeaders[constants.challengeTypeHeader], v14, t1.retryRequestCallback, t1.challengeErrorCallback, t1.resolve, t1.reject))
		end

		v14:open()

		return
	end

	assert(t1.callbacks ~= nil, "Callbacks must be specified in manual challenge mode")
	assert(t1.challengeParameters ~= nil, "Challenge parameters must be specified in manual challenge mode")
	assert(t1.challengeType ~= nil, "Challenge type must be specified in manual challenge mode")

	local v18 = ChallengeWebView.new({
		title = getLocalizedTitle(t1.title),
		challengeType = t1.challengeType,
		challengeParameters = t1.challengeParameters,
		modal = t1.renderWebViewInModal
	})
	local u19 = false

	v18:setHybridCallback(BuildHybridCallback({
		Hooks = { BuildCredentialsProtocolHook() },
		OnChallengeLoadFailed = function(t5: {[any]: any}) -- line: 128
			-- upvalues: t1 (copy), v18 (copy)
			t1.callbacks.OnChallengeLoadFailed(t5)
			v18:close()
		end,
		OnChallengeInvalidated = function(t6: {[any]: any}) -- line: 132
			-- upvalues: t1 (copy), v18 (copy)
			t1.callbacks.OnChallengeInvalidated(t6)
			v18:close()
		end,
		OnChallengeCompleted = function(t7: {[any]: any}) -- line: 136
			-- upvalues: u19 (ref), t1 (copy), v18 (copy)
			u19 = true
			t1.callbacks.OnChallengeCompleted(t7)
			v18:close()
		end
	}))
	v18:setCloseCallback(function() -- line: 142
		-- upvalues: u19 (ref), t1 (copy)
		if not u19 and t1.callbacks.OnChallengeAbandoned ~= nil then
			t1.callbacks.OnChallengeAbandoned()
		end
	end)

	if t1.onWebViewOpen ~= nil then
		v18:setOpenCallback(t1.onWebViewOpen)
	end

	v18:open()
end
