local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)
local function assignIndex(child, k: number)
	child.index = k

	if child.children then
		for k2, child2 in child.children do
			assignIndex(child2, k2)
		end
	end
end

local function indexTree(p)
	p.index = 1

	if p.children then
		for k, child in p.children do
			assignIndex(child, k)
		end
	end

	return p
end

return indexTree
