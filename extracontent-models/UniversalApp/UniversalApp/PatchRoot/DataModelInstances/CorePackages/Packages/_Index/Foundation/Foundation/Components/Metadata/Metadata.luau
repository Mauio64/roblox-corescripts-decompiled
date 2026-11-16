local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local AccessoryType = require(Foundation.Enums.AccessoryType)
local AvatarIcon = require(Foundation.Components.AvatarIcon)
local Icon = require(Foundation.Components.Icon)
local MetadataSize = require(Foundation.Enums.MetadataSize)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getMultiLineTextHeight = require(Foundation.Utility.getMultiLineTextHeight)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useMetadataVariants = require(script.Parent.useMetadataVariants)

local v = {
	size = MetadataSize.Medium,
	maxLines = 1,
	hasSeparator = true,
	testId = "--foundation-metadata"
}

local function MetadataAccessoryElement(props)
	local variant = props.variant
	local v2

	if type(props.config) == "string" then
		v2 = { iconName = props.config }
	else
		v2 = props.config
	end

	if v2.type == AccessoryType.Avatar then
		return React.createElement(View, {
			tag = variant.avatarTag,
			LayoutOrder = props.LayoutOrder
		}, {
			Avatar = React.createElement(AvatarIcon, {
				userId = v2.userId,
				size = variant.avatarSize,
				testId = props.testId
			})
		})
	end

	return React.createElement(Icon, {
		name = v2.iconName,
		variant = v2.iconVariant,
		size = variant.iconSize,
		style = variant.style,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

local function Metadata(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useTextSizeOffset()
	local v5 = useMetadataVariants(v3, v2.size, not v2.hasSeparator)
	local fontStyle = v5.text.fontStyle
	local v6 = type(v2.text) == "string" or v2.text.text ~= nil
	local v7

	if v6 then
		v7 = { v2.text }
	else
		v7 = v2.text
	end

	local v8 = {}

	for _, text in v7 do
		table.insert(v8, type(text) == "string" and { text = text } or text)
	end

	local count = #v8
	local v9 = math.clamp(v2.truncateIndex or count, 1, (math.max(count, 1)))
	local v10 = not v6 and 1 or math.max(v2.maxLines, 1)

	local multiLineTextHeight = getMultiLineTextHeight((fontStyle.FontSize or 0) + v4, v10, fontStyle.LineHeight or 1)
	local children = {}

	for k, v11 in v8 do
		if k > 1 and v2.hasSeparator then
			children[`Separator{k - 1}`] = React.createElement(Text, {
				Text = "·",
				tag = v5.text.tag,
				LayoutOrder = k * 2 - 1,
				testId = `{v2.testId}--separator-{k - 1}`
			})
		end

		local leading

		if v11.leading then
			leading = React.createElement(MetadataAccessoryElement, {
				config = v11.leading,
				variant = v5.accessory,
				LayoutOrder = 1,
				testId = `{v2.testId}--item-{k}--leading`
			})
		end

		local trailing

		if k == count and v2.trailing then
			trailing = React.createElement(MetadataAccessoryElement, {
				config = v2.trailing,
				variant = v5.accessory,
				LayoutOrder = 4,
				testId = `{v2.testId}--trailing`
			})
		end

		local formatted = `Item{k}`
		local createElement = React.createElement
		local tag2

		if k == v9 then
			tag2 = v5.truncatedItem.tag
		else
			tag2 = v5.item.tag
		end

		local v12 = {
			tag = tag2,
			LayoutOrder = k * 2,
			testId = `{v2.testId}--item-{k}`
		}

		local createElement2 = React.createElement
		local v13 = {
			Text = v11.text,
			OpenTypeFeatures = v5.text.openTypeFeatures,
			tag = 0,
			sizeConstraint = 0,
			LayoutOrder = 3,
			testId = 0
		}
		local tag

		if v10 > 1 then
			tag = v5.wrappedText.tag
		else
			tag = if k == v9 then v5.truncatedText.tag else v5.text.tag
		end

		v13.tag = tag

		v13.sizeConstraint = v10 > 1 and {
			MaxSize = Vector2.new(1e999, multiLineTextHeight)
		} or nil

		v13.testId = `{v2.testId}--text-{k}`
		children[formatted] = createElement(View, v12, {
			Leading = leading,
			Text = createElement2(Text, v13),
			Trailing = trailing
		})
	end

	return React.createElement(View, withCommonProps(v2, { tag = v5.container.tag, ref = ref }), children)
end

return React.memo(React.forwardRef(Metadata))
