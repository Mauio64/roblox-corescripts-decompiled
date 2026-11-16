local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local getProductInfo = require(script.Parent.getProductInfo)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function multiGetProductInfo(list)
	ShopDebugLogger.logLazy(function()
		return "multiGetProductInfo: start batchSize=" .. #list
	end)

	local v = ShopDebugLogger.startTimer()
	local v2 = table.create(#list)

	for i, item in ipairs(list) do
		v2[i] = getProductInfo(item.id, item.infoType):andThen(function(p)
			return { request = item, ok = true, value = p }
		end):catch(function(err)
			return { request = item, ok = false, err = err }
		end)
	end

	return ShopDebugLogger.tracePromise(Promise.all(v2), {
		onSuccess = function(list2)
			local count = 0
			local count2 = 0

			for _, item in ipairs(list2) do
				if item.ok then
					count += 1
				else
					count2 += 1
				end
			end

			ShopDebugLogger.logElapsedLazy(function()
				return "multiGetProductInfo: done succeeded=" .. count .. " failed=" .. count2
			end, v)
		end
	})
end

return multiGetProductInfo
