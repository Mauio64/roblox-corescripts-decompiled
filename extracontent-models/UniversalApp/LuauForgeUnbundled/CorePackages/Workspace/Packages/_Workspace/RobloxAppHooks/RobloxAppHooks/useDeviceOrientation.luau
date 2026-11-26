local useCurrentCamera = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppHooks/useCurrentCamera")
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/GuiObjectUtils").useProperty
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppEnums").DeviceOrientationMode

local function useDeviceOrientation()
	local v6 = useProperty(useCurrentCamera(), "ViewportSize")

	if v6 and v6.X > 1 and v6.Y > 1 then
		return v6.X > v6.Y and deviceOrientationMode.Landscape or deviceOrientationMode.Portrait
	end

	return nil
end

return useDeviceOrientation
