local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Wrappers = require(Foundation.Utility.Wrappers)
local GuiService = Wrappers.Services.GuiService
local UserInputService = Wrappers.Services.UserInputService
local Flags = require(Foundation.Utility.Flags)
local React = require(FoundationParent.React)

local function useKeyboardAwareSize(p1) -- line: 13
	-- upvalues: React (copy), UserInputService (copy), GuiService (copy), Flags (copy)
	local v10, v11 = React.useBinding(UDim2.fromScale(1, 1))

	React.useLayoutEffect(function() -- line: 16
		-- upvalues: p1 (copy), UserInputService (copy), v11 (copy), GuiService (copy), Flags (copy), v10 (copy)
		if not p1 then
			return
		end

		local function updateSafeAreaSize() -- line: 21
			-- upvalues: UserInputService (copy), v11 (copy), GuiService (copy), p1 (copy), Flags (copy), v10 (copy)
			if not UserInputService.OnScreenKeyboardVisible then
				v11(UDim2.fromScale(1, 1))

				return
			end

			local GuiInset = GuiService:GetGuiInset()
			local v17 = UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y
			local AbsoluteSize = p1.AbsoluteSize
			local v19 = p1.AbsolutePosition.Y + AbsoluteSize.Y - v17

			if Flags.FoundationOverlayKeyboardAwarenessHardened then
				local uDim2 = UDim2.new(1, 0, 1, -v19)

				if uDim2 ~= v10:getValue() then
					v11(uDim2)

					return
				end
			else
				v11(v10:getValue() - UDim2.fromOffset(0, v19))
			end
		end

		updateSafeAreaSize()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(updateSafeAreaSize)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(updateSafeAreaSize)
		local connection3 = nil

		if Flags.FoundationOverlayKeyboardAwarenessHardened then
			connection3 = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSafeAreaSize)
		end

		return function() -- line: 58
			-- upvalues: connection (copy), connection2 (copy), Flags (copy), connection3 (ref)
			connection:Disconnect()
			connection2:Disconnect()

			if Flags.FoundationOverlayKeyboardAwarenessHardened then
				connection3:Disconnect()
			end
		end
	end, { p1 })

	return v10
end

return useKeyboardAwareSize
