local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local EmphasisParser = require(script.Parent.EmphasisParser)

return ({
	postProcessTokens = function(t1: {[any]: any}) -- line: 11
		-- upvalues: EmphasisParser (copy)
		local t2 = {}
		local n1 = 1

		for i = 1, #t1 do
			local v7 = t1[i]

			if v7.isBlock or v7.name == "LINE_BREAK" then
				if n1 < i then
					for _, v9 in (EmphasisParser.processEmphasisRun(t1, n1, i - 1)) do
						table.insert(t2, v9)
					end
				end

				table.insert(t2, v7)
				n1 = i + 1
			end
		end

		if n1 <= #t1 then
			for _, v11 in (EmphasisParser.processEmphasisRun(t1, n1, #t1)) do
				table.insert(t2, v11)
			end
		end

		return t2
	end
}).postProcessTokens
