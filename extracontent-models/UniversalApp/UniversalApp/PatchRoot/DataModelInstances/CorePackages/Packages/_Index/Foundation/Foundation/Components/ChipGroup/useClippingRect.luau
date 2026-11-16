local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function useClippingRect(p)
	local v, v2 = React.useBinding(Rect.new(Vector2.zero, Vector2.zero))

	React.useEffect(function()
		if not p.current then
			return
		end

		local parent2 = p.current.Parent
		local v3 = nil

		while parent2 do
			if parent2:IsA("GuiObject") and parent2.ClipsDescendants then
				v3 = parent2
				break
			end

			parent2 = parent2.Parent
		end

		if not v3 then
			local layerCollector = p.current:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector and layerCollector:IsA("GuiBase2d") then
				v3 = layerCollector
			end
		end

		local function update() -- 1 equivalent call inferred from this helper
			if v3 then
				v2(Rect.new(v3.AbsolutePosition, v3.AbsolutePosition + v3.AbsoluteSize))
			end
		end

		local connections = {}

		if v3 then
			table.insert(connections, v3:GetPropertyChangedSignal("AbsolutePosition"):Connect(update))
			table.insert(connections, v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(update))
		end

		update() -- inferred equivalent call
		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {})

	return v
end

return useClippingRect
