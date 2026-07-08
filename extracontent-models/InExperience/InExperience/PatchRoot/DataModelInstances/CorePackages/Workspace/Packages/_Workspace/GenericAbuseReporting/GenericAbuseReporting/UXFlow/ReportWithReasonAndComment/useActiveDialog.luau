local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)

local function useActiveDialog() -- line: 8
	-- upvalues: React (copy)
	local v4, v5 = React.useState("Form")

	return v4, v5
end

return useActiveDialog
