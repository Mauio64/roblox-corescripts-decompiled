local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("ToastNotification").Parent

local React = require(parent.React)

local function useKeyCodeHold(p, p2: number, p3: number, callback, flag: boolean?)
	local state, setState = React.useState(false)
	local holdProgress, v = React.useBinding(0)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if flag then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == p then
				setState(true)
			end
		end)

		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == p then
				setState(false)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
			setState(false)
		end
	end, { flag, p })

	React.useEffect(function()
		if not state then
			return
		end

		local function disconnect() -- 3 equivalent calls inferred from this helper
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end

		local total = 0
		ref.current = RunService.Heartbeat:Connect(function(dt)
			total += dt

			if total < p2 then
				return
			end

			if p3 == 0 then
				disconnect() -- inferred equivalent call
				callback()
			else
				local v2 = math.clamp((total - p2) / p3, 0, 1)
				v(v2)

				if v2 >= 1 then
					disconnect() -- inferred equivalent call
					callback()
				end
			end
		end)

		return function()
			disconnect() -- inferred equivalent call
			v(0)
		end
	end, { state, callback, p2, p3 })

	return { holding = state, holdProgress = holdProgress }
end

return useKeyCodeHold
