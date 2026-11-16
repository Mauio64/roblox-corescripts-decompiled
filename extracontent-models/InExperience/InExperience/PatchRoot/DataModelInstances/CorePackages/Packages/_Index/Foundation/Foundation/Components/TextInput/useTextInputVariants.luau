local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)

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

local function computeProps(data)
	return {
		container = {
			minHeight = data.minContainerHeight,
			horizontalPadding = UDim.new(0, data.horizontalPadding),
			radius = data.radius,
			tag = data.containerTag
		},
		textBox = { fontStyle = data.typography },
		icon = { size = data.iconSize },
		clearButton = { icon = data.clearButtonIcon, padding = data.clearButtonPadding }
	}
end

local function variantsFactory(data)
	local fgStyle

	if Flags.FoundationFixColorOnScrubbableNumberInput then
		fgStyle = data.Color.Shift.Shift_200
	end

	return {
		common = {
			container = {
				fgStyle = fgStyle,
				strokeStyle = data.Color.Stroke.Emphasis,
				strokeThickness = data.Stroke.Standard,
				tag = "row"
			},
			textBox = {
				tag = "text-align-x-left text-align-y-center clip content-emphasis gui-object-defaults"
			},
			icon = { style = data.Color.Content.Muted },
			clearButton = { tag = "auto-xy" }
		},
		sizes = {
			[InputSize.XSmall] = computeProps({
				radius = data.Radius.Small,
				containerTag = "size-full-600 gap-small",
				horizontalPadding = data.Padding.XSmall,
				typography = data.Typography.BodySmall,
				iconSize = IconSize.XSmall,
				minContainerHeight = data.Size.Size_600,
				clearButtonIcon = BuilderIcons.Icon.XSmall,
				clearButtonPadding = data.Padding.XSmall
			}),
			[InputSize.Small] = computeProps({
				radius = data.Radius.Medium,
				containerTag = "size-full-800 gap-medium",
				horizontalPadding = data.Padding.Small,
				typography = data.Typography.BodyMedium,
				iconSize = IconSize.XSmall,
				minContainerHeight = data.Size.Size_800,
				clearButtonIcon = BuilderIcons.Icon.XSmall,
				clearButtonPadding = data.Size.Size_150
			}),
			[InputSize.Medium] = computeProps({
				radius = data.Radius.Medium,
				containerTag = "size-full-1000 gap-large",
				horizontalPadding = data.Padding.Medium,
				typography = data.Typography.BodyMedium,
				iconSize = IconSize.Small,
				minContainerHeight = data.Size.Size_1000,
				clearButtonIcon = BuilderIcons.Icon.X,
				clearButtonPadding = data.Padding.Small
			}),
			[InputSize.Large] = computeProps({
				radius = data.Radius.Medium,
				containerTag = "size-full-1200 gap-large",
				horizontalPadding = data.Padding.Medium,
				typography = data.Typography.BodyLarge,
				iconSize = IconSize.Small,
				minContainerHeight = data.Size.Size_1200,
				clearButtonIcon = BuilderIcons.Icon.X,
				clearButtonPadding = data.Padding.Small
			})
		}
	}
end

return function(p, p2, p3, p4, flag: boolean?, flag2: boolean?)
	local v = VariantsContext.useVariants("TextInput", variantsFactory, p)
	local v2 = VariantsContext.useVariants("InputField", getInputVariantsFactory, p)

	local variant = v2.variants[p3 or InputVariant.Standard]

	local common = v.common
	local siz = v2.sizes[p2]
	local siz2 = v.sizes[p2]
	local v3 = p3 == InputVariant.Utility and {} or variant
	local v4

	if p4 then
		v4 = v2.radius[p4]
	else
		v4 = v2.defaultRadius[p2]
	end

	return composeStyleVariant(
		common,
		siz,
		siz2,
		v3,
		v4,
		flag == nil and {} or v2.focusedState[flag],
		flag2 == nil and {} or v2.errorState[flag2],
		p3 ~= InputVariant.Utility and {} or variant
	)
end
