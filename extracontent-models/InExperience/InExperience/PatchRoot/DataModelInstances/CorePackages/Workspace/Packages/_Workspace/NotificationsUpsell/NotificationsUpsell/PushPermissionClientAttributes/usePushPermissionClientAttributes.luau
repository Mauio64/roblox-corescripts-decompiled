local parent = script:FindFirstAncestor("NotificationsUpsell").Parent

local React = require(parent.React)

local buildPushPermissionClientAttributes = require(script.Parent.buildPushPermissionClientAttributes)

local function usePushPermissionClientAttributes()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local flag = true
		buildPushPermissionClientAttributes.build():andThen(function(p)
			if flag then
				setState(p)
			end
		end)

		return function()
			flag = false
		end
	end, {})

	return state
end

return usePushPermissionClientAttributes
