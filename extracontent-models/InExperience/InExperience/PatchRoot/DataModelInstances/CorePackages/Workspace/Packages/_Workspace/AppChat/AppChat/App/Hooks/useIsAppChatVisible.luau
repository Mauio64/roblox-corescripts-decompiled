local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local AppChatVisible = require(AppChat.App.AppChatVisible)
local useExternalEvent = require(AppChatParent.RoactUtils).Hooks.useExternalEvent
local useState = React.useState
local useCallback = React.useCallback

local function useIsAppChatVisible(b1: boolean?) -- line: 14
	-- upvalues: useState (copy), useExternalEvent (copy), AppChatVisible (copy), useCallback (copy)
	local v10, v11 = useState(b1 or false)

	useExternalEvent(AppChatVisible.BindableEvent.Event, function(b2: boolean) -- line: 17
		-- upvalues: v10 (copy), v11 (copy)
		if b2 ~= v10 then
			v11(b2)
		end
	end, { v10 })

	return v10, (useCallback(function() -- line: 23
		-- upvalues: v11 (copy)
		v11(false)
	end, { v11 }))
end

return useIsAppChatVisible
