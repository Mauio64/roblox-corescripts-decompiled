local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local PostProcessTokens = require(script.Parent.PostProcessTokens)
local Utils = require(script.Parent.Utils)
local MarkdownCore = require(Markdown.Parent.MarkdownCore)
local Flags = MarkdownCore.Flags

local insert = table.insert

local v = { ACTION = true, OPEN = true, CLOSE = true, OPEN_CLOSE = true }

local function createInlineCodeTracker(value: string)
	local v2 = -1
	local v3 = nil
	local count = 0
	local v4 = -1
	local v5 = nil

	local function finishRun() -- 3 equivalent calls inferred from this helper
		if count == 0 then
			return
		end

		if v3 == nil then
			v3 = count
		elseif v3 == count then
			v3 = nil
		end

		count = 0
		v5 = nil
	end

	local function startLine(p: number) -- 3 equivalent calls inferred from this helper
		if p ~= v2 then
			v2 = p
			v3 = nil
			count = 0
			v4 = -1
			v5 = nil
		end
	end

	return {
		addBacktick = function(p: number, p2: number)
			startLine(p) -- inferred equivalent call

			if p2 ~= v4 + 1 then
				finishRun() -- inferred equivalent call
			end

			count += 1
			v4 = p2
		end,
		isInside = function(p: number): boolean
			startLine(p) -- inferred equivalent call
			finishRun() -- inferred equivalent call
			return v3 ~= nil
		end,
		isInsideClosed = function(p: number, p2: number)
			startLine(p) -- inferred equivalent call
			finishRun() -- inferred equivalent call

			if v3 == nil then
				return false
			end

			if v5 ~= nil then
				return v5
			end

			v5 = false
			local v6 = string.find(value, "\n", p2, true) or #value + 1

			for k in string.gmatch(string.sub(value, p2, v6 - 1), "`+") do
				if #k == v3 then
					v5 = true
					break
				end
			end

			return v5
		end
	}
end

local v2 = {
	{ "TABLE_ROW", "^[ \t]*|?" }
}

local function getTableRowCells(value: string)
	local v3 = string.match(value, "^%s*(.-)%s*$") or ""
	local v4 = string.gsub(v3, "^|", "")
	local v5 = string.gsub(v4, "|$", "")
	local v6 = string.gsub(v5, "\\|", "")

	local tableRowCells = {}

	for k in string.gmatch(v6 .. "|", "([^|]*)|") do
		insert(tableRowCells, k)
	end

	return tableRowCells
end

local function isDelimiterRow(value: string): boolean
	if not string.find(value, "|", 1, true) then
		return false
	end

	for _, v3 in getTableRowCells(value) do
		if not string.match(v3, "^%s*:?%-+:?%s*$") then
			return false
		end
	end

	return true
end

local v3 = {
	"^ ? ? ?##?#?#?#?#?[ \t]",
	"^ ? ? ?##?#?#?#?#?$",
	"^ ? ? ?%-[ \t]*%-[ \t]*%-[ \t]*[%- \t]*$",
	"^ ? ? ?%*[ \t]*%*[ \t]*%*[ \t]*[%* \t]*$",
	"^ ? ? ?_[ \t]*_[ \t]*_[ \t]*[_ \t]*$",
	"^%s*[%*%-] ",
	"^%s*```",
	"^%s*~~~",
	"^%s*>",
	"^%s*[0-9]+%.[ \t]",
	"^%s*[A-Za-z]%.[ \t]"
}

local function startsOtherBlock(value: string): boolean -- 2 equivalent calls inferred from this helper
	for _, v4 in v3 do
		if string.find(value, v4) then
			return true
		end
	end

	return false
end

local function couldBecomeDelimiterRow(value: string, count: number): boolean -- 1 equivalent call inferred from this helper
	return string.find(value, "^[%s|:%-]*$") ~= nil and #getTableRowCells(value) <= count
end

local function isTableRow(value: string, p: number, flag: boolean, flag2: boolean)
	local v4 = string.find(value, "\n", p, true)
	local v5

	if v4 then
		v5 = v4 - 1
	else
		v5 = #value
	end

	local v6 = string.sub(value, p, v5)

	if flag then
		return string.find(v6, "%S") ~= nil and (isDelimiterRow(v6) or not startsOtherBlock(v6)) -- inferred equivalent call
	else
		if not string.find(v6, "|", 1, true) then
			return false
		end

		if startsOtherBlock(v6) then -- inferred equivalent call
			return false
		end

		local v7 = flag2 and string.sub(v6, 1, 1) == "|"

		if not v4 then
			return v7
		end

		local v8 = string.find(value, "\n", v4 + 1, true)
		local v9 = v4 + 1
		local v10

		if v8 then
			v10 = v8 - 1
		else
			v10 = #value
		end

		local v11 = string.sub(value, v9, v10)
		local count = #getTableRowCells(v6)

		if isDelimiterRow(v11) and #getTableRowCells(v11) == count then
			return true
		end

		return v7 and not v8 and couldBecomeDelimiterRow(v11, count) -- inferred equivalent call
	end
