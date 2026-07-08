local Markdown = script:FindFirstAncestor("Markdown")
local MarkdownParent = Markdown.Parent
local Dash = require(MarkdownParent.Dash)

require(Markdown.Types)
require(MarkdownParent.InlineLayout)

local InlineEngineTag = require(MarkdownParent.MarkdownCore).Enums.InlineEngineTag

return {
	getCodeTextStyles = function(p1) -- line: 8
		-- upvalues: Dash (copy)
		return Dash.joinDeep(p1.textStyles, p1.codeStyles)
	end,
	getBaseTextElementEngineTags = function(p2) -- line: 12
		-- upvalues: InlineEngineTag (copy)
		if not p2 then
			return nil
		end

		local t1 = {}

		if p2.bold then
			table.insert(t1, {
				name = InlineEngineTag.BOLD,
				attributes = {}
			})
		end

		if p2.italic then
			table.insert(t1, {
				name = InlineEngineTag.ITALIC,
				attributes = {}
			})
		end

		if p2.strike then
			table.insert(t1, {
				name = InlineEngineTag.STRIKE,
				attributes = {}
			})
		end

		if p2.color then
			table.insert(t1, {
				name = InlineEngineTag.FONT,
				attributes = {
					color = p2.color
				}
			})
		end

		return t1
	end
}
