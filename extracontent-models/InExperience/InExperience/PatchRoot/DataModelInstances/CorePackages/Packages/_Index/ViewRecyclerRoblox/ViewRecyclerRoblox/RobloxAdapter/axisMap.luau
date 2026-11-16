local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local Axis = ViewRecycler.Axis
local AxisMap = {}

function AxisMap.mainOf(vector2: Vector2, p)
	return if p == Axis.X then vector2.X else vector2.Y
end

function AxisMap.crossOf(vector2: Vector2, p)
	return if p == Axis.X then vector2.Y else vector2.X
end

function AxisMap.positionFor(data, p, value: number?)
	local crossAxisIndex = data.crossAxisIndex or 1
	local crossAxisCount = data.crossAxisCount or 1
	local v = (crossAxisIndex - 1) / crossAxisCount
	local v2 = (crossAxisIndex - 1) * (data.crossAxisSpacing or 0) / crossAxisCount
	local v3 = data.startOffset + (value or 0)

	if p == Axis.X then
		return (UDim2.new(0, v3, v, v2))
	end

	return (UDim2.new(v, v2, 0, v3))
end

function AxisMap.sizeFor(data, p, flag: boolean)
	local crossAxisCount = data.crossAxisCount or 1
	local v = 1 / crossAxisCount
	local v2 = -(crossAxisCount - 1) * (data.crossAxisSpacing or 0) / crossAxisCount
	local v3 = flag and 0 or data.length

	if p == Axis.X then
		return (UDim2.new(0, v3, v, v2))
	end

	return (UDim2.new(v, v2, 0, v3))
end

function AxisMap.canvasSizeFor(p: number, p2)
	if p2 == Axis.X then
		return (UDim2.fromOffset(p, 0))
	end

	return (UDim2.fromOffset(0, p))
end

return AxisMap
