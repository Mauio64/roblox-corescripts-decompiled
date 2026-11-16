local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local Foundation = require(parent.Foundation)
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

local isBuilderIcon = Foundation.Utility.isBuilderIcon

local IconElement = require(InlineRichText.Renderer.InlineElements.IconElement)

require(InlineRichText.Types)

return function(p, p2)
	local name = p.attributes.name

	if not name then
		v:warning("IconRenderer: No name provided for icon")
		return {}
	end

	if isBuilderIcon(name) then
		return { IconElement.new({
				name = name,
				size = tonumber(p.attributes.size) or p2.styles.fontStyle.FontSize or 18
			}) }
	end

	v:warning(`IconRenderer: Icon {name} is not a builder icon. You must provide a Foundation builder icon name.`)

	return {}
end
