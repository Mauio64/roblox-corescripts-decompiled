local parent = script.Parent.Parent

local GraphQL = require(parent.GraphQL)
local parse = GraphQL.parse

local LuauPolyfill = require(parent.LuauPolyfill)
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local String = LuauPolyfill.String
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local console = LuauPolyfill.console

local v = Map.new(nil)
local v2 = Map.new(nil)
local flag = true
local experimentalFragmentVariables = false
local function normalize(value: string) -- 1 equivalent call inferred from this helper
	local v3 = value:gsub(",+%s+", " ")
	return String.trim(v3)
end

local function cacheKeyFromLoc(loc) -- 1 equivalent call inferred from this helper
	return normalize(loc.source.body:sub(loc.start, loc._end))
end

local function processFragments(parsed)
	local v3 = Set.new(nil)
	local definitions = {}

	for i = 1, #parsed.definitions do
		local definition = parsed.definitions[i]

		if definition.kind == "FragmentDefinition" then
			local value = definition.name.value
			local v4 = cacheKeyFromLoc(definition.loc) -- inferred equivalent call

			local v5 = v2:get(value)

			if v5 and not v5:has(v4) then
				if flag then
					console.warn("Warning: fragment with name " .. value .. [[
 already exists.
graphql-tag enforces all fragment names across your application to be unique; read more about
this in the docs: http://dev.apollodata.com/core/fragments.html#unique-names]])
				end
			elseif not v5 then
				v5 = Set.new()

				v2:set(value, v5)
			end

			v5:add(v4)

			if not v3:has(v4) then
				v3:add(v4)
				table.insert(definitions, definition)
			end
		else
			table.insert(definitions, definition)
		end
	end

	return Object.assign({}, parsed, { definitions = definitions })
end

local function stripLoc(p)
	local v3 = Set.new(nil)

	for i = 1, #v3 do
		local v4 = v3[i]

		if v4.loc then
			v3:delete(v4.loc)
		end

		for j = 1, #Object.keys(v4) do
			local v5 = v4[tostring(Object.keys(v4)[j])]

			if not v5 or typeof(v5) ~= "table" or Array.isArray(v5) then
				continue
			end

			v3:add(v5)
		end
	end

	local loc = p.loc

	if loc then
		loc.startToken = nil
		loc.endToken = nil
	end

	return p
end

local function parseDocument(value: string)
	local v3 = normalize(value) -- inferred equivalent call

	if not v:has(v3) then
		local parsed = parse(value, {
			experimentalFragmentVariables = experimentalFragmentVariables
		})

		if not parsed or parsed.kind ~= "Document" then
			error("Not a valid GraphQL document.")
		end

		v:set(v3, stripLoc(processFragments(parsed)))
	end

	return (v:get(v3))
end

local function gql(value)
	if typeof(value) == "string" then
		return parseDocument(value)
	end

	if typeof(value) == "table" and value.kind == "Document" then
		return value
	end

	error("graphql-tag-lua does not currently support non-strings or Fragments. Please file an issue or PR if you need this feature added.")
end

function resetCaches()
	v:clear()
	v2:clear()
end

function disableFragmentWarnings()
	flag = false
end

function enableExperimentalFragmentVariables()
	experimentalFragmentVariables = true
end

function disableExperimentalFragmentVariables()
	experimentalFragmentVariables = false
end

local v3 = {
	gql = gql,
	resetCaches = resetCaches,
	disableFragmentWarnings = disableFragmentWarnings,
	enableExperimentalFragmentVariables = enableExperimentalFragmentVariables,
	disableExperimentalFragmentVariables = disableExperimentalFragmentVariables
}

return {
	default = gql,
	gql = gql,
	resetCaches = v3.resetCaches,
	disableFragmentWarnings = v3.disableFragmentWarnings,
	enableExperimentalFragmentVariables = v3.enableExperimentalFragmentVariables,
	disableExperimentalFragmentVariables = v3.disableExperimentalFragmentVariables
}
