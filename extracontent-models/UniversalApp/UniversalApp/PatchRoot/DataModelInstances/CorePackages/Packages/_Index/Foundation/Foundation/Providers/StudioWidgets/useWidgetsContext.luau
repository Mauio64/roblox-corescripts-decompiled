local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

require(script.Parent.Types)

local WidgetsContext = require(script.Parent.WidgetsContext)

local function useWidgetsContext() -- line: 11
	-- upvalues: React (copy), WidgetsContext (copy)
	local v5 = React.useContext(WidgetsContext)

	if v5 == nil then
		error("useWidgetsContext must be used within a WidgetsProvider")
	end

	return v5
end

return useWidgetsContext
