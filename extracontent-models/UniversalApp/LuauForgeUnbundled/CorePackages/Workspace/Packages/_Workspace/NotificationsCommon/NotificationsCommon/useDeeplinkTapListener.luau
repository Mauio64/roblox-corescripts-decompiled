local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")

local DeeplinkTapListeners = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/DeeplinkTapListeners")

local function useDeeplinkTapListener(current)
	local ref = React.useRef(current)

	React.useLayoutEffect(function()
		ref.current = current
	end, { current })

	React.useEffect(function()
		return DeeplinkTapListeners.connect(function(p2)
			ref.current(p2)
		end)
	end, {})
end

return useDeeplinkTapListener
