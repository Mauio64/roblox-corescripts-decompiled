local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")

local function useHorizontalWindowStartIndex(p2, object, p3, p4)
	local state, setState = React.useState(1)

	local v5 = React.useCallback(function()
		if p4 then
			if p2.current ~= nil then
				local x = p2.current.CanvasPosition.X
				local v6 = object:getValue().X + p3

				if v6 > 0 then
					setState((math.max(1, (math.floor(x / v6)))))
				else
					setState(1)
				end
			end
		else
			setState(1)
		end
	end, { p4, p2, object, p3 })

	React.useEffect(function()
		v5()
	end, { v5 })

	React.useEffect(function()
		if not p4 then
			return nil
		end

		local connections = {}

		if p2.current ~= nil then
			v5()
			table.insert(connections, p2.current:GetPropertyChangedSignal("CanvasPosition"):Connect(v5))

			table.insert(connections, p2.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v5))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, v5, p4 })

	return state
end

return useHorizontalWindowStartIndex
