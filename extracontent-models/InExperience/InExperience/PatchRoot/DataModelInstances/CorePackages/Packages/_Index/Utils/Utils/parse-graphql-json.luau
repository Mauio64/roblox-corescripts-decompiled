local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local t1 = {}
local buildClientSchema = require(ParentParent.GraphQL).buildClientSchema

require(script.Parent.loaders)
require(script.Parent.types)

local String = LuauPolyfill.String
local json = require(script.Parent.json)

local function stripBOM(s1: string) -- line: 26
	-- upvalues: String (copy)
	local str = tostring(s1)

	if String.charCodeAt(str, 1) == 65279 then
		str = String.slice(str, 2)
	end

	return str
end
local function parseBOM(s2: string) -- line: 41
	-- upvalues: json (copy), String (copy)
	local parse = json.parse
	local str = tostring(s2)

	if String.charCodeAt(str, 1) == 65279 then
		str = String.slice(str, 2)
	end

	return parse(str)
end

function t1.parseGraphQLJSON(s3: string, s4: string, p1) -- line: 44
	-- upvalues: json (copy), String (copy), Boolean (copy), buildClientSchema (copy), Error (copy)
	local parse = json.parse
	local str = tostring(s4)

	if String.charCodeAt(str, 1) == 65279 then
		str = String.slice(str, 2)
	end

	local v21 = parse(str)

	if Boolean.toJSBoolean(v21.data) then
		v21 = v21.data
	end

	if v21.kind == "Document" then
		return {
			location = s3,
			document = v21
		}
	end

	if Boolean.toJSBoolean(v21.__schema) then
		local v22 = buildClientSchema(v21, p1)

		return {
			location = s3,
			schema = v22
		}
	end

	if typeof(v21) == "string" then
		return {
			location = s3,
			rawSDL = v21
		}
	end

	error(Error.new("Not valid JSON content"))
end

return t1
