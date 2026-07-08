local Parent = script:FindFirstAncestor("Moments").Parent
local AppNavBar = require(Parent.AppNavBar)
local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local Placement = AppNavBar.Placement

local function useScreenBottomInset() -- line: 35
	-- upvalues: useNavBarPlacement (copy), useNavBarSize (copy), Placement (copy)
	local v7 = useNavBarPlacement()
	local v8 = useNavBarSize()

	if v7 == Placement.Bottom then
		return v8
	end

	return 0
end

return useScreenBottomInset
