local parent = script:FindFirstAncestor("Responsive").Parent
local React = require(parent.React)
local HardwareSafeAreaInsets = require(script.Parent.Parent.HardwareSafeAreaInsets)

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
