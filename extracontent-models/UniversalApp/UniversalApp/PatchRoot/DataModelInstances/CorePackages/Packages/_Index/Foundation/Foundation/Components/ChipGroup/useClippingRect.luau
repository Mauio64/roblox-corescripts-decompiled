local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function useClippingRect(t1: {[any]: any}) -- line: 6
	-- upvalues: React (copy)
	local v5, v6 = React.useBinding(Rect.new(Vector2.zero, Vector2.zero))

	React.useEffect(function() -- line: 9
		-- upvalues: t1 (copy), v6 (copy)
		if not t1.current then
			return
		end

		local u7 = nil
		local currentParent = t1.current.Parent

		while currentParent do
			if currentParent:IsA("GuiObject") and currentParent.ClipsDescendants then
				u7 = currentParent

				break
			end

			currentParent = currentParent.Parent
		end

		if not u7 then
			local LayerCollector = t1.current:FindFirstAncestorWhichIsA("LayerCollector")

			if LayerCollector and LayerCollector:IsA("GuiBase2d") then
				u7 = LayerCollector
			end
		end

		local function update() -- line: 31
			-- upvalues: u7 (ref), v6 (copy)
			if u7 then
				v6(Rect.new(u7.AbsolutePosition, u7.AbsolutePosition + u7.AbsoluteSize))
			end
		end

		local t2 = {}

		if u7 then
			table.insert(t2, u7:GetPropertyChangedSignal("AbsolutePosition"):Connect(update))
			table.insert(t2, u7:GetPropertyChangedSignal("AbsoluteSize"):Connect(update))
		end

		if u7 then
			v6(Rect.new(u7.AbsolutePosition, u7.AbsolutePosition + u7.AbsoluteSize))
		end

		return function() -- line: 45
			-- upvalues: t2 (copy)
			for _, v13 in t2 do
				v13:Disconnect()
			end
		end
	end, {})

	return v5
end

return useClippingRect
