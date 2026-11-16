local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)
local MarkdownCore = require(Markdown.Parent.MarkdownCore)
local Flags = MarkdownCore.Flags
local NodeType = require(Markdown.Enums.NodeType)
local TableAlignment = require(Markdown.Enums.TableAlignment)

local insert = table.insert

local Constants = require(script.Parent.Parent.Constants)
local containers = Constants.CONTAINERS
local INLINE_TEXT = Constants.INLINE_TEXT
local PLAIN_TEXT = Constants.PLAIN_TEXT
local STYLED_TEXT = Constants.STYLED_TEXT

local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)

local v = {}

local function trimLeadingWhitespace(items, flag: boolean)
	local result = {}

	for _, item in items do
		if flag and item.name == "TEXT" and item.text then
			item.text = item.text:gsub("^[ \t]+", "")

			if #item.text == 0 then
				continue
			end
		end

		if item.name == "BREAK" and item.text ~= nil then
			flag = string.sub(item.text, -1) == "\n"
		else
			flag = false
		end

		insert(result, item)
	end

	return result
end

local function makeContentInline(state, p)
	if state.name == "TAG" then
		state.type = NodeType.InlineSpan
	elseif state.name == "DIVIDER" then
		state.name = "BREAK"
		state.type = getNodeType("BREAK", p)
	end

	for _, child in state.children do
		makeContentInline(child, p)
	end
end

