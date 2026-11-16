local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local lists = Constants.LISTS
local STYLED_TEXT = Constants.STYLED_TEXT
local dividers = Constants.DIVIDERS

local NodeType = require(Markdown.Enums.NodeType)
local getNodeType = require(script.Parent.Parent.getNodeType)
local isNodeBlock = require(script.Parent.Parent.isNodeBlock)
local MarkdownCore = require(Markdown.Parent.MarkdownCore)
local Flags = MarkdownCore.Flags

local insert = table.insert

local v = {
	area = true,
	base = true,
	br = true,
	col = true,
	embed = true,
	hr = true,
	img = true,
	input = true,
	link = true,
	meta = true,
	source = true,
	track = true,
	wbr = true
}

local v2 = { Button = true }

local v3 = {}

local function createTextNode(item, p)
	return {
		name = "TEXT",
		text = item.text,
		children = {},
		offset = item.offset,
		type = getNodeType("TEXT", p)
	}
end

local function createHorizontalRuleNode(item, p, p2)
	local v4

	if p.type == NodeType.Root then
		v4 = true
	elseif p.type == NodeType.Block then
		v4 = p.name ~= "TABLE_ROW"
	else
		v4 = false
	end

	local name = v4 and "DIVIDER" or "BREAK"
	return { name = name, children = {}, offset = item.offset, type = getNodeType(name, p2) }
end

local function isLineStartAfter(item, flag: boolean)
	if item.isBlock then
		return true
	end

	if item.name ~= "TEXT" then
		return false
	end

	local v4 = string.match(item.text, "\n([^\n]*)$")

	if v4 then
		return string.find(v4, "^[ \t]*$") ~= nil
	end

	return flag and string.find(item.text, "^[ \t]*$") ~= nil
end

local function isWellFormedOpenTag(text: string): boolean
	local v4 = string.match(text, "^<%a[%w%-]*(.-)>$")

	while v4 and string.find(v4, "%S") do
		local v5 = string.match(v4, "^%s+[%a_:][%w_%.:%-]*(.*)$")

		if not v5 then
			return false
		end

		v4 = string.match(v5, "^%s*=%s*\"[^\"]*\"(.*)$")
			or string.match(v5, "^%s*=%s*'[^']*'(.*)$")
			or string.match(v5, "^%s*=%s*[^%s\"'=<>`]+(.*)$")
			or v5
	end

	return v4 ~= nil
end

local function mayCloseLaterInStream(token, startsLine: boolean, p) -- 1 equivalent call inferred from this helper
	local v4 = token.capture[1]

	local v5 = not v2[v4]

	if v5 then
		if p.inlineTags[v4] == true or startsLine then
			return isWellFormedOpenTag(token.text)
		end

		return startsLine
	end

	return v5
end

local function findUnpairedTags(items, p)
	local unpairedTags = {}
	local v4 = {}

	local function closeOpenTagsFrom(p2: number) -- 4 equivalent calls inferred from this helper
		for i = #v4, p2, -1 do
			unpairedTags[v4[i].token] = true
			v4[i] = nil
		end
	end

	local v5 = true
	local v6 = false
	local v7 = 1

	for _, item in items do
		local lineStartAfter = isLineStartAfter(item, v5)
		local startsLine

		if item.isBlock then
			if v6 then
				startsLine = v5
				v5 = lineStartAfter
				closeOpenTagsFrom(v7) -- inferred equivalent call
			else
				startsLine = v5
				v5 = lineStartAfter
			end

			for k, v8 in v4 do
				if p.inlineTags[v8.tag] then
					closeOpenTagsFrom(k) -- inferred equivalent call
					break
				end
			end

			v6 = item.name == "TABLE_ROW"

			if v6 then
				v7 = #v4 + 1
			else
				v7 = 1
			end
		elseif v6 and item.name == "TABLE_DIVIDER" then
			startsLine = v5
			v5 = lineStartAfter
			closeOpenTagsFrom(v7) -- inferred equivalent call
		else
			startsLine = v5
			v5 = lineStartAfter
		end

		if not item.capture then
			continue
		end

		local tag = item.capture[1]

		if item.name == "OPEN" and not v[tag] then
			insert(v4, { token = item, tag = tag, startsLine = startsLine })
		elseif item.name == "CLOSE" then
			local v8 = nil

			for i = #v4, v7, -1 do
				if v4[i].tag == tag then
					v8 = i
					break
				end
			end

			if v8 then
				closeOpenTagsFrom(v8 + 1) -- inferred equivalent call
				v4[v8] = nil
			else
				unpairedTags[item] = true
			end
		end
	end

	for _, v8 in v4 do
		if p.isStreaming and mayCloseLaterInStream(v8.token, v8.startsLine, p) then -- inferred equivalent call
			continue
		end

		unpairedTags[v8.token] = true
	end

	return unpairedTags
