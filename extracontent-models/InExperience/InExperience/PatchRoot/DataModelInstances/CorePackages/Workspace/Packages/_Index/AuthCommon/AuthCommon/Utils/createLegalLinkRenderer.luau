local parent = script:FindFirstAncestor("AuthCommon").Parent

local Cryo = require(parent.Cryo)
local InlineLayout = require(parent.InlineLayout)
require(parent.InlineRichText)

local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement
local LinkElement = InlineLayout.Components.InlineLayoutElements.LinkElement

local v = { name = "u", attributes = {} }

local function createLegalLinkRenderer(callback)
	return function(p, p2)
		local href = p.attributes.href or ""
		local v2 = p2.processChildren(p, p2)
		local mapped = Cryo.List.map(v2, function(p3, layoutOrder)
			return TextElement.new({
				LayoutOrder = layoutOrder,
				EngineTags = Cryo.List.join({ v }, p3.engineTags),
				Text = p3.text,
				fontStyle = p2.styles.fontStyle,
				textStyle = p2.styles.textStyle
			})
		end)

		if #mapped == 0 then
			return {}
		end

		return { LinkElement.new(mapped, {
				onActivated = function()
					callback(href)
				end
			}) }
	end
end

return createLegalLinkRenderer
