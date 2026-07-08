local UserInputService = game:GetService("UserInputService")
local FoundationParent = game:GetService("CorePackages").Packages._Index.Foundation.Foundation.Parent
local React = require(FoundationParent.React)

local function isReturnKey(p1) -- line: 14
	return p1 == Enum.KeyCode.Return or p1 == Enum.KeyCode.KeypadEnter
end
local function useComposerKeyboardConnections(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), UserInputService (copy)
	local v8 = React.useRef(false)
	local v9 = React.useRef(nil)
	local v10 = React.useCallback(function() -- line: 22
		-- upvalues: v9 (copy), v8 (copy)
		if v9.current then
			v9.current:Disconnect()
			v9.current = nil
		end

		v8.current = false
	end, {})
	local v11 = React.useCallback(function() -- line: 30
		-- upvalues: t1 (copy), v8 (copy), v9 (copy), UserInputService (copy)
		if not t1.enabled or v8.current then
			return
		end

		v9.current = UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 36
			-- upvalues: t1 (copy), UserInputService (copy)
			local KeyCode = input.KeyCode

			if KeyCode == Enum.KeyCode.Return or KeyCode == Enum.KeyCode.KeypadEnter then
				t1.onReturnPressed(gameProcessed, UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift))
			end
		end)
		v8.current = true
	end, {
		t1.enabled,
		t1.onReturnPressed
	})

	React.useEffect(function() -- line: 49
		-- upvalues: v10 (copy)
		return function() -- line: 50
			-- upvalues: v10 (copy)
			v10()
		end
	end, { v10 })

	return {
		connect = v11,
		disconnect = v10
	}
end

return useComposerKeyboardConnections
