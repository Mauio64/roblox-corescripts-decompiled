local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Responsive")

local function useMobilePage()
	return (Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small))
end

return useMobilePage
