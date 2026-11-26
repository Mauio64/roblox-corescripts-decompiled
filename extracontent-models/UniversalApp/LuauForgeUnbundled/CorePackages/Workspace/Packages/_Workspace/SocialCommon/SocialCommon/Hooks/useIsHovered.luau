local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")

local InputUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/InputUtilities")

return function()
	local state, setState = React.useState(false)

	return state, React.useCallback(function(p2, p3)
		if InputUtilities.isPointerInput(p3) then
			setState(true)
		end
	end, { setState }), (React.useCallback(function(p2, p3)
		if InputUtilities.isPointerInput(p3) then
			setState(false)
		end
	end, { setState }))
end
