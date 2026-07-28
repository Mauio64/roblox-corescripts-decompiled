local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)
local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Enums.Radius)

local Flags = require(Foundation.Utility.Flags)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local getInputVariantsFactory = require(Foundation.Components.InputField.getInputVariantsFactory)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function computeProps(t1: {[any]: any}) -- line: 62
	return {
		container = {
			minHeight = t1.minContainerHeight,
			horizontalPadding = UDim.new(0, t1.horizontalPadding),
			radius = t1.radius,
			tag = t1.containerTag
		},
		textBox = {
			fontStyle = t1.typography
		},
		icon = {
			size = t1.iconSize
		},
		clearButton = {
			icon = t1.clearButtonIcon,
			padding = t1.clearButtonPadding
		}
	}
end
local function variantsFactory(p1) -- line: 92
	-- upvalues: InputSize (copy), computeProps (copy), IconSize (copy), BuilderIcons (copy), Flags (copy)
	local t2 = {
		container = {
			tag = "row",
			strokeStyle = p1.Color.Stroke.Emphasis,
			strokeThickness = p1.Stroke.Standard
		},
		textBox = {
			tag = "text-align-x-left text-align-y-center clip content-emphasis gui-object-defaults"
		},
		icon = {
			style = p1.Color.Content.Muted
		},
		clearButton = {
			tag = "auto-xy"
		}
	}
	local t3 = {
		[InputSize.XSmall] = computeProps({
			containerTag = "size-full-600 gap-small",
			radius = p1.Radius.Small,
			horizontalPadding = p1.Padding.XSmall,
			typography = p1.Typography.BodySmall,
			iconSize = IconSize.XSmall,
			minContainerHeight = p1.Size.Size_600,
			clearButtonIcon = BuilderIcons.Icon.XSmall,
			clearButtonPadding = p1.Padding.XSmall
		}),
		[InputSize.Small] = computeProps({
			containerTag = "size-full-800 gap-medium",
			radius = p1.Radius.Medium,
			horizontalPadding = p1.Padding.Small,
			typography = p1.Typography.BodyMedium,
			iconSize = IconSize.XSmall,
			minContainerHeight = p1.Size.Size_800,
			clearButtonIcon = BuilderIcons.Icon.XSmall,
			clearButtonPadding = p1.Size.Size_150
		}),
		[InputSize.Medium] = computeProps({
			containerTag = "size-full-1000 gap-large",
			radius = p1.Radius.Medium,
			horizontalPadding = if not Flags.FoundationNumberInputBeta then p1.Padding.Small else p1.Padding.Medium,
			typography = p1.Typography.BodyMedium,
			iconSize = IconSize.Small,
			minContainerHeight = p1.Size.Size_1000,
			clearButtonIcon = BuilderIcons.Icon.X,
			clearButtonPadding = p1.Padding.Small
		}),
		[InputSize.Large] = computeProps({
			containerTag = "size-full-1200 gap-large",
			radius = p1.Radius.Medium,
			horizontalPadding = p1.Padding.Medium,
			typography = p1.Typography.BodyLarge,
			iconSize = IconSize.Small,
			minContainerHeight = p1.Size.Size_1200,
			clearButtonIcon = BuilderIcons.Icon.X,
			clearButtonPadding = p1.Padding.Small
		})
	}

	return {
		common = t2,
		sizes = t3
	}
end

return function(p2, p3, p4, p5, b1: boolean?, b2: boolean?) -- line: 159
	-- upvalues: VariantsContext (copy), variantsFactory (copy), getInputVariantsFactory (copy), InputVariant (copy), composeStyleVariant (copy)
	local v23 = VariantsContext.useVariants("TextInput", variantsFactory, p2)
	local v24 = VariantsContext.useVariants("InputField", getInputVariantsFactory, p2)
	local v25 = v24.variants[p4 or InputVariant.Standard]

	return composeStyleVariant(v23.common, v24.sizes[p3], v23.sizes[p3], if p4 == InputVariant.Utility then {} else v25, if not p5 then v24.defaultRadius[p3] else v24.radius[p5], if b1 == nil then {} else v24.focusedState[b1], if b2 == nil then {} else v24.errorState[b2], if p4 ~= InputVariant.Utility then {} else v25)
end
