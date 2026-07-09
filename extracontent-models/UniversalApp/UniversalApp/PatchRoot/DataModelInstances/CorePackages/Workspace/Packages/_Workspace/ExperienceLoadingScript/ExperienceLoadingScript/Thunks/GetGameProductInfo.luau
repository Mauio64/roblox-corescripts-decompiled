local MarketplaceService = game:GetService("MarketplaceService")
local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local SetGameProductInfo = require(ExperienceLoadingScript.Actions.SetGameProductInfo)

return function(p1) -- line: 6
	-- upvalues: MarketplaceService (copy), SetGameProductInfo (copy)
	return function(p2) -- line: 7
		-- upvalues: p1 (copy), MarketplaceService (copy), SetGameProductInfo (copy)
		coroutine.wrap(function() -- line: 8
			-- upvalues: p1 (copy), MarketplaceService (copy), p2 (copy), SetGameProductInfo (copy)
			local u6 = p1

			if not u6 or u6 <= 0 then
				while game.PlaceId <= 0 do
					wait()
				end

				u6 = game.PlaceId
			end

			local ok, result = pcall(function() -- line: 16
				-- upvalues: MarketplaceService (copy), u6 (ref), p2 (copy), SetGameProductInfo (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					local ProductInfoAsync = MarketplaceService:GetProductInfoAsync(u6)

					p2:dispatch(SetGameProductInfo(ProductInfoAsync))

					return
				end

				local ProductInfo = MarketplaceService:GetProductInfo(u6)

				p2:dispatch(SetGameProductInfo(ProductInfo))
			end)

			if not ok then
				print("LoadingScreen:GetGameProductInfo: %s", result)
			end
		end)()
	end
end
