local MarketplaceService = game:GetService("MarketplaceService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function getProductInfo(p: number, p2)
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			ShopDebugLogger.logLazy(function()
				return "getProductInfo: call id=" .. p .. " infoType=" .. tostring(p2)
			end)

			local v = ShopDebugLogger.startTimer()
			local success, result = pcall(function()
				return MarketplaceService:GetProductInfoAsync(p, p2)
			end)

			if success then
				ShopDebugLogger.logElapsedLazy(function()
					return "getProductInfo: success id=" .. p
				end, v)

				callback(result)
			else
				ShopDebugLogger.logElapsedLazy(function()
					return "getProductInfo: error id=" .. p
				end, v)

				ShopDebugLogger.logLazy(function()
					return "getProductInfo: error detail=" .. tostring(result)
				end)

				callback2(Errors.engineError("getProductInfo: GetProductInfoAsync raised", result))
			end
		end)
	end)
end

return getProductInfo
