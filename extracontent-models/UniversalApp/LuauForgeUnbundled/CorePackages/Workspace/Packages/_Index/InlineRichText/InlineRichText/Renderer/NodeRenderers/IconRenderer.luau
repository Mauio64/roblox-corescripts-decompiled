local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Foundation")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("IconRenderer")

local isBuilderIcon = Foundation.Utility.isBuilderIcon

local IconElement = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/InlineElements/IconElement")

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

return function(p2, p3)
	local name = p2.attributes.name

	if not name then
		v5:warning("IconRenderer: No name provided for icon")
		return {}
	end

	if isBuilderIcon(name) then
		return { IconElement.new({
				name = name,
				size = tonumber(p2.attributes.size) or p3.styles.fontStyle.FontSize or 18
			}) }
	end

	v5:warning(`IconRenderer: Icon {name} is not a builder icon. You must provide a Foundation builder icon name.`)

	return {}
end
