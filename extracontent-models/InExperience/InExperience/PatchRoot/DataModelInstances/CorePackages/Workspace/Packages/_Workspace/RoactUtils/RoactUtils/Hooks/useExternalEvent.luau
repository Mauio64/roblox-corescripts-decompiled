local parent = script:FindFirstAncestor("RoactUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagMigrateRoactUtilsToReactUtils = SharedFlags.GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.useEventConnection
end

local React = require(parent.React)

local function useExternalEvent(object, callback)
	React.useEffect(function()
		if object == nil then
			return nil
		end

		local connection = object:Connect(callback)
		return function()
			connection:Disconnect()
		end
	end, { object, callback })
end

return useExternalEvent
