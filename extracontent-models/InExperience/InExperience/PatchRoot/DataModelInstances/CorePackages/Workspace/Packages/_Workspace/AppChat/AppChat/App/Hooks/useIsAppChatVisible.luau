local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local AppChatVisible = require(AppChat.App.AppChatVisible)
local RoactUtils = require(parent.RoactUtils)

local useExternalEvent = RoactUtils.Hooks.useExternalEvent
local useState = React.useState
local useCallback = React.useCallback

local function useIsAppChatVisible(flag: boolean?)
	local state, setState = useState(flag or false)

	useExternalEvent(AppChatVisible.BindableEvent.Event, function(flag2: boolean)
		if flag2 ~= state then
			setState(flag2)
		end
	end, { state })

	return state, (useCallback(function()
		setState(false)
	end, { setState }))
end

return useIsAppChatVisible
