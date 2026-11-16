local parent = script.Parent.Parent.Parent

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize

local function getLoadingIconSize(udim: UDim2?, p)
	if udim == nil then
		return nil
	end

	local offset = udim.Y.Offset

	if udim.Y.Scale > 0 and offset <= 0 then
		return IconSize.Large
	end

	local v = {
		{ IconSize.XSmall, p.Size.Size_200 },
		{ IconSize.Small, p.Size.Size_400 },
		{ IconSize.Medium, p.Size.Size_900 },
		{ IconSize.Large, p.Size.Size_1200 }
	}

	local v2 = v[1][1]
	local v3 = math.abs(offset - v[1][2])

	for i = 2, #v do
		local v4 = math.abs(offset - v[i][2])

		if not (v4 < v3) then
			continue
		end

		v2 = v[i][1]
		v3 = v4
	end

	return v2
end

return getLoadingIconSize
