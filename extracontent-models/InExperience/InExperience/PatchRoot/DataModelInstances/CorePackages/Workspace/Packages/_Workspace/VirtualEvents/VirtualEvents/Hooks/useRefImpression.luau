local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)

local function useRefImpression(p, callback)
	local ref = React.useRef(false)

	local v = React.useCallback(function(p2, p3)
		if p2.AbsolutePosition.Y <= p3.AbsoluteSize.Y then
			ref.current = true
			callback()
		end
	end, { callback })

	React.useEffect(function()
		if ref.current then
			return
		end

		local current = p.current
		local absolutePositionChangedConnection = nil

		if current then
			local screenGui = current:FindFirstAncestorWhichIsA("ScreenGui")

			if screenGui then
				v(current, screenGui)

				absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					if ref.current then
						return
					end

					v(current, screenGui)
				end)
			end
		end

		return function()
			if absolutePositionChangedConnection then
				absolutePositionChangedConnection:Disconnect()
			end
		end
	end)
end

return useRefImpression
