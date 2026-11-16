local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

require(script.Parent.Parent.language.ast)

function concatAST(list)
	local joined = {}

	for _, item in ipairs(list) do
		joined = Array.concat(joined, item.definitions)
	end

	return { kind = "Document", definitions = joined }
end

return { concatAST = concatAST }
