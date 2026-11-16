local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

local InputSize = require(Foundation.Enums.InputSize)

local ShortcutVariant = require(Foundation.Enums.ShortcutVariant)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	return {
		common = {
			container = { tag = "auto-xy", gap = data.Size.Size_150 },
			keys = { tag = "row align-y-center auto-xy" },
			cap = { tag = "row align-x-center align-y-center auto-x" },
			capless = { tag = "row align-x-center align-y-center auto-xy" },
			text = { tag = "auto-xy text-align-x-center" },
			separator = { tag = "auto-x padding-x-xxsmall text-align-x-center content-emphasis" },
			keybinding = { tag = "auto-xy text-align-x-left content-default" },
			icon = { size = IconSize.XSmall },
			gamepadIcon = { style = data.Color.Content.Emphasis }
		},
		sizes = {
			[InputSize.XSmall] = {
				keys = { tag = "gap-xxsmall" },
				cap = { tag = "size-400 radius-xsmall" },
				capWide = { padding = data.Padding.XSmall },
				text = { tag = "text-caption-small" },
				separator = { tag = "size-0-400 text-label-small" },
				keybinding = { tag = "text-label-small" },
				gamepadIcon = { size = data.Size.Size_400 }
			},
			[InputSize.Small] = {
				keys = { tag = "gap-xsmall" },
				cap = { tag = "size-500 radius-small" },
				capWide = { padding = data.Size.Size_150 },
				text = { tag = "text-caption-small" },
				separator = { tag = "size-0-500 text-label-medium" },
				keybinding = { tag = "text-label-medium" },
				gamepadIcon = { size = data.Size.Size_500 }
			},
			[InputSize.Medium] = {
				container = { gap = data.Size.Size_200 },
				keys = { tag = "gap-xsmall" },
				cap = { tag = "size-600 radius-small" },
				capWide = { padding = data.Padding.Small },
				text = { tag = "text-caption-medium" },
				separator = { tag = "size-0-600 text-label-large" },
				keybinding = { tag = "text-label-medium" },
				icon = { size = IconSize.Small },
				gamepadIcon = { size = data.Size.Size_600 }
			}
		},
		variants = {
			[ShortcutVariant.Standard] = {
				cap = { tag = "bg-shift-200" },
				text = { tag = "content-emphasis" },
				icon = { style = data.Color.Content.Emphasis }
			},
			[ShortcutVariant.Contrast] = {
				cap = { tag = "bg-system-contrast" },
				text = { tag = "content-inverse-emphasis" },
				icon = { style = data.Inverse.Content.Emphasis }
			}
		}
	}
end

local function useShortcutVariants(p, p2, p3)
	local v = VariantsContext.useVariants("Shortcut", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.variants[p3])
end

return useShortcutVariants
