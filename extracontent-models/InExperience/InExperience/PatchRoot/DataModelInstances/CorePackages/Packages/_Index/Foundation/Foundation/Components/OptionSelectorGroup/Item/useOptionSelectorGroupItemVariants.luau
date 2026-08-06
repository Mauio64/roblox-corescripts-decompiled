local Foundation = script:FindFirstAncestor("Foundation")
local IconSize = require(Foundation.Enums.IconSize)
local InputSize = require(Foundation.Enums.InputSize)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Orientation = require(Foundation.Enums.Orientation)
local Flags = require(Foundation.Utility.Flags)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 43
	-- upvalues: Flags (copy), InputSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = "col wrap align-x-left align-y-center gap-xsmall radius-medium",
			radius = p1.Radius.Medium
		},
		content = p1.Color.Content.Default,
		itemInner = if not Flags.FoundationOptionSelectorGroupFixes then {
			tag = "col gap-xsmall size-full-0 auto-y"
		} else nil,
		header = {
			tag = "row align-y-center gap-small size-full-0 auto-y"
		},
		label = {
			tag = "fill auto-xy"
		},
		metadata = {
			tag = "shrink auto-xy"
		},
		description = {
			tag = "grow auto-xy"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "padding-medium"
			},
			icon = {
				size = IconSize.XSmall
			},
			label = {
				tag = "text-title-small"
			},
			metadata = {
				tag = "text-caption-small"
			},
			description = {
				tag = "text-body-small"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "padding-large"
			},
			icon = {
				size = IconSize.Small
			},
			label = {
				tag = "text-title-small"
			},
			metadata = {
				tag = "text-caption-small"
			},
			description = {
				tag = "text-body-small"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "padding-xlarge"
			},
			icon = {
				size = IconSize.Medium
			},
			label = {
				tag = "text-title-medium"
			},
			metadata = {
				tag = "text-caption-medium"
			},
			description = {
				tag = "text-body-medium"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "padding-xxlarge"
			},
			icon = {
				size = IconSize.Large
			},
			label = {
				tag = "text-title-large"
			},
			metadata = {
				tag = "text-caption-large"
			},
			description = {
				tag = "text-body-large"
			}
		}
	}
	local v13 = if not Flags.FoundationOptionSelectorGroupFixes then {} else {
		Inline = {
			container = {
				tag = "size-full-0 auto-y"
			},
			itemInner = {
				tag = "col gap-xsmall size-full-0 auto-y"
			}
		},
		StackedFill = {
			container = {
				tag = "fill auto-y"
			},
			itemInner = {
				tag = "col gap-xsmall size-full-0 auto-y"
			}
		},
		StackedFit = {
			container = {
				tag = "auto-xy"
			},
			itemInner = {
				tag = "col gap-xsmall auto-xy"
			},
			header = {
				tag = "flex-x-between"
			},
			textContainer = {
				tag = "col gap-xsmall auto-xy"
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		layouts = v13
	}
end

return function(p2, p3, p4, p5) -- line: 116
	-- upvalues: VariantsContext (copy), variantsFactory (copy), Flags (copy), Orientation (copy), FillBehavior (copy), composeStyleVariant (copy)
	local v18 = VariantsContext.useVariants("OptionSelectorGroupItem", variantsFactory, p2)

	if Flags.FoundationOptionSelectorGroupFixes then
		local v19 = p4 == Orientation.Vertical and p5 == FillBehavior.Fit
		local v20 = if p4 ~= Orientation.Horizontal then if not v19 then v18.layouts.StackedFill else v18.layouts.StackedFit else v18.layouts.Inline

		return composeStyleVariant(v18.common, v18.sizes[p3], v20)
	end

	return composeStyleVariant(v18.common, v18.sizes[p3])
end
