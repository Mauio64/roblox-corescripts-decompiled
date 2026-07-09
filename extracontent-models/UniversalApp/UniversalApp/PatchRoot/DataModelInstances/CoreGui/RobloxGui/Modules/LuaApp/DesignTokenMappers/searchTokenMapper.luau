local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Style)

local function makeSearchTokenMapper(_, p2) -- line: 6
	local Size_500 = p2.Size.Size_500
	local v6 = p2.Size.Size_400 + Size_500
	local v7 = Size_500 + p2.Size.Size_200
	local Size_1200 = p2.Size.Size_1200
	local Size_1200_2 = p2.Size.Size_1200
	local Size_300 = p2.Size.Size_300
	local v11 = Size_1200 + 85 + Size_1200_2 + Size_300 * 2

	return {
		SearchHeadingScale = 0.8,
		SearchPaddingVertical = 85,
		SearchPaddingHorizontal = p2.Size.Size_600,
		SearchBoxHeight = Size_1200,
		SearchBoxTextSize = p2.FontSize.FontSize_500,
		SearchBoxIconSize = Size_500,
		SearchBoxIconPosition = v7,
		SearchBoxIconPaddingLeft = v6,
		SearchBoxIconPaddingRight = p2.Size.Size_400,
		SearchBoxIconPaddingVertical = p2.Size.Size_200,
		SearchTypePaddingVertical = Size_300,
		SearchTypeHeight = Size_1200_2,
		SearchBoxAndTypeOffset = v11
	}
end

return makeSearchTokenMapper
