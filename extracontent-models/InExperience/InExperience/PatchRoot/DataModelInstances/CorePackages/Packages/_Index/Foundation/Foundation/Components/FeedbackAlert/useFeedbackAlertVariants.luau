local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local AlertSeverity = require(Foundation.Enums.AlertSeverity)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function createSeverityStyles(_, p2) -- line: 34
	return {
		icon = {
			style = p2
		},
		stroke = {
			Thickness = 1,
			Color = p2.Color3,
			Transparency = p2.Transparency
		},
		backgroundStyle = {
			Transparency = 0.95,
			Color3 = p2.Color3
		}
	}
end
local function variantsFactory(p3) -- line: 49
	-- upvalues: AlertSeverity (copy), createSeverityStyles (copy)
	local t1 = {
		container = {
			tag = "col align-x-left align-y-center gap-medium size-full-0 auto-y padding-large radius-medium"
		},
		headerRow = {
			tag = "row align-y-center gap-medium size-full-0 auto-y"
		},
		title = {
			tag = "shrink auto-xy text-title-medium text-truncate-split content-emphasis"
		},
		subtitle = {
			tag = "shrink auto-xy text-body-medium text-truncate-split content-default"
		},
		description = {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left text-truncate-split content-default"
		},
		link = {
			tag = "shrink auto-xy text-body-medium text-truncate-split content-emphasis"
		}
	}
	local t2 = {
		[AlertSeverity.Info] = createSeverityStyles(p3, p3.Color.System.Emphasis),
		[AlertSeverity.Warning] = createSeverityStyles(p3, p3.Color.System.Warning),
		[AlertSeverity.Success] = createSeverityStyles(p3, p3.Color.System.Success),
		[AlertSeverity.Error] = createSeverityStyles(p3, p3.Color.System.Alert)
	}

	return {
		common = t1,
		severity = t2
	}
end

return function(p4, p5) -- line: 81
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v14 = VariantsContext.useVariants("FeedbackAlert", variantsFactory, p4)

	return composeStyleVariant(v14.common, v14.severity[p5])
end
