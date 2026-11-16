local parent = script:FindFirstAncestor("GameFilters").Parent
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local function shouldUsePeekView()
	return useBreakpointXOrSmaller(Responsive.Keys.Small)
end

return shouldUsePeekView
