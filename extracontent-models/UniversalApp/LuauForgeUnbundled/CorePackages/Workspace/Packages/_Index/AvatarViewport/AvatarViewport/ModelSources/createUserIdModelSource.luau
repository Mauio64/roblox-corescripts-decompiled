local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")
local finishModelSetup = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ModelSources/finishModelSetup")

local function createUserIdModelSource(p2)
	return function(p3)
		local v5 = tonumber(p2)

		if not v5 then
			return nil
		end

		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromUserIdAsync(v5)
		end)

		if p3.isCancelled() then
			if success and result then
				result:Destroy()
			end

			return nil
		elseif success and result then
			return finishModelSetup(result)
		else
			return nil
		end
	end
end

return createUserIdModelSource
