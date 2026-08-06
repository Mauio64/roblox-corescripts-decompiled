local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Constants = require(Foundation.Constants)
local Dash = require(FoundationParent.Dash)

require(Foundation.Components.Types)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Enums.StateLayerMode)
require(Foundation.Utility.composeStyleVariant)
require(Foundation.Providers.Style.Tokens)

local InputSize = require(Foundation.Enums.InputSize)

local function toStroke(p1) -- line: 40
	return {
		Color = p1.Color3,
		Transparency = p1.Transparency
	}
end
local function createButtonVariantStyles(p2, p3, b1: boolean?) -- line: 48
	-- upvalues: ColorNamespace (copy), Dash (copy), Constants (copy)
	local t1 = {}

	for v18 in ColorNamespace do
		local v19 = p2[v18]
		local v20 = if type(p3) ~= "table" then v19[p3] else {
			Foreground = Dash.get(v19, p3)
		}
		local t2 = {}
		local t3 = {
			style = v20.Background
		}
		local t4

		if v20.Border then
			local Border = v20.Border

			t4 = {
				Color = Border.Color3,
				Transparency = Border.Transparency
			}
		else
			t4 = nil
		end

		t3.stroke = t4
		t3.stateLayer = {
			mode = Constants.COLOR_NAMESPACE_TO_STATE_LAYER_MODE[b1 or false][v18]
		}
		t2.container = t3
		t2.content = {
			style = v20.Foreground
		}
		t1[v18] = t2
	end

	return t1
end
local function getButtonTypes(p4) -- line: 89
	-- upvalues: ButtonVariant (copy), createButtonVariantStyles (copy)
	return {
		[ButtonVariant.Utility] = createButtonVariantStyles(p4, "ActionUtility"),
		[ButtonVariant.Standard] = createButtonVariantStyles(p4, "ActionStandard"),
		[ButtonVariant.Emphasis] = createButtonVariantStyles(p4, "ActionEmphasis"),
		[ButtonVariant.Alert] = createButtonVariantStyles(p4, "ActionAlert"),
		[ButtonVariant.SubEmphasis] = createButtonVariantStyles(p4, "ActionSubEmphasis", true),
		[ButtonVariant.SoftEmphasis] = createButtonVariantStyles(p4, "ActionSoftEmphasis"),
		[ButtonVariant.Subtle] = createButtonVariantStyles(p4, "ActionSubtle"),
		[ButtonVariant.Text] = createButtonVariantStyles(p4, {
			"Content",
			"Emphasis"
		}),
		[ButtonVariant.Link] = createButtonVariantStyles(p4, {
			"Content",
			"Link"
		}),
		[ButtonVariant.OverMedia] = createButtonVariantStyles(p4, "ActionOverMedia", true)
	}
end
local function getSizes(p5) -- line: 106
	-- upvalues: InputSize (copy)
	return {
		[InputSize.XSmall] = {
			container = {
				radius = p5.Radius.Small,
				height = p5.Size.Size_600
			}
		},
		[InputSize.Small] = {
			container = {
				radius = p5.Radius.Medium,
				height = p5.Size.Size_800
			}
		},
		[InputSize.Medium] = {
			container = {
				radius = p5.Radius.Medium,
				height = p5.Size.Size_1000
			}
		},
		[InputSize.Large] = {
			container = {
				radius = p5.Radius.Medium,
				height = p5.Size.Size_1200
			}
		}
	}
end
local function getSharedVariants(p6) -- line: 123
	-- upvalues: getSizes (copy), getButtonTypes (copy)
	local v28 = getSizes(p6)
	local v29 = getButtonTypes(p6)

	return {
		sizes = v28,
		types = v29
	}
end

return getSharedVariants
