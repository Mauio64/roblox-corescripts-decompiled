local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")

local function useKeyCodeHold(p2, p3, p4, callback, p5)
	local state, setState = React.useState(false)
	local v5, v6 = React.useBinding(0)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if p5 then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == p2 then
				setState(true)
			end
		end)

		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == p2 then
				setState(false)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
			setState(false)
		end
	end, { p5, p2 })

	React.useEffect(function()
		if not state then
			return
		end

		local function disconnect()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end

		local total = 0
		ref.current = RunService.Heartbeat:Connect(function(dt)
			total += dt

			if total < p3 then
				return
			end

			if p4 == 0 then
				if ref.current then
					ref.current:Disconnect()
					ref.current = nil
				end

				callback()
			else
				local v7 = math.clamp((total - p3) / p4, 0, 1)
				v6(v7)

				if v7 >= 1 then
					if ref.current then
						ref.current:Disconnect()
						ref.current = nil
					end

					callback()
				end
			end
		end)

		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			v6(0)
		end
	end, { state, callback, p3, p4 })

	return { holding = state, holdProgress = v5 }
end

return useKeyCodeHold
