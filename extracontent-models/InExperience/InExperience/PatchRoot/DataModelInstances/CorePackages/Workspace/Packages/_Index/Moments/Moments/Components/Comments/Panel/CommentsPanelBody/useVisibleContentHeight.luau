local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local function useVisibleContentHeight(p, instance)
	local v, v2 = React.useBinding(0)

	React.useEffect(function()
		local current = p.current

		if current == nil then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			local y = current.AbsolutePosition.Y
			local v3 = y + current.AbsoluteWindowSize.Y

			if instance ~= nil then
				v3 = math.min(v3, instance.AbsolutePosition.Y)
			end

			v2((math.max(0, v3 - y)))
		end

		update() -- inferred equivalent call
		local connections = {
			current:GetPropertyChangedSignal("AbsolutePosition"):Connect(update),
			current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(update)
		}

		if instance ~= nil then
			table.insert(connections, instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(update))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p, instance })

	return v
end

return useVisibleContentHeight
