local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local function useActiveDialog()
	local state, setState = React.useState("Form")

	return state, setState
end

return useActiveDialog
