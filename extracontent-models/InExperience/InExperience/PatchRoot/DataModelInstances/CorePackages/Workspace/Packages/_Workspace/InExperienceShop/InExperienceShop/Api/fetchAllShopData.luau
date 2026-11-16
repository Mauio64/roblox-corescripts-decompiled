local HttpService = game:GetService("HttpService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

require(parent.Promise)
require(InExperienceShop.Types)
local fetchShopItemIds = require(script.Parent.fetchShopItemIds)
local multiGetProductInfo = require(script.Parent.multiGetProductInfo)
local buildShopDataFromWidgets = require(script.Parent.buildShopDataFromWidgets)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function fetchAllShopData()
	local guid = HttpService:GenerateGUID(false)
	local v = ShopDebugLogger.startTimer()
	ShopDebugLogger.logLazy(function()
		return "fetchAllShopData: start requestId=" .. guid
	end)

	local v2 = fetchShopItemIds(guid):andThen(function(p)
		return buildShopDataFromWidgets(p, multiGetProductInfo)
	end)

	return ShopDebugLogger.tracePromise(v2, {
		onSuccess = function(data)
			ShopDebugLogger.logElapsedLazy(function()
				return "fetchAllShopData: success requestId=" .. guid
			end, v)

			ShopDebugLogger.logLazy(function()
				return "fetchAllShopData: result categories=" .. #data.categories .. " sections=" .. #data.sections .. " failedItems=" .. #(data.failedItems or {})
			end)
		end,
		onError = function(p)
			ShopDebugLogger.logElapsedLazy(function()
				return "fetchAllShopData: error requestId=" .. guid
			end, v)

			ShopDebugLogger.logLazy(function()
				return "fetchAllShopData: error kind=" .. tostring(p and p.kind) .. " msg=" .. tostring(p and p.message)
			end)
		end
	})
end

return fetchAllShopData
