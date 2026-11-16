local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation")
local useNavigation = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/views/useNavigation")

local function useNavigationFocus()
	local v5 = useNavigation()

	local state, setState = React.useState(v5.isFocused())

	React.useEffect(function()
		local v6 = v5.addListener(RoactNavigation.Events.WillFocus, function()
			setState(true)
		end)
		local v7 = v5.addListener(RoactNavigation.Events.WillBlur, function()
			setState(false)
		end)
		setState(v5.isFocused())

		return function()
			v6.remove()
			v7.remove()
		end
	end, {})

	return state
end

return useNavigationFocus
