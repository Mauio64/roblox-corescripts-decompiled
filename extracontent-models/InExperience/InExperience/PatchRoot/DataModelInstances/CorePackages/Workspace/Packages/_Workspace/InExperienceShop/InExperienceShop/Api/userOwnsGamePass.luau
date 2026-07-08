local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local Promise = require(Parent.Promise)

local function userOwnsGamePass(n1: number) -- line: 21
	-- upvalues: Promise (copy), Players (copy), MarketplaceService (copy)
	return Promise.new(function(resolve, reject) -- line: 22
		-- upvalues: Players (copy), MarketplaceService (copy), n1 (copy)
		task.spawn(function() -- line: 23
			-- upvalues: Players (copy), reject (copy), MarketplaceService (copy), n1 (copy), resolve (copy)
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer == nil then
				reject("userOwnsGamePass: no LocalPlayer")

				return
			end

			local ok, result = pcall(function() -- line: 29
				-- upvalues: MarketplaceService (copy), LocalPlayer (copy), n1 (copy)
				return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, n1)
			end)

			if ok then
				resolve(result == true)

				return
			end

			reject((tostring(result)))
		end)
	end)
end

return userOwnsGamePass
