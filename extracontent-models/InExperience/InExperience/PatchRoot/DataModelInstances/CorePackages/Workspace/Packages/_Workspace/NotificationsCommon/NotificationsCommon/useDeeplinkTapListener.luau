local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local parent = NotificationsCommon.Parent
local React = require(parent.React)

local DeeplinkTapListeners = require(NotificationsCommon.DeeplinkTapListeners)

local function useDeeplinkTapListener(current)
	local ref = React.useRef(current)

	React.useLayoutEffect(function()
		ref.current = current
	end, { current })

	React.useEffect(function()
		return DeeplinkTapListeners.connect(function(p)
			ref.current(p)
		end)
	end, {})
end

return useDeeplinkTapListener