end

function v3.buildTree(list, p)
	local v4 = not Flags.FFlagMarkdownTagFallbacks and {} or findUnpairedTags(list, p)
	local tree = { name = "ROOT", children = {}, offset = 1, type = NodeType.Root }
	local v5 = 1
	local v6 = { tree }

	while v5 <= #list do
		local item = list[v5]
		local v7 = v6[#v6]

		if item.name == "CODE_BLOCK" and item.capture then
			local text = string.gsub(item.capture[2], "^%s*(.-)%s*$", "%1")
			insert(v7.children, {
				name = "CODE_BLOCK",
				text = text,
				children = {},
				attributes = { language = item.capture[1] },
				offset = item.offset,
				type = getNodeType("CODE_BLOCK", p)
			})
		elseif item.name == "EMPHASIS_START" then
			insert(v6, {
				name = "STYLED_TEXT",
				attributes = { style = item.text },
				children = {},
				offset = item.offset,
				type = getNodeType("STYLED_TEXT", p)
			})
		elseif item.name == "EMPHASIS_END" then
			v3.closeNode(v6, function(p2): boolean
				return p2.name == "STYLED_TEXT"
			end)
		elseif
			Flags.FFlagMarkdownTagFallbacks
			and v4[item]
			and item.name == "OPEN"
			and item.capture
			and v2[item.capture[1]]
		then
			local v8 = item.capture[2]
			insert(v7.children, {
				name = "TAG",
				text = item.capture[1],
				attributes = not v8 and {} or v3.parseXmlAttributes(v8),
				children = {},
				offset = item.offset,
				type = NodeType.Block
			})
		elseif STYLED_TEXT[item.name] or Flags.FFlagMarkdownTagFallbacks and v4[item] then
			insert(v7.children, createTextNode(item, p))
		elseif lists[item.name] and item.capture then
			v3.closeNode(v6, function(p2)
				return isNodeBlock(p2)
			end)

			insert(v6, {
				name = "LIST_ITEM",
				children = {},
				attributes = {
					depth = #item.capture[1],
					prefix = item.capture[2]
				},
				offset = item.offset,
				type = getNodeType("LIST_ITEM", p)
			})
		elseif item.name == "HEADING" and not item.isBlock then
			if not v3.closeNode(v6, function(p2): boolean
				return p2.name == "HEADING"
			end) then
				insert(v7.children, createTextNode(item, p))
			end
		elseif item.isBlock then
			v3.closeNode(v6, function(p2)
				return isNodeBlock(p2)
			end)
			local v8

			if dividers[item.name] then
				v8 = v6[#v6].children
			else
				v8 = v6
			end

			local attributes = {}

			if item.name == "HEADING" and item.capture then
				attributes.depth = #item.capture[1]
			end

			insert(v8, {
				name = item.name,
				children = {},
				attributes = attributes,
				offset = item.offset,
				type = getNodeType(item.name, p)
			})
		elseif item.name == "ESCAPE" and item.capture then
			insert(v7.children, {
				name = "TEXT",
				text = item.capture[1],
				offset = item.offset,
				children = {},
				type = getNodeType("TEXT", p)
			})
		elseif item.name == "LINK_START" and item.capture then
			insert(v6, {
				text = item.capture[1],
				name = "LINK",
				attributes = { url = item.capture[2], title = item.capture[3] },
				children = {},
				offset = item.offset,
				type = getNodeType("LINK", p)
			})
		elseif item.name == "LINK_END" then
			v3.closeNode(v6, function(p2): boolean
				return p2.name == "LINK"
			end)
		elseif item.name == "IMAGE" and item.capture then
			insert(v7.children, {
				name = item.name,
				text = item.capture[1],
				attributes = { url = item.capture[2], title = item.capture[3] },
				offset = item.offset,
				children = {},
				type = getNodeType("IMAGE", p)
			})
		elseif item.name == "OPEN_CLOSE" and item.capture then
			local text = item.capture[1]
			local v8 = item.capture[2]

			if item.capture and text == "br" then
				insert(v7.children, {
					name = "BREAK",
					children = {},
					offset = item.offset,
					type = getNodeType("BREAK", p)
				})
			elseif Flags.FFlagMarkdownTagFallbacks and text == "hr" then
				insert(v7.children, createHorizontalRuleNode(item, v7, p))
			else
				local children = v7.children
				local v9 = {
					name = "TAG",
					text = text,
					attributes = not v8 and {} or v3.parseXmlAttributes(v8),
					children = {},
					offset = item.offset,
					type = 0
				}
				local v10

				if p.inlineTags[text] then
					v10 = NodeType.InlineSpan
				else
					v10 = NodeType.Block
				end

				v9.type = v10
				insert(children, v9)
			end
		elseif item.name == "OPEN" and item.capture then
			local text = item.capture[1]
			local v8 = item.capture[2]

			if item.capture and text == "br" then
				insert(v7.children, {
					name = "BREAK",
					children = {},
					offset = item.offset,
					type = getNodeType("BREAK", p)
				})
			elseif Flags.FFlagMarkdownTagFallbacks and text == "hr" then
				insert(v7.children, createHorizontalRuleNode(item, v7, p))
			elseif Flags.FFlagMarkdownTagFallbacks and v[text] then
				local children = v7.children
				local v9 = {
					name = "TAG",
					text = text,
					attributes = not v8 and {} or v3.parseXmlAttributes(v8),
					children = {},
					offset = item.offset,
					type = 0
				}
				local v10

				if p.inlineTags[text] then
					v10 = NodeType.InlineSpan
				else
					v10 = NodeType.Block
				end

				v9.type = v10
				insert(children, v9)
			else
				local v9 = {
					name = "TAG",
					text = text,
					attributes = not v8 and {} or v3.parseXmlAttributes(v8),
					children = {},
					offset = item.offset,
					type = 0
				}
				local v10

				if p.inlineTags[text] then
					v10 = NodeType.InlineSpan
				else
					v10 = NodeType.Block
				end

				v9.type = v10
				insert(v6, v9)
			end
		elseif Flags.FFlagMarkdownTagFallbacks and item.name == "CLOSE" and item.capture then
			local v8 = item.capture[1]

			if not v3.closeNode(v6, function(p2): boolean
				return p2.name == "TAG" and p2.text == v8
			end) then
				insert(v7.children, createTextNode(item, p))
			end
		elseif item.name == "CLOSE" and item.capture then
			local v8 = item.capture[1]

			assert(v3.closeNode(v6, function(data): boolean
				if data.name ~= "TAG" then
					return false
				end

				assert(
					data.text == v8,
					`Found <{data.text}> at {data.offset} when trying to close </{v8}> at {item.offset}`
				)

				return true
			end), `No open tag exists trying to close </{v8}> at {item.offset}`)
		elseif v7.name == "HEADING" then
			local v8 = string.find(item.text, "\n", 1, true)

			if v8 then
				local text = string.sub(item.text, 1, v8 - 1)
				local text2 = string.sub(item.text, v8 + 1)

				if string.find(text2, "%S") == nil then
					insert(v7.children, {
						name = item.name,
						text = item.text,
						children = {},
						offset = item.offset,
						type = getNodeType(item.name, p)
					})
				else
					insert(v7.children, {
						name = item.name,
						text = text,
						children = {},
						offset = item.offset,
						type = getNodeType(item.name, p)
					})

					v3.closeNode(v6, function(p2): boolean
						return p2.name == "HEADING"
					end)

					insert(v6, {
						name = "PARAGRAPH",
						children = {
							{
								name = "TEXT",
								text = text2,
								children = {},
								offset = item.offset + v8 + 1,
								type = getNodeType("TEXT", p)
							}
						},
						offset = item.offset,
						type = getNodeType("PARAGRAPH", p)
					})
				end
			else
				insert(v7.children, {
					name = item.name,
					text = item.text,
					children = {},
					offset = item.offset,
					type = getNodeType(item.name, p)
				})
			end
		else
			insert(v7.children, {
				name = item.name,
				text = item.text,
				children = {},
				offset = item.offset,
				type = getNodeType(item.name, p)
			})
		end

		v5 += 1
	end

	v3.closeNode(v6, function(p2)
		return isNodeBlock(p2)
	end)

	v3.closeNode(v6, function(p2): boolean
		return p2.name == "ROOT"
	end)

	return tree
end

function v3.closeNode(list, p)
	local lastNodeIndex = v3.findLastNodeIndex(list, p)

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

function v3.findLastNodeIndex(list, value)
	for i = #list, 1, -1 do
		local item = list[i]
		local v4

		if typeof(value) == "string" then
			v4 = item.name == value
		else
			v4 = value(item)
		end

		if v4 then
			return i
		end
	end

	return nil
end

function v3.parseXmlAttributes(value: string)
	local v4 = value:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]+)\"%s*")

	local xmlAttributes = {}

	for k, v5 in v4 do
		xmlAttributes[k] = v5
	end

	return xmlAttributes
end

return v3.buildTree
