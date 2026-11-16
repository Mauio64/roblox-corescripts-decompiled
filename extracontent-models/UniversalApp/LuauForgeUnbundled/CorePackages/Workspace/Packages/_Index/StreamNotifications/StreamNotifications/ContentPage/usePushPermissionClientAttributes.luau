local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")

local buildPushPermissionClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/ContentPage/buildPushPermissionClientAttributes")

local function usePushPermissionClientAttributes()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local flag = true
		buildPushPermissionClientAttributes.build():andThen(function(p2)
			if flag then
				setState(p2)
			end
		end)

		return function()
			flag = false
		end
	end, {})

	return state
end

return usePushPermissionClientAttributes
