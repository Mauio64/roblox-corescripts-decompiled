local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("InExperienceShop").Parent

local Promise = require(parent.Promise)

local function userOwnsGamePass(p: number)
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			local localPlayer = Players.LocalPlayer

			if localPlayer == nil then
				callback2("userOwnsGamePass: no LocalPlayer")
				return
			end

			local success, result = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(localPlayer.UserId, p)
			end)

			if success then
				callback(result == true)
			else
				callback2((tostring(result)))
			end
		end)
	end)
end

return userOwnsGamePass
