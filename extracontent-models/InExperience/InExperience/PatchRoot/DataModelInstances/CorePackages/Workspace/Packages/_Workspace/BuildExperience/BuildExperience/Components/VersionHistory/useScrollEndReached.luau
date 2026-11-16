local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local function useScrollEndReached(p, p2: number, callback)
	React.useEffect(function()
		local current = p.current

		if current == nil then
			return
		end

		local function checkDistanceToEnd() -- 1 equivalent call inferred from this helper
			local y = current.AbsoluteWindowSize.Y

			if current.AbsoluteCanvasSize.Y - y - current.CanvasPosition.Y <= y * p2 then
				callback()
			end
		end
		local connections = {}

		for _, propertyName in { "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" } do
			table.insert(connections, current:GetPropertyChangedSignal(propertyName):Connect(checkDistanceToEnd))
		end

		checkDistanceToEnd() -- inferred equivalent call
		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p, p2, callback })
end

return useScrollEndReached
