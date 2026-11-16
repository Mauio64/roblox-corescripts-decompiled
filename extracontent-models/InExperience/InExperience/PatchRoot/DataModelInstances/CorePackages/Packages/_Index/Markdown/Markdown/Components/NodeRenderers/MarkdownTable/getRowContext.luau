local Markdown = script:FindFirstAncestor("Markdown")

local mergeContexts = require(Markdown.Utils.mergeContexts)
require(Markdown.Types)

local function getRowContext(p, p2)
	if p.name == "TABLE_HEADER" then
		return mergeContexts(p2, {
			textStyles = { bold = true }
		})
	end

	return p2
end

return getRowContext
