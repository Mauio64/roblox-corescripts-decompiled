local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local function assignIndex(p1, n1: number) -- line: 4
	-- upvalues: assignIndex (copy)
	p1.index = n1

	if p1.children then
		for v6, v7 in p1.children do
			assignIndex(v7, v6)
		end
	end
end
local function indexTree(p2) -- line: 13
	-- upvalues: assignIndex (copy)
	p2.index = 1

	if p2.children then
		for v9, v10 in p2.children do
			assignIndex(v10, v9)
		end
	end

	return p2
end

return indexTree
