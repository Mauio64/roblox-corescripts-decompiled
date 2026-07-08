local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

require(script.Parent.Parent.language.ast)

function concatAST(p1) -- line: 23
	-- upvalues: Array (copy)
	local t1 = {}

	for _, v in ipairs(p1) do
		t1 = Array.concat(t1, v.definitions)
	end

	return {
		kind = "Document",
		definitions = t1
	}
end

return {
	concatAST = concatAST
}
