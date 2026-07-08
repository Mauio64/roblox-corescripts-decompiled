local Foundation = script:FindFirstAncestor("Foundation")
local ProgressSize = require(Foundation.Enums.ProgressSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 14
	-- upvalues: ProgressSize (copy)
	return {
		sizes = {
			[ProgressSize.Small] = {
				bar = {
					height = p1.Size.Size_50
				},
				circle = {
					size = p1.Size.Size_400
				}
			},
			[ProgressSize.Medium] = {
				bar = {
					height = p1.Size.Size_100
				},
				circle = {
					size = p1.Size.Size_800
				}
			},
			[ProgressSize.Large] = {
				bar = {
					height = p1.Size.Size_150
				},
				circle = {
					size = p1.Size.Size_1300,
					labelFont = p1.Typography.LabelMedium
				}
			}
		}
	}
end

return function(p2, p3) -- line: 46
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v9 = VariantsContext.useVariants("Progress", variantsFactory, p2)

	return composeStyleVariant(v9.sizes[p3])
end
