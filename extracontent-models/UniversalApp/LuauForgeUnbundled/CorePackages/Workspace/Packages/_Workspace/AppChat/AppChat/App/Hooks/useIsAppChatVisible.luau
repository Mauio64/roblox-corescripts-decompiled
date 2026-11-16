local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local AppChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/AppChatVisible")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useExternalEvent
local useState = React.useState
local useCallback = React.useCallback

local function useIsAppChatVisible(p2)
	local state, setState = useState(p2 or false)

	useExternalEvent(AppChatVisible.BindableEvent.Event, function(p3)
		if p3 ~= state then
			setState(p3)
		end
	end, { state })

	return state, (useCallback(function()
		setState(false)
	end, { setState }))
end

return useIsAppChatVisible
