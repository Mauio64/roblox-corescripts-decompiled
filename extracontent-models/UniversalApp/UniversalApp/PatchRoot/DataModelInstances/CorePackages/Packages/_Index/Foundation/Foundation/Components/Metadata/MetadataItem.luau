local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local AccessoryType = require(Foundation.Enums.AccessoryType)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local MetadataAccessory = require(script.Parent.MetadataAccessory)
require(script.Parent.useMetadataVariants)

local function MetadataItem(props)
	local v = React.useCallback(function(value)
		if value == nil then
			return 0
		end

		local v

		if type(value) == "string" or value.type ~= AccessoryType.Avatar then
			v = props.variantProps.accessory.width
		else
			v = props.variantProps.accessory.avatarWidth
		end

		return v + props.variantProps.item.gap
	end, { props.variantProps.accessory, props.variantProps.item.gap })
	local v2

	if props.minTextWidth then
		v2 = props.minTextWidth + v(props.leading) + v(props.trailing)
	end

	local createElement = React.createElement
	local v3 = {
		tag = props.variantProps.item.tag,
		flexItem = props.shrinkRatio and {
			FlexMode = Enum.UIFlexMode.Custom,
			ShrinkRatio = props.shrinkRatio,
			GrowRatio = 0
		} or nil,
		sizeConstraint = v2 and { MinSize = Vector2.new(v2, 0) } or nil,
		LayoutOrder = props.LayoutOrder,
		testId = `{props.testId}--item-{props.index}`
	}
	local leading

	if props.leading then
		leading = React.createElement(MetadataAccessory, {
			config = props.leading,
			variant = props.variantProps.accessory,
			LayoutOrder = 1,
			testId = `{props.testId}--item-{props.index}--leading`
		})
	end

	local createElement2 = React.createElement
	local v5 = {
		Text = props.text,
		OpenTypeFeatures = props.variantProps.text.openTypeFeatures,
		tag = 0,
		sizeConstraint = 0,
		onAbsoluteSizeChanged = 0,
		LayoutOrder = 3,
		testId = 0
	}
	local tag

	if props.isWrapped then
		tag = props.variantProps.wrappedText.tag
	elseif props.shrinkRatio then
		tag = props.variantProps.truncatedText.tag
	else
		tag = props.variantProps.text.tag
	end

	v5.tag = tag

	v5.sizeConstraint = props.isWrapped and {
		MaxSize = Vector2.new(1e999, props.textHeight)
	} or nil
	v5.onAbsoluteSizeChanged = props.onTextSizeChanged

	v5.testId = `{props.testId}--text-{props.index}`
	local v4 = { Leading = leading, Text = createElement2(Text, v5), Trailing = 0 }
	local trailing

	if props.trailing then
		trailing = React.createElement(MetadataAccessory, {
			config = props.trailing,
			variant = props.variantProps.accessory,
			LayoutOrder = 4,
			testId = `{props.testId}--trailing`
		})
	end

	v4.Trailing = trailing
	return createElement(View, v3, v4)
end

return React.memo(MetadataItem)
