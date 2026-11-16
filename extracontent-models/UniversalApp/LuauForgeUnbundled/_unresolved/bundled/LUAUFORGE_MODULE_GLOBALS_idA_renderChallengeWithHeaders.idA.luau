local HttpService = game:GetService("HttpService")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/hDp")
local module2 = require("@luauforge/bundled/icP")
local module3 = require("@luauforge/bundled/geC")
local module4 = require("@luauforge/bundled/hzI")
local module5 = require("@luauforge/bundled/icQ")
local module6 = require("@luauforge/bundled/idB")

local module7 = require("@luauforge/bundled/idC")

local module8 = require("@luauforge/bundled/idD")

local module9 = require("@luauforge/bundled/idE")
local module10 = require("@luauforge/bundled/ecV")
local module11 = require("@luauforge/bundled/hDP")
local module12 = require("@luauforge/bundled/idF")
local module13 = require("@luauforge/bundled/hzX")

local module14 = require("@luauforge/bundled/idG")

local module15 = require("@luauforge/bundled/idH")

function LUAUFORGE_MODULE_GLOBALS_idA_shouldForceWebViewVisibleForChallengeType(p2)
	local v5 = module4.fromRawValue(p2)

	return v5 ~= nil
		and v5 ~= module4.Captcha
		and v5 ~= module4.ProofOfWork
		and v5 ~= module4.DeviceIntegrity
		and v5 ~= module4.PrivateAccessToken
		and v5 ~= module4.Biometric
		and (not not module8() or v5 ~= module4.CaptchaV2)
		and (module9() or v5 ~= module4.Turnstile)
end

function LUAUFORGE_MODULE_GLOBALS_idA_shouldRenderNativeChallenge(json): boolean
	local jsonDecode = HttpService:JSONDecode(json)

	return jsonDecode ~= nil
		and jsonDecode.sharedParameters ~= nil
		and jsonDecode.sharedParameters.renderNativeChallenge == true
end

