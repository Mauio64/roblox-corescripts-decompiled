local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local AlertSeverity = require(Foundation.Enums.AlertSeverity)

local AlertVariant = require(Foundation.Enums.AlertVariant)

local ColorMode = require(Foundation.Enums.ColorMode)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function createSeverityVariant(p, transparency: number, style, backgroundStyle)
	return {
		container = {
			backgroundStyle = { Color3 = p.Color3, Transparency = transparency }
		},
		icon = { style = style },
		border = { backgroundStyle = backgroundStyle }
	}
end

local function variantsFactory(data)
	local padding = {
		top = UDim.new(0, data.Size.Size_150 + 1)
	}
	local padding2 = {
		top = UDim.new(0, data.Size.Size_150),
		bottom = UDim.new(0, data.Size.Size_150)
	}

	local size_500 = data.Size.Size_500

	local v = {
		tag = "text-body-medium text-wrap text-align-x-left content-emphasis",
		padding = padding
	}

	local common = {
		main = {
			tag = "row align-y-top gap-medium size-full-0 auto-y padding-x-large padding-y-medium"
		},
		stack = { tag = "col fill gap-small auto-y" },
		iconFrame = {
			Size = UDim2.fromOffset(size_500, size_500)
		},
		message = v,
		link = v,
		border = {
			Size = UDim2.new(1, 0, 0, data.Stroke.Standard)
		}
	}

	local severity = {
		[AlertSeverity.Info] = createSeverityVariant(
			data.Color.System.Neutral,
			0.9,
			data.Color.System.Emphasis,
			data.Color.Stroke.Emphasis
		),
		[AlertSeverity.Success] = createSeverityVariant(
			data.Color.System.Success,
			0.9,
			data.Color.System.Success,
			data.Color.Stroke.Emphasis
		),
		[AlertSeverity.Warning] = createSeverityVariant(
			data.Color.System.Warning,
			0.84,
			data.Color.System.Warning,
			data.Color.System.Warning
		),
		[AlertSeverity.Error] = createSeverityVariant(
			data.Color.System.Alert,
			0.84,
			data.Color.System.Alert,
			data.Color.System.Alert
		)
	}

	local variants = {
		[AlertVariant.Feedback] = {
			container = {
				tag = "radius-medium row align-y-top gap-medium size-full-0 auto-y padding-x-large padding-y-medium"
			}
		},
		[AlertVariant.System] = {
			container = { tag = "col size-full-0 auto-y" }
		}
	}

	local v2 = {
		container = { tag = "stroke-standard stroke-emphasis" }
	}

	local strokes = {
		[AlertSeverity.Info] = v2,
		[AlertSeverity.Success] = v2,
		[AlertSeverity.Warning] = {
			container = { tag = "stroke-standard stroke-system-warning" }
		},
		[AlertSeverity.Error] = {
			container = { tag = "stroke-standard stroke-system-alert" }
		}
	}

	local v3 = size_500 - data.Size.Size_100
	local iconBackplate = {
		Size = UDim2.fromOffset(v3, v3),
		Position = UDim2.fromOffset((size_500 - v3) / 2, (size_500 - v3) / 2),
		tag = "radius-circle",
		backgroundStyle = data.Color.Extended.White.White_100
	}

	return {
		common = common,
		severity = severity,
		variants = variants,
		strokes = strokes,
		backplates = {
			[AlertSeverity.Info] = { iconBackplate = iconBackplate },
			[AlertSeverity.Success] = { iconBackplate = iconBackplate },
			[AlertSeverity.Warning] = {},
			[AlertSeverity.Error] = { iconBackplate = iconBackplate }
		},
		isStacked = {
			[false] = {
				message = { tag = "fill auto-y" },
				link = { tag = "auto-xy" },
				linkContainer = { tag = "auto-xy" }
			},
			[true] = {
				message = { tag = "size-full-0 auto-y" },
				link = { tag = "size-full-0 auto-y", padding = padding2 },
				linkContainer = { tag = "size-full-0 auto-y" }
			}
		}
	}
end

local function useAlertVariants(p, p2, p3, flag: boolean)
	local v = VariantsContext.useVariants("Alert", variantsFactory, p)

	local v2 = p.Config.ColorMode.Name == ColorMode.Dark
	return composeStyleVariant(
		v.common,
		v.severity[p2],
		v.variants[p3],
		v.isStacked[flag],
		p3 ~= AlertVariant.Feedback and {} or v.strokes[p2],
		not v2 and {} or v.backplates[p2]
	)
end

return useAlertVariants
