local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local Axis = ViewRecycler.Axis
local axisMap = require(ViewRecyclerRoblox.RobloxAdapter.axisMap)

local SlotGeometry = {}

function SlotGeometry.get(p, p2, flag: boolean, p3: number?)
	if p ~= nil then
		return axisMap.positionFor(p, p2, p3), axisMap.sizeFor(p, p2, flag)
	end

	if flag then
		return UDim2.new(), SlotGeometry.getHostSize(SlotGeometry.getAutomaticSize(p2, true))
	end

	return UDim2.new(), UDim2.new()
end

function SlotGeometry.getAutomaticSize(p, flag: boolean)
	if not flag then
		return Enum.AutomaticSize.None
	end

	if p == Axis.Y then
		return Enum.AutomaticSize.Y
	end

	return Enum.AutomaticSize.X
end

function SlotGeometry.getHostSize(p)
	if p == Enum.AutomaticSize.None then
		return UDim2.fromScale(1, 1)
	end

	if p == Enum.AutomaticSize.X then
		return UDim2.fromScale(0, 1)
	end

	if p == Enum.AutomaticSize.Y then
		return UDim2.fromScale(1, 0)
	end

	return UDim2.new()
end

return SlotGeometry
