local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent

local Dash = require(parent.Dash)
require(Markdown.Types)

local function mergeContexts(p, p2)
	return Dash.joinDeep(p, p2)
end

return mergeContexts
