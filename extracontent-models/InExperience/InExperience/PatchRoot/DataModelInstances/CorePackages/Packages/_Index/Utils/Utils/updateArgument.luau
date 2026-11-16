local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local astFromType = require(script.Parent.astFromType)
local astFromType2 = astFromType.astFromType
local UpdateArgument = {}

function UpdateArgument:updateArgument(p, p2, p3: string, p4: string, p5, p6)
	self[tostring(p3)] = {
		kind = Kind.ARGUMENT,
		name = { kind = Kind.NAME, value = p3 },
		value = {
			kind = Kind.VARIABLE,
			name = { kind = Kind.NAME, value = p4 }
		}
	}

	p[tostring(p4)] = {
		kind = Kind.VARIABLE_DEFINITION,
		variable = {
			kind = Kind.VARIABLE,
			name = { kind = Kind.NAME, value = p4 }
		},
		type = astFromType2(p5)
	}

	if p6 ~= nil then
		p2[tostring(p4)] = p6
	elseif Array.indexOf(Object.keys(p2), (tostring(p4))) ~= -1 then
		p2[tostring(p4)] = nil
	end
end

function UpdateArgument.createVariableNameGenerator(p)
	local count = 0
	return function(p2: string)
		local v

		repeat
			v = ("_v%s_%s"):format(tostring(count), p2)
			count += 1
		until Array.indexOf(Object.keys(p), (tostring(v))) == -1

		return v
	end
end

return UpdateArgument
