local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FIntRedeemBonusTokenTimeoutMs = require(InExperienceShop.Flags.FIntRedeemBonusTokenTimeoutMs)

local v = Url.APIS_URL .. "payments-bonus-service/v1/redeem-bonus-token"

local function httpStatusCodeFromError(result) -- 1 equivalent call inferred from this helper
	return (tonumber(string.match(tostring(result), "HTTP (%d%d%d)")))
end

local function redeemBonusToken(bonusJwt: string, universeId: number)
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			local flag = false
			local function settleResolve(paymentSessionId: string) -- 1 equivalent call inferred from this helper
				if flag then
					return
				end

				flag = true
				callback(paymentSessionId)
			end
			local function settleReject(p) -- 5 equivalent calls inferred from this helper
				if flag then
					return
				end

				flag = true
				callback2(p)
			end

			if FIntRedeemBonusTokenTimeoutMs > 0 then
				task.delay(FIntRedeemBonusTokenTimeoutMs / 1000, function()
					if flag then
						return
					end

					ShopDebugLogger.logLazy(function()
						return "redeemBonusToken: timed out after " .. FIntRedeemBonusTokenTimeoutMs .. "ms"
					end)

					settleReject(Errors.networkError("redeemBonusToken: timed out", FIntRedeemBonusTokenTimeoutMs)) -- inferred equivalent call
				end)
			end

			local v2 = { bonusJwt = bonusJwt, universeId = universeId }

			ShopDebugLogger.logLazy(function()
				return "redeemBonusToken: POST universeId=" .. universeId
			end)

			local v3 = ShopDebugLogger.startTimer()

			local success, result = pcall(function()
				return HttpRbxApiService:PostAsyncFullUrl(v, HttpService:JSONEncode(v2))
			end)

			if success then
				ShopDebugLogger.logElapsed("redeemBonusToken: HTTP response received", v3)

				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					local paymentSessionId

					if typeof(result2) == "table" then
						paymentSessionId = result2.paymentSessionId
					end

					if typeof(paymentSessionId) == "string" and paymentSessionId ~= "" then
						ShopDebugLogger.log("redeemBonusToken: success")
						settleResolve(paymentSessionId) -- inferred equivalent call
					else
						ShopDebugLogger.log("redeemBonusToken: schema error, missing paymentSessionId")

						settleReject(Errors.schemaError( -- inferred equivalent call
							"redeemBonusToken: malformed response, expected { paymentSessionId = string }",
							result2
						))
					end
				else
					ShopDebugLogger.logLazy(function()
						return "redeemBonusToken: JSON parse error=" .. tostring(result2)
					end)

					settleReject(Errors.parseError("redeemBonusToken: response body is not valid JSON", result2)) -- inferred equivalent call
				end
			else
				ShopDebugLogger.logElapsed("redeemBonusToken: HTTP error", v3)
				ShopDebugLogger.logLazy(function()
					return "redeemBonusToken: HTTP error detail=" .. tostring(result)
				end)

				if httpStatusCodeFromError(result) == 400 then -- inferred equivalent call
					settleReject(Errors.badRequestError("redeemBonusToken: HTTP 400", result)) -- inferred equivalent call
				else
					settleReject(Errors.networkError("redeemBonusToken: HTTP request failed", result)) -- inferred equivalent call
				end
			end
		end)
	end)
end

return redeemBonusToken
