local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local function shouldUsePeekView()
	return useBreakpointXOrSmaller(Responsive.Keys.Small)
end

return shouldUsePeekView
