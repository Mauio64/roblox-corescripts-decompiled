local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

local function useInputConnections(data)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local disconnectInputConnection = React.useCallback(function()
		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		ref.current = false
	end, {})

	local focusChanged = React.useCallback(function(p)
		if p and not ref.current then
			ref2.current = data.userInputService.InputBegan:Connect(data.onInputBegan)
			ref3.current = data.userInputService.InputEnded:Connect(data.onInputEnded)
			ref.current = true
		elseif not p and ref.current then
			disconnectInputConnection()

			if data.onFocusLost then
				data.onFocusLost()
			end
		end
	end, { data.onInputBegan, data.onInputEnded, disconnectInputConnection, data.onFocusLost })

	React.useEffect(function()
		return function()
			if ref.current then
				disconnectInputConnection()
			end
		end
	end, { disconnectInputConnection })

	return { focusChanged = focusChanged, disconnectInputConnection = disconnectInputConnection }
end

return useInputConnections
