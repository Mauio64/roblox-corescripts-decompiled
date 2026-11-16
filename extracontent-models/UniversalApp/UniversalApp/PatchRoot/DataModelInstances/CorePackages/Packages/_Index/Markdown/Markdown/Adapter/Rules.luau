local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(script.Parent.AdapterTypes)
local Children = require(script.Parent.Children)
require(parent.CommonMark)
require(script.Parent.Engine)
local ListMarkers = require(script.Parent.ListMarkers)
require(Markdown.Types)

local function optionalAttributes(destination: string?, title: string?) -- 2 equivalent calls inferred from this helper
	if destination == nil and title == nil then
		return nil
	end

	return { url = destination, title = title }
end

local function appendListItems(data, list, object)
	local list2 = data.list
	local v = data.out
	local v2 = not list2.tight

	if v2 and data.splitParent == nil then
		object:gap("LooseList", list2)
	end

	local splitParent

	if v2 then
		splitParent = data.splitParent
	else
		splitParent = nil
	end

	local bulletPrefix = ListMarkers.bulletPrefix(list2)
	local v3 = ListMarkers.startNumber(list2)
	local v4 = nil
	local function appendItem()
		if splitParent ~= nil and v4 ~= nil then
			v = object:append(splitParent, "LIST")
		end

		local prefix

		if v3 == nil then
			prefix = bulletPrefix
		else
			prefix = ListMarkers.orderedPrefix(v3)
		end

		if v3 ~= nil then
			v3 += 1
		end

		local v5 = object:append(v, "LIST_ITEM", { prefix = prefix })
		v4 = v5
		return v5
	end

	for _, v5 in object:_units(list2, true) do
		local block = v5.block

		if block == nil or block.kind ~= "ListItem" then
			object:_flattenUnits({ v5 }, v4 or appendItem())
		else
			local v6 = appendItem()
			local units = object:_units(block, false)
			local block2 = nil

			for _, unit in units do
				if Children.isList(unit) then
					block2 = unit.block
					break
				end
			end

			object:_flattenUnits(units, v6, { except = block2, gap = "ListItemBlocks" }, block)

			if block2 ~= nil then
				table.insert(list, { list = block2, out = object:append(v, "LIST") })
			end
		end
	end
end

local Rules = {}

function Rules.list(p)
	local v = p == nil or p.splitLooseTopLevel ~= false
	return function(list, object)
		local v3 = { list = list, out = object:block("LIST"), splitParent = 0 }
		local splitParent

		if v and object.depth == 0 then
			splitParent = object.parent
		end

		v3.splitParent = splitParent
		local v2 = { v3 }

		while #v2 > 0 do
			appendListItems(table.remove(v2), v2, object)
		end
	end
end

function Rules.quote(p)
	local v = p == nil and "flatten" or p.nested or "flatten"

	if v ~= "flatten" and v ~= "drop" then
		error(`Rules.quote's nested must be "flatten" or "drop", not {v}`)
	end

	local frozen

	if v == "drop" then
		frozen = table.freeze({ BlockQuote = true })
	else
		frozen = nil
	end

	return function(p2, object)
		object:flatten(p2, object:block("QUOTE"), { gap = "QuoteBlocks", drop = frozen })
	end
end

function Rules.codeBlock()
	return function(data, object)
		local info

		if data.kind == "FencedCodeBlock" then
			info = data.info
		end

		local v

		if not (info == nil or info == "") then
			local v2 = string.find(info, " ", 1, true)
			v = { language = 0 }

			if v2 then
				info = string.sub(info, 1, v2 - 1)
			end

			v.language = info
		end

		local block = object:block("CODE_BLOCK", v)
		local literal = data.literal or ""

		if string.sub(literal, -1) == "\n" then
			literal = string.sub(literal, 1, -2)
		end

		block.text = literal
	end
end

function Rules.divider()
	return function(_, object)
		object:block("DIVIDER")
	end
end

function Rules.htmlBlock()
	return function(p, object)
		local block = object:block("PARAGRAPH")
		local literal = p.literal

		if literal ~= nil and literal ~= "" then
			local append = object:append(block, "TEXT")
			append.text = literal
		end
	end
end

function Rules.code()
	return function(p, object)
		local v = object:append(object.parent, "STYLED_TEXT", { style = "INLINE_CODE" })
		local literal = p.literal

		if literal ~= nil and literal ~= "" then
			local append = object:append(v, "TEXT")
			append.text = literal
		end
	end
end

function Rules.hardLineBreak()
	return function(_, object)
		object:append(object.parent, "BREAK")
	end
end

function Rules.link()
	return function(p, object)
		object:adaptInlinesOf(p, (object:append(object.parent, "LINK", optionalAttributes(p.destination, p.title)))) -- inferred equivalent call
	end
end

function Rules.image()
	return function(p, object)
		local parent2 = object.parent
		local append = object:append(parent2, "IMAGE", optionalAttributes(p.destination, p.title)) -- inferred equivalent call
		append.text = object:plainText(p)
	end
end

return Rules
