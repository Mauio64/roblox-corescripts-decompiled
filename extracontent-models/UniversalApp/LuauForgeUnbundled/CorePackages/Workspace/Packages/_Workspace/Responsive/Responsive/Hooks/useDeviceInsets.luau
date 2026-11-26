local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local HardwareSafeAreaInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/HardwareSafeAreaInsets")

return function()
	local state, setState = React.useState(HardwareSafeAreaInsets.deviceInsets())
	React.useLayoutEffect(function()
		local connection = HardwareSafeAreaInsets:connect(setState)

		if HardwareSafeAreaInsets.diffInsets(state, HardwareSafeAreaInsets.deviceInsets()) then
			setState(HardwareSafeAreaInsets.deviceInsets)
		end

		return function()
			connection:disconnect()
		end
	end, {})
	return state
end
