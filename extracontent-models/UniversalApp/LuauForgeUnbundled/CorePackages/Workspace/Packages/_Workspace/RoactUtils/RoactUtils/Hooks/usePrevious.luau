local getFFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/ReactUtils")

if getFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.usePrevious
end

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local function usePrevious(current)
	local ref = React.useRef(nil)
	React.useEffect(function()
		ref.current = current
	end)
	return ref.current
end

return usePrevious
