local Players = game:GetService("Players")

require(script.Parent.Parent.Types)
local finishModelSetup = require(script.Parent.finishModelSetup)

local function createUserIdModelSource(p)
	return function(p2)
		local v = tonumber(p)

		if not v then
			return nil
		end

		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromUserIdAsync(v)
		end)

		if p2.isCancelled() then
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
