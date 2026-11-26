local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/AppCommonLib")

local function useSignal(object, p2)
	React.useEffect(function()
		if not object then
			return
		end

		assert(object ~= nil, "signal is not nil")

		local connection = object:connect(p2)
		return function()
			connection:disconnect()
		end
	end, { object, p2 })
end

return useSignal
