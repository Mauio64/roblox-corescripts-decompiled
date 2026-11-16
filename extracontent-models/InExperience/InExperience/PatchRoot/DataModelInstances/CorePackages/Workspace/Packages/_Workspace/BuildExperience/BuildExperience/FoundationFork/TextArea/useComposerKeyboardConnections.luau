local UserInputService = game:GetService("UserInputService")

local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

local function isReturnKey(keyCode): boolean -- 1 equivalent call inferred from this helper
	return keyCode == Enum.KeyCode.Return or keyCode == Enum.KeyCode.KeypadEnter
end

local function useComposerKeyboardConnections(p)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local disconnect = React.useCallback(function()
		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		ref.current = false
	end, {})

	local connect = React.useCallback(function()
		if p.enabled and not ref.current then
			ref2.current = UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean)
				if isReturnKey(input.KeyCode) then -- inferred equivalent call
					p.onReturnPressed(
						gameProcessed,
						UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
					)
				end
			end)

			ref.current = true
		end
	end, { p.enabled, p.onReturnPressed })

	React.useEffect(function()
		return function()
			disconnect()
		end
	end, { disconnect })

	return { connect = connect, disconnect = disconnect }
end

return useComposerKeyboardConnections
