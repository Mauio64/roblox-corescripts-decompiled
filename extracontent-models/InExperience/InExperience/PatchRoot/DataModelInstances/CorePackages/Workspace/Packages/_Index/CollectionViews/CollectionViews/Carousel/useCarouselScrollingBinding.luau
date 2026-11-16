local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)

local function useCarouselScrollingBinding(p, flag: boolean)
	local v, v2 = React.useBinding(false)

	React.useEffect(function()
		local current = p.current

		if not (flag and current) then
			return nil
		end

		assert(current, "scrollingFrame must exist")
		local v3 = 0
		local heartbeatConnection = nil

		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			v3 = os.clock() + 0.01

			if not heartbeatConnection then
				v2(true)
				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now = os.clock()

					if v3 <= now then
						v2(false)

						if heartbeatConnection then
							heartbeatConnection:Disconnect()
							heartbeatConnection = nil
						end
					end
				end)
			end
		end)

		return function()
			canvasPositionChangedConnection:Disconnect()

			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end
	end, { p })

	return v
end

return useCarouselScrollingBinding
