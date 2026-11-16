local Players = game:GetService("Players")

require(script.Parent.Parent.Types)
local finishModelSetup = require(script.Parent.finishModelSetup)

local function createUserIdRigTypeModelSource(p, p2)
	return function(p3)
		local v = tonumber(p)

		if not v then
			return nil
		end

		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromDescriptionAsync(Players:GetHumanoidDescriptionFromUserIdAsync(v), p2)
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

return createUserIdRigTypeModelSource
