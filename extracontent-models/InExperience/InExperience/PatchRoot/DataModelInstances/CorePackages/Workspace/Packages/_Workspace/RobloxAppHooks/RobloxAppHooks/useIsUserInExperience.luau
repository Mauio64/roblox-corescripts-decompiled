local parent = script:FindFirstAncestor("RobloxAppHooks").Parent

local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local React = require(parent.React)

local function useIsUserInExperience(flag: boolean?)
	local state, setState = React.useState(flag or false)
	React.useEffect(function()
		local v = {
			experienceService:RegisterForExperienceJoin(function()
				setState(true)
			end),
			experienceService:RegisterForExperienceLeave(function()
				setState(false)
			end)
		}

		return function()
			for _, connection in v do
				if connection and connection.Disconnect then
					connection:Disconnect()
				end
			end
		end
	end, {})
	return state
end

return useIsUserInExperience
