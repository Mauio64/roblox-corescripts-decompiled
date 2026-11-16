require(script.Parent.Parent.language.ast)

local kinds = require(script.Parent.Parent.language.kinds)
local kind = kinds.Kind

return {
	getOperationAST = function(p, p2: string?)
		local v = nil

		for _, definition in pairs(p.definitions) do
			if definition.kind ~= kind.OPERATION_DEFINITION then
				continue
			end

			if p2 == nil then
				if v then
					return nil
				end

				v = definition
			elseif definition.name and definition.name.value == p2 then
				return definition
			end
		end

		return v
	end
}