function v.postProcessTree(data, p)
	local result = {}
	local total = 1
	local children = data.children
	local v2 = data.name == "TAG"
		and (p.inlineTags[data.text] or Flags.FFlagMarkdownTagFallbacks and data.type == NodeType.InlineSpan)

	local v3 = containers[data.name] and not v2
	local v4 = Flags.FFlagMarkdownTagFallbacks

	if v4 then
		if data.type == NodeType.TextBlock then
			v4 = true
		else
			v4 = data.type == NodeType.InlineSpan
		end
	end

	while total <= #children do
		local child = children[total]

		if v4 and child.name == "TAG" then
			makeContentInline(child, p)
		end

		local v5

		if child.name == "TAG" then
			v5 = child.text and p.inlineTags[child.text]
		else
			v5 = false
		end

		if (INLINE_TEXT[child.name] or v5) and v3 then
			local paragraph, v6 = v.buildParagraph(children, total, p)
			assert(paragraph > 0, "Did not find an inline node when expected")

			if #v6.children > 0 then
				insert(result, v6)
			end

			total += paragraph
		elseif PLAIN_TEXT[child.name] then
			local mergeTextNodes, v6 = v.mergeTextNodes(children, total, nil, p)
			assert(mergeTextNodes > 0, "Did not find a text node when expected")

			if v6.text and #v6.text > 0 then
				insert(result, v6)
			end

			total += mergeTextNodes
		elseif child.name == "LIST_ITEM" then
			local list, v6 = v.buildList(children, total, p)
			insert(result, v6)
			assert(list > 0, "Did not find a list node when expected")
			total += list
		elseif child.name == "TABLE_ROW" then
			local tbl, v6 = v.buildTable(children, total, p)
			insert(result, v6)
			assert(tbl > 0, "Did not find a table row node when expected")
			total += tbl
		elseif child.name == "QUOTE" then
			local quote, v6 = v.buildQuote(children, total, p)
			insert(result, v6)
			assert(quote > 0, "Did not find a quote node when expected")
			total += quote
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

	result = trimLeadingWhitespace(result, false)

	local v5 = result[1]

	if v5 and v5.text then
		v5.text = v5.text:gsub("^%s+", "")
	end

	local v6 = result[#result]

	if v6 and v6.text then
		v6.text = v6.text:gsub("%s+$", "")
	end

	return result
end

function v.buildParagraph(list, p: number, p2, flag: boolean?)
	local v2 = p
	local children = {}
	local total = 0

	while v2 <= #list do
		local item = list[v2]
		local v3 = item.name == "TAG" and item.text and p2.inlineTags[item.text]
		local v4 = INLINE_TEXT[item.name] or v3

		if PLAIN_TEXT[item.name] then
			local mergeTextNodes, v5 = v.mergeTextNodes(list, v2, flag, p2)

			if v5.text and #v5.text > 0 then
				insert(children, v5)
			end

			assert(mergeTextNodes > 0, "Did not find a rich text node when expected")
			total += mergeTextNodes
			v2 += mergeTextNodes
		elseif item.name == "STYLED_TEXT" then
			local _, v5 = v.buildParagraph(item.children, 1, p2, true)

			if item.attributes and item.attributes.style == "INLINE_CODE" then
				item.children = v.applyCodeSpanRules(v5.children)
			else
				item.children = trimLeadingWhitespace(v5.children, false)
			end

			insert(children, item)
			total += 1
			v2 += 1
		else
			if not v4 then
				break
			end

			if Flags.FFlagMarkdownTagFallbacks and item.name == "TAG" then
				makeContentInline(item, p2)
			end

			insert(children, item)
			total += 1
			v2 += 1
		end
	end

	if not flag then
		local item = list[p - 1]
		children = trimLeadingWhitespace(children, not item or item.name ~= "TAG")
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
		local mergeTextNodes, v3 = v.mergeTextNodes(data.children, 1, nil, p)
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

local function isEmptyQuoteLine(children): boolean
	for _, item in children do
		if item.name ~= "TEXT" or item.text and #item.text > 0 then
			return false
		end
	end

	return true
end

function v.buildQuote(list, p: number, p2)
	local v2 = p
	local v3 = {}
	local count = 0

	while v2 <= #list and list[v2].name == "QUOTE" do
		local item = list[v2]
		insert(v3, { node = item, children = v.postProcessTree(item, p2) })
		count += 1
		v2 += 1
	end

	local count2 = #v3
	local v4 = 1

	while v4 <= count2 and isEmptyQuoteLine(v3[v4].children) do
		v4 += 1
	end

	while v4 <= count2 and isEmptyQuoteLine(v3[count2].children) do
		count2 -= 1
	end

	local children = {}

	for i = v4, count2 do
		local v5 = v3[i]

		if v4 < i then
			insert(children, {
				name = "BREAK",
				children = {},
				offset = v5.node.offset,
				type = getNodeType("BREAK", p2)
			})
		end

		for _, child in v5.children do
			if child.name ~= "TEXT" or child.text ~= "" then
				insert(children, child)
			end
		end
	end

	local item = list[p]
	item.children = children
	return count, item
end

local function buildTableCellsLegacy(item, p)
	local child = item.children[1]
	local children = {}
	local result = {}
	local v2 = true

	for i = 1, #item.children do
		local child2 = item.children[i]

		if child2.name == "TABLE_DIVIDER" then
			local offset

			if children[1] then
				offset = children[1].offset
			else
				offset = item.offset
			end

			local v3 = {
				name = "TABLE_CELL",
				children = children,
				offset = offset,
				type = getNodeType("TABLE_CELL", p)
			}

			v3.children = v.postProcessTree(v3, p)
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

local function buildTableLegacy(list, p: number, p2)
	local count = 0
	local children = {}

	for i = p, #list do
		local item = list[i]

		if item.name ~= "TABLE_ROW" then
			break
		end

		local tableCellsLegacy = buildTableCellsLegacy(item, p2)

		if tableCellsLegacy then
			item.children = tableCellsLegacy
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

local function getDelimiterAlignment(tableCell)
	local v2 = ""

	for _, child in tableCell.children do
		v2 ..= child.text or ""
	end

	local v3 = string.match(v2, "^%s*(.-)%s*$") or ""
	local v4 = string.sub(v3, 1, 1) == ":"
	local v5 = string.sub(v3, -1) == ":"

	if v4 and v5 then
		return TableAlignment.Center
	end

	if v5 then
		return TableAlignment.Right
	end

	return if v4 then TableAlignment.Left else nil
end

function v.buildTable(list, p: number, p2)
	if not Flags.FFlagMarkdownTables then
		return buildTableLegacy(list, p, p2)
	end

	local children = {}
	local v2 = {}
	local count = 0

	for i = p, #list do
		local item = list[i]

		if item.name ~= "TABLE_ROW" then
			break
		end

		local tableCells, v3 = v.buildTableCells(item, p2)
		local v4 = count == 1

		if v3 and v4 then
			children[1].name = "TABLE_HEADER"

			for k, tableCell in tableCells do
				v2[k] = getDelimiterAlignment(tableCell)
			end
		else
			item.children = tableCells
			insert(children, item)
		end

		count += 1
	end

	if children[1] then
		local count2 = #children[1].children

		for _, v3 in children do
			for _ = #v3.children + 1, count2 do
				insert(v3.children, v.buildTableCell({}, v3, p2))
			end

			for _ = count2 + 1, #v3.children do
				table.remove(v3.children)
			end

			for k, child in v3.children do
				local alignment = v2[k]

				if alignment then
					child.attributes = { alignment = alignment }
				end
			end
		end
	end

	return count, {
		name = "TABLE",
		children = children,
		offset = list[p].offset,
		type = getNodeType("TABLE", p2)
	}
end

local function isDividerCell(tableCell): boolean
	local v2 = ""

	for _, child in tableCell.children do
		if child.name ~= "TEXT" then
			return false
		end

		v2 ..= child.text or ""
	end

	return v2:match("^%s*:?%-+:?%s*$") ~= nil
end

local function hasContent(children): boolean
	for _, item in children do
		if item.name ~= "TEXT" or item.text and item.text:find("%S") then
			return true
		end
	end

	return false
end

function v.buildTableCell(children, p, p2)
	local offset = if children[1] then children[1].offset else p.offset
	local tableCell = {
		name = "TABLE_CELL",
		children = children,
		offset = offset,
		type = getNodeType("TABLE_CELL", p2)
	}

	tableCell.children = v.postProcessTree(tableCell, p2)

	return tableCell
end

function v.buildTableCells(p, p2)
	local children = {}
	local tableCells = {}
	local v2 = true

	for i = 1, #p.children do
		local child = p.children[i]

		if child.name == "TABLE_DIVIDER" then
			local tableCell = v.buildTableCell(children, p, p2)
			insert(tableCells, tableCell)
			v2 = v2 and isDividerCell(tableCell)
			children = {}
		else
			insert(children, child)
		end
	end

	if hasContent(children) then
		local tableCell = v.buildTableCell(children, p, p2)
		insert(tableCells, tableCell)
		v2 = v2 and isDividerCell(tableCell)
	end

	return tableCells, v2 and #tableCells > 0
end

function v.mergeTextNodes(list, p: number, flag: boolean?, p2)
	local text = ""
	local count = 0

	for i = p, #list do
		local item = list[i]

		if not PLAIN_TEXT[item.name] then
			break
		end

		text ..= item.text
		count += 1
	end

	if not flag then
		text = text:gsub("^\n*(.-)\n*$", "%1")
	end

	return count, {
		name = "TEXT",
		text = text,
		children = {},
		offset = list[p].offset,
		type = getNodeType("TEXT", p2)
	}
end

function v.applyCodeSpanRules(items)
	local v2 = nil
	local v3 = nil
	local v4 = false

	for _, item in items do
		if not (item.text and #item.text > 0) then
			continue
		end

		if v2 == nil then
			v2 = item
		end

		if item.text:find("[^\n ]") then
			v3 = item
			v4 = true
		else
			v3 = item
		end
	end

	if v2 == nil or v3 == nil then
		return items
	end

	local text = (v2.text or ""):gsub("\n", " ")
	local text2 = (v3.text or ""):gsub("\n", " ")

	if text:sub(1, 1) == " " and text2:sub(-1, -1) == " " and v4 then
		if v2 == v3 then
			text = text:sub(2, -2)
			text2 = text
		else
			text = text:sub(2)
			text2 = text2:sub(1, -2)
		end
	end

	v2.text = text
	v3.text = text2

	return items
end

return v.postProcessTree
