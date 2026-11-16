local deviceTier = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Devices").DeviceTier

local defineFastInt = game:DefineFastInt("AXWidgetListWindowSizeLow", 5)
local defineFastInt2 = game:DefineFastInt("AXWidgetListWindowSizeMid", 8)
local defineFastInt3 = game:DefineFastInt("AXWidgetListWindowSizeHigh", 11)

local function resolveWidgetListWindowSize(p2)
	local deviceMemoryTier = deviceTier.GetDeviceMemoryTier()

	if deviceMemoryTier == "LowEnd" then
		return defineFastInt
	elseif deviceMemoryTier == "MidTier" then
		return defineFastInt2
	elseif deviceMemoryTier == "HighEnd" then
		return defineFastInt3
	end

	return p2
end

return resolveWidgetListWindowSize
