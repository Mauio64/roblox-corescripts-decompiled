local Foundation = script:FindFirstAncestor("Foundation")
local AvatarSize = require(Foundation.Enums.AvatarSize)

require(Foundation.Providers.Style.Tokens)

local function getAvatarSize(p1, p2, b1: boolean) -- line: 9
	-- upvalues: AvatarSize (copy)
	if b1 then
		return ({
			[AvatarSize.XSmall] = p1.Size.Size_300,
			[AvatarSize.Small] = p1.Size.Size_400,
			[AvatarSize.Medium] = p1.Size.Size_500,
			[AvatarSize.Large] = p1.Size.Size_600,
			[AvatarSize.XLarge] = p1.Size.Size_600
		})[p2]
	end

	return ({
		[AvatarSize.XSmall] = p1.Size.Size_600,
		[AvatarSize.Small] = p1.Size.Size_800,
		[AvatarSize.Medium] = p1.Size.Size_1000,
		[AvatarSize.Large] = p1.Size.Size_1200,
		[AvatarSize.XLarge] = p1.Size.Size_1400,
		[AvatarSize.Pictogram] = p1.Size.Size_2400
	})[p2]
end

return getAvatarSize
