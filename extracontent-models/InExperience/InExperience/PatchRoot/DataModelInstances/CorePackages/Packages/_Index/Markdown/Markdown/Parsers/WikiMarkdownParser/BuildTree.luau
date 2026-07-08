local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local LISTS = Constants.LISTS
local STYLED_TEXT = Constants.STYLED_TEXT
local DIVIDERS = Constants.DIVIDERS
local insert = table.insert
local NodeType = require(Markdown.Enums.NodeType)
local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)
local t1 = {}

function t1.buildTree(t2: {[any]: any}, p1) -- line: 21
	-- upvalues: NodeType (copy), getNodeType (copy), insert (copy), STYLED_TEXT (copy), t1 (copy), LISTS (copy), isNodeBlock (copy), DIVIDERS (copy)
	local t3 = {
		name = "ROOT",
		offset = 1,
		children = {},
		type = NodeType.Root
	}
	local t4 = { t3 }
	local n1 = 1

	while n1 <= #t2 do
		local v16 = t2[n1]
		local v17 = t4[#t4]

		if v16.name == "CODE_BLOCK" and v16.capture then
			local v18 = string.gsub(v16.capture[2], "^%s*(.-)%s*$", "%1")

			insert(v17.children, {
				name = "CODE_BLOCK",
				text = v18,
				children = {},
				attributes = {
					language = v16.capture[1]
				},
				offset = v16.offset,
				type = getNodeType("CODE_BLOCK", p1)
			})
		elseif v16.name == "INLINE_CODE" and v16.capture then
			insert(v17.children, {
				name = "STYLED_TEXT",
				attributes = {
					style = "INLINE_CODE"
				},
				children = {{
					name = "TEXT",
					text = v16.capture[1],
					children = {},
					offset = v16.offset,
					type = getNodeType("TEXT", p1)
				}},
				offset = v16.offset,
				type = getNodeType("STYLED_TEXT", p1)
			})
		elseif STYLED_TEXT[v16.name] then
			if not t1.closeNode(t4, function(p2) -- line: 70
				-- upvalues: v16 (copy)
				if p2.name == "STYLED_TEXT" and (p2.attributes and p2.attributes.style) then
					assert(p2.attributes.style == v16.name, `Can't put { v16.name } at { v16.offset } inside { p2.attributes.style } at { p2.offset }`)

					return true
				end

				return false
			end) then
				insert(t4, {
					name = "STYLED_TEXT",
					attributes = {
						style = v16.name
					},
					children = {},
					offset = v16.offset,
					type = getNodeType("STYLED_TEXT", p1)
				})
			end
		elseif LISTS[v16.name] and v16.capture then
			t1.closeNode(t4, function(p3) -- line: 95
				-- upvalues: isNodeBlock (copy)
				return isNodeBlock(p3)
			end)
			insert(t4, {
				name = "LIST_ITEM",
				children = {},
				attributes = {
					depth = #v16.capture[1],
					prefix = v16.capture[2]
				},
				offset = v16.offset,
				type = getNodeType("LIST_ITEM", p1)
			})
		elseif v16.isBlock then
			t1.closeNode(t4, function(p4) -- line: 111
				-- upvalues: isNodeBlock (copy)
				return isNodeBlock(p4)
			end)

			local t5 = {}

			if v16.name == "HEADING" and v16.capture then
				t5.depth = #v16.capture[1]
			end

			insert(if not DIVIDERS[v16.name] then t4 else t4[#t4].children, {
				name = v16.name,
				children = {},
				attributes = t5,
				offset = v16.offset,
				type = getNodeType(v16.name, p1)
			})
		elseif v16.name == "ESCAPE" and v16.capture then
			insert(v17.children, {
				name = "TEXT",
				text = v16.capture[1],
				offset = v16.offset,
				children = {},
				type = getNodeType("TEXT", p1)
			})
		elseif v16.name == "LINK" and v16.capture then
			local v20 = string.find(v16.text, v16.capture[1], 1, true)

			insert(v17.children, {
				name = "LINK",
				text = v16.capture[1],
				url = v16.capture[2],
				offset = v16.offset,
				children = {{
					name = "TEXT",
					text = v16.capture[1],
					offset = v20 or v16.offset,
					children = {},
					type = getNodeType("TEXT", p1)
				}},
				type = getNodeType("LINK", p1)
			})
		elseif v16.name == "IMAGE" and v16.capture then
			insert(v17.children, {
				name = v16.name,
				text = v16.capture[1],
				url = v16.capture[2],
				offset = v16.offset,
				children = {},
				type = getNodeType("IMAGE", p1)
			})
		elseif v16.name == "OPEN_CLOSE" and v16.capture then
			local v21 = v16.capture[1]
			local v22 = v16.capture[2]

			if v16.capture and v21 == "br" then
				insert(v17.children, {
					name = "BREAK",
					children = {},
					offset = v16.offset,
					type = getNodeType("BREAK", p1)
				})
			else
				insert(v17.children, {
					name = "TAG",
					text = v21,
					attributes = if not v22 then {} else t1.parseXmlAttributes(v22),
					children = {},
					offset = v16.offset,
					type = if not p1.inlineTags[v21] then NodeType.Block else NodeType.InlineSpan
				})
			end
		elseif v16.name == "OPEN" and v16.capture then
			local v23 = v16.capture[1]
			local v24 = v16.capture[2]

			if v16.capture and v23 == "br" then
				insert(v17.children, {
					name = "BREAK",
					children = {},
					offset = v16.offset,
					type = getNodeType("BREAK", p1)
				})
			else
				insert(t4, {
					name = "TAG",
					text = v23,
					attributes = if not v24 then {} else t1.parseXmlAttributes(v24),
					children = {},
					offset = v16.offset,
					type = if not p1.inlineTags[v23] then NodeType.Block else NodeType.InlineSpan
				})
			end
		elseif v16.name == "CLOSE" and v16.capture then
			local v25 = v16.capture[1]

			assert(t1.closeNode(t4, function(p5) -- line: 209
				-- upvalues: v25 (copy), v16 (copy)
				if p5.name == "TAG" then
					assert(p5.text == v25, `Found <{ p5.text }> at { p5.offset } when trying to close </{ v25 }> at { v16.offset }`)

					return true
				end

				return false
			end), `No open tag exists trying to close </{ v25 }> at { v16.offset }`)
		else
			insert(v17.children, {
				name = v16.name,
				text = v16.text,
				children = {},
				offset = v16.offset,
				type = getNodeType(v16.name, p1)
			})
		end

		n1 += 1
	end

	t1.closeNode(t4, function(p6) -- line: 234
		-- upvalues: isNodeBlock (copy)
		return isNodeBlock(p6)
	end)
	t1.closeNode(t4, function(p7) -- line: 238
		return p7.name == "ROOT"
	end)

	return t3
end
function t1.closeNode(t6: {[any]: any}, p8) -- line: 245
	-- upvalues: t1 (copy), insert (copy)
	local v28 = t1.findLastNodeIndex(t6, p8)

	if v28 then
		local v29 = t6[v28]

		for i = v28 + 1, #t6 do
			insert(v29.children, t6[i])
		end

		for _ = v28 + 1, #t6 do
			table.remove(t6)
		end

		local v32 = t6[v28 - 1]

		if v32 then
			table.remove(t6)
			insert(v32.children, v29)
		end

		return v29
	end

	return nil
end
function t1.findLastNodeIndex(t7: {[any]: any}, p9) -- line: 272
	for i = #t7, 1, -1 do
		local v36 = t7[i]

		if if typeof(p9) ~= "string" then p9(v36) else p9 == v36.name then
			return i
		end
	end

	return nil
end
function t1.parseXmlAttributes(s1: string) -- line: 284
	local t8 = {}

	for match, v40 in (s1:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]+)\"%s*")) do
		t8[match] = v40
	end

	return t8
end

return t1.buildTree
