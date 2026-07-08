local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local LISTS = Constants.LISTS
local STYLED_TEXT = Constants.STYLED_TEXT
local DIVIDERS = Constants.DIVIDERS
local NodeType = require(Markdown.Enums.NodeType)
local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)
local insert = table.insert
local t1 = {}

local function createTextNode(p1, p2) -- line: 23
	-- upvalues: getNodeType (copy)
	return {
		name = "TEXT",
		text = p1.text,
		children = {},
		offset = p1.offset,
		type = getNodeType("TEXT", p2)
	}
end

function t1.buildTree(t2: {[any]: any}, p3) -- line: 34
	-- upvalues: NodeType (copy), getNodeType (copy), insert (copy), t1 (copy), STYLED_TEXT (copy), createTextNode (copy), LISTS (copy), isNodeBlock (copy), DIVIDERS (copy)
	local t3 = {
		name = "ROOT",
		offset = 1,
		children = {},
		type = NodeType.Root
	}
	local t4 = { t3 }
	local n1 = 1

	while n1 <= #t2 do
		local v19 = t2[n1]
		local v20 = t4[#t4]

		if v19.name == "CODE_BLOCK" and v19.capture then
			local v21 = string.gsub(v19.capture[2], "^%s*(.-)%s*$", "%1")

			insert(v20.children, {
				name = "CODE_BLOCK",
				text = v21,
				children = {},
				attributes = {
					language = v19.capture[1]
				},
				offset = v19.offset,
				type = getNodeType("CODE_BLOCK", p3)
			})
		elseif v19.name == "EMPHASIS_START" then
			local text = v19.text

			insert(t4, {
				name = "STYLED_TEXT",
				attributes = {
					style = text
				},
				children = {},
				offset = v19.offset,
				type = getNodeType("STYLED_TEXT", p3)
			})
		elseif v19.name == "EMPHASIS_END" then
			t1.closeNode(t4, function(p4) -- line: 76
				return p4.name == "STYLED_TEXT"
			end)
		elseif STYLED_TEXT[v19.name] then
			insert(v20.children, (createTextNode(v19, p3)))
		elseif LISTS[v19.name] and v19.capture then
			t1.closeNode(t4, function(p5) -- line: 85
				-- upvalues: isNodeBlock (copy)
				return isNodeBlock(p5)
			end)
			insert(t4, {
				name = "LIST_ITEM",
				children = {},
				attributes = {
					depth = #v19.capture[1],
					prefix = v19.capture[2]
				},
				offset = v19.offset,
				type = getNodeType("LIST_ITEM", p3)
			})
		elseif v19.name == "HEADING" and not v19.isBlock then
			if not t1.closeNode(t4, function(p6) -- line: 101
				return p6.name == "HEADING"
			end) then
				insert(v20.children, (createTextNode(v19, p3)))
			end
		elseif v19.isBlock then
			t1.closeNode(t4, function(p7) -- line: 110
				-- upvalues: isNodeBlock (copy)
				return isNodeBlock(p7)
			end)

			local v23 = if not DIVIDERS[v19.name] then t4 else t4[#t4].children
			local t5 = {}

			if v19.name == "HEADING" and v19.capture then
				t5.depth = #v19.capture[1]
			end

			insert(v23, {
				name = v19.name,
				children = {},
				attributes = t5,
				offset = v19.offset,
				type = getNodeType(v19.name, p3)
			})
		elseif v19.name == "ESCAPE" and v19.capture then
			insert(v20.children, {
				name = "TEXT",
				text = v19.capture[1],
				offset = v19.offset,
				children = {},
				type = getNodeType("TEXT", p3)
			})
		elseif v19.name == "LINK_START" and v19.capture then
			insert(t4, {
				name = "LINK",
				text = v19.capture[1],
				attributes = {
					url = v19.capture[2],
					title = v19.capture[3]
				},
				children = {},
				offset = v19.offset,
				type = getNodeType("LINK", p3)
			})
		elseif v19.name == "LINK_END" then
			t1.closeNode(t4, function(p8) -- line: 153
				return p8.name == "LINK"
			end)
		elseif v19.name == "IMAGE" and v19.capture then
			insert(v20.children, {
				name = v19.name,
				text = v19.capture[1],
				attributes = {
					url = v19.capture[2],
					title = v19.capture[3]
				},
				offset = v19.offset,
				children = {},
				type = getNodeType("IMAGE", p3)
			})
		elseif v19.name == "OPEN_CLOSE" and v19.capture then
			local v25 = v19.capture[1]
			local v26 = v19.capture[2]

			if v19.capture and v25 == "br" then
				insert(v20.children, {
					name = "BREAK",
					children = {},
					offset = v19.offset,
					type = getNodeType("BREAK", p3)
				})
			else
				insert(v20.children, {
					name = "TAG",
					text = v25,
					attributes = if not v26 then {} else t1.parseXmlAttributes(v26),
					children = {},
					offset = v19.offset,
					type = if not p3.inlineTags[v25] then NodeType.Block else NodeType.InlineSpan
				})
			end
		elseif v19.name == "OPEN" and v19.capture then
			local v27 = v19.capture[1]
			local v28 = v19.capture[2]

			if v19.capture and v27 == "br" then
				insert(v20.children, {
					name = "BREAK",
					children = {},
					offset = v19.offset,
					type = getNodeType("BREAK", p3)
				})
			else
				insert(t4, {
					name = "TAG",
					text = v27,
					attributes = if not v28 then {} else t1.parseXmlAttributes(v28),
					children = {},
					offset = v19.offset,
					type = if not p3.inlineTags[v27] then NodeType.Block else NodeType.InlineSpan
				})
			end
		elseif v19.name == "CLOSE" and v19.capture then
			local v29 = v19.capture[1]

			assert(t1.closeNode(t4, function(p9) -- line: 213
				-- upvalues: v29 (copy), v19 (copy)
				if p9.name == "TAG" then
					assert(p9.text == v29, `Found <{ p9.text }> at { p9.offset } when trying to close </{ v29 }> at { v19.offset }`)

					return true
				end

				return false
			end), `No open tag exists trying to close </{ v29 }> at { v19.offset }`)
		elseif v20.name == "HEADING" then
			local v30 = string.find(v19.text, "\n", 1, true)

			if not v30 then
				insert(v20.children, {
					name = v19.name,
					text = v19.text,
					children = {},
					offset = v19.offset,
					type = getNodeType(v19.name, p3)
				})
				n1 += 1

				continue
			end

			local v31 = string.sub(v19.text, 1, v30 - 1)
			local v32 = string.sub(v19.text, v30 + 1)

			if string.find(v32, "%S") == nil then
				insert(v20.children, {
					name = v19.name,
					text = v19.text,
					children = {},
					offset = v19.offset,
					type = getNodeType(v19.name, p3)
				})
				n1 += 1

				continue
			end

			insert(v20.children, {
				name = v19.name,
				text = v31,
				children = {},
				offset = v19.offset,
				type = getNodeType(v19.name, p3)
			})
			t1.closeNode(t4, function(p10) -- line: 264
				return p10.name == "HEADING"
			end)
			insert(t4, {
				name = "PARAGRAPH",
				children = {{
					name = "TEXT",
					text = v32,
					children = {},
					offset = v19.offset + v30 + 1,
					type = getNodeType("TEXT", p3)
				}},
				offset = v19.offset,
				type = getNodeType("PARAGRAPH", p3)
			})
		else
			insert(v20.children, {
				name = v19.name,
				text = v19.text,
				children = {},
				offset = v19.offset,
				type = getNodeType(v19.name, p3)
			})
		end

		n1 += 1
	end

	t1.closeNode(t4, function(p11) -- line: 294
		-- upvalues: isNodeBlock (copy)
		return isNodeBlock(p11)
	end)
	t1.closeNode(t4, function(p12) -- line: 298
		return p12.name == "ROOT"
	end)

	return t3
end
function t1.closeNode(t6: {[any]: any}, p13) -- line: 305
	-- upvalues: t1 (copy), insert (copy)
	local v35 = t1.findLastNodeIndex(t6, p13)

	if v35 then
		local v36 = t6[v35]

		for i = v35 + 1, #t6 do
			insert(v36.children, t6[i])
		end

		for _ = v35 + 1, #t6 do
			table.remove(t6)
		end

		local v39 = t6[v35 - 1]

		if v39 then
			table.remove(t6)
			insert(v39.children, v36)
		end

		return v36
	end

	return nil
end
function t1.findLastNodeIndex(t7: {[any]: any}, p14) -- line: 332
	for i = #t7, 1, -1 do
		local v43 = t7[i]

		if if typeof(p14) ~= "string" then p14(v43) else p14 == v43.name then
			return i
		end
	end

	return nil
end
function t1.parseXmlAttributes(s1: string) -- line: 344
	local t8 = {}

	for match, v47 in (s1:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]+)\"%s*")) do
		t8[match] = v47
	end

	return t8
end

return t1.buildTree
