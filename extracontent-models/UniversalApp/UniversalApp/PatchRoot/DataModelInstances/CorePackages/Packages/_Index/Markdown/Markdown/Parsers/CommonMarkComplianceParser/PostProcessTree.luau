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
			local v22, v23 = t1.mergeTextNodes(children, n1, nil, p2)

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
function t1.buildParagraph(t3: {[any]: any}, n2: number, p3, b1: boolean?) -- line: 88
	-- upvalues: INLINE_TEXT (copy), PLAIN_TEXT (copy), t1 (copy), insert (copy), getNodeType (copy)
	local t4 = {}
	local n3 = 0
	local v36 = n2

	while v36 <= #t3 do
		local v37 = t3[v36]
		local v38 = v37.name == "TAG" and (v37.text and p3.inlineTags[v37.text])
		local v39 = INLINE_TEXT[v37.name] or v38

		if PLAIN_TEXT[v37.name] then
			local v40, v41 = t1.mergeTextNodes(t3, v36, b1, p3)

			if v41.text and #v41.text > 0 then
				insert(t4, v41)
			end

			assert(v40 > 0, "Did not find a rich text node when expected")
			n3 += v40
			v36 += v40

			continue
		end

		if v37.name == "STYLED_TEXT" then
			local _, v43 = t1.buildParagraph(v37.children, 1, p3, true)

			if v37.attributes and v37.attributes.style == "INLINE_CODE" then
				v37.children = t1.applyCodeSpanRules(v43.children)
			else
				v37.children = v43.children
			end

			insert(t4, v37)
			n3 += 1
			v36 += 1

			continue
		end

		if not v39 then
			return n3, {
				name = "PARAGRAPH",
				children = t4,
				offset = t3[n2].offset,
				type = getNodeType("PARAGRAPH", p3)
			}
		end

		insert(t4, v37)
		n3 += 1
		v36 += 1
	end

	return n3, {
		name = "PARAGRAPH",
		children = t4,
		offset = t3[n2].offset,
		type = getNodeType("PARAGRAPH", p3)
	}
end
function t1.outputRichText(p4, p5) -- line: 141
	-- upvalues: STYLED_TEXT (copy), t1 (copy)
	local v46 = if not p4.attributes then nil else STYLED_TEXT[p4.attributes.style]

	if v46 then
		local v47, v48 = t1.mergeTextNodes(p4.children, 1, nil, p5)

		assert(v47 == #p4.children, `Found non-inline content inside inline element at { p4.offset }`)

		return `<{ v46 }>{ v48.text }</{ v46 }>`
	end

	if p4.text then
		return p4.text
	end

	assert(false, `No text for node at { p4.offset }`)
end
function t1.buildList(t5: {[any]: any}, n4: number, p6) -- line: 155
	-- upvalues: t1 (copy), insert (copy), getNodeType (copy)
	local n5 = 0
	local depth = t5[n4].attributes.depth
	local t6 = {}
	local v55 = n4

	while v55 <= #t5 do
		local v56 = t5[v55]

		if v56.name ~= "LIST_ITEM" then
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

		if depth ~= v56.attributes.depth then
			if not (depth < v56.attributes.depth) then
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

			local v57, v58 = t1.buildList(t5, v55, p6)

			insert(t6, v58)
			assert(v57 > 0, "Did not find a list node when expected")
			v55 += v57
			n5 += v57

			continue
		end

		v56.children = t1.postProcessTree(v56, p6)
		insert(t6, v56)
		n5 += 1
		v55 += 1
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
function t1.buildTable(t7: {[any]: any}, n6: number, p7) -- line: 195
	-- upvalues: t1 (copy), insert (copy), getNodeType (copy)
	local n7 = 0
	local t8 = {}

	for i = n6, #t7 do
		local v65 = t7[i]

		if v65.name ~= "TABLE_ROW" then
			return n7, {
				name = "TABLE",
				children = t8,
				offset = t7[n6].offset,
				type = getNodeType("TABLE", p7)
			}
		end

		local v66 = t1.buildTableCells(v65, p7)

		if v66 then
			v65.children = v66
			insert(t8, v65)
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
function t1.buildTableCells(p8, p9) -- line: 225
	-- upvalues: getNodeType (copy), t1 (copy), insert (copy)
	local t9 = {}
	local t10 = {}
	local v71 = true
	local v72 = p8.children[1]

	for i = 1, #p8.children do
		local v74 = p8.children[i]

		if v74.name == "TABLE_DIVIDER" then
			local t11 = {
				name = "TABLE_CELL",
				children = t10,
				offset = if not t10[1] then p8.offset else t10[1].offset,
				type = getNodeType("TABLE_CELL", p9)
			}

			t11.children = t1.postProcessTree(t11, p9)
			insert(t9, t11)

			local v76 = v72.text and v72.text:match("^[ \t-=]+$") ~= nil

			v71 = not not v71 and (v76 or false)
			t10 = {}
		else
			insert(t10, v74)
		end
	end

	if v71 then
		return nil
	end

	return t9
end
function t1.mergeTextNodes(t12: {[any]: any}, n8: number, b2: boolean?, p10) -- line: 258
	-- upvalues: PLAIN_TEXT (copy), getNodeType (copy)
	local s1 = ""
	local n9 = 0

	for i = n8, #t12 do
		local v84 = t12[i]

		if not PLAIN_TEXT[v84.name] then
			break
		end

		s1 ..= v84.text
		n9 += 1
	end

	if not b2 then
		s1 = s1:gsub("^\n*(.-)\n*$", "%1")
	end

	return n9, {
		name = "TEXT",
		text = s1,
		children = {},
		offset = t12[n8].offset,
		type = getNodeType("TEXT", p10)
	}
end
function t1.applyCodeSpanRules(t13: {[any]: any}) -- line: 289
	local v86 = nil
	local v87 = nil
	local v88 = false

	for _, v90 in t13 do
		if v90.text and #v90.text > 0 then
			if v86 == nil then
				v86 = v90
			end

			v87 = v90

			if v90.text:find("[^\n ]") then
				v88 = true
			end
		end
	end

	if v86 == nil or v87 == nil then
		return t13
	end

	local v91 = (v86.text or ""):gsub("\n", " ")
	local v92 = (v87.text or ""):gsub("\n", " ")

	if v91:sub(1, 1) == " " and v92:sub(-1, -1) == " " and v88 then
		if v86 == v87 then
			v91 = v91:sub(2, -2)
			v92 = v91
		else
			v91 = v91:sub(2)
			v92 = v92:sub(1, -2)
		end
	end

	v86.text = v91
	v87.text = v92

	return t13
end

return t1.postProcessTree
