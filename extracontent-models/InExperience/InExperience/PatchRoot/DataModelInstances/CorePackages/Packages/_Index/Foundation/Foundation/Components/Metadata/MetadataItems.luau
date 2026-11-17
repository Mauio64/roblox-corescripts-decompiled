local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.MetadataSize)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)

local MetadataItem = require(script.Parent.MetadataItem)
require(script.Parent.useMetadataVariants)
local useTruncationFallback = require(script.Parent.useTruncationFallback)

local function MetadataItems(props)
	local count = #props.items
	local v = React.useMemo(function()
		local result = { [props.truncateIndex] = 0 }
		local v = 1

		for i = 1, count do
			if i == props.truncateIndex then
				continue
			end

			result[i] = v
			v += 1
		end

		return result
	end, { count, props.truncateIndex })
	local v2 = useTextSizeOffset()
	local v3 = useTruncationFallback(React.useMemo(function()
		local v3 = {}

		for _, item in props.items do
			local leading = item.leading
			table.insert(
				v3,
				`{leading == nil and "" or type(leading) == "string" and "icon" or leading.type}:{item.text}`
			)
		end

		return table.concat({
			tostring(props.truncateIndex),
			props.size,
			tostring(props.hasSeparator),
			tostring(props.trailing ~= nil),
			tostring(v2),
			table.concat(v3, "\0")
		}, "|")
	end, { props.items, props.truncateIndex, props.size, props.hasSeparator, props.trailing, v2 }), count, props.variantProps.text.fontStyle)
	local v4 = React.useMemo(function()
		local result = {}

		for i = 0, count - 1 do
			result[i] = function(p)
				v3.onSizeChanged(i, p)
			end
		end

		return result
	end, { count, v3.onSizeChanged })
	local children = {}

	for k, item in props.items do
		local v5 = v[k]
		local shrinkRatio = v3.getShrinkRatio(v5)

		if k > 1 and props.hasSeparator then
			children[`Separator{k - 1}`] = React.createElement(Text, {
				Text = "·",
				tag = props.variantProps.text.tag,
				LayoutOrder = k * 2 - 1,
				testId = `{props.testId}--separator-{k - 1}`
			})
		end

		local v6

		if count > 1 then
			v6 = shrinkRatio ~= nil
		else
			v6 = false
		end

		local formatted = `Item{k}`
		local createElement = React.createElement
		local v7 = {
			index = k,
			text = item.text,
			leading = item.leading,
			trailing = 0,
			variantProps = 0,
			isWrapped = 0,
			textHeight = 0,
			shrinkRatio = 0,
			minTextWidth = 0,
			onTextSizeChanged = 0,
			LayoutOrder = 0,
			testId = 0
		}
		local trailing

		if k == count then
			trailing = props.trailing
		end

		v7.trailing = trailing
		v7.variantProps = props.variantProps
		v7.isWrapped = props.maxLines > 1
		v7.textHeight = props.textHeight
		v7.shrinkRatio = shrinkRatio
		local minTextWidth

		if v6 and v3.isPinned(v5) then
			minTextWidth = v3.minWidth
		end

		v7.minTextWidth = minTextWidth
		local onTextSizeChanged

		if v6 and v3.isDeciding(v5) then
			onTextSizeChanged = v4[v5]
		end

		v7.onTextSizeChanged = onTextSizeChanged

		v7.LayoutOrder = k * 2
		v7.testId = props.testId
		children[formatted] = createElement(MetadataItem, v7)
	end

	return React.createElement(React.Fragment, nil, children)
end

return MetadataItems
