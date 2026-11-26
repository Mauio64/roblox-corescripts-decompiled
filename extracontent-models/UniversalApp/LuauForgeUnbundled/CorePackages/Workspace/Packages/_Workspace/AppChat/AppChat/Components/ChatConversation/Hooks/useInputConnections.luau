local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function useInputConnections(data)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v5 = React.useCallback(function()
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

	local v6 = React.useCallback(function(p2)
		if p2 and not ref.current then
			ref2.current = data.userInputService.InputBegan:Connect(data.onInputBegan)
			ref3.current = data.userInputService.InputEnded:Connect(data.onInputEnded)
			ref.current = true
		elseif not p2 and ref.current then
			v5()

			if data.onFocusLost then
				data.onFocusLost()
			end
		end
	end, { data.onInputBegan, data.onInputEnded, v5, data.onFocusLost })

	React.useEffect(function()
		return function()
			if ref.current then
				v5()
			end
		end
	end, { v5 })

	return { focusChanged = v6, disconnectInputConnection = v5 }
end

return useInputConnections
