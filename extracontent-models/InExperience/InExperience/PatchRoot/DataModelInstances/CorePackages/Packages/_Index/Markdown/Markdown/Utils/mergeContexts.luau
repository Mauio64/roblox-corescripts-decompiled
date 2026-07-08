local Markdown = script:FindFirstAncestor("Markdown")
local MarkdownParent = Markdown.Parent
local Dash = require(MarkdownParent.Dash)

require(Markdown.Types)

local function mergeContexts(p1, p2) -- line: 7
	-- upvalues: Dash (copy)
	return Dash.joinDeep(p1, p2)
end

return mergeContexts
