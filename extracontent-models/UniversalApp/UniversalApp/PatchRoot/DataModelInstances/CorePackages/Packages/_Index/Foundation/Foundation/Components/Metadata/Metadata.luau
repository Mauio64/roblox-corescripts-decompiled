local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
local MetadataSize = require(Foundation.Enums.MetadataSize)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getMultiLineTextHeight = require(Foundation.Utility.getMultiLineTextHeight)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local MetadataAccessory = require(script.Parent.MetadataAccessory)
local MetadataItems = require(script.Parent.MetadataItems)
local useMetadataVariants = require(script.Parent.useMetadataVariants)

local v = {
	size = MetadataSize.Medium,
	maxLines = 1,
	hasSeparator = true,
	testId = "--foundation-metadata"
}

local function Metadata(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useTextSizeOffset()
	local variantProps = useMetadataVariants(v3, v2.size, not v2.hasSeparator)
	local fontStyle = variantProps.text.fontStyle
	local v5 = type(v2.text) == "string" or v2.text.text ~= nil
	local v6

	if v5 then
		v6 = { v2.text }
	else
		v6 = v2.text
	end

	local items = {}

	for _, text in v6 do
		table.insert(items, type(text) == "string" and { text = text } or text)
	end

	local count = #items
	local truncateIndex = math.clamp(v2.truncateIndex or count, 1, (math.max(count, 1)))
	local maxLines = not v5 and 1 or math.max(v2.maxLines, 1)

	local multiLineTextHeight = getMultiLineTextHeight(
		(fontStyle.FontSize or 0) + v4,
		maxLines,
		fontStyle.LineHeight or 1
	)
	local children = {}

	if Flags.FoundationMetadataTruncateFallback then
		children.Items = React.createElement(MetadataItems, {
			items = items,
			trailing = v2.trailing,
			truncateIndex = truncateIndex,
			maxLines = maxLines,
			textHeight = multiLineTextHeight,
			hasSeparator = v2.hasSeparator,
			size = v2.size,
			variantProps = variantProps,
			testId = v2.testId
		})
	else
		for k, v7 in items do
			if k > 1 and v2.hasSeparator then
				children[`Separator{k - 1}`] = React.createElement(Text, {
					Text = "·",
					tag = variantProps.text.tag,
					LayoutOrder = k * 2 - 1,
					testId = `{v2.testId}--separator-{k - 1}`
				})
			end

			local leading

			if v7.leading then
				leading = React.createElement(MetadataAccessory, {
					config = v7.leading,
					variant = variantProps.accessory,
					LayoutOrder = 1,
					testId = `{v2.testId}--item-{k}--leading`
				})
			end

			local trailing

			if k == count and v2.trailing then
				trailing = React.createElement(MetadataAccessory, {
					config = v2.trailing,
					variant = variantProps.accessory,
					LayoutOrder = 4,
					testId = `{v2.testId}--trailing`
				})
			end

			local formatted = `Item{k}`
			local createElement = React.createElement
			local tag2

			if k == truncateIndex then
				tag2 = variantProps.truncatedItem.tag
			else
				tag2 = variantProps.item.tag
			end

			local v8 = {
				tag = tag2,
				LayoutOrder = k * 2,
				testId = `{v2.testId}--item-{k}`
			}

			local createElement2 = React.createElement
			local v9 = {
				Text = v7.text,
				OpenTypeFeatures = variantProps.text.openTypeFeatures,
				tag = 0,
				sizeConstraint = 0,
				LayoutOrder = 3,
				testId = 0
			}
			local tag

			if maxLines > 1 then
				tag = variantProps.wrappedText.tag
			elseif k == truncateIndex then
				tag = variantProps.truncatedText.tag
			else
				tag = variantProps.text.tag
			end

			v9.tag = tag

			v9.sizeConstraint = maxLines > 1 and {
				MaxSize = Vector2.new(1e999, multiLineTextHeight)
			} or nil

			v9.testId = `{v2.testId}--text-{k}`
			children[formatted] = createElement(View, v8, {
				Leading = leading,
				Text = createElement2(Text, v9),
				Trailing = trailing
			})
		end
	end

	return React.createElement(View, withCommonProps(v2, {
		tag = variantProps.container.tag,
		ref = ref
	}), children)
end

return React.memo(React.forwardRef(Metadata))