function LUAUFORGE_MODULE_GLOBALS_idA_renderChallengeWithHeaders(callback, p2, p3, p4, p5)
	return function(object)
		if p5 == nil then
			return module10.resolve()
		end

		if
			type(p5.Headers) ~= "table"
			or not (p5.Headers["rblx-challenge-type"] and p5.Headers["rblx-challenge-metadata"] and p5.Headers["rblx-challenge-id"])
		then
			return module10.reject(p5)
		end

		local v5 = module4.fromRawValue(p5.Headers["rblx-challenge-type"])
		local decoded = module.Decode(p5.Headers["rblx-challenge-metadata"])

		local jsonDecode = HttpService:JSONDecode(decoded)

		if
			v5 == module4.Denied
			and jsonDecode
			and jsonDecode.reason == module6.toRawValue(module6.RateLimited)
			and jsonDecode.rateLimited
			and jsonDecode.rateLimited.retryTime
		then
			return module10.reject(module2:new(module5.RateLimited, jsonDecode.rateLimited))
		end

		if LUAUFORGE_MODULE_GLOBALS_idA_shouldRenderNativeChallenge(decoded) then
			logging.warn("Rendering native challenge.")
			return module10.new(function(callback2, callback3)
				object:dispatch(module12({
					challengeId = p5.Headers["rblx-challenge-id"],
					challengeType = v5,
					challengeMetadata = decoded,
					onSessionCompleted = function()
						p4 = type(p4) ~= "table" and {} or p4
						p4.headers = type(p4.headers) ~= "table" and {} or p4.headers
						p4.headers["rblx-challenge-id"] = p5.Headers["rblx-challenge-id"]
						p4.headers["rblx-challenge-type"] = p5.Headers["rblx-challenge-type"]
						p4.headers["rblx-challenge-metadata"] = p5.Headers["rblx-challenge-metadata"]

						if module15() then
							callback2(callback(p2, p3, p4))
							return
						end

						local v6, v7 = callback(p2, p3, p4):andThen(nil, function(p6)
							callback3(module2:new(module5.Invalidated, {
								challengeType = v5
							}))
						end)
						callback2(v6)
					end,
					onSessionFailed = function()
						callback3(module2:new(module5.Invalidated, {
							challengeType = v5
						}))
					end,
					onSessionAbandoned = function()
						callback3(module2:new(module5.Abandoned, { challengeType = v5 }))
					end,
					onWebViewChallengeIssued = module13() and function(rblxchallengetype, p6)
						logging.warn("Rendering generic web challenge.")
						object:dispatch(module11({
							challengeType = module3.Generic,
							challengeParameters = {
								genericChallengeId = p5.Headers["rblx-challenge-id"],
								genericChallengeType = rblxchallengetype,
								genericChallengeMetadata = module.EncodeUrl(p6),
								onChallengeCompleted = function(p7)
									p4 = type(p4) ~= "table" and {} or p4
									p4.headers = type(p4.headers) ~= "table" and {} or p4.headers
									p4.headers["rblx-challenge-id"] = p5.Headers["rblx-challenge-id"]
									p4.headers["rblx-challenge-type"] = rblxchallengetype
									p4.headers["rblx-challenge-metadata"] = module.Encode(HttpService:JSONEncode(p6))

									if module15() then
										callback2(callback(p2, p3, p4))
										return
									end

									local v6, v7 = callback(p2, p3, p4):andThen(nil, function(p8)
										callback3(module2:new(module5.Invalidated, {
											challengeType = v5
										}))
									end)

									callback2(v6)
								end,
								onChallengeInvalidated = function(p7)
									if p7 and p7.challengeType then
										p7.challengeType = module4.fromRawValue((tostring(p7.challengeType)))
										callback3(module2:new(module5.Invalidated, p7))
									else
										local v6 = {}
										v6.challengeType = module4.fromRawValue(rblxchallengetype)
										callback3(module2:new(module5.Invalidated, v6))
									end
								end
							},
							onChallengeAbandoned = function()
								callback3(module2:new(module5.Abandoned, {
									challengeType = module4.fromRawValue(rblxchallengetype)
								}))
							end,
							onChallengeLoadFailed = function()
								logging.warn("Load generic challenge failed.")
								callback3(module2:new(module5.LoadFailed, {
									challengeType = module4.fromRawValue(rblxchallengetype)
								}))
							end,
							forceWebViewVisible = not module7() or LUAUFORGE_MODULE_GLOBALS_idA_shouldForceWebViewVisibleForChallengeType(rblxchallengetype)
						}, false, module14()))
					end or nil
				}))
			end)
		end

		logging.warn("Rendering generic challenge.")
		return module10.new(function(callback2, callback3)
			object:dispatch(module11({
				challengeType = module3.Generic,
				challengeParameters = {
					genericChallengeId = p5.Headers["rblx-challenge-id"],
					genericChallengeType = p5.Headers["rblx-challenge-type"],
					genericChallengeMetadata = module.EncodeUrl(decoded),
					onChallengeCompleted = function(p6)
						p4 = type(p4) ~= "table" and {} or p4
						p4.headers = type(p4.headers) ~= "table" and {} or p4.headers
						p4.headers["rblx-challenge-id"] = p5.Headers["rblx-challenge-id"]
						p4.headers["rblx-challenge-type"] = p5.Headers["rblx-challenge-type"]
						p4.headers["rblx-challenge-metadata"] = module.Encode(HttpService:JSONEncode(p6.metadata))

						local v6, v7 = callback(p2, p3, p4)
						callback2((v6:andThen(nil, function(p7)
							return object:dispatch(LUAUFORGE_MODULE_GLOBALS_idA_renderChallengeWithHeaders(
								callback,
								p2,
								p3,
								p4,
								p7
							))
						end)))
					end,
					onChallengeInvalidated = function(p6)
						if p6 and p6.challengeType then
							p6.challengeType = module4.fromRawValue((tostring(p6.challengeType)))
							callback3(module2:new(module5.Invalidated, p6))
						else
							local v6 = {}
							v6.challengeType = module4.fromRawValue(p5.Headers["rblx-challenge-type"])
							callback3(module2:new(module5.Invalidated, v6))
						end
					end
				},
				onChallengeAbandoned = function()
					callback3(module2:new(module5.Abandoned, {
						challengeType = module4.fromRawValue(p5.Headers["rblx-challenge-type"])
					}))
				end,
				onChallengeLoadFailed = function()
					logging.warn("Load generic challenge failed.")
					callback3(module2:new(module5.LoadFailed, {
						challengeType = module4.fromRawValue(p5.Headers["rblx-challenge-type"])
					}))
				end,
				forceWebViewVisible = not module7() or LUAUFORGE_MODULE_GLOBALS_idA_shouldForceWebViewVisibleForChallengeType(p5.Headers["rblx-challenge-type"])
			}, false))
		end)
	end
end

return LUAUFORGE_MODULE_GLOBALS_idA_renderChallengeWithHeaders
