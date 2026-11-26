local UserInputService = game:GetService("UserInputService")

local usePositionOffsetForVirtualKeyboard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/usePositionOffsetForVirtualKeyboard")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

return function(p2): nil
	local v5 = useSelector(function(p3)
		if p3.GlobalGuiInset then
			return p3.GlobalGuiInset.top
		end

		return 0
	end)

	local current = if p2.parentViewRef then p2.parentViewRef.current else nil
	local v6 = usePositionOffsetForVirtualKeyboard({ isNearBottomOfScreen = true })
	local v7 = React.useCallback(function()
		local v8 = 0

		if UserInputService.OnScreenKeyboardVisible then
			if v6 == nil then
				if current then
					v8 = current.AbsolutePosition.Y + current.AbsoluteSize.Y - (UserInputService.OnScreenKeyboardPosition.Y - v5)
				end
			else
				v8 = v6
			end
		end

		if p2.onKeyboardOffsetChanged then
			p2.onKeyboardOffsetChanged(v8)
		end
	end, { v6, v5, p2.onKeyboardOffsetChanged, current })

	React.useEffect(function()
		v7()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v7)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v7)

		local absoluteSizeChangedConnection = if current then current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v7) else nil

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
	end, { v7, current })

	return nil
end
