local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ButtonVariant)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local getSharedVariants = require(script.Parent.getSharedVariants)

require(Foundation.Providers.Style.Tokens)

local function v8(p1) -- line: 48
	-- upvalues: getSharedVariants (copy), InputSize (copy), Flags (copy)
	local v10 = getSharedVariants(p1)
	local t1 = {
		container = {
			tag = "row align-x-center align-y-center clip"
		},
		text = {
			tag = "shrink size-0-full auto-x text-truncate-end"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "gap-xsmall padding-small",
				radius = v10.sizes[InputSize.XSmall].container.radius,
				height = v10.sizes[InputSize.XSmall].container.height
			},
			icon = {
				size = UDim2.fromOffset(p1.Size.Size_300, p1.Size.Size_300)
			},
			text = {
				tag = {
					["text-label-small"] = Flags.FoundationButtonLabelTypography,
					["text-title-small"] = not Flags.FoundationButtonLabelTypography
				}
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "gap-xsmall padding-small",
				radius = v10.sizes[InputSize.Small].container.radius,
				height = v10.sizes[InputSize.Small].container.height
			},
			icon = {
				size = UDim2.fromOffset(p1.Size.Size_400, p1.Size.Size_400)
			},
			text = {
				tag = {
					["text-label-small"] = Flags.FoundationButtonLabelTypography,
					["text-title-small"] = not Flags.FoundationButtonLabelTypography
				}
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "gap-small padding-medium",
				radius = v10.sizes[InputSize.Medium].container.radius,
				height = v10.sizes[InputSize.Medium].container.height
			},
			icon = {
				size = UDim2.fromOffset(p1.Size.Size_500, p1.Size.Size_500)
			},
			text = {
				tag = {
					["text-label-medium"] = Flags.FoundationButtonLabelTypography,
					["text-title-medium"] = not Flags.FoundationButtonLabelTypography
				}
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "gap-small padding-medium",
				radius = v10.sizes[InputSize.Large].container.radius,
				height = v10.sizes[InputSize.Large].container.height
			},
			icon = {
				size = UDim2.fromOffset(p1.Size.Size_600, p1.Size.Size_600)
			},
			text = {
				tag = {
					["text-label-large"] = Flags.FoundationButtonLabelTypography,
					["text-title-large"] = not Flags.FoundationButtonLabelTypography
				}
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		types = v10.types
	}
end

return function(p2, p3, p4, p5) -- line: 130
	-- upvalues: VariantsContext (copy), v8 (copy), composeStyleVariant (copy), ColorNamespace (copy)
	local v17 = VariantsContext.useVariants("Button", v8, p2)

	return composeStyleVariant(v17.common, v17.sizes[p3], v17.types[p4][p5 or ColorNamespace.Color])
end
