local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

local AlertVariant = require(Foundation.Enums.AlertVariant)

local AlertSeverity = require(Foundation.Enums.AlertSeverity)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function createStandardVariantStyles(p, style)
	return {
		container = { tag = "bg-shift-200", colorNamespace = ColorNamespace.Color },
		title = { style = p.Color.Content.Emphasis },
		description = { style = p.Color.Content.Default },
		icon = { style = style }
	}
end

local function createEmphasisVariantStyles(p, tag: string, colorNamespace)
	return {
		container = { tag = tag, colorNamespace = colorNamespace },
		title = { style = p[colorNamespace].Content.Emphasis },
		description = { style = p[colorNamespace].Content.Default },
		icon = { style = p[colorNamespace].Content.Emphasis }
	}
end

local function variantsFactory(p)
	local severity = {
		[AlertVariant.Standard] = {
			[AlertSeverity.Info] = createStandardVariantStyles(p, p.Color.System.Emphasis),
			[AlertSeverity.Warning] = createStandardVariantStyles(p, p.Color.System.Warning),
			[AlertSeverity.Success] = createStandardVariantStyles(p, p.Color.System.Success),
			[AlertSeverity.Error] = createStandardVariantStyles(p, p.Color.System.Alert)
		}
	}

	local emphasis = AlertVariant.Emphasis
	severity[emphasis] = {
		[AlertSeverity.Info] = createEmphasisVariantStyles(p, "bg-system-emphasis", ColorNamespace.DarkMode),
		[AlertSeverity.Warning] = createEmphasisVariantStyles(p, "bg-system-warning", ColorNamespace.LightMode),
		[AlertSeverity.Success] = createEmphasisVariantStyles(p, "bg-system-success", ColorNamespace.LightMode),
		[AlertSeverity.Error] = createEmphasisVariantStyles(p, "bg-system-alert", ColorNamespace.DarkMode)
	}
	return {
		common = {
			container = {
				tag = "row gap-medium size-full-0 auto-y padding-x-medium padding-y-large"
			},
			title = {
				tag = "auto-xy padding-y-xxsmall text-title-medium text-wrap text-align-x-left"
			},
			description = { tag = "auto-xy text-body-medium text-wrap text-align-x-left" }
		},
		severity = severity
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("SystemBanner", variantsFactory, p)
	return composeStyleVariant(v.common, v.severity[p2][p3])
end
