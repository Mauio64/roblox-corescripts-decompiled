local MarketplaceService = game:GetService("MarketplaceService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
require(InExperienceShop.Types)

return {
	getPassOwnership = function(p, p2: number)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local success, result = pcall(function()
					return MarketplaceService:GetPassOwnershipAsync(p, p2)
				end)

				if success then
					callback(typeof(result) == "table" and {
						Owned = result.Owned == true,
						Active = result.Active == true,
						StartTime = result.StartTime,
						EndTime = result.EndTime
					} or nil)
				else
					callback2((tostring(result)))
				end
			end)
		end)
	end
}
