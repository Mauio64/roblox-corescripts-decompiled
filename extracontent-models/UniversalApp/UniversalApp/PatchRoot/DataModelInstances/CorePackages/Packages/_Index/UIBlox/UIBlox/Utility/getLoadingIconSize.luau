local ParentParent = script.Parent.Parent.Parent
local IconSize = require(ParentParent.Foundation).Enums.IconSize

local function getLoadingIconSize(uDim2: UDim2?, p1) -- line: 15
	-- upvalues: IconSize (copy)
	if uDim2 == nil then
		return nil
	end

	local YOffset = uDim2.Y.Offset

	if uDim2.Y.Scale > 0 and YOffset <= 0 then
		return IconSize.Large
	end

	local t1 = {
		{
			IconSize.XSmall,
			p1.Size.Size_200
		},
		{
			IconSize.Small,
			p1.Size.Size_400
		},
		{
			IconSize.Medium,
			p1.Size.Size_900
		},
		{
			IconSize.Large,
			p1.Size.Size_1200
		}
	}
	local v8 = t1[1][1]
	local v9 = math.abs(YOffset - t1[1][2])

	for i = 2, #t1 do
		local v11 = math.abs(YOffset - t1[i][2])

		if v11 < v9 then
			v8 = t1[i][1]
			v9 = v11
		end
	end

	return v8
end

return getLoadingIconSize
