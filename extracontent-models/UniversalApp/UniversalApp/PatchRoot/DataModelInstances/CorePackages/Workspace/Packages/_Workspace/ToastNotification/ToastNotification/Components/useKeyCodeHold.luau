local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("ToastNotification").Parent
local React = require(Parent.React)

local function useKeyCodeHold(p1, n1: number, n2: number, p2: ((...any) -> ...any), b1: boolean?) -- line: 14
	-- upvalues: React (copy), UserInputService (copy), RunService (copy)
	local v11, v12 = React.useState(false)
	local v13, v14 = React.useBinding(0)
	local v15 = React.useRef(nil)

	React.useEffect(function() -- line: 25
		-- upvalues: b1 (copy), UserInputService (copy), p1 (copy), v12 (copy)
		if b1 then
			return
		end

		local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 30
			-- upvalues: p1 (copy), v12 (copy)
			if gameProcessed then
				return
			end

			if input.KeyCode == p1 then
				v12(true)
			end
		end)
		local connection2 = UserInputService.InputEnded:Connect(function(input) -- line: 40
			-- upvalues: p1 (copy), v12 (copy)
			if input.KeyCode == p1 then
				v12(false)
			end
		end)

		return function() -- line: 46
			-- upvalues: connection (copy), connection2 (copy), v12 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			v12(false)
		end
	end, {
		b1,
		p1
	})
	React.useEffect(function() -- line: 53
		-- upvalues: v11 (copy), v15 (copy), RunService (copy), n1 (copy), n2 (copy), p2 (copy), v14 (copy)
		if not v11 then
			return
		end

		local function disconnect() -- line: 58
			-- upvalues: v15 (copy)
			if v15.current then
				v15.current:Disconnect()
				v15.current = nil
			end
		end

		local n3 = 0

		v15.current = RunService.Heartbeat:Connect(function(dt) -- line: 66
			-- upvalues: n3 (ref), n1 (copy), n2 (copy), v15 (copy), p2 (copy), v14 (copy)
			n3 += dt

			if n3 < n1 then
				return
			end

			if n2 == 0 then
				if v15.current then
					v15.current:Disconnect()
					v15.current = nil
				end

				p2()

				return
			end

			local v24 = math.clamp((n3 - n1) / n2, 0, 1)

			v14(v24)

			if v24 >= 1 then
				if v15.current then
					v15.current:Disconnect()
					v15.current = nil
				end

				p2()
			end
		end)

		return function() -- line: 89
			-- upvalues: v15 (copy), v14 (copy)
			if v15.current then
				v15.current:Disconnect()
				v15.current = nil
			end

			v14(0)
		end
	end, {
		v11,
		p2,
		n1,
		n2
	})

	return {
		holding = v11,
		holdProgress = v13
	}
end

return useKeyCodeHold
