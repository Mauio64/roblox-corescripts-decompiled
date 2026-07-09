local MarketplaceService = game:GetService("MarketplaceService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function getProductInfo(n1: number, p1) -- line: 20
	-- upvalues: Promise (copy), ShopDebugLogger (copy), MarketplaceService (copy), Errors (copy)
	return Promise.new(function(resolve, reject) -- line: 21
		-- upvalues: ShopDebugLogger (copy), n1 (copy), p1 (copy), MarketplaceService (copy), Errors (copy)
		task.spawn(function() -- line: 22
			-- upvalues: ShopDebugLogger (copy), n1 (copy), p1 (copy), MarketplaceService (copy), resolve (copy), reject (copy), Errors (copy)
			ShopDebugLogger.logLazy(function() -- line: 23
				-- upvalues: n1 (copy), p1 (copy)
				return "getProductInfo: call id=" .. n1 .. " infoType=" .. tostring(p1)
			end)

			local v12 = ShopDebugLogger.startTimer()
			local ok, result = pcall(function() -- line: 27
				-- upvalues: MarketplaceService (copy), n1 (copy), p1 (copy)
				return MarketplaceService:GetProductInfoAsync(n1, p1)
			end)

			if ok then
				ShopDebugLogger.logElapsedLazy(function() -- line: 31
					-- upvalues: n1 (copy)
					return "getProductInfo: success id=" .. n1
				end, v12)
				resolve(result)

				return
			end

			ShopDebugLogger.logElapsedLazy(function() -- line: 36
				-- upvalues: n1 (copy)
				return "getProductInfo: error id=" .. n1
			end, v12)
			ShopDebugLogger.logLazy(function() -- line: 39
				-- upvalues: result (copy)
				return "getProductInfo: error detail=" .. tostring(result)
			end)
			reject(Errors.engineError("getProductInfo: GetProductInfoAsync raised", result))
		end)
	end)
end

return getProductInfo