end

local v4 = {
	{ "BREAK", "^\\\n" },
	{ "ESCAPE", "^\\(%p)" }
}

local v5 = {
	{ "IMAGE", "^!%[([^%]]+)%]%(([^%)]+)%)" }
}

local v6 = {
	{ "OPEN_CLOSE", "^<([%w-]+)%s?([^>]*)/>" },
	{ "CLOSE", "^</([%w-]+)%s?([^>]*)>" },
	{ "OPEN", "^<([%w-]+)%s?([^>]*)>" }
}

local v7 = {
	{ "BOLD_2", "^%*%*" },
	{ "BOLD", "^%*" }
}

local v8 = {
	{ "ITALIC_2", "^__" },
	{ "ITALIC", "^_" }
}

local v9 = {
	{ "STRIKE", "^~" }
}

local v10 = {
	{ "INLINE_CODE", "^`" }
}

local v11 = {
	["\\"] = v4,
	["!"] = v5,
	["<"] = v6,
	["*"] = v7,
	_ = v8,
	["~"] = v9,
	["`"] = v10
}

local v12 = {
	["\n"] = {
		{ "LINE_BREAK", "^\n", 1 },
		{ "HEADING", "^ ? ? ?(##?#?#?#?#?)[ \t]+", 1 },
		{ "HEADING", "^ ? ? ?(##?#?#?#?#?)\n", 1 },
		{ "DIVIDER", "^ ? ? ?%-[ \t]*%-[ \t]*%-[ \t]*[%- \t]*\n", 1 },
		{ "DIVIDER", "^ ? ? ?%*[ \t]*%*[ \t]*%*[ \t]*[%* \t]*\n", 1 },
		{ "DIVIDER", "^ ? ? ?_[ \t]*_[ \t]*_[ \t]*[_ \t]*\n", 1 },
		{ "BULLET_LIST_ITEM", "^(%s*)(%* )" },
		{ "BULLET_LIST_ITEM_2", "^(%s*)(- )" },
		{ "CODE_BLOCK", "^```[ \t]*([^\n]*)[ \t]*\n(.-)```" },
		{ "CODE_BLOCK", "^```[ \t]*([^\n]*)[ \t]*\n(.+)$" },
		{ "CODE_BLOCK", "^~~~[ \t]*([^\n]*)[ \t]*\n(.-)~~~" },
		{ "CODE_BLOCK", "^~~~[ \t]*([^\n]*)[ \t]*\n(.+)$" },
		{ "QUOTE", "^%s*>" },
		{ "ORDERED_LIST_ITEM", "^(%s*)([0-9]+)%.[ \t]+" },
		{ "ORDERED_LIST_ITEM", "^(%s*)([A-Za-z])%.[ \t]+" },
		{ "TABLE_ROW", "^|" }
	},
	["\\"] = v4,
	["-"] = {
		{ "TABLE_HEADER", "^[-]+" }
	},
	["="] = {
		{ "TABLE_HEADER_2", "^[=]+" }
	},
	["!"] = v5,
	["|"] = {
		{ "TABLE_DIVIDER", "^|" }
	},
	["<"] = v6,
	["*"] = v7,
	_ = v8,
	["~"] = v9,
	["["] = {
		{ "LINK", "^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]\"([^\n]+)\"[ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]'([^\n]+)'[ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]%(([^\n]+)%)[ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*<>[ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*<([^\n\t]+)>[ \t]*%)" },
		{ "LINK", "^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]*%)" },
		{ "ACTION", "^%[%[([^%]]+)%]%]" }
	},
	["`"] = v10
}

