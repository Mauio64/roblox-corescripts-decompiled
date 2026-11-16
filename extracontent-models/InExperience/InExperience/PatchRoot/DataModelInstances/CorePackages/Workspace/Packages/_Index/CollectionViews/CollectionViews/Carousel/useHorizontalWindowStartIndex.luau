local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)

local function useHorizontalWindowStartIndex(p, object, p2: number, flag: boolean)
	local state, setState = React.useState(1)

	local v = React.useCallback(function()
		if flag then
			if p.current ~= nil then
				local x = p.current.CanvasPosition.X
				local v = object:getValue().X + p2

				if v > 0 then
					setState((math.max(1, (math.floor(x / v)))))
				else
					setState(1)
				end
			end
		else
			setState(1)
		end
	end, { flag, p, object, p2 })

	React.useEffect(function()
		v()
	end, { v })

	React.useEffect(function()
		if not flag then
			return nil
		end

		local connections = {}

		if p.current ~= nil then
			v()
			table.insert(connections, p.current:GetPropertyChangedSignal("CanvasPosition"):Connect(v))

			table.insert(connections, p.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p, v, flag })

	return state
end

return useHorizontalWindowStartIndex
