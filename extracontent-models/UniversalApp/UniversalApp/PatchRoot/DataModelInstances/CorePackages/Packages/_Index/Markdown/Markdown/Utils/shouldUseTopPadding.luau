local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local function shouldUseTopPadding(p): boolean
	return p.offset ~= 0
end

return shouldUseTopPadding
