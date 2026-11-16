local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local buildUIVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/buildUIVisibility")

local function trackBuildOpenSafetyService(p2)
	React.useEffect(function()
		if not p2 then
			return nil
		end

		buildUIVisibility.acquire()
		return function()
			buildUIVisibility.release()
		end
	end, { p2 })
end

return trackBuildOpenSafetyService
