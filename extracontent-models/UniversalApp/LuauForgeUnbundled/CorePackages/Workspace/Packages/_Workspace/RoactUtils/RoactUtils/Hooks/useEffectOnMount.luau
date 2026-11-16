local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

return function(callback)
	React.useEffect(function()
		callback()
	end, {})
end
