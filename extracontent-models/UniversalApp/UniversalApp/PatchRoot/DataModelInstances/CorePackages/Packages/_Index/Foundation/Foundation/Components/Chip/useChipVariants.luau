local Foundation = script:FindFirstAncestor("Foundation")
local ChipSize = require(Foundation.Enums.ChipSize)
local ChipVariant = require(Foundation.Enums.ChipVariant)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 17
	-- upvalues: ChipSize (copy), ChipVariant (copy)
	local t1 = {
		[ChipSize.Small] = UDim.new(0, p1.Padding.Small),
		[ChipSize.Medium] = UDim.new(0, p1.Padding.Medium),
		[ChipSize.Large] = UDim.new(0, p1.Padding.Large)
	}
	local t2 = {
		chip = {
			tag = "row align-x-center align-y-center auto-x radius-circle clip"
		},
		text = {
			tag = "shrink size-0-full auto-x text-truncate-end"
		}
	}
	local t3 = {
		[ChipSize.Small] = {
			chip = {
				tag = "size-0-600"
			},
			text = {
				tag = "text-label-small"
			}
		},
		[ChipSize.Medium] = {
			chip = {
				tag = "size-0-800"
			},
			text = {
				tag = "text-label-medium"
			}
		},
		[ChipSize.Large] = {
			chip = {
				tag = "size-0-1000"
			},
			text = {
				tag = "text-label-medium"
			}
		}
	}
	local t4 = {
		[ChipVariant.Utility] = {
			[true] = {
				chip = {
					backgroundStyle = p1.Inverse.Surface.Surface_0
				},
				text = {
					contentStyle = p1.Inverse.Content.Emphasis
				}
			},
			[false] = {
				chip = {
					backgroundStyle = p1.Color.ActionUtility.Background
				},
				text = {
					contentStyle = p1.Color.ActionUtility.Foreground
				}
			}
		},
		[ChipVariant.Standard] = {
			[true] = {
				chip = {
					backgroundStyle = p1.Inverse.Surface.Surface_0
				},
				text = {
					contentStyle = p1.Inverse.Content.Emphasis
				}
			},
			[false] = {
				chip = {
					backgroundStyle = p1.Color.ActionStandard.Background
				},
				text = {
					contentStyle = p1.Color.ActionStandard.Foreground
				}
			}
		}
	}

	return {
		common = t2,
		sizes = t3,
		types = t4,
		textSpacing = t1
	}
end

return function(p2, p3, p4, b1: boolean, b2: boolean, b3: boolean) -- line: 75
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v18 = VariantsContext.useVariants("Chip", variantsFactory, p2)

	return composeStyleVariant(v18.common, v18.sizes[p3], v18.types[p4][b1], {
		text = {
			padding = {
				left = if not b2 then v18.textSpacing[p3] else nil,
				right = if not b3 then v18.textSpacing[p3] else nil
			}
		}
	})
end
