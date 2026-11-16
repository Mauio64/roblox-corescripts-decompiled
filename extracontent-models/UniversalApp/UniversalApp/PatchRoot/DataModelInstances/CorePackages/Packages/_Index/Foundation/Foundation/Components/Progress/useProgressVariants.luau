local Foundation = script:FindFirstAncestor("Foundation")

local ProgressSize = require(Foundation.Enums.ProgressSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	return {
		sizes = {
			[ProgressSize.Small] = {
				bar = { height = p.Size.Size_50 },
				circle = { size = p.Size.Size_400 }
			},
			[ProgressSize.Medium] = {
				bar = { height = p.Size.Size_100 },
				circle = { size = p.Size.Size_800 }
			},
			[ProgressSize.Large] = {
				bar = { height = p.Size.Size_150 },
				circle = { size = p.Size.Size_1300, labelFont = p.Typography.LabelMedium }
			}
		}
	}
end

return function(p, p2)
	return composeStyleVariant(VariantsContext.useVariants("Progress", variantsFactory, p).sizes[p2])
end
