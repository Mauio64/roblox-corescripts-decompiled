local Foundation = script:FindFirstAncestor("Foundation")

local StatusBadgeShape = require(Foundation.Enums.StatusBadgeShape)

local StatusBadgeSize = require(Foundation.Enums.StatusBadgeSize)

local StatusBadgeVariant = require(Foundation.Enums.StatusBadgeVariant)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

function variantsFactory(p)
	return {
		common = {
			container = { tag = "row align-x-center align-y-center auto-xy" },
			statusLight = {
				tag = "row align-x-center align-y-center auto-x size-0-300 padding-x-xxsmall"
			},
			content = { tag = "row align-y-center auto-x size-0-full" },
			dot = { tag = "radius-circle" },
			text = {
				style = p.Color.Content.Emphasis,
				tag = "auto-xy text-align-x-left text-truncate-split padding-right-xxsmall"
			}
		},
		variants = {
			[StatusBadgeVariant.Standard] = {
				dot = { tag = "bg-system-neutral" }
			},
			[StatusBadgeVariant.Emphasis] = {
				dot = { tag = "bg-system-emphasis" }
			},
			[StatusBadgeVariant.Success] = {
				dot = { tag = "bg-system-success" }
			},
			[StatusBadgeVariant.Warning] = {
				dot = { tag = "bg-system-warning" }
			},
			[StatusBadgeVariant.Alert] = {
				dot = { tag = "bg-system-alert" }
			}
		},
		shapes = {
			[StatusBadgeShape.Utility] = {},
			[StatusBadgeShape.Box] = {
				container = { tag = "radius-small bg-shift-200" }
			}
		},
		sizes = {
			[StatusBadgeSize.XSmall] = {
				container = { tag = "size-0-400" },
				content = { tag = "gap-xxsmall" },
				dot = { tag = "size-150" },
				text = { tag = "text-caption-small" }
			},
			[StatusBadgeSize.Small] = {
				container = { tag = "size-0-600" },
				content = { gap = p.Size.Size_150 },
				dot = { tag = "size-200" },
				text = { tag = "text-caption-medium" }
			}
		},
		boxSizes = {
			[StatusBadgeSize.XSmall] = {
				container = { tag = "padding-x-xsmall" }
			},
			[StatusBadgeSize.Small] = {
				container = { tag = "padding-x-small" }
			}
		}
	}
end

return function(p, p2, p3, p4)
	local v = VariantsContext.useVariants("StatusBadge", variantsFactory, p)

	local common = v.common
	local variant = v.variants[p2]
	local shape = v.shapes[p3]
	local siz = v.sizes[p4]
	local v2

	if p3 == StatusBadgeShape.Box then
		v2 = v.boxSizes[p4]
	end

	return composeStyleVariant(common, variant, shape, siz, v2)
end
