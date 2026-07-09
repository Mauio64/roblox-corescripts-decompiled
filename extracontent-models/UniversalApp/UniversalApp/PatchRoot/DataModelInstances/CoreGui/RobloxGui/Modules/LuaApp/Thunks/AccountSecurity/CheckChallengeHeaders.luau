local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Modules = CoreGui.RobloxGui.Modules
local Base64 = require(Modules.LuaApp.Util.Base64)
local ChallengeError = require(Modules.LuaApp.Util.ChallengeError)
local Type = require(Modules.LuaApp.Enum.Challenge.Type)
local GenericType = require(Modules.LuaApp.Enum.Challenge.GenericType)
local ErrorKind = require(Modules.LuaApp.Enum.Challenge.ErrorKind)
local DeniedReason = require(Modules.LuaApp.Enum.Challenge.DeniedReason)
local GetFFlagLuaAppChallengeDisableForceWebViewVisible = require(Modules.LuaApp.Flags.GetFFlagLuaAppChallengeDisableForceWebViewVisible)
local GetFFlagLuaAppChallengeCaptchaV2ForceWebViewVisible = require(Modules.LuaApp.Flags.GetFFlagLuaAppChallengeCaptchaV2ForceWebViewVisible)
local GetFFlagLuaAppChallengeTurnstileForceWebViewVisible = require(Modules.LuaApp.Flags.GetFFlagLuaAppChallengeTurnstileForceWebViewVisible)
local Promise = require(Modules.LuaApp.Promise)
local RenderChallenge = require(Modules.LuaApp.Thunks.Challenge.RenderChallenge)
local RenderNativeChallenge = require(Modules.LuaApp.Thunks.Challenge.RenderNativeChallenge)
local GetFFlagEnableNativeToWebviewMiddleware = require(Modules.LuaApp.Flags.GetFFlagEnableNativeToWebviewMiddleware)
local GetFFlagEnableBypassNavigationLockHybridWebview = require(Modules.LuaApp.Flags.GetFFlagEnableBypassNavigationLockHybridWebview)
local GetFFlagChallengeInterceptorResolveOriginalNetworkImpl = require(Modules.LuaApp.Flags.GetFFlagChallengeInterceptorResolveOriginalNetworkImpl)

function shouldForceWebViewVisibleForChallengeType(s1: string) -- line: 38
	-- upvalues: GenericType (copy), GetFFlagLuaAppChallengeCaptchaV2ForceWebViewVisible (copy), GetFFlagLuaAppChallengeTurnstileForceWebViewVisible (copy)
	local v22 = GenericType.fromRawValue(s1)

	return v22 ~= nil and (v22 ~= GenericType.Captcha and (v22 ~= GenericType.ProofOfWork and (v22 ~= GenericType.DeviceIntegrity and (v22 ~= GenericType.PrivateAccessToken and (v22 ~= GenericType.Biometric and ((GetFFlagLuaAppChallengeCaptchaV2ForceWebViewVisible() or v22 ~= GenericType.CaptchaV2) and (GetFFlagLuaAppChallengeTurnstileForceWebViewVisible() or v22 ~= GenericType.Turnstile)))))))
end
function shouldRenderNativeChallenge(p1) -- line: 55
	-- upvalues: HttpService (copy)
	local data = HttpService:JSONDecode(p1)

	return data ~= nil and (data.sharedParameters ~= nil and data.sharedParameters.renderNativeChallenge == true)
