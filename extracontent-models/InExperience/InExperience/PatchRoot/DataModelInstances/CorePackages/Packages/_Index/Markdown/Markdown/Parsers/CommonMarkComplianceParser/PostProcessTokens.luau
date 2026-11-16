local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local EmphasisParser = require(script.Parent.EmphasisParser)
local MarkdownCore = require(Markdown.Parent.MarkdownCore)
local Flags = MarkdownCore.Flags

return ({
	postProcessTokens = function(list)
		local v = false
		local v2 = 1
		local result = {}

		for i = 1, #list do
			local item = list[i]

			local v3 = v and item.name == "TABLE_DIVIDER"

			if Flags.FFlagMarkdownTables and item.isBlock then
				v = item.name == "TABLE_ROW"
			end

			if not (item.isBlock or item.name == "LINE_BREAK" or v3) then
				continue
			end

			if v2 < i then
				local v4 = EmphasisParser.processEmphasisRun(list, v2, i - 1)

				for _, v5 in v4 do
					table.insert(result, v5)
				end
			end

			table.insert(result, item)
			v2 = i + 1
		end

		if v2 <= #list then
			local v3 = EmphasisParser.processEmphasisRun(list, v2, #list)

			for _, v4 in v3 do
				table.insert(result, v4)
			end
		end

		return result
	end
}).postProcessTokens
