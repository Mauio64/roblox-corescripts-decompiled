local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local AlertVariant = require(Foundation.Enums.AlertVariant)
local AlertSeverity = require(Foundation.Enums.AlertSeverity)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function createStandardVariantStyles(p1, p2) -- line: 31
	-- upvalues: ColorNamespace (copy)
	return {
		container = {
			tag = "bg-shift-200",
			colorNamespace = ColorNamespace.Color
		},
		title = {
			style = p1.Color.Content.Emphasis
		},
		description = {
			style = p1.Color.Content.Default
		},
		icon = {
			style = p2
		}
	}
end
local function createEmphasisVariantStyles(p3, s1: string, p4) -- line: 43
	return {
		container = {
			tag = s1,
			colorNamespace = p4
		},
		title = {
			style = p3[p4].Content.Emphasis
		},
		description = {
			style = p3[p4].Content.Default
		},
		icon = {
			style = p3[p4].Content.Emphasis
		}
	}
end
local function variantsFactory(p5) -- line: 59
	-- upvalues: AlertVariant (copy), AlertSeverity (copy), createStandardVariantStyles (copy), createEmphasisVariantStyles (copy), ColorNamespace (copy)
	local t1 = {
		container = {
			tag = "row gap-medium size-full-0 auto-y padding-x-medium padding-y-large"
		},
		title = {
			tag = "auto-xy padding-y-xxsmall text-title-medium text-wrap text-align-x-left"
		},
		description = {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left"
		}
	}
	local t2 = {
		[AlertVariant.Standard] = {
			[AlertSeverity.Info] = createStandardVariantStyles(p5, p5.Color.System.Emphasis),
			[AlertSeverity.Warning] = createStandardVariantStyles(p5, p5.Color.System.Warning),
			[AlertSeverity.Success] = createStandardVariantStyles(p5, p5.Color.System.Success),
			[AlertSeverity.Error] = createStandardVariantStyles(p5, p5.Color.System.Alert)
		},
		[AlertVariant.Emphasis] = {
			[AlertSeverity.Info] = createEmphasisVariantStyles(p5, "bg-system-emphasis", ColorNamespace.DarkMode),
			[AlertSeverity.Warning] = createEmphasisVariantStyles(p5, "bg-system-warning", ColorNamespace.LightMode),
			[AlertSeverity.Success] = createEmphasisVariantStyles(p5, "bg-system-success", ColorNamespace.LightMode),
			[AlertSeverity.Error] = createEmphasisVariantStyles(p5, "bg-system-alert", ColorNamespace.DarkMode)
		}
	}

	return {
		common = t1,
		severity = t2
	}
end

return function(p6, p7, p8) -- line: 98
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v21 = VariantsContext.useVariants("SystemBanner", variantsFactory, p6)

	return composeStyleVariant(v21.common, v21.severity[p7][p8])
end
