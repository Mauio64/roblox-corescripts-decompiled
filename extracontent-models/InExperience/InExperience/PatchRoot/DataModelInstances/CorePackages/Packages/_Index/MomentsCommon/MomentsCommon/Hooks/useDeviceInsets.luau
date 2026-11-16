local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)

local HardwareSafeAreaInsets = require(MomentsCommon.Utils.HardwareSafeAreaInsets)

return function()
	local state, setState = React.useState(HardwareSafeAreaInsets.deviceInsets())
	React.useLayoutEffect(function()
		local connection = HardwareSafeAreaInsets:connect(setState)

		if HardwareSafeAreaInsets.diffInsets(state, HardwareSafeAreaInsets.deviceInsets()) then
			setState(HardwareSafeAreaInsets.deviceInsets)
		end

		return function()
			connection.disconnect()
		end
	end, {})
	return state
end