local v13 = {
	{ "LINE_BREAK", "^[ \t\r]+\n", 1 }
}
table.move(v12["\n"], 1, #v12["\n"], #v13 + 1, v13)

local function withoutTableRow(items)
	local result = {}

	for _, item in items do
		if item[1] ~= "TABLE_ROW" then
			insert(result, item)
		end
	end

	return result
end

local v14 = withoutTableRow(v12["\n"])
local v15 = withoutTableRow(v13)

local v16 = {
	LINK = {
		mapToText = function(p)
			return p.capture and p.capture[1] or ""
		end,
		startToken = "LINK_START",
		endToken = "LINK_END",
		textStartOffset = 1
	}
}

local v17 = {
	{ "HEADING", "^  ? ?(#+)%s*\n", 1 }
}

local function tokenizeTextSpan(value: string, p: number, flag: boolean, p2)
	local total = 0
	local v18 = 0
	local v19 = 0
	local v20 = {}

	local v21 = nil
	local v22 = false
	local v23 = Flags.FFlagMarkdownTables and p2.isStreaming == true
	local v24

	if Flags.FFlagMarkdownTagFallbacks then
		v24 = createInlineCodeTracker(value)
	end

	while total <= #value do
		local v25 = total == 0 and not flag and "\n" or string.sub(value, total, total)
		local v26

		if v25 == "\n" then
			v26 = not flag
		else
			v26 = false
		end

		local v27 = Flags.FFlagMarkdownTables
			and v26
			and isTableRow(
				value,
				total + 1,
				v22,
				v23 and (total <= 1 or string.sub(value, total - 1, total - 1) == "\n")
			)

		local v28 = Flags.FFlagMarkdownTables and v26 and not v27
		local v29

		if flag then
			v29 = v11[v25] or {}
		elseif v25 == "\n" and v21 == "QUOTE" then
			v29 = if v28 then v15 else v13
		elseif v27 then
			v29 = v2
		elseif v28 then
			v29 = v14
		else
			v29 = v12[v25] or v17
		end

		local v30 = false
		local v31 = nil
		local v32

		if v25 == "\n" and not flag then
			v19 = total
			v32 = 1
		else
			v32 = 0
		end

		for _, v34 in v29 do
			local v35 = v34[2]
			local v36, v37 = string.find(value, v35, total + v32)

			if not (v36 and v37) then
				continue
			end

			local text = string.sub(value, v36, v37)
			local name = v34[1]

			local v40 = v34[3] or 0
			local v41 = #text - v40
			local context = nil

			if not flag then
				local _, v43 = string.find(text, "\n[^\n]*$")

				if v43 then
					v19 = v43 + v36
				end
			end

			local v43 = Flags.FFlagMarkdownTables

			if v43 then
				if v21 == "TABLE_ROW" then
					v43 = text == "\\|"
				else
					v43 = false
				end
			end

			if name == "ESCAPE" and not v43 then
				local v44

				if v24 then
					v44 = v24.isInside(v19)
				else
					v44 = Utils.isInsideInlineCode(v20, v19)
				end

				if v44 then
					continue
				end
			end

			if v24 and v[name] and v24.isInsideClosed(v19, total) then
				continue
			end

			if Constants.STYLED_TEXT[name] then
				context = Utils.getCharacterContext(value, total, v32 + v41)
			end

			local capture = { string.match(value, v35, total + v32) }

			if not flag or v25 ~= "<" or not (#capture > 0) or p2.inlineTags[capture[1]] then
				if total ~= v18 then
					insert(v20, {
						name = "TEXT",
						text = string.sub(value, v18, total - 1),
						offset = v18 + p
					})
				end

				local isBlock = not flag and v25 == "\n"

				if isBlock then
					v21 = name
				end

				if not (#capture > 0) then
					capture = nil
				end

				insert(v20, {
					name = name,
					text = text,
					capture = capture,
					isBlock = isBlock,
					offset = total + p,
					context = context
				})

				if v24 and name == "INLINE_CODE" then
					v24.addBacktick(v19, total)
				end

				total += v32 + v41
				v18 = total
				v31 = name
				v30 = true
				break
			end
		end

		if not v30 then
			total += 1
		end

		if Flags.FFlagMarkdownTables and v26 then
			v22 = v31 == "TABLE_ROW"
		end
	end

	if total ~= v18 then
		insert(v20, {
			name = "TEXT",
			text = string.sub(value, v18, total - 1),
			offset = v18 + p
		})
	end

	return PostProcessTokens(v20)
end

local function tokenize(value: string, p)
	local v18 = tokenizeTextSpan(value, 0, false, p)

	local result = {}

	for _, v19 in v18 do
		local v20 = v16[v19.name]

		if v20 then
			local v21 = {
				{
					name = v20.startToken,
					offset = v19.offset,
					text = string.sub(value, v19.offset, v19.offset + v20.textStartOffset - 1),
					capture = v19.capture
				}
			}

			local mapToText = v20.mapToText(v19)

			local v22 = tokenizeTextSpan(mapToText, v19.offset + v20.textStartOffset, true, p)
			table.move(v22, 1, #v22, 2, v21)

			local offset = v19.offset + v20.textStartOffset + #mapToText
			insert(v21, {
				name = v20.endToken,
				offset = offset,
				text = string.sub(value, offset, v19.offset + #v19.text - 1)
			})

			table.move(v21, 1, #v21, #result + 1, result)
		else
			insert(result, v19)
		end
	end

	return result
end

return tokenize
