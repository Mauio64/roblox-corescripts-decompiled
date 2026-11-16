local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Devices = require(parent.Devices)
local DeviceTier = Devices.DeviceTier

local defineFastInt = game:DefineFastInt("AXWidgetListWindowSizeLow", 5)
local defineFastInt2 = game:DefineFastInt("AXWidgetListWindowSizeMid", 8)
local defineFastInt3 = game:DefineFastInt("AXWidgetListWindowSizeHigh", 11)

local function resolveWidgetListWindowSize(p: number)
	local deviceMemoryTier = DeviceTier.GetDeviceMemoryTier()

	if deviceMemoryTier == "LowEnd" then
		return defineFastInt
	elseif deviceMemoryTier == "MidTier" then
		return defineFastInt2
	elseif deviceMemoryTier == "HighEnd" then
		return defineFastInt3
	end

	return p
end

return resolveWidgetListWindowSize
