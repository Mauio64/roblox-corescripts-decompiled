local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local buildUIVisibility = require(BuildExperience.utils.buildUIVisibility)

local function trackBuildOpenSafetyService(flag: boolean)
	React.useEffect(function()
		if not flag then
			return nil
		end

		buildUIVisibility.acquire()
		return function()
			buildUIVisibility.release()
		end
	end, { flag })
end

return trackBuildOpenSafetyService
