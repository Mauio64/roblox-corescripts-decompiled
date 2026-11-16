local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Common/Types")

return function(object)
	local v5 = if object ~= nil then object:get() else nil
	local state, setState = React.useState(v5)
	React.useEffect(function()
		if object == nil then
			return
		end

		local v6 = object
		local connection = v6:connect(function(p2)
			setState(p2)
		end)

		if state ~= v6:get() then
			setState(v6:get())
		end

		return function()
			connection:disconnect()
		end
	end, { object })

	return state
end
