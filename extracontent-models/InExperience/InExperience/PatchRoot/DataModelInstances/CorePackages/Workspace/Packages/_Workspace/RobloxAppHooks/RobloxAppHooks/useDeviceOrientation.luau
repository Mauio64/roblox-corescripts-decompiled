local RobloxAppHooks = script:FindFirstAncestor("RobloxAppHooks")
local parent = RobloxAppHooks.Parent
local useCurrentCamera = require(RobloxAppHooks.useCurrentCamera)
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local function useDeviceOrientation()
	local v = useProperty(useCurrentCamera(), "ViewportSize")

	if v and v.X > 1 and v.Y > 1 then
		return v.X > v.Y and DeviceOrientationMode.Landscape or DeviceOrientationMode.Portrait
	end

	return nil
end

return useDeviceOrientation
