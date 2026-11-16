local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Motion = require(parent.Motion)
local useMotion = Motion.useMotion

local Components = Foundation.Components
local Icon = require(Components.Icon)
local Image = require(Components.Image)
local Text = require(Components.Text)
require(Components.Types)
local View = require(Components.View)

local Constants = require(Foundation.Constants)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon
local normalizeIconName = iconMigrationUtils.normalizeIconName
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useOptionSelectorGroupItemMotionStates = require(script.Parent.useOptionSelectorGroupItemMotionStates)
local useOptionSelectorGroupItemVariants = require(script.Parent.useOptionSelectorGroupItemVariants)

local FillBehavior = require(Foundation.Enums.FillBehavior)

require(Foundation.Enums.IconSize)

local InputSize = require(Foundation.Enums.InputSize)

local OptionSelectorGroupSize = require(Foundation.Enums.OptionSelectorGroupSize)

local Orientation = require(Foundation.Enums.Orientation)

local useOptionSelectorGroup = require(script.Parent.Parent.useOptionSelectorGroup)

local function getTransparency(transparency: number?, transparency2) -- 1 equivalent call inferred from this helper
	return transparency2:map(function(p)
		if transparency == nil then
			return p
		end

		return transparency + (1 - transparency) * p
	end)
end

local function getTextStyle(textTransparency, transparency, color: Color3)
	return React.joinBindings({ textTransparency, transparency }):map(function(list)
		return { Color3 = color, Transparency = list[2] }
	end)
end

local function renderIcon(props)
	if not props.icon then
		return nil
	end

	if not isBuilderOrMigratedIcon(props.icon) then
		local iconExtent = props.iconExtent
		return React.createElement(Image, {
			Image = props.icon,
			Size = UDim2.fromOffset(iconExtent, iconExtent),
			imageStyle = props.transparency:map(function(transparency)
				return { Color3 = props.contentColor, Transparency = transparency }
			end),
			LayoutOrder = props.layoutOrder,
			testId = `{props.testId}--icon`
		})
	end

	local iconName = normalizeIconName(props.icon)

	local v = {
		name = iconName.name,
		size = props.iconSize,
		style = props.transparency:map(function(transparency)
			return { Color3 = props.contentColor, Transparency = transparency }
		end),
		LayoutOrder = props.layoutOrder,
		testId = `{props.testId}--icon`
	}

	if iconName.variant then
		v.variant = iconName.variant
	end

	return React.createElement(Icon, v)
end

local v = { isDisabled = false, size = InputSize.Medium, width = UDim.new(0, 0) }

local function OptionSelectorGroupItem(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useOptionSelectorGroup()

	local v4 = v3.value == v2.value
	local v5

	if v3.size == nil then
		if v2.size == InputSize.Large then
			v5 = OptionSelectorGroupSize.Medium
		else
			v5 = v2.size
		end
	else
		v5 = v3.size
	end

	local v6

	if v3.orientation == Orientation.Vertical then
		v6 = Orientation.Horizontal
	else
		v6 = Orientation.Vertical
	end

	local fillBehavior

	if v3.fillBehavior == nil then
		fillBehavior = v2.fillBehavior
	else
		fillBehavior = v3.fillBehavior
	end

	local v7

	if v6 == Orientation.Horizontal then
		v7 = FillBehavior.Fill
	else
		v7 = fillBehavior or FillBehavior.Fit
	end

	local v8

	if v6 == Orientation.Vertical then
		v8 = v7 == FillBehavior.Fit
	else
		v8 = false
	end

	local udim

	if not v8 then
		udim = UDim2.fromScale(1, 0)
	end

	local v9 = useTokens()
	local v10 = useOptionSelectorGroupItemVariants(v9, v5, v6, v7, v4)

	local color3 = v10.content.Color3
	local v11

	if v10.supportingContent then
		v11 = v10.supportingContent.Color3
	else
		v11 = color3
	end

	local stroke = v10.container.stroke

	local v12 = useOptionSelectorGroupItemMotionStates(0, Constants.DISABLED_TRANSPARENCY)
	local v13, v14 = useMotion(v12.Default)
	local v15, _ = useMotion(v12.Default)

	React.useEffect(function()
		if v2.isDisabled then
			v14(v12.Disabled)
		else
			v14(v12.Default)
		end
	end, { v2.isDisabled })

	local onActivated = React.useCallback(function()
		local onValueChanged = v3.onValueChanged
		local v16

		if v3.value ~= v2.value then
			v16 = v2.value
		end

		onValueChanged(v16)
	end, { v2.isDisabled, v2.value, v3.onValueChanged, v3.value })

	v2.testId = `{v3.testId}--item-{v2.value}`

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v10.container.radius),
			offset = v9.Size.Size_200,
			borderWidth = v9.Stroke.Thicker
		}
	end, { v9, v10.container.radius })
	local v16 = {
		Icon = renderIcon({
			icon = v2.icon,
			iconExtent = v10.icon.extent,
			iconSize = v10.icon.size,
			contentColor = color3,
			transparency = v13.transparency,
			layoutOrder = 1,
			testId = v2.testId
		}),
		Text = 0
	}

	local createElement = React.createElement
	local v17 = { tag = v10.textContainer.tag, LayoutOrder = 2, testId = `{v2.testId}--body` }
	local v18 = {
		Label = React.createElement(Text, {
			Text = escapeRichText(v2.label or v2.value),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			tag = v10.label.tag,
			textStyle = getTextStyle(v15.textTransparency, v13.transparency, color3),
			LayoutOrder = 1,
			testId = `{v2.testId}--label`
		}),
		Metadata = 0,
		Description = 0
	}
	local metadata

	if v2.metadata then
		metadata = React.createElement(Text, {
			Text = escapeRichText(v2.metadata),
			TextTruncate = Enum.TextTruncate.None,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			tag = v10.metadata.tag,
			textStyle = getTextStyle(v15.textTransparency, v13.transparency, v11),
			LayoutOrder = 2,
			testId = `{v2.testId}--metadata`
		})
	end

	v18.Metadata = metadata
	local description

	if v2.description then
		description = React.createElement(Text, {
			Text = escapeRichText(v2.description),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			tag = v10.description.tag,
			textStyle = getTextStyle(v15.textTransparency, v13.transparency, v11),
			LayoutOrder = 3,
			testId = `{v2.testId}--description`
		})
	end

	v18.Description = description
	v16.Text = createElement(View, v17, v18)

	return React.createElement(View, withCommonProps(v2, {
		stroke = {
			Color = stroke.Color3,
			Transparency = getTransparency(stroke.Transparency, v13.transparency) -- inferred equivalent call
		},
		Size = udim,
		padding = v10.container.padding,
		selection = {
			Selectable = not v2.isDisabled and v3.Selectable
		},
		cursor = cursor,
		onActivated = onActivated,
		isDisabled = v2.isDisabled,
		tag = v10.container.tag,
		ref = ref
	}), {
		ItemInner = React.createElement(
			View,
			{ tag = v10.itemInner.tag, Size = udim, testId = `{v2.testId}--content` },
			v16
		)
	})
end

return React.memo(React.forwardRef(OptionSelectorGroupItem))
