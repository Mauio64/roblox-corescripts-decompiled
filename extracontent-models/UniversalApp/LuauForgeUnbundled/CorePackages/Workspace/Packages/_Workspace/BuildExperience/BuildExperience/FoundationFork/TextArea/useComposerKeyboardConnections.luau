local UserInputService = game:GetService("UserInputService")

local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

local function isReturnKey(p2): boolean
	return p2 == Enum.KeyCode.Return or p2 == Enum.KeyCode.KeypadEnter
end

local function useComposerKeyboardConnections(p2)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local v5 = React.useCallback(function()
		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		ref.current = false
	end, {})

	local v6 = React.useCallback(function()
		if p2.enabled and not ref.current then
			ref2.current = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				local keyCode = input.KeyCode

				if keyCode == Enum.KeyCode.Return or keyCode == Enum.KeyCode.KeypadEnter then
					p2.onReturnPressed(
						gameProcessed,
						UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
					)
				end
			end)

			ref.current = true
		end
	end, { p2.enabled, p2.onReturnPressed })

	React.useEffect(function()
		return function()
			v5()
		end
	end, { v5 })

	return { connect = v6, disconnect = v5 }
end

return useComposerKeyboardConnections
