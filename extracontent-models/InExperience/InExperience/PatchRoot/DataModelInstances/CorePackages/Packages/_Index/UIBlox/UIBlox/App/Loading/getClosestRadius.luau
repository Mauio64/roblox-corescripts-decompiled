local ParentParent = script.Parent.Parent.Parent.Parent
local EnumsRadius = require(ParentParent.Foundation).Enums.Radius

local function getClosestRadius(p1, uDim: UDim?) -- line: 9
	-- upvalues: EnumsRadius (copy)
	if not uDim or uDim == UDim.new(0, 0) then
		return EnumsRadius.None
	end

	if uDim.Scale >= 0.5 then
		return EnumsRadius.Circle
	end

	local v6 = nil
	local n1 = 1e999

	for v8, v9 in {
		[EnumsRadius.None] = 0,
		[EnumsRadius.XSmall] = 2,
		[EnumsRadius.Small] = p1.Small,
		[EnumsRadius.Medium] = p1.Medium,
		[EnumsRadius.Large] = p1.XLarge,
		[EnumsRadius.Circle] = p1.Circle
	} do
		local v10 = math.abs(uDim.Offset - v9)

		if v10 < n1 then
			n1 = v10
			v6 = v8
		end
	end

	return v6
end

return getClosestRadius
