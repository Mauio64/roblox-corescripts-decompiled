local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local insert = table.insert

local Constants = require(script.Parent.Parent.Constants)
local containers = Constants.CONTAINERS
local INLINE_TEXT = Constants.INLINE_TEXT
local PLAIN_TEXT = Constants.PLAIN_TEXT
local STYLED_TEXT = Constants.STYLED_TEXT

local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)

local v = {}

function v.postProcessTree(data, p)
	local result = {}
	local total = 1
	local children = data.children
	local v2 = data.name == "TAG" and p.inlineTags[data.text]
	local v3 = containers[data.name] and not v2

	while total <= #children do
		local child = children[total]
		local v4

		if child.name == "TAG" then
			v4 = child.text and p.inlineTags[child.text]
		else
			v4 = false
		end

		if (INLINE_TEXT[child.name] or v4) and v3 then
			local paragraph, v5 = v.buildParagraph(children, total, p)
			assert(paragraph > 0, "Did not find an inline node when expected")

			if #v5.children > 0 then
				insert(result, v5)
			end

			total += paragraph
		elseif PLAIN_TEXT[child.name] then
			local mergeTextNodes, v5 = v.mergeTextNodes(children, total, p)
			assert(mergeTextNodes > 0, "Did not find a text node when expected")

			if v5.text and #v5.text > 0 then
				insert(result, v5)
			end

			total += mergeTextNodes
		elseif child.name == "LIST_ITEM" then
			local list, v5 = v.buildList(children, total, p)
			insert(result, v5)
			assert(list > 0, "Did not find a list node when expected")
			total += list
		elseif child.name == "TABLE_ROW" then
			local tbl, v5 = v.buildTable(children, total, p)
			insert(result, v5)
			assert(tbl > 0, "Did not find a table row node when expected")
			total += tbl
		else
			if child.name ~= "LINE_BREAK" then
				child.children = v.postProcessTree(child, p)
				insert(result, child)
			end

			total += 1
		end
	end

	if not isNodeBlock(data) then
		return result
	end

	local v4 = result[1]

	if v4 and v4.text then
		v4.text = v4.text:gsub("^%s+", "")
	end

	local v5 = result[#result]

	if v5 and v5.text then
		v5.text = v5.text:gsub("%s+$", "")
	end

	return result
end

function v.buildParagraph(list, p: number, p2)
	local v2 = p
	local total = 0
	local children = {}

	while v2 <= #list do
		local item = list[v2]
		local v3 = item.name == "TAG" and item.text and p2.inlineTags[item.text]
		local v4 = INLINE_TEXT[item.name] or v3

		if PLAIN_TEXT[item.name] then
			local mergeTextNodes, v5 = v.mergeTextNodes(list, v2, p2)

			if v5.text and #v5.text > 0 then
				insert(children, v5)
			end

			assert(mergeTextNodes > 0, "Did not find a rich text node when expected")
			total += mergeTextNodes
			v2 += mergeTextNodes
		else
			if not v4 then
				break
			end

			insert(children, item)
			total += 1
			v2 += 1
		end
	end

	return
		total,
		{
			name = "PARAGRAPH",
			children = children,
			offset = list[p].offset,
			type = getNodeType("PARAGRAPH", p2)
		}
end

function v.outputRichText(data, p)
	local v2

	if data.attributes then
		v2 = STYLED_TEXT[data.attributes.style]
	end

	if v2 then
		local mergeTextNodes, v3 = v.mergeTextNodes(data.children, 1, p)
		assert(mergeTextNodes == #data.children, `Found non-inline content inside inline element at {data.offset}`)
		return `<{v2}>{v3.text}</{v2}>`
	end

	if data.text then
		return data.text
	end

	assert(false, `No text for node at {data.offset}`)
end

function v.buildList(list, p: number, p2)
	local depth = list[p].attributes.depth
	local v2 = p
	local children = {}
	local total = 0

	while v2 <= #list do
		local item = list[v2]

		if item.name ~= "LIST_ITEM" then
			break
		end

		if item.attributes.depth == depth then
			item.children = v.postProcessTree(item, p2)
			insert(children, item)
			total += 1
			v2 += 1
		else
			if not (depth < item.attributes.depth) then
				break
			end

			local list2, v3 = v.buildList(list, v2, p2)
			insert(children, v3)
			assert(list2 > 0, "Did not find a list node when expected")
			v2 += list2
			total += list2
		end
	end

	return total, {
		name = "LIST",
		attributes = { depth = depth },
		children = children,
		offset = list[p].offset,
		type = getNodeType("LIST", p2)
	}
end

function v.buildTable(list, p: number, p2)
	local count = 0
	local children = {}

	for i = p, #list do
		local item = list[i]

		if item.name ~= "TABLE_ROW" then
			break
		end

		local tableCells = v.buildTableCells(item, p2)

		if tableCells then
			item.children = tableCells
			insert(children, item)
		elseif #children > 0 then
			children[#children].name = "TABLE_HEADER"
		end

		count += 1
	end

	return count, {
		name = "TABLE",
		children = children,
		offset = list[p].offset,
		type = getNodeType("TABLE", p2)
	}
end

function v.buildTableCells(p, p2)
	local child = p.children[1]
	local children = {}
	local result = {}
	local v2 = true

	for i = 1, #p.children do
		local child2 = p.children[i]

		if child2.name == "TABLE_DIVIDER" then
			local offset

			if children[1] then
				offset = children[1].offset
			else
				offset = p.offset
			end

			local v3 = {
				name = "TABLE_CELL",
				children = children,
				offset = offset,
				type = getNodeType("TABLE_CELL", p2)
			}

			v3.children = v.postProcessTree(v3, p2)
			insert(result, v3)

			local v4 = child.text and child.text:match("^[ \t-=]+$") ~= nil

			children = {}
			v2 = v2 and v4 or false
		else
			insert(children, child2)
		end
	end

	return if not v2 then result else nil
end

function v.mergeTextNodes(list, p: number, p2)
	local v2 = ""
	local count = 0

	for i = p, #list do
		local item = list[i]

		if not PLAIN_TEXT[item.name] then
			break
		end

		v2 ..= item.text
		count += 1
	end

	return count, {
		name = "TEXT",
		text = v2:gsub("^\n*(.-)\n*$", "%1"),
		children = {},
		offset = list[p].offset,
		type = getNodeType("TEXT", p2)
	}
end

return v.postProcessTree
