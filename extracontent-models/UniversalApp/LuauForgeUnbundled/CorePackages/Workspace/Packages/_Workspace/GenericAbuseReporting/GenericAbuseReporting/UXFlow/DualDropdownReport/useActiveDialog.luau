local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function useActiveDialog()
	local state, setState = React.useState("Form")

	return state, setState
end

return useActiveDialog
