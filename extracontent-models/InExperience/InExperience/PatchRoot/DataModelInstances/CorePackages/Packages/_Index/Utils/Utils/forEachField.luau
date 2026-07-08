local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local getNamedType = GraphQL.getNamedType
local isObjectType = GraphQL.isObjectType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function t1.forEachField(p1, p2) -- line: 25
	-- upvalues: String (copy), getNamedType (copy), isObjectType (copy)
	local v10 = p1:getTypeMap()

	for _, v12 in v10 do
		local v13 = v12[1]
		local v14 = v10:get(v13)

		if not String.startsWith(getNamedType(v14).name, "__") and isObjectType(v14) then
			local v15 = v14:getFields()

			for _, v17 in v15 do
				local v18 = v17[1]

				p2(v15:get(v18), v13, v18)
			end
		end
	end
end

return t1
