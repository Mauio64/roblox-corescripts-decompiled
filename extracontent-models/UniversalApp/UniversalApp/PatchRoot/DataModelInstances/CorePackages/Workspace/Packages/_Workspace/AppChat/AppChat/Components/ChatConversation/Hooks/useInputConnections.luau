local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)

local function useInputConnections(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy)
	local v5 = React.useRef(false)
	local v6 = React.useRef(nil)
	local v7 = React.useRef(nil)
	local v8 = React.useCallback(function() -- line: 18
		-- upvalues: v6 (copy), v7 (copy), v5 (copy)
		if v6.current then
			v6.current:Disconnect()
			v6.current = nil
		end

		if v7.current then
			v7.current:Disconnect()
			v7.current = nil
		end

		v5.current = false
	end, {})
	local v9 = React.useCallback(function(p1) -- line: 32
		-- upvalues: v5 (copy), v6 (copy), t1 (copy), v7 (copy), v8 (copy)
		if p1 and not v5.current then
			v6.current = t1.userInputService.InputBegan:Connect(t1.onInputBegan)
			v7.current = t1.userInputService.InputEnded:Connect(t1.onInputEnded)
			v5.current = true

			return
		end

		if not p1 and v5.current then
			v8()

			if t1.onFocusLost then
				t1.onFocusLost()
			end
		end
	end, {
		t1.onInputBegan,
		t1.onInputEnded,
		v8,
		t1.onFocusLost
	})

	React.useEffect(function() -- line: 53
		-- upvalues: v5 (copy), v8 (copy)
		return function() -- line: 54
			-- upvalues: v5 (copy), v8 (copy)
			if v5.current then
				v8()
			end
		end
	end, { v8 })

	return {
		focusChanged = v9,
		disconnectInputConnection = v8
	}
end

return useInputConnections
