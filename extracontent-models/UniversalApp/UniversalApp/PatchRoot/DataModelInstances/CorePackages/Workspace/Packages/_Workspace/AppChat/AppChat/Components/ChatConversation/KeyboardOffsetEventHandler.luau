local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UserInputService = game:GetService("UserInputService")
local usePositionOffsetForVirtualKeyboard = require(AppChat.Hooks.usePositionOffsetForVirtualKeyboard)
local React = require(AppChatParent.React)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: useSelector (copy), usePositionOffsetForVirtualKeyboard (copy), React (copy), UserInputService (copy)
	local v8 = useSelector(function(p1) -- line: 17
		if p1.GlobalGuiInset then
			return p1.GlobalGuiInset.top
		end

		return 0
	end)
	local v9 = if not t1.parentViewRef then nil else t1.parentViewRef.current
	local v10 = usePositionOffsetForVirtualKeyboard({
		isNearBottomOfScreen = true
	})
	local v11 = React.useCallback(function() -- line: 23
		-- upvalues: UserInputService (copy), v10 (copy), v9 (copy), v8 (copy), t1 (copy)
		local n1 = 0

		if UserInputService.OnScreenKeyboardVisible then
			if v10 ~= nil then
				n1 = v10
			elseif v9 then
				n1 = v9.AbsolutePosition.Y + v9.AbsoluteSize.Y - (UserInputService.OnScreenKeyboardPosition.Y - v8)
			end
		end

		if t1.onKeyboardOffsetChanged then
			t1.onKeyboardOffsetChanged(n1)
		end
	end, {
		v10,
		v8,
		t1.onKeyboardOffsetChanged,
		v9
	})

	React.useEffect(function() -- line: 40
		-- upvalues: v11 (copy), UserInputService (copy), v9 (copy)
		v11()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v11)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v11)
		local connection3 = nil

		if v9 then
			connection3 = v9:GetPropertyChangedSignal("AbsoluteSize"):Connect(v11)
		end

		return function() -- line: 53
			-- upvalues: connection (copy), connection2 (copy), connection3 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end
		end
	end, {
		v11,
		v9
	})

	return nil
end
