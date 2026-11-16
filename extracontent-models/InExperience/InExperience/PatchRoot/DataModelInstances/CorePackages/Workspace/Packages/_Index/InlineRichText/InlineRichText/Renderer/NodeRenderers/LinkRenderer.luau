local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local Cryo = require(parent.Cryo)
local InlineLayout = require(parent.InlineLayout)
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local LinkBehavior = require(InlineRichText.Enums.LinkBehavior)
local InlineCustomRenderer = require(InlineRichText.Renderer.NodeRenderers.InlineCustomRenderer)

require(InlineRichText.Types)

return function(p, data)
	local v = { textStyle = data.styles.textStyle, showUnderline = true }

	local union = Cryo.Dictionary.union(v, data.nodeProps or {})

	local href = p.attributes.href or ""
	local linkBehavior = data.linker.evaluateLinkBehavior(href)

	if linkBehavior == LinkBehavior.Hide then
		return {}
	end

	if linkBehavior == LinkBehavior.Disable then
		return InlineCustomRenderer(Cryo.Dictionary.join(p, { name = "TEXT_SPAN" }), data)
	end

	local v2 = data.processChildren(p, data)
	local mapped = Cryo.List.map(v2, function(p2, layoutOrder)
		local new = TextElement.new
		local engineTags

		if union.showUnderline then
			engineTags = Cryo.List.join({
				{ name = "u", attributes = {} }
			}, p2.engineTags)
		else
			engineTags = p2.engineTags
		end

		return new({
			LayoutOrder = layoutOrder,
			EngineTags = engineTags,
			Text = p2.text,
			fontStyle = data.styles.fontStyle,
			textStyle = Cryo.Dictionary.union(v.textStyle, union.textStyle)
		})
	end)

	if #mapped > 0 then
		return { LinkElement.new(mapped, {
				onActivated = function()
					data.linker.onActivated({ url = href, linkBehavior = linkBehavior })
				end
			}) }
	end

	return {}
end
