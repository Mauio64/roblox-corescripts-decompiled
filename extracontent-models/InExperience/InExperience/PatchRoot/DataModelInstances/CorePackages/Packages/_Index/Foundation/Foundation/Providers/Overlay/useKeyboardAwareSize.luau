local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Wrappers = require(Foundation.Utility.Wrappers)

local GuiService = Wrappers.Services.GuiService
local UserInputService = Wrappers.Services.UserInputService

local React = require(parent.React)

local function useKeyboardAwareSize(instance)
	local v, v2 = React.useBinding(UDim2.fromScale(1, 1))

	React.useLayoutEffect(function()
		if not instance then
			return
		end

		local function updateSafeAreaSize()
			if not UserInputService.OnScreenKeyboardVisible then
				v2(UDim2.fromScale(1, 1))
				return
			end

			local guiInset = GuiService:GetGuiInset()
			local v3 = UserInputService.OnScreenKeyboardPosition.Y - guiInset.Y

			local absoluteSize = instance.AbsoluteSize
			local v4 = instance.AbsolutePosition.Y + absoluteSize.Y - v3
			local udim = UDim2.new(1, 0, 1, -v4)

			if v:getValue() ~= udim then
				v2(udim)
			end
		end

		updateSafeAreaSize()

		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(updateSafeAreaSize)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(updateSafeAreaSize)
		local absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSafeAreaSize)

		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardPositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { instance })

	return v
end

return useKeyboardAwareSize
