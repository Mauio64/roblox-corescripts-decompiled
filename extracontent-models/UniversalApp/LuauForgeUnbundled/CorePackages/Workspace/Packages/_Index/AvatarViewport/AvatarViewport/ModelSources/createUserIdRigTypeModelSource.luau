local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")
local finishModelSetup = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ModelSources/finishModelSetup")

local function createUserIdRigTypeModelSource(p2, p3)
	return function(p4)
		local v5 = tonumber(p2)

		if not v5 then
			return nil
		end

		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromDescriptionAsync(
				Players:GetHumanoidDescriptionFromUserIdAsync(v5),
				p3
			)
		end)

		if p4.isCancelled() then
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

return createUserIdRigTypeModelSource
