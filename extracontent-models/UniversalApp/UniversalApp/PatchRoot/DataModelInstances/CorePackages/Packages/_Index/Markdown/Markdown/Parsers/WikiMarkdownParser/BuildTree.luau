local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local lists = Constants.LISTS
local STYLED_TEXT = Constants.STYLED_TEXT
local dividers = Constants.DIVIDERS

local insert = table.insert

local NodeType = require(Markdown.Enums.NodeType)
local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)

local v = {}

function v.buildTree(list, p)
	local tree = { name = "ROOT", children = {}, offset = 1, type = NodeType.Root }
	local v2 = 1
	local v3 = { tree }

	while v2 <= #list do
		local item = list[v2]
		local v4 = v3[#v3]

		if item.name == "CODE_BLOCK" and item.capture then
			local text = string.gsub(item.capture[2], "^%s*(.-)%s*$", "%1")
			insert(v4.children, {
				name = "CODE_BLOCK",
				text = text,
				children = {},
				attributes = { language = item.capture[1] },
				offset = item.offset,
				type = getNodeType("CODE_BLOCK", p)
			})
		elseif item.name == "INLINE_CODE" and item.capture then
			insert(v4.children, {
				name = "STYLED_TEXT",
				attributes = { style = "INLINE_CODE" },
				children = {
					{
						name = "TEXT",
						text = item.capture[1],
						children = {},
						offset = item.offset,
						type = getNodeType("TEXT", p)
					}
				},
				offset = item.offset,
				type = getNodeType("STYLED_TEXT", p)
			})
		elseif STYLED_TEXT[item.name] then
			if not v.closeNode(v3, function(data): boolean
				if data.name ~= "STYLED_TEXT" or not (data.attributes and data.attributes.style) then
					return false
				end

				assert(
					data.attributes.style == item.name,
					`Can't put {item.name} at {item.offset} inside {data.attributes.style} at {data.offset}`
				)

				return true
			end) then
				insert(v3, {
					name = "STYLED_TEXT",
					attributes = { style = item.name },
					children = {},
					offset = item.offset,
					type = getNodeType("STYLED_TEXT", p)
				})
			end
		elseif lists[item.name] and item.capture then
			v.closeNode(v3, function(p2)
				return isNodeBlock(p2)
			end)

			insert(v3, {
				name = "LIST_ITEM",
				children = {},
				attributes = {
					depth = #item.capture[1],
					prefix = item.capture[2]
				},
				offset = item.offset,
				type = getNodeType("LIST_ITEM", p)
			})
		elseif item.isBlock then
			v.closeNode(v3, function(p2)
				return isNodeBlock(p2)
			end)

			local attributes = {}

			if item.name == "HEADING" and item.capture then
				attributes.depth = #item.capture[1]
			end

			local v5

			if dividers[item.name] then
				v5 = v3[#v3].children
			else
				v5 = v3
			end

			insert(v5, {
				name = item.name,
				children = {},
				attributes = attributes,
				offset = item.offset,
				type = getNodeType(item.name, p)
			})
		elseif item.name == "ESCAPE" and item.capture then
			insert(v4.children, {
				name = "TEXT",
				text = item.capture[1],
				offset = item.offset,
				children = {},
				type = getNodeType("TEXT", p)
			})
		elseif item.name == "LINK" and item.capture then
			local v5 = string.find(item.text, item.capture[1], 1, true)
			insert(v4.children, {
				name = "LINK",
				text = item.capture[1],
				url = item.capture[2],
				offset = item.offset,
				children = {
					{
						name = "TEXT",
						text = item.capture[1],
						offset = v5 or item.offset,
						children = {},
						type = getNodeType("TEXT", p)
					}
				},
				type = getNodeType("LINK", p)
			})
		elseif item.name == "IMAGE" and item.capture then
			insert(v4.children, {
				name = item.name,
				text = item.capture[1],
				url = item.capture[2],
				offset = item.offset,
				children = {},
				type = getNodeType("IMAGE", p)
			})
		elseif item.name == "OPEN_CLOSE" and item.capture then
			local text = item.capture[1]
			local v5 = item.capture[2]

			if item.capture and text == "br" then
				insert(v4.children, {
					name = "BREAK",
					children = {},
					offset = item.offset,
					type = getNodeType("BREAK", p)
				})
			else
				local children = v4.children
				local v6 = {
					name = "TAG",
					text = text,
					attributes = not v5 and {} or v.parseXmlAttributes(v5),
					children = {},
					offset = item.offset,
					type = 0
				}
				local v7

				if p.inlineTags[text] then
					v7 = NodeType.InlineSpan
				else
					v7 = NodeType.Block
				end

				v6.type = v7
				insert(children, v6)
			end
		elseif item.name == "OPEN" and item.capture then
			local text = item.capture[1]
			local v5 = item.capture[2]

			if item.capture and text == "br" then
				insert(v4.children, {
					name = "BREAK",
					children = {},
					offset = item.offset,
					type = getNodeType("BREAK", p)
				})
			else
				local v6 = {
					name = "TAG",
					text = text,
					attributes = not v5 and {} or v.parseXmlAttributes(v5),
					children = {},
					offset = item.offset,
					type = 0
				}
				local v7

				if p.inlineTags[text] then
					v7 = NodeType.InlineSpan
				else
					v7 = NodeType.Block
				end

				v6.type = v7
				insert(v3, v6)
			end
		elseif item.name == "CLOSE" and item.capture then
			local v5 = item.capture[1]

			assert(v.closeNode(v3, function(data): boolean
				if data.name ~= "TAG" then
					return false
				end

				assert(
					data.text == v5,
					`Found <{data.text}> at {data.offset} when trying to close </{v5}> at {item.offset}`
				)

				return true
			end), `No open tag exists trying to close </{v5}> at {item.offset}`)
		else
			insert(v4.children, {
				name = item.name,
				text = item.text,
				children = {},
				offset = item.offset,
				type = getNodeType(item.name, p)
			})
		end

		v2 += 1
	end

	v.closeNode(v3, function(p2)
		return isNodeBlock(p2)
	end)

	v.closeNode(v3, function(p2): boolean
		return p2.name == "ROOT"
	end)

	return tree
end

function v.closeNode(list, p)
	local lastNodeIndex = v.findLastNodeIndex(list, p)

	if not lastNodeIndex then
		return nil
	end

	local item = list[lastNodeIndex]

	for i = lastNodeIndex + 1, #list do
		insert(item.children, list[i])
	end

	for _ = lastNodeIndex + 1, #list do
		table.remove(list)
	end

	local item2 = list[lastNodeIndex - 1]

	if item2 then
		table.remove(list)
		insert(item2.children, item)
	end

	return item
end

function v.findLastNodeIndex(list, value)
	for i = #list, 1, -1 do
		local item = list[i]
		local v2

		if typeof(value) == "string" then
			v2 = item.name == value
		else
			v2 = value(item)
		end

		if v2 then
			return i
		end
	end

	return nil
end

function v.parseXmlAttributes(value: string)
	local v2 = value:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]+)\"%s*")

	local xmlAttributes = {}

	for k, v3 in v2 do
		xmlAttributes[k] = v3
	end

	return xmlAttributes
end

return v.buildTree
