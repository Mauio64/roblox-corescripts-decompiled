local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Promise = require(CorePackages.Packages.Promise)

return function() -- line: 6
	-- upvalues: Promise (copy), Players (copy)
	return Promise.new(function(resolve, reject) -- line: 7
		-- upvalues: Players (copy)
		local ok, result = pcall(function() -- line: 8
			-- upvalues: Players (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return Players:GetHumanoidDescriptionFromUserIdAsync(Players.LocalPlayer.UserId)
			end

			return Players:GetHumanoidDescriptionFromUserId(Players.LocalPlayer.UserId)
		end)

		if ok then
			resolve(result)

			return
		end

		reject()
	end)
end
