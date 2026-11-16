local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

return function(callback, p2)
	local ref = React.useRef(false)

	React.useEffect(function()
		if p2 and not ref.current then
			callback()
			ref.current = true
		end
	end, { p2 })
end
