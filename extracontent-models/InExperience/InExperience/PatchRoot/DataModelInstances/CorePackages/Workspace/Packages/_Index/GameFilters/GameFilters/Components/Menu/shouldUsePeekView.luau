local Parent = script:FindFirstAncestor("GameFilters").Parent
local Responsive = require(Parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local function shouldUsePeekView() -- line: 7
	-- upvalues: useBreakpointXOrSmaller (copy), Responsive (copy)
	return useBreakpointXOrSmaller(Responsive.Keys.Small)
end

return shouldUsePeekView
