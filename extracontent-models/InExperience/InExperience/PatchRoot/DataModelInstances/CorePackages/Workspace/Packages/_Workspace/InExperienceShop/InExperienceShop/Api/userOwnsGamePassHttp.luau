local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local Url = require(InExperienceShopParent.Http).Url
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local v10 = Url.APIS_URL .. "game-passes/v1/game-passes:batchGetOwnership"

local function userOwnsGamePassHttp(n1: number) -- line: 24
	-- upvalues: Promise (copy), Players (copy), Errors (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), v10 (copy), HttpService (copy)
	return Promise.new(function(resolve, reject) -- line: 25
		-- upvalues: Players (copy), Errors (copy), n1 (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), v10 (copy), HttpService (copy)
		task.spawn(function() -- line: 26
			-- upvalues: Players (copy), reject (copy), Errors (copy), n1 (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), v10 (copy), HttpService (copy), resolve (copy)
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer == nil then
				reject((Errors.engineError("userOwnsGamePassHttp: no LocalPlayer")))

				return
			end

			local UserId = LocalPlayer.UserId
			local t1 = {
				ownershipIdentifiers = {{
					userId = UserId,
					gamePassId = n1
				}}
			}

			ShopDebugLogger.logLazy(function() -- line: 43
				-- upvalues: n1 (copy), UserId (copy)
				return "userOwnsGamePassHttp: POST gamePassId=" .. n1 .. " userId=" .. UserId
			end)

			local v18 = ShopDebugLogger.startTimer()
			local ok, result = pcall(function() -- line: 48
				-- upvalues: HttpRbxApiService (copy), v10 (copy), HttpService (copy), t1 (copy)
				return HttpRbxApiService:PostAsyncFullUrl(v10, HttpService:JSONEncode(t1))
			end)

			if not ok then
				ShopDebugLogger.logElapsed("userOwnsGamePassHttp: HTTP error", v18)
				ShopDebugLogger.logLazy(function() -- line: 53
					-- upvalues: result (copy)
					return "userOwnsGamePassHttp: HTTP error detail=" .. tostring(result)
				end)
				reject((Errors.networkError("userOwnsGamePassHttp: HTTP request failed", result)))

				return
			end

			ShopDebugLogger.logElapsed("userOwnsGamePassHttp: HTTP response received", v18)

			local ok2, result2 = pcall(function() -- line: 62
				-- upvalues: HttpService (copy), result (copy)
				return HttpService:JSONDecode(result)
			end)

			if not ok2 then
				ShopDebugLogger.logLazy(function() -- line: 66
					-- upvalues: result2 (copy)
					return "userOwnsGamePassHttp: JSON parse error=" .. tostring(result2)
				end)
				reject((Errors.parseError("userOwnsGamePassHttp: response body is not valid JSON", result2)))

				return
			end

			if typeof(result2) ~= "table" or typeof(result2.ownershipIdentifiers) ~= "table" then
				ShopDebugLogger.log("userOwnsGamePassHttp: schema error, missing ownershipIdentifiers")
				reject((Errors.schemaError("userOwnsGamePassHttp: malformed response, expected { ownershipIdentifiers = ... }", result2)))

				return
			end

			for _, v24 in result2.ownershipIdentifiers do
				if typeof(v24) == "table" and UserId == v24.userId and v24.gamePassId == n1 then
					ShopDebugLogger.logLazy(function() -- line: 92
						-- upvalues: n1 (copy)
						return "userOwnsGamePassHttp: owns=true gamePassId=" .. n1
					end)
					resolve(true)

					return
				end
			end

			ShopDebugLogger.logLazy(function() -- line: 100
				-- upvalues: n1 (copy)
				return "userOwnsGamePassHttp: owns=false gamePassId=" .. n1
			end)
			resolve(false)
		end)
	end)
end

return userOwnsGamePassHttp
