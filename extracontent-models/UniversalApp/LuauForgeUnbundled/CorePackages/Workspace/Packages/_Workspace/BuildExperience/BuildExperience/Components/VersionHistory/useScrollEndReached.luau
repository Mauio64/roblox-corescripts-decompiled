local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function useScrollEndReached(p2, p3, callback)
	React.useEffect(function()
		local current = p2.current

		if current == nil then
			return
		end

		local function checkDistanceToEnd()
			local y = current.AbsoluteWindowSize.Y

			if current.AbsoluteCanvasSize.Y - y - current.CanvasPosition.Y <= y * p3 then
				callback()
			end
		end
		local connections = {}

		for k, propertyName in { "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" } do
			table.insert(
				connections,
				current:GetPropertyChangedSignal(propertyName):Connect(checkDistanceToEnd)
			)
		end

		local y = current.AbsoluteWindowSize.Y

		if current.AbsoluteCanvasSize.Y - y - current.CanvasPosition.Y <= y * p3 then
			callback()
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, p3, callback })
end

return useScrollEndReached
