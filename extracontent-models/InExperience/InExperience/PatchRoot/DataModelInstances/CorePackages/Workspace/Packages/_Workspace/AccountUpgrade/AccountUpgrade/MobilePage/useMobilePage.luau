local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local Responsive = require(parent.Responsive)

local function useMobilePage()
	return (Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small))
end

return useMobilePage
