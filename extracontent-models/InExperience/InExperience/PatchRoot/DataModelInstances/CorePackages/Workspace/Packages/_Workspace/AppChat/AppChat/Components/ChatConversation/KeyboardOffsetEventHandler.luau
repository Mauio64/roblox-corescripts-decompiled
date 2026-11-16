local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local UserInputService = game:GetService("UserInputService")

local usePositionOffsetForVirtualKeyboard = require(AppChat.Hooks.usePositionOffsetForVirtualKeyboard)

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p): nil
	local v = useSelector(function(p2)
		return if p2.GlobalGuiInset then p2.GlobalGuiInset.top else 0
	end)
	local current

	if p.parentViewRef then
		current = p.parentViewRef.current
	else
		current = nil
	end

	local v2 = usePositionOffsetForVirtualKeyboard({ isNearBottomOfScreen = true })
	local v3 = React.useCallback(function()
		local v3 = 0

		if UserInputService.OnScreenKeyboardVisible then
			if v2 == nil then
				if current then
					v3 = current.AbsolutePosition.Y + current.AbsoluteSize.Y - (UserInputService.OnScreenKeyboardPosition.Y - v)
				end
			else
				v3 = v2
			end
		end

		if p.onKeyboardOffsetChanged then
			p.onKeyboardOffsetChanged(v3)
		end
	end, { v2, v, p.onKeyboardOffsetChanged, current })

	React.useEffect(function()
		v3()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v3)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v3)
		local absoluteSizeChangedConnection

		if current then
			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v3)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			if onScreenKeyboardPositionChangedConnection then
				onScreenKeyboardPositionChangedConnection:Disconnect()
			end

			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v3, current })

	return nil
end
