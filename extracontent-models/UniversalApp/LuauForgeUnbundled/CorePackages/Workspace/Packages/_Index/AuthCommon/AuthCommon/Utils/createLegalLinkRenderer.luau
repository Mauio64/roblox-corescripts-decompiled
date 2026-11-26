local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local InlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/InlineLayout")
require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/InlineRichText")

local textElement = InlineLayout.Components.InlineLayoutElements.TextElement
local linkElement = InlineLayout.Components.InlineLayoutElements.LinkElement

local v5 = { name = "u", attributes = {} }

local function createLegalLinkRenderer(callback)
	return function(p2, p3)
		local href = p2.attributes.href or ""
		local v6 = p3.processChildren(p2, p3)
		local mapped = Cryo.List.map(v6, function(p4, p5)
			return textElement.new({
				LayoutOrder = p5,
				EngineTags = Cryo.List.join({ v5 }, p4.engineTags),
				Text = p4.text,
				fontStyle = p3.styles.fontStyle,
				textStyle = p3.styles.textStyle
			})
		end)

		if #mapped == 0 then
			return {}
		end

		return { linkElement.new(mapped, {
				onActivated = function()
					callback(href)
				end
			}) }
	end
end

return createLegalLinkRenderer
