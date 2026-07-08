local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local getProductInfo = require(script.Parent.getProductInfo)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)

local function multiGetProductInfo(t1: {[any]: any}) -- line: 39
	-- upvalues: ShopDebugLogger (copy), getProductInfo (copy), Promise (copy)
	ShopDebugLogger.logLazy(function() -- line: 42
		-- upvalues: t1 (copy)
		return "multiGetProductInfo: start batchSize=" .. #t1
	end)

	local v8 = ShopDebugLogger.startTimer()
	local t2 = table.create(#t1)

	for i, v in ipairs(t1) do
		t2[i] = getProductInfo(v.id, v.infoType):andThen(function(p1) -- line: 49
			-- upvalues: v (copy)
			return {
				ok = true,
				request = v,
				value = p1
			}
		end):catch(function(p2) -- line: 52
			-- upvalues: v (copy)
			return {
				ok = false,
				request = v,
				err = p2
			}
		end)
	end

	return ShopDebugLogger.tracePromise(Promise.all(t2), {
		onSuccess = function(t3: {[any]: any}) -- line: 57
			-- upvalues: ShopDebugLogger (copy), v8 (copy)
			local n1 = 0
			local n2 = 0

			for _, v in ipairs(t3) do
				if v.ok then
					n1 += 1
				else
					n2 += 1
				end
			end

			ShopDebugLogger.logElapsedLazy(function() -- line: 66
				-- upvalues: n1 (ref), n2 (ref)
				return "multiGetProductInfo: done succeeded=" .. n1 .. " failed=" .. n2
			end, v8)
		end
	})
end

return multiGetProductInfo
