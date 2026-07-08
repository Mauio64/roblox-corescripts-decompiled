local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local Cryo = require(InlineRichTextParent.Cryo)
local InlineLayout = require(InlineRichTextParent.InlineLayout)
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local LinkBehavior = require(InlineRichText.Enums.LinkBehavior)
local InlineCustomRenderer = require(InlineRichText.Renderer.NodeRenderers.InlineCustomRenderer)

require(InlineRichText.Types)

return function(p1, p2) -- line: 13
	-- upvalues: Cryo (copy), LinkBehavior (copy), InlineCustomRenderer (copy), TextElement (copy), LinkElement (copy)
	local t1 = {
		showUnderline = true,
		textStyle = p2.styles.textStyle
	}
	local v12 = Cryo.Dictionary.union(t1, p2.nodeProps or {})
	local v13 = p1.attributes.href or ""
	local v14 = p2.linker.evaluateLinkBehavior(v13)

	if v14 == LinkBehavior.Hide then
		return {}
	end

	if v14 == LinkBehavior.Disable then
		return InlineCustomRenderer(Cryo.Dictionary.join(p1, {
			name = "TEXT_SPAN"
		}), p2)
	end

	local v15 = p2.processChildren(p1, p2)
	local v16 = Cryo.List.map(v15, function(p3, p4) -- line: 30
		-- upvalues: TextElement (copy), v12 (copy), Cryo (copy), p2 (copy), t1 (copy)
		return TextElement.new({
			LayoutOrder = p4,
			EngineTags = if not v12.showUnderline then p3.engineTags else Cryo.List.join({{
				name = "u",
				attributes = {}
			}}, p3.engineTags),
			Text = p3.text,
			fontStyle = p2.styles.fontStyle,
			textStyle = Cryo.Dictionary.union(t1.textStyle, v12.textStyle)
		})
	end)

	if #v16 > 0 then
		return { LinkElement.new(v16, {
			onActivated = function() -- line: 44
				-- upvalues: p2 (copy), v13 (copy), v14 (copy)
				p2.linker.onActivated({
					url = v13,
					linkBehavior = v14
				})
			end
		}) }
	end

	return {}
end
