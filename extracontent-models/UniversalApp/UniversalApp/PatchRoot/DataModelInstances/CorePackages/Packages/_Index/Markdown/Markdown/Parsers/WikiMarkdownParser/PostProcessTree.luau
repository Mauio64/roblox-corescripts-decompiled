local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local insert = table.insert
local Constants = require(script.Parent.Parent.Constants)
local CONTAINERS = Constants.CONTAINERS
local INLINE_TEXT = Constants.INLINE_TEXT
local PLAIN_TEXT = Constants.PLAIN_TEXT
local STYLED_TEXT = Constants.STYLED_TEXT
local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)
local t1 = {}

function t1.postProcessTree(p1, p2) -- line: 23
	-- upvalues: CONTAINERS (copy), INLINE_TEXT (copy), t1 (copy), insert (copy), PLAIN_TEXT (copy), isNodeBlock (copy)
	local t2 = {}
	local n1 = 1
	local children = p1.children
	local v16 = p1.name == "TAG" and p2.inlineTags[p1.text]
	local v17 = CONTAINERS[p1.name] and not v16

	while n1 <= #children do
		local v18 = children[n1]
		local v19 = v18.name == "TAG" and (v18.text and p2.inlineTags[v18.text])

		if (INLINE_TEXT[v18.name] or v19) and v17 then
			local v20, v21 = t1.buildParagraph(children, n1, p2)

			assert(v20 > 0, "Did not find an inline node when expected")

			if #v21.children > 0 then
				insert(t2, v21)
			end

			n1 += v20
		elseif PLAIN_TEXT[v18.name] then
			local v22, v23 = t1.mergeTextNodes(children, n1, p2)

			assert(v22 > 0, "Did not find a text node when expected")

			if v23.text and #v23.text > 0 then
				insert(t2, v23)
			end

			n1 += v22
		elseif v18.name == "LIST_ITEM" then
			local v24, v25 = t1.buildList(children, n1, p2)

			insert(t2, v25)
			assert(v24 > 0, "Did not find a list node when expected")
			n1 += v24
		elseif v18.name == "TABLE_ROW" then
			local v26, v27 = t1.buildTable(children, n1, p2)

			insert(t2, v27)
			assert(v26 > 0, "Did not find a table row node when expected")
			n1 += v26
		elseif v18.name == "LINE_BREAK" then
			n1 += 1
		else
			v18.children = t1.postProcessTree(v18, p2)
			insert(t2, v18)
			n1 += 1
		end
	end

	if isNodeBlock(p1) then
		local v28 = t2[1]

		if v28 and v28.text then
			v28.text = v28.text:gsub("^%s+", "")
		end

		local v29 = t2[#t2]

		if v29 and v29.text then
			v29.text = v29.text:gsub("%s+$", "")
		end
	end

	return t2
end
function t1.buildParagraph(t3: {[any]: any}, n2: number, p3) -- line: 87
	-- upvalues: INLINE_TEXT (copy), PLAIN_TEXT (copy), t1 (copy), insert (copy), getNodeType (copy)
	local t4 = {}
	local n3 = 0
	local v35 = n2

	while v35 <= #t3 do
		local v36 = t3[v35]
		local v37 = v36.name == "TAG" and (v36.text and p3.inlineTags[v36.text])
		local v38 = INLINE_TEXT[v36.name] or v37

		if PLAIN_TEXT[v36.name] then
			local v39, v40 = t1.mergeTextNodes(t3, v35, p3)

			if v40.text and #v40.text > 0 then
				insert(t4, v40)
			end

			assert(v39 > 0, "Did not find a rich text node when expected")
			n3 += v39
			v35 += v39

			continue
		end

		if not v38 then
			return n3, {
				name = "PARAGRAPH",
				children = t4,
				offset = t3[n2].offset,
				type = getNodeType("PARAGRAPH", p3)
			}
		end

		insert(t4, v36)
		n3 += 1
		v35 += 1
	end

	return n3, {
		name = "PARAGRAPH",
		children = t4,
		offset = t3[n2].offset,
		type = getNodeType("PARAGRAPH", p3)
	}
end
function t1.outputRichText(p4, p5) -- line: 123
	-- upvalues: STYLED_TEXT (copy), t1 (copy)
	local v43 = if not p4.attributes then nil else STYLED_TEXT[p4.attributes.style]

	if v43 then
		local v44, v45 = t1.mergeTextNodes(p4.children, 1, p5)

		assert(v44 == #p4.children, `Found non-inline content inside inline element at { p4.offset }`)

		return `<{ v43 }>{ v45.text }</{ v43 }>`
	end

	if p4.text then
		return p4.text
	end

	assert(false, `No text for node at { p4.offset }`)
end
function t1.buildList(t5: {[any]: any}, n4: number, p6) -- line: 137
	-- upvalues: t1 (copy), insert (copy), getNodeType (copy)
	local n5 = 0
	local depth = t5[n4].attributes.depth
	local t6 = {}
	local v52 = n4

	while v52 <= #t5 do
		local v53 = t5[v52]

		if v53.name ~= "LIST_ITEM" then
			return n5, {
				name = "LIST",
				attributes = {
					depth = depth
				},
				children = t6,
				offset = t5[n4].offset,
				type = getNodeType("LIST", p6)
			}
		end

		if depth ~= v53.attributes.depth then
			if not (depth < v53.attributes.depth) then
				return n5, {
					name = "LIST",
					attributes = {
						depth = depth
					},
					children = t6,
					offset = t5[n4].offset,
					type = getNodeType("LIST", p6)
				}
			end

			local v54, v55 = t1.buildList(t5, v52, p6)

			insert(t6, v55)
			assert(v54 > 0, "Did not find a list node when expected")
			v52 += v54
			n5 += v54

			continue
		end

		v53.children = t1.postProcessTree(v53, p6)
		insert(t6, v53)
		n5 += 1
		v52 += 1
	end

	return n5, {
		name = "LIST",
		attributes = {
			depth = depth
		},
		children = t6,
		offset = t5[n4].offset,
		type = getNodeType("LIST", p6)
	}
end
function t1.buildTable(t7: {[any]: any}, n6: number, p7) -- line: 177
	-- upvalues: t1 (copy), insert (copy), getNodeType (copy)
	local n7 = 0
	local t8 = {}

	for i = n6, #t7 do
		local v62 = t7[i]

		if v62.name ~= "TABLE_ROW" then
			return n7, {
				name = "TABLE",
				children = t8,
				offset = t7[n6].offset,
				type = getNodeType("TABLE", p7)
			}
		end

		local v63 = t1.buildTableCells(v62, p7)

		if v63 then
			v62.children = v63
			insert(t8, v62)
		elseif #t8 > 0 then
			t8[#t8].name = "TABLE_HEADER"
		end

		n7 += 1
	end

	return n7, {
		name = "TABLE",
		children = t8,
		offset = t7[n6].offset,
		type = getNodeType("TABLE", p7)
	}
end
function t1.buildTableCells(p8, p9) -- line: 207
	-- upvalues: getNodeType (copy), t1 (copy), insert (copy)
	local t9 = {}
	local t10 = {}
	local v68 = true
	local v69 = p8.children[1]

	for i = 1, #p8.children do
		local v71 = p8.children[i]

		if v71.name == "TABLE_DIVIDER" then
			local t11 = {
				name = "TABLE_CELL",
				children = t10,
				offset = if not t10[1] then p8.offset else t10[1].offset,
				type = getNodeType("TABLE_CELL", p9)
			}

			t11.children = t1.postProcessTree(t11, p9)
			insert(t9, t11)

			local v73 = v69.text and v69.text:match("^[ \t-=]+$") ~= nil

			v68 = not not v68 and (v73 or false)
			t10 = {}
		else
			insert(t10, v71)
		end
	end

	if v68 then
		return nil
	end

	return t9
end
function t1.mergeTextNodes(t12: {[any]: any}, n8: number, p10) -- line: 240
	-- upvalues: PLAIN_TEXT (copy), getNodeType (copy)
	local s1 = ""
	local n9 = 0

	for i = n8, #t12 do
		local v80 = t12[i]

		if not PLAIN_TEXT[v80.name] then
			break
		end

		s1 ..= v80.text
		n9 += 1
	end

	local v81 = s1:gsub("^\n*(.-)\n*$", "%1")

	return n9, {
		name = "TEXT",
		text = v81,
		children = {},
		offset = t12[n8].offset,
		type = getNodeType("TEXT", p10)
	}
end

return t1.postProcessTree
