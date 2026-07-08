local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local ResponsiveContext = require(script.Parent.ResponsiveContext)

local function useResponsive() -- line: 9
	-- upvalues: React (copy), ResponsiveContext (copy)
	return React.useContext(ResponsiveContext)
end

return useResponsive
