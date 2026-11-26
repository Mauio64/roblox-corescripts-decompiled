local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local InlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/InlineLayout")
local textElement = InlineLayout.Components.InlineLayoutElements.TextElement
local linkElement = InlineLayout.Components.InlineLayoutElements.LinkElement
local LinkBehavior = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/LinkBehavior")
local InlineCustomRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/InlineCustomRenderer")

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

return function(p2, data)
	local v5 = { textStyle = data.styles.textStyle, showUnderline = true }

	local union = Cryo.Dictionary.union(v5, data.nodeProps or {})

	local href = p2.attributes.href or ""
	local linkBehavior = data.linker.evaluateLinkBehavior(href)

	if linkBehavior == LinkBehavior.Hide then
		return {}
	end

	if linkBehavior == LinkBehavior.Disable then
		return InlineCustomRenderer(Cryo.Dictionary.join(p2, { name = "TEXT_SPAN" }), data)
	end

	local v6 = data.processChildren(p2, data)
	local mapped = Cryo.List.map(v6, function(p3, p4)
		local new = textElement.new

		local v8 = if union.showUnderline then Cryo.List.join({
			{ name = "u", attributes = {} }
		}, p3.engineTags) else p3.engineTags
		return new({
			LayoutOrder = p4,
			EngineTags = v8,
			Text = p3.text,
			fontStyle = data.styles.fontStyle,
			textStyle = Cryo.Dictionary.union(v5.textStyle, union.textStyle)
		})
	end)

	if #mapped > 0 then
		return { linkElement.new(mapped, {
				onActivated = function()
					data.linker.onActivated({ url = href, linkBehavior = linkBehavior })
				end
			}) }
	end

	return {}
end
