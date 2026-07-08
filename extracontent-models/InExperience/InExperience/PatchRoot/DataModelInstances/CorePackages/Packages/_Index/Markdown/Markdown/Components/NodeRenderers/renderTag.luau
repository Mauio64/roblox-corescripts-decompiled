local Markdown = script:FindFirstAncestor("Markdown")
local MarkdownParent = Markdown.Parent

require(Markdown.Types)

local React = require(MarkdownParent.React)
local Foundation = require(MarkdownParent.Foundation)
local ImageElement = require(MarkdownParent.InlineLayout).Components.InlineLayoutElements.ImageElement
local joinTags = require(Markdown.Utils.joinTags)
local mergeContexts = require(Markdown.Utils.mergeContexts)

local function renderTag(p1, p2) -- line: 12
	-- upvalues: ImageElement (copy), React (copy), joinTags (copy), Foundation (copy), mergeContexts (copy)
	if p1.text == "img" then
		local size = p2.imageStyles.size
		local v12 = if not p1.attributes or not p1.attributes.width then size.Width.Offset else p1.attributes.width
		local v13 = if not p1.attributes or not p1.attributes.height then size.Height.Offset else p1.attributes.height

		if p2.isInline then
			return ImageElement.new({
				LayoutOrder = p1.index,
				Image = (not p1.attributes or not p1.attributes.src) and "" or p1.attributes.src,
				Size = UDim2.fromOffset(v12, v13),
				backgroundStyle = {
					Transparency = p2.imageStyles.backgroundTransparency,
					Color3 = p2.imageStyles.backgroundColor3
				},
				imageStyle = {
					Transparency = p2.imageStyles.transparency
				},
				ScaleType = p2.imageStyles.scaleType,
				ResampleMode = p2.imageStyles.resampleMode,
				tag = p2.imageStyles.tags
			})
		end

		return React.createElement("ImageLabel", {
			key = tostring(p1.index),
			LayoutOrder = p1.index,
			Image = (not p1.attributes or not p1.attributes.src) and "" or p1.attributes.src,
			Size = UDim2.fromOffset(v12, v13),
			BackgroundColor3 = p2.imageStyles.backgroundColor3,
			BackgroundTransparency = p2.imageStyles.backgroundTransparency,
			ImageTransparency = p2.imageStyles.transparency,
			ScaleType = p2.imageStyles.scaleType,
			ResampleMode = p2.imageStyles.resampleMode,
			[React.Tag] = joinTags("X-PadS X-Middle", p2.imageStyles.tags)
		})
	end

	if p1.text == "Button" then
		if not p1.attributes or not p1.attributes.text or not p1.attributes.url then
			warn("Button tag misses required text and url attributes")

			return nil
		end

		return React.createElement(Foundation.Button, {
			tag = "auto-xy",
			key = tostring(p1.index),
			LayoutOrder = p1.index,
			text = p1.attributes.text,
			icon = p1.attributes.icon,
			onActivated = function() -- line: 68
				-- upvalues: p2 (copy), p1 (copy)
				p2.linkCallback(p1.attributes.url)
			end
		})
	end

	if p1.text == "font" then
		local v14 = if not p1.attributes or not p1.attributes.color then nil else p1.attributes.color

		return p2.processChildren(p1, mergeContexts(p2, {
			textStyles = {
				color = v14
			}
		}))
	end

	return nil
end

return renderTag
