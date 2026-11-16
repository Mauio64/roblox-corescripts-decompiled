local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Promise = require(CorePackages.Packages.Promise)

return function()
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return Players:GetHumanoidDescriptionFromUserIdAsync(Players.LocalPlayer.UserId)
		end)

		if success then
			callback(result)
		else
			callback2()
		end
	end)
end
