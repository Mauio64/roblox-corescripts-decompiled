local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local ExperienceService = require(Parent.ExperienceService).ExperienceService
local React = require(Parent.React)

local function useIsUserInExperience(b1: boolean?) -- line: 10
	-- upvalues: React (copy), ExperienceService (copy)
	local v6, v7 = React.useState(b1 or false)

	React.useEffect(function() -- line: 12
		-- upvalues: ExperienceService (copy), v7 (copy)
		local t1 = {
			ExperienceService:RegisterForExperienceJoin(function() -- line: 14
				-- upvalues: v7 (copy)
				v7(true)
			end),
			ExperienceService:RegisterForExperienceLeave(function() -- line: 17
				-- upvalues: v7 (copy)
				v7(false)
			end)
		}

		return function() -- line: 22
			-- upvalues: t1 (copy)
			for _, v10 in t1 do
				if v10 and v10.Disconnect then
					v10:Disconnect()
				end
			end
		end
	end, {})

	return v6
end

return useIsUserInExperience
