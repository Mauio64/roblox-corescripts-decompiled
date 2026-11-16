local getFFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/ReactUtils")

if getFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.useEventConnection
end

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local function useExternalEvent(object, p2)
	React.useEffect(function()
		if object == nil then
			return nil
		end

		local connection = object:Connect(p2)
		return function()
			connection:Disconnect()
		end
	end, { object, p2 })
end

return useExternalEvent
