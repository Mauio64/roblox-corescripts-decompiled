local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local AlertSeverity = require(Foundation.Enums.AlertSeverity)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function createSeverityStyles(_, style)
	return {
		icon = { style = style },
		stroke = { Color = style.Color3, Transparency = style.Transparency, Thickness = 1 },
		backgroundStyle = { Color3 = style.Color3, Transparency = 0.95 }
	}
end

local function variantsFactory(p)
	return {
		common = {
			container = {
				tag = "col align-x-left align-y-center gap-medium size-full-0 auto-y padding-large radius-medium"
			},
			headerRow = { tag = "row align-y-center gap-medium size-full-0 auto-y" },
			title = {
				tag = "shrink auto-xy text-title-medium text-truncate-split content-emphasis"
			},
			subtitle = {
				tag = "shrink auto-xy text-body-medium text-truncate-split content-default"
			},
			description = {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left text-truncate-split content-default"
			},
			link = { tag = "shrink auto-xy text-body-medium text-truncate-split content-emphasis" }
		},
		severity = {
			[AlertSeverity.Info] = createSeverityStyles(p, p.Color.System.Emphasis),
			[AlertSeverity.Warning] = createSeverityStyles(p, p.Color.System.Warning),
			[AlertSeverity.Success] = createSeverityStyles(p, p.Color.System.Success),
			[AlertSeverity.Error] = createSeverityStyles(p, p.Color.System.Alert)
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("FeedbackAlert", variantsFactory, p)
	return composeStyleVariant(v.common, v.severity[p2])
end
