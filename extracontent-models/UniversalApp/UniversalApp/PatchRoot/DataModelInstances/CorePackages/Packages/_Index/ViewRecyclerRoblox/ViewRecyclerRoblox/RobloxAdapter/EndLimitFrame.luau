local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local transparentFrame = require(ViewRecyclerRoblox.RobloxAdapter.transparentFrame)

local Axis = ViewRecycler.Axis

return {
	new = function()
		local v = transparentFrame("ViewRecyclerEndLimit")
		local v2 = transparentFrame("Spacer")
		v2.Parent = v

		return {
			instance = v,
			place = function(parent, p, p2, p3, zIndex)
				local v3 = math.max(0, p3 - p2)

				if p == Axis.X then
					v.AnchorPoint = Vector2.xAxis
					v.Position = UDim2.fromOffset(p3, 0)
					v.Size = UDim2.fromScale(0, 1)
					v.AutomaticSize = Enum.AutomaticSize.X
					v2.Size = UDim2.fromOffset(v3, 0)
				else
					v.AnchorPoint = Vector2.yAxis
					v.Position = UDim2.fromOffset(0, p3)
					v.Size = UDim2.fromScale(1, 0)
					v.AutomaticSize = Enum.AutomaticSize.Y
					v2.Size = UDim2.fromOffset(0, v3)
				end

				v.ZIndex = zIndex
				v.Parent = parent
			end,
			destroy = function()
				v:Destroy()
			end
		}
	end
}
