local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local Foundation = require(InlineRichTextParent.Foundation)
local v4 = require(InlineRichText.Logger):new(script.Name)
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local IconElement = require(InlineRichText.Renderer.InlineElements.IconElement)

require(InlineRichText.Types)

return function(p1, p2) -- line: 12
	-- upvalues: v4 (copy), isBuilderIcon (copy), IconElement (copy)
	local name = p1.attributes.name

	if not name then
		v4:warning("IconRenderer: No name provided for icon")

		return {}
	end

	if not isBuilderIcon(name) then
		v4:warning(`IconRenderer: Icon { name } is not a builder icon. You must provide a Foundation builder icon name.`)

		return {}
	end

	return { IconElement.new({
		name = name,
		size = tonumber(p1.attributes.size) or (p2.styles.fontStyle.FontSize or 18)
	}) }
end
