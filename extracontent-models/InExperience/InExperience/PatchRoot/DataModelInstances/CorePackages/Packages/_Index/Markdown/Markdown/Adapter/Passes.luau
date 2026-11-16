local Markdown = script:FindFirstAncestor("Markdown")
require(script.Parent.Registry)
local RendererNodes = require(script.Parent.RendererNodes)
require(Markdown.Types)

local frozen = table.freeze({ QUOTE = true })
local Passes = {}

function Passes.isDroppable(p: string): boolean
	return frozen[p] == true
end

function Passes.finish(items, items2, p)
	for k, list in items do
		k.text = table.concat(list)
	end

	if not p.dropEmpty then
		return
	end

	local set = {}
	local set2 = {}

	for k, item in items2 do
		if #k.children ~= 0 then
			continue
		end

		set[k] = true
		set2[item] = true
	end

	for k in set2 do
		local children = k.children
		local count = 0

		for i = 1, #children do
			local child = children[i]

			if set[child] then
				continue
			end

			count += 1
			children[count] = child
			child.index = count
			child.offset = RendererNodes.offsetAt(k, child, count)
		end

		for i = #children, count + 1, -1 do
			children[i] = nil
		end
	end
end

return Passes
