require(script.Parent.Parent.language.ast)

local Kind = require(script.Parent.Parent.language.kinds).Kind

return {
	getOperationAST = function(p1, s1: string?) -- line: 21
		-- upvalues: Kind (copy)
		local v4 = nil

		for _, v in pairs(p1.definitions) do
			if v.kind ~= Kind.OPERATION_DEFINITION then
				continue
			end

			if s1 ~= nil then
				if not v.name or s1 ~= v.name.value then
					continue
				end

				return v
			end

			if v4 then
				return nil
			end

			v4 = v
		end

		return v4
	end
}
