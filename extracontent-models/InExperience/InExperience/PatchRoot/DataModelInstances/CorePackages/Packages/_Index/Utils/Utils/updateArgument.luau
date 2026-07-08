local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind
local astFromType = require(script.Parent.astFromType).astFromType

function t1.updateArgument(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}, s1: string, s2: string, p1, p2) -- line: 22
	-- upvalues: Kind (copy), astFromType (copy), Array (copy), Object (copy)
	t2[tostring(s1)] = {
		kind = Kind.ARGUMENT,
		name = {
			kind = Kind.NAME,
			value = s1
		},
		value = {
			kind = Kind.VARIABLE,
			name = {
				kind = Kind.NAME,
				value = s2
			}
		}
	}
	t3[tostring(s2)] = {
		kind = Kind.VARIABLE_DEFINITION,
		variable = {
			kind = Kind.VARIABLE,
			name = {
				kind = Kind.NAME,
				value = s2
			}
		},
		type = astFromType(p1)
	}

	if p2 ~= nil then
		t4[tostring(s2)] = p2

		return
	end

	if Array.indexOf(Object.keys(t4), (tostring(s2))) ~= -1 then
		t4[tostring(s2)] = nil
	end
end
function t1.createVariableNameGenerator(t5: {[any]: any}) -- line: 55
	-- upvalues: Array (copy), Object (copy)
	local n1 = 0

	return function(s3: string) -- line: 59
		-- upvalues: n1 (ref), Array (copy), Object (copy), t5 (copy)
		local v18

		repeat
			v18 = ("_v%s_%s"):format(tostring(n1), s3)
			n1 += 1
		until Array.indexOf(Object.keys(t5), (tostring(v18))) == -1

		return v18
	end
end

return t1
