local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")

local function useCarouselScrollingBinding(p2, p3)
	local v5, v6 = React.useBinding(false)

	React.useEffect(function()
		local current = p2.current

		if not (p3 and current) then
			return nil
		end

		assert(current, "scrollingFrame must exist")
		local v7 = 0
		local heartbeatConnection = nil

		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			v7 = os.clock() + 0.01

			if not heartbeatConnection then
				v6(true)
				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now = os.clock()

					if v7 <= now then
						v6(false)

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
	end, { p2 })

	return v5
end

return useCarouselScrollingBinding
