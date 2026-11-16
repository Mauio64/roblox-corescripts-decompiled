local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local ResponsiveContext = require(script.Parent.ResponsiveContext)

local function useResponsive()
	return React.useContext(ResponsiveContext)
end

return useResponsive
