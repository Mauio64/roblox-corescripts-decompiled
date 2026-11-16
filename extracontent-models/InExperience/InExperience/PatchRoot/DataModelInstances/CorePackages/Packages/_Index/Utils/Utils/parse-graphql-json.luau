local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local ParseGraphqlJson = {}
local GraphQL = require(parent.GraphQL)
local buildClientSchema = GraphQL.buildClientSchema

require(script.Parent.loaders)

require(script.Parent.types)

local String = LuauPolyfill.String
local json = require(script.Parent.json)

local function stripBOM(p: string) -- 1 equivalent call inferred from this helper
	local v = tostring(p)

	if String.charCodeAt(v, 1) == 65279 then
		return (String.slice(v, 2))
	end

	return v
end

local function parseBOM(p: string) -- 1 equivalent call inferred from this helper
	return json.parse(stripBOM(p)) -- inferred equivalent call
end

function ParseGraphqlJson.parseGraphQLJSON(location: string, p: string, p2)
	local v = parseBOM(p) -- inferred equivalent call

	if Boolean.toJSBoolean(v.data) then
		v = v.data
	end

	if v.kind == "Document" then
		return { location = location, document = v }
	end

	if Boolean.toJSBoolean(v.__schema) then
		return { location = location, schema = buildClientSchema(v, p2) }
	end

	if typeof(v) == "string" then
		return { location = location, rawSDL = v }
	end

	error(Error.new("Not valid JSON content"))
end
return ParseGraphqlJson
