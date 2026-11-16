local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Accessory = require(script.Parent.Accessory)

local IconPosition = require(Foundation.Enums.IconPosition)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)

require(Foundation.Enums.CursorType)

local ChipSize = require(Foundation.Enums.ChipSize)

local ChipVariant = require(Foundation.Enums.ChipVariant)

local useChipVariants = require(script.Parent.useChipVariants)

local v = {
	isChecked = false,
	Selectable = true,
	isDisabled = false,
	size = ChipSize.Medium,
	variant = ChipVariant.Standard,
	testId = "--foundation-chip"
}

local function Chip(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = useTokens()
	local config, config2 = React.useMemo(function()
		local v4 = v2.leading
		local v5 = v2.trailing

		if v2.icon ~= nil then
			if typeof(v2.icon) == "string" then
				v4 = { iconName = v2.icon }
			else
				local v6 = { iconName = v2.icon.name }

				if v2.icon.position == IconPosition.Left then
					v4 = v6
				else
					v5 = v6
				end
			end
		end

		if typeof(v4) == "table" and v4.isCircular then
			v4.iconVariant = IconVariant.Filled
		end

		if typeof(v5) == "table" and v5.isCircular then
			v5.iconVariant = IconVariant.Filled
		end

		return v4, v5
	end, { v2.leading, v2.icon, v2.trailing })
	local v4

	if v2.text == nil then
		v4 = false
	else
		v4 = v2.text ~= ""
	end

	local isIconOnly

	if Flags.FoundationFixChipAccessoryLayout then
		isIconOnly = not v4 and (config == nil) ~= (config2 == nil)
	end

	local v5 = useChipVariants(v3, v2.size, v2.variant, v2.isChecked, config ~= nil, config2 ~= nil)
	local thicker = math.floor(v3.Stroke.Thicker)

	local v6 = React.useMemo(function()
		local colorNamespace

		if v2.isChecked then
			colorNamespace = ColorNamespace.Inverse
		else
			colorNamespace = ColorNamespace.Color
		end

		return { colorNamespace = colorNamespace, isIconSize = true }
	end, { v2.isChecked })

	local createElement = React.createElement

	local v7 = withCommonProps(v2, {
		isDisabled = v2.isDisabled,
		selection = {
			Selectable = not v2.isDisabled and v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = v2.NextSelectionRight
		},
		onActivated = v2.onActivated,
		stateLayer = v2.isChecked and { mode = StateLayerMode.Inverse } or nil,
		backgroundStyle = v5.chip.backgroundStyle,
		padding = v5.chip.padding,
		cursor = {
			radius = UDim.new(0, v3.Radius.Circle),
			offset = thicker * 2,
			borderWidth = thicker
		},
		tag = v5.chip.tag,
		ref = ref,
		GroupTransparency = not v2.isDisabled and 0 or Constants.DISABLED_TRANSPARENCY
	})

	local createElement2 = React.createElement
	local provider = PresentationContext.Provider
	local leading

	if config then
		leading = React.createElement(Accessory, {
			isLeading = true,
			config = config,
			size = v2.size,
			chipBackgroundStyle = v5.chip.backgroundStyle,
			contentStyle = v5.text.contentStyle,
			isDisabled = v2.isDisabled,
			isIconOnly = isIconOnly,
			testId = `{v2.testId}--leading-accessory`
		})
	end

	local text

	if v4 then
		text = React.createElement(Text, {
			Text = v2.text,
			textStyle = v5.text.contentStyle,
			LayoutOrder = 2,
			tag = v5.text.tag,
			padding = v5.text.padding,
			testId = `{v2.testId}--text`
		})
	end

	local trailing

	if config2 then
		trailing = React.createElement(Accessory, {
			isLeading = false,
			config = config2,
			size = v2.size,
			chipBackgroundStyle = v5.chip.backgroundStyle,
			contentStyle = v5.text.contentStyle,
			isDisabled = v2.isDisabled,
			isIconOnly = isIconOnly,
			testId = `{v2.testId}--trailing-accessory`
		})
	end

	return createElement(
		View,
		v7,
		createElement2(provider, { value = v6 }, {
			Leading = leading,
			Text = text,
			Trailing = trailing
		})
	)
end

return React.memo(React.forwardRef(Chip))
