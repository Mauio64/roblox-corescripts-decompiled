local parent = script:FindFirstAncestor("Markdown").Parent
require(parent.CommonMark)
require(script.Parent.Registry)
local Children = {}

function Children.units(object, p, flag: boolean)
	local result = {}
	local inlines = nil
	local function flushRun() -- 3 equivalent calls inferred from this helper
		if inlines ~= nil then
			table.insert(result, { inlines = inlines })
			inlines = nil
		end
	end

	local v = { object:getFirstChild() }
	local v2 = 1

	while v2 > 0 do
		local block = v[v2]

		if block == nil then
			v[v2] = nil
			v2 -= 1
			flushRun() -- inferred equivalent call
		else
			v[v2] = block:getNext()

			if block.isBlock then
				local v3 = flag and block.kind == "ListItem" and "handler"
					or (p.block[block.kind] or p.unknownBlock).form

				if v3 ~= "drop" then
					if v3 == "children" then
						flushRun() -- inferred equivalent call
						v2 += 1
						v[v2] = block:getFirstChild()
					else
						flushRun() -- inferred equivalent call
						table.insert(result, { block = block })
					end
				end
			elseif inlines == nil then
				inlines = { block }
			else
				table.insert(inlines, block)
			end
		end
	end

	return result
end

function Children.isList(p): boolean
	local block = p.block
	return block ~= nil and (block.kind == "BulletList" or block.kind == "OrderedList")
end

function Children.isParagraphLike(p): boolean
	local block = p.block
	return block == nil or block.kind == "Paragraph"
end

return Children
