local Foundation = script:FindFirstAncestor("Foundation")

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local InputSize = require(Foundation.Enums.InputSize)

local IconSize = require(Foundation.Enums.IconSize)

local function variantsFactory(_)
	local sizes = {
		[InputSize.XSmall] = {
			text = { tag = "size-0-400 text-label-small" },
			content = { tag = "padding-y-small" },
			icon = { size = IconSize.XSmall }
		},
		[InputSize.Small] = {
			text = { tag = "size-0-600 text-label-medium" },
			content = { tag = "padding-y-small" },
			icon = { size = IconSize.Medium }
		},
		[InputSize.Medium] = {
			text = { tag = "size-0-600 text-label-medium" },
			content = { tag = "padding-y-medium" },
			icon = { size = IconSize.Medium }
		},
		[InputSize.Large] = {
			text = { tag = "size-0-600 text-label-medium" },
			content = { tag = "padding-y-xlarge" },
			icon = { size = IconSize.Medium }
		}
	}

	local paddings = {
		[InputSize.XSmall] = {
			content = { tag = "padding-x-xsmall" }
		},
		[InputSize.Small] = {
			content = { tag = "padding-x-small" }
		},
		[InputSize.Medium] = {
			content = { tag = "padding-x-medium" }
		},
		[InputSize.Large] = {
			content = { tag = "padding-x-large" }
		}
	}
	return {
		common = {
			text = { tag = "auto-x" },
			content = { tag = "row align-x-center align-y-center gap-small" }
		},
		sizes = sizes,
		isFill = {
			[false] = {
				container = { tag = "auto-xy" },
				content = { tag = "size-0-0 auto-xy" }
			},
			[true] = {
				container = { tag = "grow auto-xy" },
				content = { tag = "auto-y", Size = UDim2.fromScale(1, 0) }
			}
		},
		paddings = paddings
	}
end

return function(p, p2, flag: boolean)
	local v = VariantsContext.useVariants("Tab", variantsFactory, p)

	return composeStyleVariant(v.common, v.sizes[p2], v.isFill[flag], v.paddings[p2])
end
