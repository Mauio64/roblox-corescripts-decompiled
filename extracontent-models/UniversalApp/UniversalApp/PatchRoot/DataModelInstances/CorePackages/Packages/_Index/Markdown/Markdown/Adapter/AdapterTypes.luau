local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(parent.CommonMark)
require(Markdown.Types)

return {}
