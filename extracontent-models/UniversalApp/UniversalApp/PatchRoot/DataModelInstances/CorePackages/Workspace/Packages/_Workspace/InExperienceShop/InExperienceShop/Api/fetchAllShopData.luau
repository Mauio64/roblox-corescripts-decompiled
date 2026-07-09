local HttpService = game:GetService("HttpService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent

require(InExperienceShopParent.Promise)
require(InExperienceShop.Types)

local fetchShopItemIds = require(script.Parent.fetchShopItemIds)
local multiGetProductInfo = require(script.Parent.multiGetProductInfo)
local buildShopDataFromWidgets = require(script.Parent.buildShopDataFromWidgets)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function fetchAllShopData() -- line: 28
	-- upvalues: HttpService (copy), ShopDebugLogger (copy), fetchShopItemIds (copy), buildShopDataFromWidgets (copy), multiGetProductInfo (copy)
	local guid = HttpService:GenerateGUID(false)
	local v10 = ShopDebugLogger.startTimer()

	ShopDebugLogger.logLazy(function() -- line: 36
		-- upvalues: guid (copy)
		return "fetchAllShopData: start requestId=" .. guid
	end)

	local v11 = fetchShopItemIds(guid):andThen(function(p1) -- line: 39
		-- upvalues: buildShopDataFromWidgets (copy), multiGetProductInfo (copy)
		return buildShopDataFromWidgets(p1, multiGetProductInfo)
	end)

	return ShopDebugLogger.tracePromise(v11, {
		onSuccess = function(p2) -- line: 43
			-- upvalues: ShopDebugLogger (copy), guid (copy), v10 (copy)
			ShopDebugLogger.logElapsedLazy(function() -- line: 44
				-- upvalues: guid (copy)
				return "fetchAllShopData: success requestId=" .. guid
			end, v10)
			ShopDebugLogger.logLazy(function() -- line: 47
				-- upvalues: p2 (copy)
				return "fetchAllShopData: result categories=" .. #p2.categories .. " sections=" .. #p2.sections .. " failedItems=" .. #(p2.failedItems or {})
			end)
		end,
		onError = function(p3) -- line: 56
			-- upvalues: ShopDebugLogger (copy), guid (copy), v10 (copy)
			ShopDebugLogger.logElapsedLazy(function() -- line: 57
				-- upvalues: guid (copy)
				return "fetchAllShopData: error requestId=" .. guid
			end, v10)
			ShopDebugLogger.logLazy(function() -- line: 60
				-- upvalues: p3 (copy)
				return "fetchAllShopData: error kind=" .. tostring(p3 and p3.kind) .. " msg=" .. tostring(p3 and p3.message)
			end)
		end
	})
end

return fetchAllShopData
