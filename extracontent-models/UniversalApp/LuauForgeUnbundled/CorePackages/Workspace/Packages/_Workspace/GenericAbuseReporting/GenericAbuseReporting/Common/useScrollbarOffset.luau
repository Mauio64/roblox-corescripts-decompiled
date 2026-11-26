local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function useScrollbarOffset(p2, p3): number
	local state, setState = React.useState(false)

	React.useEffect(function()
		if p2.Y > p3.Y then
			setState(true)
		else
			setState(false)
		end
	end, { p2, p3 })

	if state then
		return 16
	end

	return 0
end

return useScrollbarOffset
