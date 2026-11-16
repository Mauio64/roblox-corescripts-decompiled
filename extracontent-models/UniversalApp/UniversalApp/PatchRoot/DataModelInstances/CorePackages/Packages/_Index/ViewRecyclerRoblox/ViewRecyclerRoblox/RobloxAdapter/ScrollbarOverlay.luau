local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

return {
	connect = function(instance, p, p2)
		local flag = false

		local function synchronize()
			if flag then
				return
			end

			local scrollBarThickness = instance.ScrollBarThickness
			p.Position = UDim2.fromOffset(
				(p2 ~= ViewRecycler.Axis.Y or instance.VerticalScrollBarPosition ~= Enum.VerticalScrollBarPosition.Left) and 0 or scrollBarThickness,
				0
			)
			local size

			if p2 == ViewRecycler.Axis.X then
				size = UDim2.new(1, 0, 1, -scrollBarThickness)
			else
				size = UDim2.new(1, -scrollBarThickness, 1, 0)
			end

			p.Size = size
		end

		synchronize()
		local scrollBarThicknessChangedConnection = instance:GetPropertyChangedSignal("ScrollBarThickness"):Connect(synchronize)
		local verticalScrollBarPositionChangedConnection = instance:GetPropertyChangedSignal("VerticalScrollBarPosition"):Connect(synchronize)

		return function()
			if flag then
				return
			end

			flag = true
			scrollBarThicknessChangedConnection:Disconnect()
			verticalScrollBarPositionChangedConnection:Disconnect()
		end
	end
}
