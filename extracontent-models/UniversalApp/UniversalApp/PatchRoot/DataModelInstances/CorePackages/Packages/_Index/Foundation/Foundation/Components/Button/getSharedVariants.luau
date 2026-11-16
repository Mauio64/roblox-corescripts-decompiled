local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Constants = require(Foundation.Constants)
local Dash = require(parent.Dash)
require(Foundation.Components.Types)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Enums.StateLayerMode)

require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local InputSize = require(Foundation.Enums.InputSize)

local function toStroke(border) -- 1 equivalent call inferred from this helper
	return { Color = border.Color3, Transparency = border.Transparency }
end

local function createButtonVariantStyles(p, p2, flag: boolean?)
	local buttonVariantStyles = {}

	for k in ColorNamespace do
		local v = p[k]
		local v2

		if (type)(p2) == "table" then
			v2 = { Foreground = Dash.get(v, p2) }
		else
			v2 = v[p2]
		end

		local container = { style = v2.Background, stroke = 0, stateLayer = 0 }
		local stroke

		if v2.Border then
			stroke = toStroke(v2.Border) -- inferred equivalent call
		end

		container.stroke = stroke
		container.stateLayer = {
			mode = Constants.COLOR_NAMESPACE_TO_STATE_LAYER_MODE[flag or false][k]
		}
		buttonVariantStyles[k] = {
			container = container,
			content = { style = v2.Foreground }
		}
	end

	return buttonVariantStyles
end

local function getButtonTypes(p)
	return {
		[ButtonVariant.Utility] = createButtonVariantStyles(p, "ActionUtility"),
		[ButtonVariant.Standard] = createButtonVariantStyles(p, "ActionStandard"),
		[ButtonVariant.Emphasis] = createButtonVariantStyles(p, "ActionEmphasis"),
		[ButtonVariant.Alert] = createButtonVariantStyles(p, "ActionAlert"),
		[ButtonVariant.SubEmphasis] = createButtonVariantStyles(p, "ActionSubEmphasis", true),
		[ButtonVariant.SoftEmphasis] = createButtonVariantStyles(p, "ActionSoftEmphasis"),
		[ButtonVariant.Subtle] = createButtonVariantStyles(p, "ActionSubtle"),
		[ButtonVariant.Text] = createButtonVariantStyles(p, { "Content", "Emphasis" }),
		[ButtonVariant.Link] = createButtonVariantStyles(p, { "Content", "Link" }),
		[ButtonVariant.OverMedia] = createButtonVariantStyles(p, "ActionOverMedia", true)
	}
end

local function getSizes(p)
	return {
		[InputSize.XSmall] = {
			container = { radius = p.Radius.Small, height = p.Size.Size_600 }
		},
		[InputSize.Small] = {
			container = { radius = p.Radius.Medium, height = p.Size.Size_800 }
		},
		[InputSize.Medium] = {
			container = { radius = p.Radius.Medium, height = p.Size.Size_1000 }
		},
		[InputSize.Large] = {
			container = { radius = p.Radius.Medium, height = p.Size.Size_1200 }
		}
	}
end

local function getSharedVariants(p)
	return { sizes = getSizes(p), types = getButtonTypes(p) }
end

return getSharedVariants
