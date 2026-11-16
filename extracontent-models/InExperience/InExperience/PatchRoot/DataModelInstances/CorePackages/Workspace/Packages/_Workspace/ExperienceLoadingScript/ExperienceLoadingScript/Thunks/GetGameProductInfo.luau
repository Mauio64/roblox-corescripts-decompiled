local MarketplaceService = game:GetService("MarketplaceService")

local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local SetGameProductInfo = require(ExperienceLoadingScript.Actions.SetGameProductInfo)

return function(p)
	return function(object)
		coroutine.wrap(function()
			local v = p

			if not v or v <= 0 then
				while game.PlaceId <= 0 do
					wait()
				end

				v = game.PlaceId
			end

			local success, result = pcall(function()
				object:dispatch(SetGameProductInfo((MarketplaceService:GetProductInfoAsync(v))))
			end)

			if not success then
				print("LoadingScreen:GetGameProductInfo: %s", result)
			end
		end)()
	end
end
