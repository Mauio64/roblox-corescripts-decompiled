local parent = script.Parent.Parent.Parent.Parent

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius

local function getClosestRadius(data, udim: UDim?)
	if not udim or udim == UDim.new(0, 0) then
		return Radius.None
	end

	if udim.Scale >= 0.5 then
		return Radius.Circle
	end

	local v = 1e999
	local v2 = nil

	for k, v3 in {
		[Radius.None] = 0,
		[Radius.XSmall] = 2,
		[Radius.Small] = data.Small,
		[Radius.Medium] = data.Medium,
		[Radius.Large] = data.XLarge,
		[Radius.Circle] = data.Circle
	} do
		local v4 = math.abs(udim.Offset - v3)

		if not (v4 < v) then
			continue
		end

		v2 = k
		v = v4
	end

	return v2
end

return getClosestRadius
