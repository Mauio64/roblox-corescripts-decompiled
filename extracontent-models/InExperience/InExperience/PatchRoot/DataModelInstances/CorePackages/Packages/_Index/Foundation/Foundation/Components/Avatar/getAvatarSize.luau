local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Providers.Style.Tokens)

local function getAvatarSize(p1, p2, b1: boolean) -- line: 9
	-- upvalues: InputSize (copy)
	if b1 then
		return ({
			[InputSize.XSmall] = p1.Size.Size_300,
			[InputSize.Small] = p1.Size.Size_400,
			[InputSize.Medium] = p1.Size.Size_500,
			[InputSize.Large] = p1.Size.Size_600
		})[p2]
	end

	return ({
		[InputSize.XSmall] = p1.Size.Size_600,
		[InputSize.Small] = p1.Size.Size_800,
		[InputSize.Medium] = p1.Size.Size_1000,
		[InputSize.Large] = p1.Size.Size_1200
	})[p2]
end

return getAvatarSize
