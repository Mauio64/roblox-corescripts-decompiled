local Foundation = script:FindFirstAncestor("Foundation")

local AvatarSize = require(Foundation.Enums.AvatarSize)

require(Foundation.Providers.Style.Tokens)

local function getAvatarSize(p, p2, flag: boolean)
	if flag then
		return ({
			[AvatarSize.XSmall] = p.Size.Size_300,
			[AvatarSize.Small] = p.Size.Size_400,
			[AvatarSize.Medium] = p.Size.Size_500,
			[AvatarSize.Large] = p.Size.Size_600,
			[AvatarSize.XLarge] = p.Size.Size_600
		})[p2]
	end

	return ({
		[AvatarSize.XSmall] = p.Size.Size_600,
		[AvatarSize.Small] = p.Size.Size_800,
		[AvatarSize.Medium] = p.Size.Size_1000,
		[AvatarSize.Large] = p.Size.Size_1200,
		[AvatarSize.XLarge] = p.Size.Size_1400,
		[AvatarSize.Pictogram] = p.Size.Size_2400
	})[p2]
end

return getAvatarSize
