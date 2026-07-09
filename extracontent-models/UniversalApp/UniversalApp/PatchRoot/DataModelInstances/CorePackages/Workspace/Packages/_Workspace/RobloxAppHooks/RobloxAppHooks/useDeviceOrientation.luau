local RobloxAppHooks = script:FindFirstAncestor("RobloxAppHooks")
local RobloxAppHooksParent = RobloxAppHooks.Parent
local useCurrentCamera = require(RobloxAppHooks.useCurrentCamera)
local useProperty = require(RobloxAppHooksParent.GuiObjectUtils).useProperty
local DeviceOrientationMode = require(RobloxAppHooksParent.RobloxAppEnums).DeviceOrientationMode

local function useDeviceOrientation() -- line: 10
	-- upvalues: useCurrentCamera (copy), useProperty (copy), DeviceOrientationMode (copy)
	local v7 = useCurrentCamera()
	local v8 = useProperty(v7, "ViewportSize")

	if v8.X > 1 and v8.Y > 1 then
		return v8.X > v8.Y and DeviceOrientationMode.Landscape or DeviceOrientationMode.Portrait
	end

	return nil
end

return useDeviceOrientation
