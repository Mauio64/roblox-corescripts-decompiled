local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(Markdown.Types)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Dash = require(parent.Dash)
local MarkdownCore = require(parent.MarkdownCore)
local Flags = MarkdownCore.Flags

local InlineLayout = require(parent.InlineLayout)
local ImageElement = InlineLayout.Components.InlineLayoutElements.ImageElement
local joinTags = require(Markdown.Utils.joinTags)
local mergeContexts = require(Markdown.Utils.mergeContexts)
local NodeType = require(Markdown.Enums.NodeType)

local function bold()
	return { bold = true }
end

local function italic()
	return { italic = true }
end

local function strike()
	return { strike = true }
end

local function code(p)
	return Dash.joinDeep(p.codeStyles, { selectable = true })
end

local v = {
	b = bold,
	strong = bold,
	i = italic,
	em = italic,
	s = strike,
	del = strike,
	strike = strike,
	code = code,
	kbd = code
}

local function renderTag(props, props2)
	if props.text == "img" then
		local size = props2.imageStyles.size
		local v2

		if props.attributes and props.attributes.width then
			v2 = props.attributes.width
		else
			v2 = size.Width.Offset
		end

		local v3

		if props.attributes and props.attributes.height then
			v3 = props.attributes.height
		else
			v3 = size.Height.Offset
		end

		if props2.isInline then
			return ImageElement.new({
				LayoutOrder = props.index,
				Image = not (props.attributes and props.attributes.src) and "" or props.attributes.src,
				Size = UDim2.fromOffset(v2, v3),
				backgroundStyle = {
					Transparency = props2.imageStyles.backgroundTransparency,
					Color3 = props2.imageStyles.backgroundColor3
				},
				imageStyle = { Transparency = props2.imageStyles.transparency },
				ScaleType = props2.imageStyles.scaleType,
				ResampleMode = props2.imageStyles.resampleMode,
				tag = props2.imageStyles.tags
			})
		end

		return React.createElement("ImageLabel", {
			key = tostring(props.index),
			LayoutOrder = props.index,
			Image = not (props.attributes and props.attributes.src) and "" or props.attributes.src,
			Size = UDim2.fromOffset(v2, v3),
			BackgroundColor3 = props2.imageStyles.backgroundColor3,
			BackgroundTransparency = props2.imageStyles.backgroundTransparency,
			ImageTransparency = props2.imageStyles.transparency,
			ScaleType = props2.imageStyles.scaleType,
			ResampleMode = props2.imageStyles.resampleMode,
			[React.Tag] = joinTags("X-PadS X-Middle", props2.imageStyles.tags)
		})
	elseif props.text == "Button" then
		if props.attributes and props.attributes.text and props.attributes.url then
			return React.createElement(Foundation.Button, {
				key = tostring(props.index),
				LayoutOrder = props.index,
				text = props.attributes.text,
				icon = props.attributes.icon,
				onActivated = function()
					props2.linkCallback(props.attributes.url)
				end,
				tag = "auto-xy"
			})
		end

		warn("Button tag misses required text and url attributes")
		return nil
	elseif props.text == "font" then
		local color

		if props.attributes and props.attributes.color then
			color = props.attributes.color
		end

		return props2.processChildren(props, mergeContexts(props2, {
			textStyles = { color = color }
		}))
	else
		if not Flags.FFlagMarkdownTagFallbacks then
			return nil
		end

		local href = props.attributes and props.attributes.href

		if props.text == "a" and href and props2.renderers and props2.renderers.LINK then
			return props2.renderers.LINK(Dash.join(props, {
				attributes = Dash.join(props.attributes, { url = href })
			}), props2)
		end

		if props.type ~= NodeType.InlineSpan then
			return React.createElement(
				Foundation.View,
				{
					key = tostring(props.index),
					tag = "size-full-0 auto-y col",
					LayoutOrder = props.index
				},
				(props2.processChildren(props, props2))
			)
		end

		local v2 = v[props.text]
		local textStyles = not v2 and {} or v2(props2)

		return props2.processChildren(props, mergeContexts(props2, { textStyles = textStyles }))
	end
end

return renderTag
