local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local function useVisibleContentHeight(p2, instance)
	local v5, v6 = React.useBinding(0)

	React.useEffect(function()
		local current = p2.current

		if current == nil then
			return
		end

		local function update()
			local y = current.AbsolutePosition.Y
			local v7 = y + current.AbsoluteWindowSize.Y

			if instance ~= nil then
				v7 = math.min(v7, instance.AbsolutePosition.Y)
			end

			v6((math.max(0, v7 - y)))
		end

		local y = current.AbsolutePosition.Y
		local v7 = y + current.AbsoluteWindowSize.Y

		if instance ~= nil then
			v7 = math.min(v7, instance.AbsolutePosition.Y)
		end

		v6((math.max(0, v7 - y)))

		local connections = {
			current:GetPropertyChangedSignal("AbsolutePosition"):Connect(update),
			current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(update)
		}

		if instance ~= nil then
			table.insert(connections, instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(update))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, instance })

	return v5
end

return useVisibleContentHeight
