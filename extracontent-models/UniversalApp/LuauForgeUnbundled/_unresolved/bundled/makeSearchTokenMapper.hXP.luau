require("@game/CorePackages/Workspace/Packages/Style")

local function makeSearchTokenMapper(p2, p3)
	local size_500 = p3.Size.Size_500
	local v5 = p3.Size.Size_400 + size_500
	local v6 = size_500 + p3.Size.Size_200

	local size_1200 = p3.Size.Size_1200
	local size_1200_2 = p3.Size.Size_1200
	local size_300 = p3.Size.Size_300
	local v7 = 85 + size_1200 + size_1200_2 + size_300 * 2

	return {
		SearchHeadingScale = 0.8,
		SearchPaddingHorizontal = p3.Size.Size_600,
		SearchPaddingVertical = 85,
		SearchBoxHeight = size_1200,
		SearchBoxTextSize = p3.FontSize.FontSize_500,
		SearchBoxIconSize = size_500,
		SearchBoxIconPosition = v6,
		SearchBoxIconPaddingLeft = v5,
		SearchBoxIconPaddingRight = p3.Size.Size_400,
		SearchBoxIconPaddingVertical = p3.Size.Size_200,
		SearchTypePaddingVertical = size_300,
		SearchTypeHeight = size_1200_2,
		SearchBoxAndTypeOffset = v7
	}
end

return makeSearchTokenMapper
