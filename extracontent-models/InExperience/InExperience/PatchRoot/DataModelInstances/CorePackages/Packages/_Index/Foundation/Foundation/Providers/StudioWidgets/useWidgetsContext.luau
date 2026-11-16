local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

require(script.Parent.Types)
local WidgetsContext = require(script.Parent.WidgetsContext)

local function useWidgetsContext()
	local v = React.useContext(WidgetsContext)

	if v == nil then
		error("useWidgetsContext must be used within a WidgetsProvider")
	end

	return v
end

return useWidgetsContext
