local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local v = Url.APIS_URL .. "game-passes/v1/game-passes:batchGetOwnership"

local function userOwnsGamePassHttp(gamePassId: number)
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			local localPlayer = Players.LocalPlayer

			if localPlayer == nil then
				callback2((Errors.engineError("userOwnsGamePassHttp: no LocalPlayer")))
				return
			end

			local userId = localPlayer.UserId
			local v2 = {
				ownershipIdentifiers = {
					{ userId = userId, gamePassId = gamePassId }
				}
			}

			ShopDebugLogger.logLazy(function()
				return "userOwnsGamePassHttp: POST gamePassId=" .. gamePassId .. " userId=" .. userId
			end)

			local v3 = ShopDebugLogger.startTimer()

			local success, result = pcall(function()
				return HttpRbxApiService:PostAsyncFullUrl(v, HttpService:JSONEncode(v2))
			end)

			if success then
				ShopDebugLogger.logElapsed("userOwnsGamePassHttp: HTTP response received", v3)

				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					if typeof(result2) == "table" and typeof(result2.ownershipIdentifiers) == "table" then
						for _, ownershipIdentifier in result2.ownershipIdentifiers do
							if
								typeof(ownershipIdentifier) == "table"
								and ownershipIdentifier.userId == userId
								and ownershipIdentifier.gamePassId == gamePassId
							then
								ShopDebugLogger.logLazy(function()
									return "userOwnsGamePassHttp: owns=true gamePassId=" .. gamePassId
								end)

								callback(true)
								return
							end
						end

						ShopDebugLogger.logLazy(function()
							return "userOwnsGamePassHttp: owns=false gamePassId=" .. gamePassId
						end)

						callback(false)
					else
						ShopDebugLogger.log("userOwnsGamePassHttp: schema error, missing ownershipIdentifiers")
						callback2((Errors.schemaError(
							"userOwnsGamePassHttp: malformed response, expected { ownershipIdentifiers = ... }",
							result2
						)))
					end
				else
					ShopDebugLogger.logLazy(function()
						return "userOwnsGamePassHttp: JSON parse error=" .. tostring(result2)
					end)

					callback2((Errors.parseError("userOwnsGamePassHttp: response body is not valid JSON", result2)))
				end
			else
				ShopDebugLogger.logElapsed("userOwnsGamePassHttp: HTTP error", v3)
				ShopDebugLogger.logLazy(function()
					return "userOwnsGamePassHttp: HTTP error detail=" .. tostring(result)
				end)

				callback2((Errors.networkError("userOwnsGamePassHttp: HTTP request failed", result)))
			end
		end)
	end)
end

return userOwnsGamePassHttp
