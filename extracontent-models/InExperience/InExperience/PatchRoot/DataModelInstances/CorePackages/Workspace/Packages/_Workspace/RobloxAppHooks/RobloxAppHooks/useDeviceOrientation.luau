local RobloxAppHooks = script:FindFirstAncestor("RobloxAppHooks")
local RobloxAppHooksParent = RobloxAppHooks.Parent
local useCurrentCamera = require(RobloxAppHooks.useCurrentCamera)
local useProperty = require(RobloxAppHooksParent.GuiObjectUtils).useProperty
local DeviceOrientationMode = require(RobloxAppHooksParent.RobloxAppEnums).DeviceOrientationMode
local v6 = game:DefineFastFlag("FixUseDeviceOrientationNilViewportSize", true)

local function useDeviceOrientation() -- line: 12
	-- upvalues: useCurrentCamera (copy), useProperty (copy), v6 (copy), DeviceOrientationMode (copy)
	local v8 = useCurrentCamera()
	local v9 = useProperty(v8, "ViewportSize")

	if v6 then
		if v9 and v9.X > 1 and v9.Y > 1 then
			return v9.X > v9.Y and DeviceOrientationMode.Landscape or DeviceOrientationMode.Portrait
		end
	elseif v9.X > 1 and v9.Y > 1 then
		return v9.X > v9.Y and DeviceOrientationMode.Landscape or DeviceOrientationMode.Portrait
	end

	return nil
end

return useDeviceOrientation
