local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/ExperienceService").ExperienceService
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/React")

local function useIsUserInExperience(p2)
	local state, setState = React.useState(p2 or false)
	React.useEffect(function()
		local v5 = {
			experienceService:RegisterForExperienceJoin(function()
				setState(true)
			end),
			experienceService:RegisterForExperienceLeave(function()
				setState(false)
			end)
		}

		return function()
			for k, connection in v5 do
				if connection and connection.Disconnect then
					connection:Disconnect()
				end
			end
		end
	end, {})
	return state
end

return useIsUserInExperience