end
function renderChallengeWithHeaders(p2, p3, p4, p5, p6) -- line: 63
	-- upvalues: Promise (copy), GenericType (copy), Base64 (copy), HttpService (copy), DeniedReason (copy), ChallengeError (copy), ErrorKind (copy), Logging (copy), RenderNativeChallenge (copy), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), GetFFlagEnableNativeToWebviewMiddleware (copy), RenderChallenge (copy), Type (copy), GetFFlagLuaAppChallengeDisableForceWebViewVisible (copy), GetFFlagEnableBypassNavigationLockHybridWebview (copy)
	return function(p7) -- line: 64
		-- upvalues: p6 (copy), Promise (copy), GenericType (copy), Base64 (copy), HttpService (copy), DeniedReason (copy), ChallengeError (copy), ErrorKind (copy), Logging (copy), RenderNativeChallenge (copy), p5 (ref), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), p2 (copy), p3 (copy), p4 (copy), GetFFlagEnableNativeToWebviewMiddleware (copy), RenderChallenge (copy), Type (copy), GetFFlagLuaAppChallengeDisableForceWebViewVisible (copy), GetFFlagEnableBypassNavigationLockHybridWebview (copy)
		if p6 == nil then
			return Promise.resolve()
		end

		if type(p6.Headers) == "table" and p6.Headers["rblx-challenge-type"] and p6.Headers["rblx-challenge-metadata"] and p6.Headers["rblx-challenge-id"] then
			local v32 = GenericType.fromRawValue(p6.Headers["rblx-challenge-type"])
			local v33 = Base64.Decode(p6.Headers["rblx-challenge-metadata"])
			local data = HttpService:JSONDecode(v33)

			if v32 == GenericType.Denied and data and data.reason == DeniedReason.toRawValue(DeniedReason.RateLimited) and data.rateLimited and data.rateLimited.retryTime then
				return Promise.reject(ChallengeError:new(ErrorKind.RateLimited, data.rateLimited))
			end

			if shouldRenderNativeChallenge(v33) then
				Logging.warn("Rendering native challenge.")

				return Promise.new(function(resolve, reject) -- line: 98
					-- upvalues: p7 (copy), RenderNativeChallenge (copy), p6 (copy), v32 (copy), v33 (copy), p5 (ref), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), p2 (copy), p3 (copy), p4 (copy), ChallengeError (copy), ErrorKind (copy), GetFFlagEnableNativeToWebviewMiddleware (copy), Logging (copy), RenderChallenge (copy), Type (copy), Base64 (copy), HttpService (copy), GenericType (copy), GetFFlagLuaAppChallengeDisableForceWebViewVisible (copy), GetFFlagEnableBypassNavigationLockHybridWebview (copy)
					p7:dispatch(RenderNativeChallenge({
						challengeId = p6.Headers["rblx-challenge-id"],
						challengeType = v32,
						challengeMetadata = v33,
						onSessionCompleted = function() -- line: 103
							-- upvalues: p5 (ref), p6 (copy), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), resolve (copy), p2 (copy), p3 (copy), p4 (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
							p5 = if type(p5) ~= "table" then {} else p5
							p5.headers = if type(p5.headers) ~= "table" then {} else p5.headers
							p5.headers["rblx-challenge-id"] = p6.Headers["rblx-challenge-id"]
							p5.headers["rblx-challenge-type"] = p6.Headers["rblx-challenge-type"]
							p5.headers["rblx-challenge-metadata"] = p6.Headers["rblx-challenge-metadata"]

							if GetFFlagChallengeInterceptorResolveOriginalNetworkImpl() then
								resolve(p2(p3, p4, p5))

								return
							end

							local v39, _ = p2(p3, p4, p5):andThen(nil, function(_) -- line: 116
								-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
								reject(ChallengeError:new(ErrorKind.Invalidated, {
									challengeType = v32
								}))
							end)

							resolve(v39)
						end,
						onSessionFailed = function() -- line: 121
							-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
							reject(ChallengeError:new(ErrorKind.Invalidated, {
								challengeType = v32
							}))
						end,
						onSessionAbandoned = function() -- line: 124
							-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
							reject(ChallengeError:new(ErrorKind.Abandoned, {
								challengeType = v32
							}))
						end,
						onWebViewChallengeIssued = if not GetFFlagEnableNativeToWebviewMiddleware() then nil else function(p9, p10) -- line: 128
							-- upvalues: Logging (copy), p7 (copy), RenderChallenge (copy), Type (copy), p6 (copy), Base64 (copy), p5 (ref), HttpService (copy), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), resolve (copy), p2 (copy), p3 (copy), p4 (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy), GenericType (copy), GetFFlagLuaAppChallengeDisableForceWebViewVisible (copy), GetFFlagEnableBypassNavigationLockHybridWebview (copy)
							Logging.warn("Rendering generic web challenge.")
							p7:dispatch(RenderChallenge({
								challengeType = Type.Generic,
								challengeParameters = {
									genericChallengeId = p6.Headers["rblx-challenge-id"],
									genericChallengeType = p9,
									genericChallengeMetadata = Base64.EncodeUrl(p10),
									onChallengeCompleted = function(_) -- line: 136
										-- upvalues: p5 (ref), p6 (copy), p9 (copy), Base64 (copy), HttpService (copy), p10 (copy), GetFFlagChallengeInterceptorResolveOriginalNetworkImpl (copy), resolve (copy), p2 (copy), p3 (copy), p4 (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
										p5 = if type(p5) ~= "table" then {} else p5
										p5.headers = if type(p5.headers) ~= "table" then {} else p5.headers
										p5.headers["rblx-challenge-id"] = p6.Headers["rblx-challenge-id"]
										p5.headers["rblx-challenge-type"] = p9
										p5.headers["rblx-challenge-metadata"] = Base64.Encode(HttpService:JSONEncode(p10))

										if GetFFlagChallengeInterceptorResolveOriginalNetworkImpl() then
											resolve(p2(p3, p4, p5))

											return
										end

										local v51, _ = p2(p3, p4, p5):andThen(nil, function(_) -- line: 153
											-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), v32 (copy)
											reject(ChallengeError:new(ErrorKind.Invalidated, {
												challengeType = v32
											}))
										end)

										resolve(v51)
									end,
									onChallengeInvalidated = function(p13) -- line: 164
										-- upvalues: GenericType (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), p9 (copy)
										if p13 and p13.challengeType then
											p13.challengeType = GenericType.fromRawValue((tostring(p13.challengeType)))
											reject(ChallengeError:new(ErrorKind.Invalidated, p13))

											return
										end

										local t1 = {
											challengeType = GenericType.fromRawValue(p9)
										}

										reject(ChallengeError:new(ErrorKind.Invalidated, t1))
									end
								},
								onChallengeAbandoned = function() -- line: 177
									-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), GenericType (copy), p9 (copy)
									reject(ChallengeError:new(ErrorKind.Abandoned, {
										challengeType = GenericType.fromRawValue(p9)
									}))
								end,
								onChallengeLoadFailed = function() -- line: 182
									-- upvalues: Logging (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), GenericType (copy), p9 (copy)
									Logging.warn("Load generic challenge failed.")
									reject(ChallengeError:new(ErrorKind.LoadFailed, {
										challengeType = GenericType.fromRawValue(p9)
									}))
								end,
								forceWebViewVisible = not GetFFlagLuaAppChallengeDisableForceWebViewVisible() or shouldForceWebViewVisibleForChallengeType(p9)
							}, false, GetFFlagEnableBypassNavigationLockHybridWebview()))
						end
					}))
				end)
			end

			Logging.warn("Rendering generic challenge.")

			return Promise.new(function(resolve, reject) -- line: 198
				-- upvalues: p7 (copy), RenderChallenge (copy), Type (copy), p6 (copy), Base64 (copy), v33 (copy), p5 (ref), HttpService (copy), p2 (copy), p3 (copy), p4 (copy), GenericType (copy), ChallengeError (copy), ErrorKind (copy), Logging (copy), GetFFlagLuaAppChallengeDisableForceWebViewVisible (copy)
				p7:dispatch(RenderChallenge({
					challengeType = Type.Generic,
					challengeParameters = {
						genericChallengeId = p6.Headers["rblx-challenge-id"],
						genericChallengeType = p6.Headers["rblx-challenge-type"],
						genericChallengeMetadata = Base64.EncodeUrl(v33),
						onChallengeCompleted = function(p14) -- line: 210
							-- upvalues: p5 (ref), p6 (copy), Base64 (copy), HttpService (copy), p2 (copy), p3 (copy), p4 (copy), p7 (copy), resolve (copy)
							p5 = if type(p5) ~= "table" then {} else p5
							p5.headers = if type(p5.headers) ~= "table" then {} else p5.headers
							p5.headers["rblx-challenge-id"] = p6.Headers["rblx-challenge-id"]
							p5.headers["rblx-challenge-type"] = p6.Headers["rblx-challenge-type"]
							p5.headers["rblx-challenge-metadata"] = Base64.Encode(HttpService:JSONEncode(p14.metadata))

							local v44, _ = p2(p3, p4, p5)
							local v46 = v44:andThen(nil, function(p15) -- line: 221
								-- upvalues: p7 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (ref)
								return p7:dispatch(renderChallengeWithHeaders(p2, p3, p4, p5, p15))
							end)

							resolve(v46)
						end,
						onChallengeInvalidated = function(p16) -- line: 228
							-- upvalues: GenericType (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), p6 (copy)
							if p16 and p16.challengeType then
								p16.challengeType = GenericType.fromRawValue((tostring(p16.challengeType)))
								reject(ChallengeError:new(ErrorKind.Invalidated, p16))

								return
							end

							local t2 = {
								challengeType = GenericType.fromRawValue(p6.Headers["rblx-challenge-type"])
							}

							reject(ChallengeError:new(ErrorKind.Invalidated, t2))
						end
					},
					onChallengeAbandoned = function() -- line: 240
						-- upvalues: reject (copy), ChallengeError (copy), ErrorKind (copy), GenericType (copy), p6 (copy)
						reject(ChallengeError:new(ErrorKind.Abandoned, {
							challengeType = GenericType.fromRawValue(p6.Headers["rblx-challenge-type"])
						}))
					end,
					onChallengeLoadFailed = function() -- line: 248
						-- upvalues: Logging (copy), reject (copy), ChallengeError (copy), ErrorKind (copy), GenericType (copy), p6 (copy)
						Logging.warn("Load generic challenge failed.")
						reject(ChallengeError:new(ErrorKind.LoadFailed, {
							challengeType = GenericType.fromRawValue(p6.Headers["rblx-challenge-type"])
						}))
					end,
					forceWebViewVisible = not GetFFlagLuaAppChallengeDisableForceWebViewVisible() or shouldForceWebViewVisibleForChallengeType(p6.Headers["rblx-challenge-type"])
				}, false))
			end)
		end

		return Promise.reject(p6)
	end
end

return renderChallengeWithHeaders
